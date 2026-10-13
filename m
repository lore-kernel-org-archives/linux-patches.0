Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548004F4739;
	Tue, 13 Oct 2026 12:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894975; cv=none; b=QshXwLOVWqg9GhIBy4IXFc1HvJwkRpQ05LplOnDF/ntrvaL01EBw9m0uVvGtFeSVZY7I5bvvfsf2JONmqtKZs0skRN/671quZz5y7GErIsVyD//L5ijDP46sUF56p95c8QAZKpTDC6NWiMWeTx2tsD5jVjzlNz0nBxAEL+7FkNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894975; c=relaxed/simple;
	bh=57ZpmSDVZZtZD+zsI8lWXu3SL+T/KzV3GNNzQ5qI60M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXaVU8Y+BQOPPevFxdJ7VKtKjLZ1ADttPARKbF5SOBuyZ7VY6YRHkwqer9lkuVIMOfaCNlWEjehM2dhq3/Vam3S3BWh1UG4EqVs+a6AtTERWBJnx7Y+wBsenM6Rf/PZXcekWMXi1L0g1LCPLgTIkkKzRc6lerfSORuXCmK+552M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qGg0yzar; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qGg0yzar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7CA1F00898;
	Tue, 13 Oct 2026 12:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894974;
	bh=NSLSWvzynReU/7XpWg+wrZnGxi82wHHTrqacfyv0ejU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qGg0yzarbhdH4+mr4pigNgAWLaZ8ilRgnYcFMIY1tPXNbm+W+7LUOwUPiYLNE4Juh
	 xtCi7yoIyghOoI5I2LvSCejAXTC9cdnT2LNTeT60TRC/W11ogGtGcbgPYicO8PMDOE
	 VSgLXOMhhWww3cxVwUBZauHCD7gEpbPdfdMUInBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haojie Li <lihaojie@kylinos.cn>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.12 118/497] drm/mediatek: Add missing IS_ERR check for ovl_adaptor platform device
Date: Tue, 13 Oct 2026 13:34:45 +0200
Message-ID: <20261013112910.692093230@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -873,6 +873,9 @@ static int mtk_drm_probe(struct platform
 							    PLATFORM_DEVID_AUTO,
 							    (void *)private->mmsys_dev,
 							    sizeof(*private->mmsys_dev));
+		if (IS_ERR(ovl_adaptor))
+			return PTR_ERR(ovl_adaptor);
+
 		private->ddp_comp[DDP_COMPONENT_DRM_OVL_ADAPTOR].dev = &ovl_adaptor->dev;
 		mtk_ddp_comp_init(dev, NULL, &private->ddp_comp[DDP_COMPONENT_DRM_OVL_ADAPTOR],
 				  DDP_COMPONENT_DRM_OVL_ADAPTOR);


