Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E268F4E1AD;
	Tue, 23 Jan 2024 01:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975087; cv=none; b=kh9pDxAxXrXvhQxPtqOFsOWXcrZCyE2tWSaO5Q8Q2F6/q83JO3EVVnwIW3SUpE8356kkudhG+LaNxPv4vY2OmHO0tadBdsL7lLcZw2NC8/LYhFV6O/lDLHp08jAIod0uR9TqI4abiABcn9PSAburB6Tp84hjlZCKgzLma2eMWJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975087; c=relaxed/simple;
	bh=83mFWHUPDGLFFX5i3FOXOdla4tie9WzsSnnNdT0+3V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzNTX+PmlPO8uPqqzN+86W29DWCWUdpAEUsLulo/IVh1W47tMaz0/dtyvqbTuxrhC9z7O6NT3kVnC/ulN0c7Yjxnj2AMcIo/+tlHT87Ul/U7aJ3SWyCZNqpVI8fHx71f2tid5tEXtvT/RFvAw3sVCHPq+2G0/orNRQIRxuWsXac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vnjpWHWA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vnjpWHWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9BEC43601;
	Tue, 23 Jan 2024 01:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975086;
	bh=83mFWHUPDGLFFX5i3FOXOdla4tie9WzsSnnNdT0+3V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vnjpWHWAABl5v6jMGvjFkS+2FE3v3gqFbu6R585dzxytQPTw/ULWoB28qTnak6sSe
	 noOlFQECySgGZHu4bIVsOuumZcgx9d3CE+c2iwH8UC9RiNAcSPtdtMi1brluo6VIli
	 iVBWkjsOyK3ArCy1L0h9wbJJXKJhYkcPYlohxUHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 232/583] drm/tilcdc: Fix irq free on unload
Date: Mon, 22 Jan 2024 15:54:43 -0800
Message-ID: <20240122235819.088379367@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8ebd7134ee21..2f6eaac7f659 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_drv.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
@@ -138,7 +138,7 @@ static int tilcdc_irq_install(struct drm_device *dev, unsigned int irq)
 	if (ret)
 		return ret;
 
-	priv->irq_enabled = false;
+	priv->irq_enabled = true;
 
 	return 0;
 }
-- 
2.43.0



