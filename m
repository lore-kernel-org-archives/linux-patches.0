Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD743A4AD4;
	Wed, 21 Jan 2026 18:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019793; cv=none; b=lOCCIoP2yByze7h4hS/JJjIJ1125uhoNhV0JeQgA3a5ricoS8iE3KLa44v2itXOYqIG7trYdAt4pPYwDo3hOs7ZRROOGHtLx2i2k/+sgRyf2QetCjyhI3cJhj4Eg35Yh5x2jWg29yXt3mtn/yNfPQZMDEWrwPy6QfwiUuM5Kclc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019793; c=relaxed/simple;
	bh=5DGjm0B6Q3M7UqmlB+pNxDsFWUKxHEUgrngDOOhqMHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kCWVFHBBZL5aeSqZxDcA5cjLPVqsRXmBn841TCtR5h8oy6P4Xn93cu/8Q3tCrx8thKqmZWEyktjP/tp56ag3AqJMBA7zztQpqiEFw3NM/QOBiCNdapnS0E5X3XSBGlH/e5PHvQOPYHWDhIKn0YgbuAMnWpxTEX97/RpTGXK+NtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M+P20u1v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M+P20u1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52A9C4CEF1;
	Wed, 21 Jan 2026 18:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019792;
	bh=5DGjm0B6Q3M7UqmlB+pNxDsFWUKxHEUgrngDOOhqMHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+P20u1vWHRYf95avQ9TW3uhoHG+BqmxUbf7RHguYyrEGKstSRSvRaWIS7e4jrxrU
	 shbC3j8/mAOCynN3R6C9czO9UWoO+coF1afsppVSoC1J0O8RcnDvQAVBdWJ50QdwvX
	 1+/nPZNPI3ioFyzd8hegPRUFGyYN2dO5LpOPb4KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 110/139] dmaengine: bcm-sba-raid: fix device leak on probe
Date: Wed, 21 Jan 2026 19:15:58 +0100
Message-ID: <20260121181415.406562802@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 7c3a46ebf15a9796b763a54272407fdbf945bed8 upstream.

Make sure to drop the reference taken when looking up the mailbox device
during probe on probe failures and on driver unbind.

Fixes: 743e1c8ffe4e ("dmaengine: Add Broadcom SBA RAID driver")
Cc: stable@vger.kernel.org	# 4.13
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20251117161258.10679-4-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/bcm-sba-raid.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/dma/bcm-sba-raid.c
+++ b/drivers/dma/bcm-sba-raid.c
@@ -1699,7 +1699,7 @@ static int sba_probe(struct platform_dev
 	/* Prealloc channel resource */
 	ret = sba_prealloc_channel_resources(sba);
 	if (ret)
-		goto fail_free_mchan;
+		goto fail_put_mbox;
 
 	/* Check availability of debugfs */
 	if (!debugfs_initialized())
@@ -1729,6 +1729,8 @@ skip_debugfs:
 fail_free_resources:
 	debugfs_remove_recursive(sba->root);
 	sba_freeup_channel_resources(sba);
+fail_put_mbox:
+	put_device(sba->mbox_dev);
 fail_free_mchan:
 	mbox_free_channel(sba->mchan);
 	return ret;
@@ -1744,6 +1746,8 @@ static void sba_remove(struct platform_d
 
 	sba_freeup_channel_resources(sba);
 
+	put_device(sba->mbox_dev);
+
 	mbox_free_channel(sba->mchan);
 }
 


