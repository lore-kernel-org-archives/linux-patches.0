Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5348B1A6199;
	Tue, 30 Jul 2024 16:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357184; cv=none; b=GWZNqB1sCGCfUqOQr8N7wxX6IbVbKOoP3LjDIksqjaoxtjAIBx9dK0x/8eUzqv3Mua4ppom54G/9sc5vOeq4uH0rGU72Xma4JK75iuYFgiJIGKzQuAeXW4nb694CJ+D1wAvAsa1f/MJjPckNb7DXZURrWHItYjHND6Z5XhT2FJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357184; c=relaxed/simple;
	bh=NcPfSdRI7wYRSJ2cHMfYcuAh8eR9KLxbe5Uz+F5FnSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXZwbvHbdWg0OOmlXkPifeS+IEkZfu1DCBFDMghzT/3vJlafPRu9e0E/XDLuVM1A1VRWEgySfXWiM5lTJrzK2zLML1sCePYX2M2e7YpeRV6g+HULB2H3ouNqEZARyl1HA+qAugHqmWl/+f/ndvyqRTnETlm/RUgIO0D4agsmzOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gkTJSFgR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gkTJSFgR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8FFC32782;
	Tue, 30 Jul 2024 16:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357184;
	bh=NcPfSdRI7wYRSJ2cHMfYcuAh8eR9KLxbe5Uz+F5FnSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gkTJSFgRPqBSu+OfIT7vEfRJCErGjalhyE4axIKtbs4DQxm9TDita76Fg2rDYhVPP
	 nVmQr1iCChkiZBAFPe0KhpQRqREXccT2XePqcma7dawsdiBLarbRkQMG2uFnjfrRy+
	 1SfeH9KlLyqoSmeuD+Fc8n9SGslSzRkK6JX6RlBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 227/568] drm/etnaviv: fix DMA direction handling for cached RW buffers
Date: Tue, 30 Jul 2024 17:45:34 +0200
Message-ID: <20240730151648.756019523@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index b5f73502e3dd4..69fccbcd92c62 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
@@ -356,9 +356,11 @@ static void *etnaviv_gem_vmap_impl(struct etnaviv_gem_object *obj)
 
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



