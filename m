Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586B4280A3B;
	Wed,  4 Feb 2026 14:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216267; cv=none; b=pzs7NpD9w5myrnrpXSx+pUfAcHzLzwynOYTs9DcP4kU2iOIDyPOpXllAH9gSTIovjRseo+GhrM3MX9WvcDcLmCtEHxJb8iR7hHIGgmJJw41kmj1A2HpVWWObvY0ZQEvZm8puwFXwwcnxdYo+sbWsD4ke1nrC8wVbqxaY1r6KSQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216267; c=relaxed/simple;
	bh=NsrnnFvoNKQXCIIfV+ejeYLY5bUr6cGDEAROsyHM2to=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XaA6Eyl8g6ArJjO817MSykCAkGFAkZHsyLn8W3wsq95BO9WT2FfZDaxYlEdUiwmtcVypNFvfUTtYcC7g/FuONniga2at6wPPcrVWZ1y4Xy7w5AP17gmEV39+5bOB7JiHkQ2x87JRswHmluY0ug60XdjI7FAVlqjXgqRzM6I80Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6c/eFsA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6c/eFsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C035DC4CEF7;
	Wed,  4 Feb 2026 14:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216267;
	bh=NsrnnFvoNKQXCIIfV+ejeYLY5bUr6cGDEAROsyHM2to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c6c/eFsAFP6gDIkxWKyamD4ik8efjW3u/a+WrcWMaANde3XN77almAEBSBo7uPFhZ
	 hfkab9RtX85cGmOes05aLv9aK2xEG4gn6d5WQ237GPrwjX6R/3peGGHvsO4UwETiQ/
	 RPbfD/K1+YLG8/bJ99IqdtgsGZRgTQlsYIMZIW+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 038/161] dmaengine: bcm-sba-raid: fix device leak on probe
Date: Wed,  4 Feb 2026 15:38:21 +0100
Message-ID: <20260204143853.133608500@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1707,7 +1707,7 @@ static int sba_probe(struct platform_dev
 	/* Prealloc channel resource */
 	ret = sba_prealloc_channel_resources(sba);
 	if (ret)
-		goto fail_free_mchan;
+		goto fail_put_mbox;
 
 	/* Check availability of debugfs */
 	if (!debugfs_initialized())
@@ -1737,6 +1737,8 @@ skip_debugfs:
 fail_free_resources:
 	debugfs_remove_recursive(sba->root);
 	sba_freeup_channel_resources(sba);
+fail_put_mbox:
+	put_device(sba->mbox_dev);
 fail_free_mchan:
 	mbox_free_channel(sba->mchan);
 	return ret;
@@ -1752,6 +1754,8 @@ static int sba_remove(struct platform_de
 
 	sba_freeup_channel_resources(sba);
 
+	put_device(sba->mbox_dev);
+
 	mbox_free_channel(sba->mchan);
 
 	return 0;


