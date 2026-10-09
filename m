Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11C231A045;
	Fri,  9 Oct 2026 14:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555938; cv=none; b=j+f/I0wQU3JaR6Vif2wZaVjhtssBfM1jz9Gu8bTJY7Mk6fSDeVoGwKBPgOmIWo+CaASXqnYkITmrZU0gEuaK8/wkvMBM6Fv+evqZR5LF+WQR1wNcEyJfkTM9JoL04Wbs3EaKHbN1cKS5Mx8CHk6gEwj5IltGPJjJzNuZqGVR868=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555938; c=relaxed/simple;
	bh=4FArng+CxNfhlnYFbb5oKDd42O9B+iHpYzjiUlPwJMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAblIHngGzKWG8y0lkuqsZOQLqokgkKIerhw0lwWqYydneemTzfviphqyiD1BGhKkun16Ejmgv3gYgWpC8a/wsfv3SNH6C7vAtrxOaDp4n8xfemhvfAMwEcJ8KVIFQF93mFSVIOcBXrmswBkpmAVmWO1+5D7mjD3e/PL30Ei7G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NiNudUhI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NiNudUhI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2501F000FF;
	Fri,  9 Oct 2026 14:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555937;
	bh=0DCEQcxGLXjJjAeC+cpNcpwKqoyygPxtVT2GckteU40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NiNudUhITBsl+pTAAtMWJQMsAtLc1CFlXScgfsV6r0c2WSwqyLS7AD54VehLZY2Mx
	 hsP+50eYR0vda7Z6oHdR5qB502nhJsPPc8J3WQgQFrJ4ZF/2ZZBFO9Xgdc7biyBQWy
	 DsIqxXZTM+xtg74j1UBC6G/ILemygeBBUFD4V2jU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haojie Li <lihaojie@kylinos.cn>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.18 142/403] drm/mediatek: Add missing IS_ERR check for ovl_adaptor platform device
Date: Fri,  9 Oct 2026 16:08:23 +0200
Message-ID: <20261009140955.393790490@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1122,6 +1122,9 @@ static int mtk_drm_probe(struct platform
 							    PLATFORM_DEVID_AUTO,
 							    (void *)private->mmsys_dev,
 							    sizeof(*private->mmsys_dev));
+		if (IS_ERR(ovl_adaptor))
+			return PTR_ERR(ovl_adaptor);
+
 		private->ddp_comp[DDP_COMPONENT_DRM_OVL_ADAPTOR].dev = &ovl_adaptor->dev;
 		mtk_ddp_comp_init(dev, NULL, &private->ddp_comp[DDP_COMPONENT_DRM_OVL_ADAPTOR],
 				  DDP_COMPONENT_DRM_OVL_ADAPTOR);


