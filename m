Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E49B35E92B;
	Thu, 30 Jul 2026 15:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426139; cv=none; b=a83v7KmukmqADPBeqSbI81rusXzCNl3kvBis52eizbO/jk/S/9HrdojOoMfFECt2ZAph1BUZGOxwNnFdK5f2X2hpxqUrAvDJXkX5as4InettwRzNdIcPyO1Cx/D/XDamDOb3mK6wDF+4e+p7jz+SplyWdWpeh1BZrwESq/EujA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426139; c=relaxed/simple;
	bh=aEWhHGo4p22rWdDb9vYAyToHTJJ2K2V/CS+99/DN6wI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtpa1AMnJwIcJ/CVvPHkgItRFL9js5z1TH/LLfqYBQIvDaWJ+l0bW3BdJ4wp512tkzQsX9TlGJSv+fBnAMhDeXQY2DR/HmmvSCDckiol+edmLbyp7h62leH18GVN8gO1uH5rqNSPc7VHcXFfAdVIKz5k6EE9vofMxxoZiOEsx64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nn1rcy1n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nn1rcy1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DA51F000E9;
	Thu, 30 Jul 2026 15:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426138;
	bh=D/D8R8jEpLZhcxrIzKPOK6TmhECKc01hn3P4pFfpkzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nn1rcy1nQsUWGSwY1sz+OCvSVIq+CSAbTNE9Kog5If7zpwYadtNFodEF/dlOKUmX8
	 tJc9Yhv5Y1Pjf6c1g2UISov8/dgpYLhg0lc8h7uoKZijW0Y0xNGN9paNanGSnvdPRG
	 3Tj2vls/sCdxM6P7XOvnVS8bgDbFTzu+XUIWxjcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 313/602] media: nuvoton: npcm-video: fix error handling in npcm_video_init()
Date: Thu, 30 Jul 2026 16:11:45 +0200
Message-ID: <20260730141442.544244870@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

commit 60ca00792bce46ec170c7ed101f376186d4cf8a9 upstream.

npcm_video_init() has two error handling issues after
of_reserved_mem_device_init() is called:

When dma_set_mask_and_coherent() fails, the function releases the
reserved memory but does not return, allowing execution to fall through
into npcm_video_ece_init() with a failed DMA configuration.

When npcm_video_ece_init() fails, the function returns an error without
calling of_reserved_mem_device_release(), leaking the reserved memory
association.

Fix both by adding the missing return after the DMA mask failure and
adding the missing of_reserved_mem_device_release() call on the ECE init
error path.

Fixes: 46c15a4ff1f4 ("media: nuvoton: Add driver for NPCM video capture and encoding engine")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nuvoton/npcm-video.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/platform/nuvoton/npcm-video.c
+++ b/drivers/media/platform/nuvoton/npcm-video.c
@@ -1719,10 +1719,12 @@ static int npcm_video_init(struct npcm_v
 	if (rc) {
 		dev_err(dev, "Failed to set DMA mask\n");
 		of_reserved_mem_device_release(dev);
+		return rc;
 	}
 
 	rc = npcm_video_ece_init(video);
 	if (rc) {
+		of_reserved_mem_device_release(dev);
 		dev_err(dev, "Failed to initialize ECE\n");
 		return rc;
 	}


