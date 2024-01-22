Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880BC5A7B8;
	Tue, 23 Jan 2024 01:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974341; cv=none; b=St9SfEjvsRZp4LiWOPULYmVw0vFO9N0tKOqPXUO56W/0lOl/QPmGzbaIUtr+Rzb+N9D5SAIYpNOqsdX6NLmMJw9acVbSm6OEmypBIe9/JnvXWD8/s3Wz4PVw687pFMdvLMj08le89a6HchV1M2eVFarXHct9eRhwdTOsvzQC+UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974341; c=relaxed/simple;
	bh=IouHy77Gizj3sU4uRru1AfoZzh6r7idgawc50D60vog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUMWiTW/FeusVQ95EjrOpnnDgYXu/fkF6uq4dUGCtItE1e5nWIif1EDxWIprCCMKsTz/R1IsUdThh7V3zBuvcOcA+F0J955Y+wb2GFGNitN8uN2BowqPFhKiGt6hC+TQkS6MAx1/xDYmcDQhkKX9gPPvGbHbploeWuDCSgkCBFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ZzMRqkO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ZzMRqkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D808C43390;
	Tue, 23 Jan 2024 01:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974341;
	bh=IouHy77Gizj3sU4uRru1AfoZzh6r7idgawc50D60vog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ZzMRqkOqEjfarwSJKUYiaCLDlroprqES4Cuqw+yAe69pLERMVV62K6cXO774nLPC
	 NUl5DKM7r2+EGswLhTo/lX7jDgPigzHRgbwG+scPr/AIj8PtRmTkP4rt3VUxLFBUUU
	 gyy88lK6wOpTkHn5eBo4oYbGa2lz/ZVdiK8umTFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 183/374] drm/tilcdc: Fix irq free on unload
Date: Mon, 22 Jan 2024 15:57:19 -0800
Message-ID: <20240122235750.996378314@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 38360bf96d816e175bc602c4ee76953cd303b71d ]

The driver only frees the reserved irq if priv->irq_enabled is set to
true. However, the driver mistakenly sets priv->irq_enabled to false,
instead of true, in tilcdc_irq_install(), and thus the driver never
frees the irq, causing issues on loading the driver a second time.

Fixes: b6366814fa77 ("drm/tilcdc: Convert to Linux IRQ interfaces")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Aradhya Bhatia <a-bhatia1@ti.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230919-lcdc-v1-1-ba60da7421e1@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tilcdc/tilcdc_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.c b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
index 6b03f89a98d4..6924488274dd 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_drv.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
@@ -140,7 +140,7 @@ static int tilcdc_irq_install(struct drm_device *dev, unsigned int irq)
 	if (ret)
 		return ret;
 
-	priv->irq_enabled = false;
+	priv->irq_enabled = true;
 
 	return 0;
 }
-- 
2.43.0



