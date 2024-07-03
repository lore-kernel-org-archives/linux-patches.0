Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA38713BC18;
	Wed,  3 Jul 2024 11:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005484; cv=none; b=KIVHnOTq8NCiovD5N+w8XhdcmaOuHfEMSIBao4l/voQALgf2bpU1bPB/n1+wVGDzKyzYiDCTDV7QH+1f9aLVZ6gTyqGlJClTXjmM+9wVNUq2G5VHeTnONE+1nF09vfOfa8uvdM/E3QUiV5YX/tv5kg7AgkarqO+6u8+QadavfxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005484; c=relaxed/simple;
	bh=sHKbKhAwvk5SGOuf22xERn5jmd7xUW8uAtyvYjSiMO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LI0PmlVG139aPWllDExSujmPUIO25A13cAXzIW70uF1cgsNYGWbr3zmIBftHh4X+U3VXLbqHlfctksp2+movPPzZMFnssxlSm0/JxT31ERCszrXkXiHFXbCA4pygP3PVEbVE3R+DQN4f/Y70HXYIB0DIzKYhmsub1MKKngmOQxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZP1aGAE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZP1aGAE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B81C2BD10;
	Wed,  3 Jul 2024 11:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005484;
	bh=sHKbKhAwvk5SGOuf22xERn5jmd7xUW8uAtyvYjSiMO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZP1aGAECgrNfJUAUuMScz7CkeV+mIrUVzk+i2v3sV/Q/kKxdUh8xmvOfyyqKAkHv
	 TBKTTYD+TYxvU4uy/REGxBAX9fhLjnZxBzY5T3chXdwlCqnlRJtNBE91ABI8pkreJA
	 K5R59faIl6rgEV0ogJq24BGInXtureinvaAtWGYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/356] drm/vmwgfx: 3D disabled should not effect STDU memory limits
Date: Wed,  3 Jul 2024 12:37:12 +0200
Message-ID: <20240703102916.734482860@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

From: Ian Forbes <ian.forbes@broadcom.com>

[ Upstream commit fb5e19d2dd03eb995ccd468d599b2337f7f66555 ]

This limit became a hard cap starting with the change referenced below.
Surface creation on the device will fail if the requested size is larger
than this limit so altering the value arbitrarily will expose modes that
are too large for the device's hard limits.

Fixes: 7ebb47c9f9ab ("drm/vmwgfx: Read new register for GB memory when available")

Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240521184720.767-3-ian.forbes@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index 8449d09c06f7a..0f09a9116b054 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -904,13 +904,6 @@ static int vmw_driver_load(struct vmw_private *dev_priv, u32 pci_id)
 				vmw_read(dev_priv,
 					 SVGA_REG_SUGGESTED_GBOBJECT_MEM_SIZE_KB);
 
-		/*
-		 * Workaround for low memory 2D VMs to compensate for the
-		 * allocation taken by fbdev
-		 */
-		if (!(dev_priv->capabilities & SVGA_CAP_3D))
-			mem_size *= 3;
-
 		dev_priv->max_mob_pages = mem_size * 1024 / PAGE_SIZE;
 		dev_priv->max_primary_mem =
 			vmw_read(dev_priv, SVGA_REG_MAX_PRIMARY_MEM);
-- 
2.43.0



