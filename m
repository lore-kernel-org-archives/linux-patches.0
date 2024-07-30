Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B321A00F7;
	Tue, 30 Jul 2024 16:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356128; cv=none; b=WyhF0YExdXKTAMt1N3v8QBhy/vK0q3dDHLRdgP4TkecYgHosY7CPIKdM/IEEnE7Nim855Z4HqvqEINVB5ccPKPmnEuEaZvEnMPral08lp7WFtM4utJMMBJZijLwfhOFwNWsGLKhmZjCo4xGApvs6aNcskQT9Tjx4TWNCBW/AEQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356128; c=relaxed/simple;
	bh=NJUilYkBnTyZRRwoBIcQPbarrmuO5dWidg6hg4v+YV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WtM6abU3L09DOVAH6oq53nc7xMZ1iY1KgLVw/fqLGzbQlHPvSRadub+Kf7jQlut5bxrskGfZjVKsbDNmXntURfZ2d/nT8OxPagKSZ4P4mXTy9cr2oBgXA9KdgKgyDKUJxE0au/hFjKn3gWgbTN9ETkQD6A9fLjCQwGcgOL2KpAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UGlOQeL+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGlOQeL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DD9C32782;
	Tue, 30 Jul 2024 16:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356128;
	bh=NJUilYkBnTyZRRwoBIcQPbarrmuO5dWidg6hg4v+YV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGlOQeL+jJ9B/oCLKsKuqUhK+4Jts9A7uj6KO4U4im5OZrTc7vJIeJv4CEiNhmDXL
	 xk8Bnw0kz7a0nCVN5bVpsDaOJfH8WqEXPO8eDoPZH7d7SVtiSmADCZeF2RvLl4wvwQ
	 41EqEDWh6tibYHT3zkza8vTiTti+Zrj67X64dmBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 161/440] drm/etnaviv: fix DMA direction handling for cached RW buffers
Date: Tue, 30 Jul 2024 17:46:34 +0200
Message-ID: <20240730151622.162700751@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
index 5cf13e52f7c94..23d5058eca8d8 100644
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



