Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13A417B40E;
	Wed,  3 Jul 2024 11:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004590; cv=none; b=SKLdLx7fR4iycLmbxa4U0vQtcypA10fMJeoFQewhp0yxeQSHE9Ymb9uD0cbA1eohH2a7WO6PZjhoW/6D3zov70ENLmbCX/ndZhuvOZaXGkZPpVjZSf+PluqKYQ7r3waXWFJnp7UTUKIRumbHi7BkBu/oZ+fKOq0xeB8jhBZ4ea8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004590; c=relaxed/simple;
	bh=SZLnF2Hfxga27zM7odsBV6m3AOUf+0IlTcM7l3o1ml8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nq938SC+W0L3Rb5wHUjpksNr0llMHoSGK3lMr2hXYYSXkZadq1iwmUBDu7s3+T3MOXRTXeAb34cGzNucfxfFqsalnTmkS9mgkPMFqDy0MSuv26aXLr6cMZ+4VQl+Noa5DXcNw4FgsTHUeiVEsZgkeOoaKZXlm6ST8P4UQwe3Hz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zHHOqfo6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zHHOqfo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379ECC2BD10;
	Wed,  3 Jul 2024 11:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004590;
	bh=SZLnF2Hfxga27zM7odsBV6m3AOUf+0IlTcM7l3o1ml8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zHHOqfo6ac//i/nsss/SNHPjB+PXzEJ9PaPp+hzmtZKtfUDQNCNeTUntlzb/AjJWd
	 F1VSStVb+Ek0lRPVj68rQqIlzEFB6ioqqVpLIe0zN6pRXmtDqeL8FK0ItFTD4Cb6UI
	 ynN/5Yan9vP/GQV2NQ1SvmiVh3o69RY+qg4KPavc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/290] drm/vmwgfx: 3D disabled should not effect STDU memory limits
Date: Wed,  3 Jul 2024 12:37:22 +0200
Message-ID: <20240703102906.506135723@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bdb7a5e965601..25a9c72cca806 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -752,13 +752,6 @@ static int vmw_driver_load(struct drm_device *dev, unsigned long chipset)
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
 		dev_priv->prim_bb_mem =
 			vmw_read(dev_priv,
-- 
2.43.0



