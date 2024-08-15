Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68D01DDF5;
	Thu, 15 Aug 2024 13:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728564; cv=none; b=EWg1WMQPAwUTw5Z8SXMqStZHiAf+UJGPSBegOBX8qy3apr/3hw49Ay1GGBdrBt2OZwa7RCvuuzW516zarTiKcZWUFbcB0Uf2sMag8CKispMdJw18aUkocZsZxaGzxyB0gmcLSn/6FsjrvTnC4m9N9DcHDOK6qqXP+P72dvKb0t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728564; c=relaxed/simple;
	bh=+hAlCvOomL1fBp/d2Fn+KqIBwpTMbub6Kbf6Fjan/So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvzBjiChT09g0nLoA/zX2dcWHHEEZXTFsfjBYBsr+iR51gddCBsJXaAUQbzHC//IkEmIrXpd9oXzX1mCcNw6PnRfnePbmWqrhvwi4B2yiiTdBEN4mFZ/1qYde7Ck6m2caFqfOqFtjf+D+Xa0Ie1UzWwR0bEZ80DOuXT5WWWJstQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2WiGoDU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2WiGoDU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FF3C32786;
	Thu, 15 Aug 2024 13:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728563;
	bh=+hAlCvOomL1fBp/d2Fn+KqIBwpTMbub6Kbf6Fjan/So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2WiGoDUSymDMqt5658sXeiGKXitElwJdbrPNkd2e6m09JZsjUg0yj3cq6HjwKHhu
	 t0fjeIDmw/REOMnUuf2YmDPEx5XYBjZGgeFvxQP89oKqiRGtfNRPXL1Q243jil25Ki
	 oy4uk1HA7GaO2V2JKqT54G1B1OMFJitmFAEnAxWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 038/196] drm/etnaviv: fix DMA direction handling for cached RW buffers
Date: Thu, 15 Aug 2024 15:22:35 +0200
Message-ID: <20240815131853.544310363@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 1fa74226db91f..69f91662ba236 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
@@ -370,9 +370,11 @@ static void *etnaviv_gem_vmap_impl(struct etnaviv_gem_object *obj)
 
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



