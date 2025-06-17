Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169FC2EF659;
	Tue, 17 Jun 2025 15:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174250; cv=none; b=XK8S2xhL8GBeRifki8of7A6YCMnEpwJc93gH8T2J63Oz0HneyJaU9b1EFeCduOpUeNaZYVOXPOiI1MJfjBHvAFmp1vIf2NACHWr6kEhoMotxoQq8r09CIYHCEAzQJq3AtyW6Ryl9vePtGQi+gaILN2hN2RM5Ztpmn1Ks4poTAwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174250; c=relaxed/simple;
	bh=hXXunDOyTT+ijKRUSfxPYF1HzP1TZ065YCRPFvY8gwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHgOjv1pM1urMhNL0y9CDjbvPG1c5JWVhuwfziQLeLlnJE992xdoGW2tpaU7R+KskW2uL5x8kHVYuzMFxwOMNEqGCGfn+5ccbGAaWaNy9aQOo+x4+VbC4HcyHkv9ZaPgsyk9Jb/a+KYnU18juhO3a16YPTut7B9Fn0gfmGAq/Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lywZTe/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lywZTe/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795F5C4CEE7;
	Tue, 17 Jun 2025 15:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174250;
	bh=hXXunDOyTT+ijKRUSfxPYF1HzP1TZ065YCRPFvY8gwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lywZTe/KJlcsaFjlsvqS1So4DjtykUTcWCM0wFoXdPtRDecaHJEQXLs/ZxuQjIxuw
	 fTrmGlDpIBdD7oi8Dwsp4aRsyE4hzbi0nFRkEW9HC1cGT3ivEzatD75rQCZhcCFvhG
	 YhniNYL9fCMIWB4ikr8h7RlmPqVypH6sIdI/Mt48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qasim Ijaz <qasdev00@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 010/356] usb: typec: ucsi: fix Clang -Wsign-conversion warning
Date: Tue, 17 Jun 2025 17:22:05 +0200
Message-ID: <20250617152338.639882705@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qasim Ijaz <qasdev00@gmail.com>

commit f4239ace2dd8606f6824757f192965a95746da05 upstream.

debugfs.c emits the following warnings when compiling with the -Wsign-conversion flag with clang 15:

drivers/usb/typec/ucsi/debugfs.c:58:27: warning: implicit conversion changes signedness: 'int' to 'u32' (aka 'unsigned int') [-Wsign-conversion]
                ucsi->debugfs->status = ret;
                                      ~ ^~~
drivers/usb/typec/ucsi/debugfs.c:71:25: warning: implicit conversion changes signedness: 'u32' (aka 'unsigned int') to 'int' [-Wsign-conversion]
                return ucsi->debugfs->status;
                ~~~~~~ ~~~~~~~~~~~~~~~^~~~~~

During ucsi_cmd() we see:

	if (ret < 0) {
		ucsi->debugfs->status = ret;
		return ret;
	}

But "status" is u32 meaning unsigned wrap-around occurs when assigning a value which is < 0 to it, this obscures the real status.

To fix this make the "status" of type int since ret is also of type int.

Fixes: df0383ffad64 ("usb: typec: ucsi: Add debugfs for ucsi commands")
Cc: stable@vger.kernel.org
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250422134717.66218-1-qasdev00@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi.h
+++ b/drivers/usb/typec/ucsi/ucsi.h
@@ -302,7 +302,7 @@ struct ucsi_debugfs_entry {
 		u64 low;
 		u64 high;
 	} response;
-	u32 status;
+	int status;
 	struct dentry *dentry;
 };
 


