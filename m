Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710EC3A9879;
	Sat, 17 Oct 2026 17:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256453; cv=none; b=Llb6Bz/bJci9fYTWLI7C164Z9Olii7xEA06Y/blgqy+VUVL98GksKA9HjHUdLghKdXmwo9GBUU40S+wV7jzZGdRx07wV53ADe+VFP33g80Bo9J54eLIFKzyuHZbW7BDlXn1H4I3GDVEDffc/pZ+hla6l5ywgMY3VPf9fgEgW338=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256453; c=relaxed/simple;
	bh=a5yLBvDP3WOe8he7v7au4nTfPazSkbLHS2MMfdmltOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=li3xbXQIwitvpN+CJ7hlHRJcqIqToGn+AFL8uZ/DmVDwmaVsWnvBWyNHkjgK51tPgKIBDgY2ilr4M/TjZGuj3IGd2uZ4mm6xEvJ8kYtfA2HyTApi/tnVBOOOJ89SyqX0zy482gh9FqRmgeU+DHyyuhA/cDOIMi738X0xUMB3IZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cAE9xyJF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cAE9xyJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CB01F000C4;
	Sat, 17 Oct 2026 17:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256452;
	bh=A1FpaIwDv078fgIygbmiKJSi/3bHgik2eM9MVZlhlZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cAE9xyJFyA3MIyWmUTMGhnsHIfxbd4UTuEKiHCsBZ+mgHOD75nUuKz+v3f1nH2xAU
	 F3GeUnnpzwEuD+vYcgDO+2cboSfQpgSz4gNq8wKVplFJ3lip9LYotsgFOnt5xbM0Ej
	 QVPwcFck8pJ7QXL7Amoi/Ob+XKKD+dU+gbvFiRRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haojie Li <lihaojie@kylinos.cn>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.6 0240/1674] drm/mediatek: Add missing IS_ERR check for ovl_adaptor platform device
Date: Sat, 17 Oct 2026 17:41:52 +0200
Message-ID: <20261017160437.293207668@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haojie Li <lihaojie@kylinos.cn>

commit bce7698e2e6565bb765bd0522337f29f5f312624 upstream.

platform_device_register_data() can fail and return an ERR_PTR, but the
return value is used without checking, leading to an invalid pointer
being stored in ddp_comp[].dev and passed to component_match_add() and
mtk_ddp_comp_init(), which could result in a kernel crash.

Add an IS_ERR() check to jump to the error handling path on failure.

Fixes: 0d9eee9118b7 ("drm/mediatek: Add drm ovl_adaptor sub driver for MT8195")
Cc: stable@vger.kernel.org
Signed-off-by: Haojie Li <lihaojie@kylinos.cn>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20260825100845.438893-1-lihaojie@kylinos.cn/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -840,6 +840,9 @@ static int mtk_drm_probe(struct platform
 							    PLATFORM_DEVID_AUTO,
 							    (void *)private->mmsys_dev,
 							    sizeof(*private->mmsys_dev));
+		if (IS_ERR(ovl_adaptor))
+			return PTR_ERR(ovl_adaptor);
+
 		private->ddp_comp[DDP_COMPONENT_DRM_OVL_ADAPTOR].dev = &ovl_adaptor->dev;
 		mtk_ddp_comp_init(dev, NULL, &private->ddp_comp[DDP_COMPONENT_DRM_OVL_ADAPTOR],
 				  DDP_COMPONENT_DRM_OVL_ADAPTOR);


