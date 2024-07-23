Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B27157A61;
	Tue, 23 Jul 2024 18:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759974; cv=none; b=BsS0AWYN/4oV4gQ2nvUn6zLtdIYzqCE2LaEQu7CLJtN8m1cwd97oryuLnIM7aas60NTJ/R3L3MmqNBU4Smh2I8Oc8UgluV9a4H4YDtMo190Skj07r8zYwlkSiY8ZfDUDAWzjPu9lwrwijfJYjkzJ8gu7Bj62QK1rDosLSqZdc3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759974; c=relaxed/simple;
	bh=e9KMmS60aeg7zo8Vp/a2pWOo1O9rQXutc/fDRhCJplo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBOwHr6yb/6HUnXqUhTi5v9EFB+sbJdvKzrpbtyLZIBCJDtpFSzOBb17fA+9kUDl3etp5aaUB6kIw8VV2KJmUIxaZD15JJqkX8o161v0f8XdRcLmJf9C0NZDiSd9zVtOgwoZRFUbyClFDhwXi6W9YLssHJXHwFDN69l8IctXcYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AQqmlwJL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQqmlwJL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91499C4AF0A;
	Tue, 23 Jul 2024 18:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759974;
	bh=e9KMmS60aeg7zo8Vp/a2pWOo1O9rQXutc/fDRhCJplo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQqmlwJLChAW/iGc9VBLPoCqAIrTWlks1prtlDTEd2FBfh6tGhTaMAS5uEOclr+pf
	 reJJZm29kUMsPTJ56e5CJepYfUhDdInN7Hq+4mZvIee73abNxmBVhitl7+CHI2KOTS
	 jhdFli8XGRjp5wb+9asY2eyYbE5k7L4c1mD67x0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sui Jingfeng <sui.jingfeng@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 060/163] drm: renesas: shmobile: Call drm_atomic_helper_shutdown() at shutdown time
Date: Tue, 23 Jul 2024 20:23:09 +0200
Message-ID: <20240723180145.791880560@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 0320ca14c6fb68ad19aa72e55a1a21c061b2946b ]

Based on grepping through the source code, this driver appears to be
missing a call to drm_atomic_helper_shutdown() at system shutdown time.
This is important because drm_atomic_helper_shutdown() will cause
panels to get disabled cleanly which may be important for their power
sequencing.  Future changes will remove any custom powering off in
individual panel drivers so the DRM drivers need to start getting this
right.

The fact that we should call drm_atomic_helper_shutdown() in the case of
OS shutdown comes straight out of the kernel doc "driver instance
overview" in drm_drv.c.

[geert: shmob_drm_remove() already calls drm_atomic_helper_shutdown]

Suggested-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20230901164111.RFT.15.Iaf638a1d4c8b3c307a6192efabb4cbb06b195f15@changeid
[geert: s/drm_helper_force_disable_all/drm_atomic_helper_shutdown/]
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Sui Jingfeng <sui.jingfeng@linux.dev>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/17c6a5a668e5975f871b77fb1fca6711a0799d9e.1718176895.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/renesas/shmobile/shmob_drm_drv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/renesas/shmobile/shmob_drm_drv.c b/drivers/gpu/drm/renesas/shmobile/shmob_drm_drv.c
index e83c3e52251de..0250d5f00bf10 100644
--- a/drivers/gpu/drm/renesas/shmobile/shmob_drm_drv.c
+++ b/drivers/gpu/drm/renesas/shmobile/shmob_drm_drv.c
@@ -171,6 +171,13 @@ static void shmob_drm_remove(struct platform_device *pdev)
 	drm_kms_helper_poll_fini(ddev);
 }
 
+static void shmob_drm_shutdown(struct platform_device *pdev)
+{
+	struct shmob_drm_device *sdev = platform_get_drvdata(pdev);
+
+	drm_atomic_helper_shutdown(&sdev->ddev);
+}
+
 static int shmob_drm_probe(struct platform_device *pdev)
 {
 	struct shmob_drm_platform_data *pdata = pdev->dev.platform_data;
@@ -273,6 +280,7 @@ static const struct of_device_id shmob_drm_of_table[] __maybe_unused = {
 static struct platform_driver shmob_drm_platform_driver = {
 	.probe		= shmob_drm_probe,
 	.remove_new	= shmob_drm_remove,
+	.shutdown	= shmob_drm_shutdown,
 	.driver		= {
 		.name	= "shmob-drm",
 		.of_match_table = of_match_ptr(shmob_drm_of_table),
-- 
2.43.0



