Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A646682495;
	Wed, 19 Jun 2024 13:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803187; cv=none; b=NX/PB5vgbqdkBSBDdo4UX5lJzKrEPMhcL6ifHx/QsSPP7RJ4Kb7OXpArOpaNApTdhtnYamlu/P4KwENHoe+rFJnklUPNyPCUmxwG9Kw2n+Ihf4H+RixLnd7gSC9ltCCXjgXXUuiuJLTG66GDF8hd6mahG9M7zaN/KGA0LYGD6Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803187; c=relaxed/simple;
	bh=Z8jSb+CF7Wvb7uOwSM4MLfgWaSFELcl0Kk9xi+VEFWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LqZq779EUhFnmfC1S4uqJZiBivfM/j8YVyDza77bf9QxoDPBCeAHrfTk1VrcRCG7FpMIPfseqWRznTpz4dvMCAcmOcziLeU7qXYdXL7cZvIMoB52P6qIUcZL9CJosW8WkPvNYYZ6Kq79QxKP4c89xuGfBi9aSrYmxwat8vrXR+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w0dThLdq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w0dThLdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CE7C2BBFC;
	Wed, 19 Jun 2024 13:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803187;
	bh=Z8jSb+CF7Wvb7uOwSM4MLfgWaSFELcl0Kk9xi+VEFWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w0dThLdqe6Bt1ZOGL7FqBGwsNjW+Vd8SKFFJKddV5i6Hd18b5zFVV2PXgpgzum/76
	 Zr7r1IFvfpZ4FEUJ9giV+HXI6U3FayLcGFWE0W48qUgt5W47rg+k3USMc+c4A/Lqqk
	 9p+JRHDJyDWviu5xF0SETWl/iFj+lBKbkJbGBphE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 141/281] drm/vmwgfx: 3D disabled should not effect STDU memory limits
Date: Wed, 19 Jun 2024 14:55:00 +0200
Message-ID: <20240619125615.267113345@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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
index 58fb40c93100a..bea576434e475 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -956,13 +956,6 @@ static int vmw_driver_load(struct vmw_private *dev_priv, u32 pci_id)
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



