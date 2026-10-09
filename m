Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08A93B582F;
	Fri,  9 Oct 2026 14:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556478; cv=none; b=Eq2MB6mEZ0NGTMnrU4qm1/hcSLTMgz1eoRU+jt+NZRO1+CHhd2CGNsmC3uBqob0jcg7DnbX9NIO0fEGTMatTmD8EWdWO4QxlKE/Rwv3i4gL2VgdmRbkZ+jnnX36P2YjuSgxZW7R1C5CHI4+8F5x4kJ7wm77IFa8uO3Vy6or6a6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556478; c=relaxed/simple;
	bh=SNDLkUHvmjgV4agMrl0evzWsJOiSAWu+pKko4I+hyE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKhh/WJixujt0HzFwwHJIk7UZX8d+u3ZmLl1mQjQxgxEAzKwWaZsc9CC6MxPLi7V20sVrS891jefiIz0sEMBN6FUyBHlHgBiNgrd5Cfy5o41YyxRinDCCYVWug8HotJR8jrtMVoN+osJk6cPKyMmBm5H0ovQZ1n1ftrbZyz5Qgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=erPfDZ87; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="erPfDZ87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397091F00893;
	Fri,  9 Oct 2026 14:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556476;
	bh=pUGjKahWjfU8cmxndfT+ek7mZ3YPVPWy8pKgStQKZhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=erPfDZ87xaPvoIRrDV/gtD3z46Xxxkp2QO7nS4thZkqCknNcDTMLYO4r9Jp1sgTd3
	 LEArs2DQI8Ikm1zlm6QsY0N8zA5ZqmE1I8BJvw+TK13HWEG4wR+n6u8SP+pHaU7ULW
	 30Io2J3GnW+jzCCAKIQqvQKQojHPKzVeuRzXfn6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haojie Li <lihaojie@kylinos.cn>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 7.2 182/428] drm/mediatek: Add missing IS_ERR check for ovl_adaptor platform device
Date: Fri,  9 Oct 2026 16:08:39 +0200
Message-ID: <20261009140950.145474726@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1112,6 +1112,9 @@ static int mtk_drm_probe(struct platform
 							    PLATFORM_DEVID_AUTO,
 							    (void *)private->mmsys_dev,
 							    sizeof(*private->mmsys_dev));
+		if (IS_ERR(ovl_adaptor))
+			return PTR_ERR(ovl_adaptor);
+
 		private->ddp_comp[DDP_COMPONENT_DRM_OVL_ADAPTOR].dev = &ovl_adaptor->dev;
 		mtk_ddp_comp_init(dev, NULL, &private->ddp_comp[DDP_COMPONENT_DRM_OVL_ADAPTOR],
 				  DDP_COMPONENT_DRM_OVL_ADAPTOR);


