Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C2230567C;
	Thu, 30 Jul 2026 15:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426142; cv=none; b=pDOlYfIVgjXrrJT6QjrI7uQur5qN6VFzsaUucAlWx+flbd3MeBOPLISs8xMOrdAvtM92Ry5aW0A+Y85nkgXFpr8SnaJ21SRDnN+Coaf0Lo8CWYGM04DbOG9N8nLyvRPnGY17vJhkt8yyzzZu7c9EeuWI0LrBx8jPQH96pkxX+R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426142; c=relaxed/simple;
	bh=+zW2oV145XA7xBcj/ktALwRNMoKYypZe1zd4hVcYYNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n17br8lZX5+ieQ5sSRn/ofreoIwCMxm/S6dB2QK7bCcPWByNdvOlZa9xWit9gI84E+0FoXEW1nCdY+gYqa3VEI4Rzg2aG5fF2vyAZSnbGHT/XeODdKKNlFjn06nS7fWq9U++rVKvY8X/hrLNb1KcfUAE7BWmGl+11GiENjq9RFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ZZSgJVu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ZZSgJVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6889B1F000E9;
	Thu, 30 Jul 2026 15:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426141;
	bh=ttfjnZ7w2HBn633rAFsLQ1najhWgnD36husZbTvvw5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ZZSgJVufI47g7tTC1eWPd4FwnYzEamRze63oYsTn4J42FQ7LbAjn5wQd6hJX8viu
	 LxPYoWRNm2aCZHYnobSQVOKLwM54AsUJDizkVkppxpIc/uN7iBNE9/AZy7jdS5MY7w
	 PjsvcP68t9gDRJRNrUd5j6Qne6JSe68UKhBz+jx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 314/602] media: nuvoton: npcm-video: fix memory leaks in probe and remove
Date: Thu, 30 Jul 2026 16:11:46 +0200
Message-ID: <20260730141442.564844679@linuxfoundation.org>
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

commit 50cc0e547da50b887e63dfa1ad203cd5b735d01e upstream.

npcm_video_probe() allocates the npcm_video structure with kzalloc_obj()
but never frees it on any probe error path or in npcm_video_remove(),
leaking the allocation on every failed probe and every normal unbind.

Additionally, when npcm_video_setup_video() fails, the reserved memory
association established by of_reserved_mem_device_init() in
npcm_video_init() is not released, leaking the rmem_assigned_device
entry on the global list.

Fix both by adding kfree(video) to all probe error paths and to
npcm_video_remove(), and adding the missing
of_reserved_mem_device_release() call when npcm_video_setup_video()
fails.

Fixes: 46c15a4ff1f4 ("media: nuvoton: Add driver for NPCM video capture and encoding engine")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nuvoton/npcm-video.c |   32 ++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 9 deletions(-)

--- a/drivers/media/platform/nuvoton/npcm-video.c
+++ b/drivers/media/platform/nuvoton/npcm-video.c
@@ -1749,42 +1749,55 @@ static int npcm_video_probe(struct platf
 	regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(regs)) {
 		dev_err(&pdev->dev, "Failed to parse VCD reg in DTS\n");
-		return PTR_ERR(regs);
+		rc = PTR_ERR(regs);
+		goto err_free;
 	}
 
 	video->vcd_regmap = devm_regmap_init_mmio(&pdev->dev, regs,
 						  &npcm_video_regmap_cfg);
 	if (IS_ERR(video->vcd_regmap)) {
 		dev_err(&pdev->dev, "Failed to initialize VCD regmap\n");
-		return PTR_ERR(video->vcd_regmap);
+		rc = PTR_ERR(video->vcd_regmap);
+		goto err_free;
 	}
 
 	video->reset = devm_reset_control_get(&pdev->dev, NULL);
 	if (IS_ERR(video->reset)) {
 		dev_err(&pdev->dev, "Failed to get VCD reset control in DTS\n");
-		return PTR_ERR(video->reset);
+		rc = PTR_ERR(video->reset);
+		goto err_free;
 	}
 
 	video->gcr_regmap = syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
 							    "nuvoton,sysgcr");
-	if (IS_ERR(video->gcr_regmap))
-		return PTR_ERR(video->gcr_regmap);
+	if (IS_ERR(video->gcr_regmap)) {
+		rc = PTR_ERR(video->gcr_regmap);
+		goto err_free;
+	}
 
 	video->gfx_regmap = syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
 							    "nuvoton,sysgfxi");
-	if (IS_ERR(video->gfx_regmap))
-		return PTR_ERR(video->gfx_regmap);
+	if (IS_ERR(video->gfx_regmap)) {
+		rc = PTR_ERR(video->gfx_regmap);
+		goto err_free;
+	}
 
 	rc = npcm_video_init(video);
 	if (rc)
-		return rc;
+		goto err_free;
 
 	rc = npcm_video_setup_video(video);
 	if (rc)
-		return rc;
+		goto err_release_mem;
 
 	dev_info(video->dev, "NPCM video driver probed\n");
 	return 0;
+
+err_release_mem:
+	of_reserved_mem_device_release(&pdev->dev);
+err_free:
+	kfree(video);
+	return rc;
 }
 
 static void npcm_video_remove(struct platform_device *pdev)
@@ -1799,6 +1812,7 @@ static void npcm_video_remove(struct pla
 	v4l2_device_unregister(v4l2_dev);
 	if (video->ece.enable)
 		npcm_video_ece_stop(video);
+	kfree(video);
 	of_reserved_mem_device_release(dev);
 }
 


