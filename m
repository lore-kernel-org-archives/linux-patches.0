Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773261E492;
	Wed, 19 Jun 2024 13:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803965; cv=none; b=CYH4wN/N/Ns/PqCJ8jtf7CwqKRhK/uhMRUrPhC2WRuFTtlx2KdVBVVTyuHtgt602w+XeW4EwXH6SSwquuvXmhcmdGdxmix5No/4JdwsM0Q59C+6Iut4oMx5EC4R7kVDzzdoGxkk7ohaJic7+00+iCvPiFd89VygJh1Px85YK2W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803965; c=relaxed/simple;
	bh=VFt/f5AmiT7nkmjTXml/OAOpF5ABDdX5dFq+rntIpLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jk/vSO458GezmElR482RmDL2Pg3MXRQV8lmHp993vTzTiorI05vbL39jDnDxjR4vaI6Ogw7llFLoTij6Ap6QoxfgSb+KigbvS4o6M8mZFDEvb3uuSiKQ48oQ++xAAMg4ty0yjg4XhzYM3PW6T3y4roEc9fbo91AOLRv1rMILz7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H5rLZojN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H5rLZojN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E606BC2BBFC;
	Wed, 19 Jun 2024 13:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803965;
	bh=VFt/f5AmiT7nkmjTXml/OAOpF5ABDdX5dFq+rntIpLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H5rLZojNyFSmmcXTdhJj8tqZObzVeER8iuHOYY7OkZUEAYTR8ZmLzJT7igStKMPWy
	 m8/HH99xvvwPipxfSEC2FMB1Z0jugEqoOvlQs9ZaG72VHrh+KL6dU3irdh+4HBvui3
	 0BpzRvJf+6uhqJfDp5jotHORjYRxVpHb2aa4mbB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 136/217] drm/vmwgfx: 3D disabled should not effect STDU memory limits
Date: Wed, 19 Jun 2024 14:56:19 +0200
Message-ID: <20240619125601.937945474@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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
index 0a75084cd32a2..be27f9a3bf67b 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -938,13 +938,6 @@ static int vmw_driver_load(struct vmw_private *dev_priv, u32 pci_id)
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



