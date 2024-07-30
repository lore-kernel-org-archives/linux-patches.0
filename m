Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530681A6195;
	Tue, 30 Jul 2024 16:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358451; cv=none; b=GPiQhz+Wm8pp5PDQhEiolCetRPbbb25SI80zOiO3mpIfQzi9duGgUGX8kUYWtUVsHBNU2D5vmfjvLm5bPOa9NRDrOcPjyyPrbxdYpvR8yPTmD02BNObl5BTHhyG8leGKeJbE4JCEWjfIkOMtsMlL4cRt3Pvd2+bOHDgiBmEtvQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358451; c=relaxed/simple;
	bh=RI8b7cusEt5oNG50Ndco6yJGZoDvpMFxxVOivFPAI8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inmKed1fxa4fb+HUTtAl0B8XlaFkEtjiZOQqfTEiOslbBSy1Ithmu+dCj0ej+lpRM3zmvj9wPglyBStlQcWv0y0vW7nhpN8rhL/PcJQVZfx7V5VN0pPkh7yhnatScnxBpvOwrGhOg4WVEhUQiQVIxpH+QC7FG3qjNpVKtKtE+u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DgzwB3Kx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DgzwB3Kx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9375C32782;
	Tue, 30 Jul 2024 16:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358451;
	bh=RI8b7cusEt5oNG50Ndco6yJGZoDvpMFxxVOivFPAI8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DgzwB3KxLAqhaEA1ty/5JFhwQtOBHOd+/9/o068hutiHN9/r5Su9+8sJKgWviG6j8
	 KDmjpNBIhKfEIxHpJS+1+9YaB4wt49+9kKx8vYaLZmoeTBbr8BFHvJScXdDJktjjcR
	 LWK07TUvWcK9ScVAUHISiqajOFcNOiv3Hu7j0fzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 348/809] drm/etnaviv: fix DMA direction handling for cached RW buffers
Date: Tue, 30 Jul 2024 17:43:44 +0200
Message-ID: <20240730151738.380461249@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 58979ad6330a70450ed78837be3095107d022ea9 ]

The dma sync operation needs to be done with DMA_BIDIRECTIONAL when
the BO is prepared for both read and write operations.

Fixes: a8c21a5451d8 ("drm/etnaviv: add initial etnaviv DRM driver")
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Christian Gmeiner <cgmeiner@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gem.c b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
index 71a6d2b1c80f5..5c0c9d4e3be18 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
@@ -355,9 +355,11 @@ static void *etnaviv_gem_vmap_impl(struct etnaviv_gem_object *obj)
 
 static inline enum dma_data_direction etnaviv_op_to_dma_dir(u32 op)
 {
-	if (op & ETNA_PREP_READ)
+	op &= ETNA_PREP_READ | ETNA_PREP_WRITE;
+
+	if (op == ETNA_PREP_READ)
 		return DMA_FROM_DEVICE;
-	else if (op & ETNA_PREP_WRITE)
+	else if (op == ETNA_PREP_WRITE)
 		return DMA_TO_DEVICE;
 	else
 		return DMA_BIDIRECTIONAL;
-- 
2.43.0



