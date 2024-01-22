Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D8063119;
	Tue, 23 Jan 2024 00:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971170; cv=none; b=ZmrhJaCQdY40nHIIpL/SN9u2NMmGl6ZusRYBDzki9rGll2nf5N+Y9rkMWip4JF3tUw6AXBKogotWFAtEE/YeLjQEVDP/u4AQajyFFvPYdauWTfhXR/Tr/M8hhcNbOqiOHUX4Y9lCj2xZXqplRffc/F5HwIzVk4f1aTZjgW9+erE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971170; c=relaxed/simple;
	bh=L0NGbkEPsA9BFJe0e9nxPOeOJvFiAyITp+iRjzzwrP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRx+x0hod7XBx8xZX3Cu6xqETfaS5HifrrncfOrOF/miTjZ0QufagIV5wV7KXq+NYe62pfLEYZdQRa4VZXDfJn5esIsMxA/B6Zsk1nuX4rZsjnmRk7mSTHV/XqY6OboWAimC89R3YUKBbONx6txHABMYBO0AKI6xxG5pog6xO8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rM4hxMVz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rM4hxMVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B382C43390;
	Tue, 23 Jan 2024 00:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971170;
	bh=L0NGbkEPsA9BFJe0e9nxPOeOJvFiAyITp+iRjzzwrP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rM4hxMVz2qvBq0w472UpodPa1PdmtB8IrMf7QXrsR6w8olvUW6HDPzwS8fBg6iDtf
	 yVnv7BoePkx5szwWvtqUA5em+uEBW7ctUCXUx0ijvdOEsbAF62cVbpjX1bThjPZbEY
	 QtiwU+22PsW6o0xeuUGmWa+cAWWNkg+Q8MXOV7S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommaso Merciai <tomm.merciai@gmail.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 196/417] media: rkisp1: Fix media device memory leak
Date: Mon, 22 Jan 2024 15:56:04 -0800
Message-ID: <20240122235758.728161519@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 452f604a4683654f4d9472b3126d8da61d748443 ]

Add missing calls to media_device_cleanup() to fix memory leak.

Link: https://lore.kernel.org/r/20231122-rkisp-fixes-v2-1-78bfb63cdcf8@ideasonboard.com

Fixes: d65dd85281fb ("media: staging: rkisp1: add Rockchip ISP1 base driver")
Reviewed-by: Tommaso Merciai <tomm.merciai@gmail.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c b/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c
index f2475c6235ea..2b76339f9381 100644
--- a/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c
+++ b/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c
@@ -582,7 +582,7 @@ static int rkisp1_probe(struct platform_device *pdev)
 
 	ret = v4l2_device_register(rkisp1->dev, &rkisp1->v4l2_dev);
 	if (ret)
-		goto err_pm_runtime_disable;
+		goto err_media_dev_cleanup;
 
 	ret = media_device_register(&rkisp1->media_dev);
 	if (ret) {
@@ -617,6 +617,8 @@ static int rkisp1_probe(struct platform_device *pdev)
 	media_device_unregister(&rkisp1->media_dev);
 err_unreg_v4l2_dev:
 	v4l2_device_unregister(&rkisp1->v4l2_dev);
+err_media_dev_cleanup:
+	media_device_cleanup(&rkisp1->media_dev);
 err_pm_runtime_disable:
 	pm_runtime_disable(&pdev->dev);
 	return ret;
@@ -637,6 +639,8 @@ static int rkisp1_remove(struct platform_device *pdev)
 	media_device_unregister(&rkisp1->media_dev);
 	v4l2_device_unregister(&rkisp1->v4l2_dev);
 
+	media_device_cleanup(&rkisp1->media_dev);
+
 	pm_runtime_disable(&pdev->dev);
 
 	return 0;
-- 
2.43.0



