Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32A1217F29;
	Sat,  7 Jun 2025 10:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749291099; cv=none; b=FKp0eMQlwi2ekT5d8vzjQgT2j2DiL9RjIr6BCAjCoCD9DPuJqA+yPYaQvKHoz/CXAZSVpIS2//I8eqedYwoS71X8rB5xvbxTr8zPAnAbL9Me0p7e4+QBSYwSAoSV4Mk4phsoYjAlAMogqW43n9KM3B/qSJqTjvLGKE08xUOqNr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749291099; c=relaxed/simple;
	bh=QuOMD3MIOwD3hazlIPb/KNHVzVvCwmvjVZU40TLEgG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h8/JswzRiAHj7VeZX2CZY2K6sXPuCfVLwz/Gyq0xieEjbrosvRqoW9tAbb+de9gDz89AWyI96E73eP1RvtMCg2OJSeaemug5UF9Oifj86FRHvm4PlK32OXjvi8qOH/ozoRy7ezwBhbkSRL+GXTsjBqpquJjz3M+1nNLqoaGQfmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eBLN1iDu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eBLN1iDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54AAC4CEE4;
	Sat,  7 Jun 2025 10:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749291098;
	bh=QuOMD3MIOwD3hazlIPb/KNHVzVvCwmvjVZU40TLEgG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eBLN1iDuTNWwVRoUMSZ79LtLu1xwlCd5CH2M2BTJMG6tBR6OM8gR6LGuyyf16YUSj
	 UzrTdM3fdLpdWJIXVkb6WEFpe4DfTq89nx6KKk7gYKhI/5mk++VnyJJliNwGxAEo1v
	 ohgfSnz5vPRmYqImlOep2bS+0N7v3g5ID6vxnXYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qasim Ijaz <qasdev00@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.15 22/34] usb: typec: ucsi: fix Clang -Wsign-conversion warning
Date: Sat,  7 Jun 2025 12:08:03 +0200
Message-ID: <20250607100720.585396549@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100719.711372213@linuxfoundation.org>
References: <20250607100719.711372213@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -434,7 +434,7 @@ struct ucsi_debugfs_entry {
 		u64 low;
 		u64 high;
 	} response;
-	u32 status;
+	int status;
 	struct dentry *dentry;
 };
 


