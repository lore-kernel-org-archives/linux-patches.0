Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4C22566FE;
	Thu, 17 Apr 2025 18:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914499; cv=none; b=D9IRj72KnB7RhpKNl5x8nZ4wsA1/RQrxA+fS1vsKV4W3fSNGq7gPNInfSGAXMryFj8TvIB7PVncWfB5ndI9mqu1vh76jP+8sGkfOC10ppKt4Zs0SMLcXNbIZlDTLXEcVMnXdbz2tF0Nk5ns53D7TZKi6f7dbTFswi88TP955lrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914499; c=relaxed/simple;
	bh=O6v6rAS+cD8Y3SfTD9nN8nuSq03ViO6W4lPwHWSzmOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igxrvz/53j7mnSbg880pMa67GkzpcZmAENzFe/SeVMtV2oLuEICJiasmtIgpQk7qMOxRZzGAJBIitTj7LMvgu2y+k8uhJcu5pXSu9v4pbvrXfhrmVWGsGl6j/WtDANOYs8u2bJ8j++hQaWdL3LpDLdAi8iWLXVbOVcuOKvoAQ8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d27lcVVQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d27lcVVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2851C4CEE4;
	Thu, 17 Apr 2025 18:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914499;
	bh=O6v6rAS+cD8Y3SfTD9nN8nuSq03ViO6W4lPwHWSzmOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d27lcVVQj/pDRiofrOPYUuCnj7L03axUvFadZZhwFdGauTl0E9Qxuikrglh7i+LAV
	 tw+9Ox06DHdPprzt9RafA7uw9EELzqparEtowj3yKKJxSrKLSdJCR2F/O5XhQOrwnj
	 GpSFLTVznhUGetgurk2pO0oYmGw5WmPtBMoozGGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 235/414] media: nuvoton: Fix reference handling of ece_pdev
Date: Thu, 17 Apr 2025 19:49:53 +0200
Message-ID: <20250417175120.880801839@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

commit 453d5cadab1bde8e6fdd5bd05f4200338cb21e72 upstream.

When we obtain a reference to of a platform_device, we need to release
it via put_device.

Found by cocci:
./platform/nuvoton/npcm-video.c:1677:3-9: ERROR: missing put_device; call of_find_device_by_node on line 1667, but without a corresponding object release within this function.
./platform/nuvoton/npcm-video.c:1684:3-9: ERROR: missing put_device; call of_find_device_by_node on line 1667, but without a corresponding object release within this function.
./platform/nuvoton/npcm-video.c:1690:3-9: ERROR: missing put_device; call of_find_device_by_node on line 1667, but without a corresponding object release within this function.
./platform/nuvoton/npcm-video.c:1694:1-7: ERROR: missing put_device; call of_find_device_by_node on line 1667, but without a corresponding object release within this function.

Instead of manually calling put_device, use the __free macros.

Cc: stable@vger.kernel.org
Fixes: 46c15a4ff1f4 ("media: nuvoton: Add driver for NPCM video capture and encoding engine")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nuvoton/npcm-video.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/nuvoton/npcm-video.c
+++ b/drivers/media/platform/nuvoton/npcm-video.c
@@ -1669,6 +1669,7 @@ static int npcm_video_ece_init(struct np
 			dev_err(dev, "Failed to find ECE device\n");
 			return -ENODEV;
 		}
+		struct device *ece_dev __free(put_device) = &ece_pdev->dev;
 
 		regs = devm_platform_ioremap_resource(ece_pdev, 0);
 		if (IS_ERR(regs)) {
@@ -1683,7 +1684,7 @@ static int npcm_video_ece_init(struct np
 			return PTR_ERR(video->ece.regmap);
 		}
 
-		video->ece.reset = devm_reset_control_get(&ece_pdev->dev, NULL);
+		video->ece.reset = devm_reset_control_get(ece_dev, NULL);
 		if (IS_ERR(video->ece.reset)) {
 			dev_err(dev, "Failed to get ECE reset control in DTS\n");
 			return PTR_ERR(video->ece.reset);


