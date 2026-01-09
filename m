Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5FE35A948;
	Fri,  9 Jan 2026 12:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961182; cv=none; b=Fngeg7JyA/2fkQrr1pJrh5DiROaWnfGysveN+Wt3tHRH4kbO+XA3gmH1W87fSfXvP1CHfQU8JQ+qHDDHt3nZvQDDH1s81wJVDvr4ov6Kdkiro9pT8zRVk524emnx2FfFZ/llqQ0PkZcC+OvE4RVOj4+A/ZueA1RVtQ/EPvxTV38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961182; c=relaxed/simple;
	bh=mhxTAE/fWqAYULPT6DYLJI4Paw7c2DuW59jpofXHV/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uyaS8bRVVyA2BDQgpMEHiU8lYcwhQlSezPDZ+AJ0AHOGAt0EjzS/TmT7NTXyAAtBAF7YA2MHrcv51jkh1Jia570plKcyR5OYBAZyJZ3LfThkWAhvHPDTDsmZzQ64D9sB+YRd3vF2l5Vdc77PntU/FqMWyi1uxtysKOAY2UFSOQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rmH+dPcE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rmH+dPcE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187BDC4CEF1;
	Fri,  9 Jan 2026 12:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961182;
	bh=mhxTAE/fWqAYULPT6DYLJI4Paw7c2DuW59jpofXHV/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rmH+dPcE4iB8w/m3p7oEjGf5nbTuHBml6iisUhunLXOWeGCDRedyvCPIUkFe+pDca
	 eWX0FIk2R0D32YkWIHqu1AafcgZN3g3YRhqquGKqyGY+N8sAH6QFB6PhJLh96QHVsV
	 Dy7oKOOTDHq98v7lBi0YIewUbiIw8q4fS3uYGo/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	CK Hu <ck.hu@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 663/737] drm/mediatek: Fix probe memory leak
Date: Fri,  9 Jan 2026 12:43:22 +0100
Message-ID: <20260109112158.981670085@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 5e49200593f331cd0629b5376fab9192f698e8ef ]

The Mediatek DRM driver allocates private data for components without a
platform driver but as the lifetime is tied to each component device,
the memory is never freed.

Tie the allocation lifetime to the DRM platform device so that the
memory is released on probe failure (e.g. probe deferral) and when the
driver is unbound.

Fixes: c0d36de868a6 ("drm/mediatek: Move clk info from struct mtk_ddp_comp to sub driver private data")
Cc: stable@vger.kernel.org	# 5.12
Cc: CK Hu <ck.hu@mediatek.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20250923152340.18234-3-johan@kernel.org/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
@@ -588,7 +588,7 @@ int mtk_ddp_comp_init(struct device_node
 	    type == MTK_DSI)
 		return 0;
 
-	priv = devm_kzalloc(comp->dev, sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 


