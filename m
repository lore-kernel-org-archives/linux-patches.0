Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385A182871;
	Wed, 19 Jun 2024 13:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802264; cv=none; b=qsqtUkBTx6wihAdlXxBunThZE53rzLELcc4F7dtIx9Ox90RPVy9i15igoNihI5gaVQ5KaODDvTTxxvVKII2QUd4ck6bCP9QytlNeEH0r3OUnCb5Id3JTkj4R9It0AQIioaBfBHxaj/ewSuMXA1sHGe6T/0EluvNNciyb+pzdG6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802264; c=relaxed/simple;
	bh=9MC16PRgkwB5F5qqvlNKNMnJ50Qzp85medvMXMirCK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZYiKG8XK+Al3MfeHxBLUxgdbpaX358PiExB4aZyO2XO0mRJf+eeDV0WV6arPHaH+giFRRsUzt/V17nizPbxVrcLDV8UCJ3gHRnUmdxKW9ZsZt6gtVuaFuFt3s4sus23yVzCLiFC1OzZPfHck412ZvpI4G4kxhYpxMVPTP1vGyIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMsIHhRO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMsIHhRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF66EC2BBFC;
	Wed, 19 Jun 2024 13:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802264;
	bh=9MC16PRgkwB5F5qqvlNKNMnJ50Qzp85medvMXMirCK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bMsIHhROwRURHwrLFA01nS0DWZaQHnuafuFGkIsfK3/j1ywewwxE/GLwZf6QLyqYR
	 lLDRTRUPDgt19HyhDSytjq+ZD3xJ2WsJkdznwbDpAoBtlVCQTqA7Yi11xbyJDKfgAw
	 HExRZt+tavBjAfHBKCLCA27OK7TvVOzDcxVc9Qso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 137/267] drm/vmwgfx: 3D disabled should not effect STDU memory limits
Date: Wed, 19 Jun 2024 14:54:48 +0200
Message-ID: <20240619125611.607491100@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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



