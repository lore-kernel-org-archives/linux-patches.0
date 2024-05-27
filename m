Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D907015FCF9;
	Mon, 27 May 2024 18:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836352; cv=none; b=hHyQTsfiWRAK5nQorjJ7G0oUfArZZJCq5j9S5Kght09U7Q/AjCGtRe1Xsb/NJUhOrik7UtovWwRWs8s21xTbYHvYq8QChkWMZtS/LcZK8czBlSzEfMKr2ZrnlqwkUbl9BLHfahR72pKDLWqrLVGX0x91LVGJpImj8OgF7zNooJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836352; c=relaxed/simple;
	bh=6oLyWY6V0qF8i32EmVSYzTXDDE2KjpTR1NzI7/vXxyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=icibdk3FKKClahs56CthPl3yPw4c5xgR/Ik3ONEhXInbPl8UFTZKdK/cDa8TJBd9ZWLndkQ0zCF6nGevKQkPThxjjAY3pj0V7AubPkavCXZd+EXDj1FJpurH1bldWnj1MzQ++ywf+f9e4FsK6WC8/85ZAe6+9uaN2eiutUwhAIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pAjXfyYp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pAjXfyYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D618C2BBFC;
	Mon, 27 May 2024 18:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836352;
	bh=6oLyWY6V0qF8i32EmVSYzTXDDE2KjpTR1NzI7/vXxyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pAjXfyYplAwNGgtFxqLVPWy+0OaYRqvPsZAy5sUb+EpB+qLbQv25Gyhm9X/blkgQ4
	 58u/hAprvgFAL0MTwpJhOF6u16zBJeF7ayuaJK5tn6zYmIYb3ZIA4yKJ8ip7NQd/VE
	 MFtbsqn/tILSY09eQ1bJ4i7PYwXWjZIHhQ9Dg7E4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Dexuan Cui <decui@microsoft.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.9 020/427] net: mana: Fix the extra HZ in mana_hwc_send_request
Date: Mon, 27 May 2024 20:51:07 +0200
Message-ID: <20240527185603.618691859@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>

commit 9c91c7fadb1771dcc2815c5271d14566366d05c5 upstream.

Commit 62c1bff593b7 added an extra HZ along with msecs_to_jiffies.
This patch fixes that.

Cc: stable@vger.kernel.org
Fixes: 62c1bff593b7 ("net: mana: Configure hwc timeout from hardware")
Signed-off-by: Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Link: https://lore.kernel.org/r/1716185104-31658-1-git-send-email-schakrabarti@linux.microsoft.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microsoft/mana/hw_channel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -848,7 +848,7 @@ int mana_hwc_send_request(struct hw_chan
 	}
 
 	if (!wait_for_completion_timeout(&ctx->comp_event,
-					 (msecs_to_jiffies(hwc->hwc_timeout) * HZ))) {
+					 (msecs_to_jiffies(hwc->hwc_timeout)))) {
 		dev_err(hwc->dev, "HWC: Request timed out!\n");
 		err = -ETIMEDOUT;
 		goto out;


