Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D4730101A;
	Fri, 21 Nov 2025 13:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732192; cv=none; b=KzIQyIYlYWrHDm9G4UF9carSDq594wRTMEiEzNFpCs6V2XndhcLbW8H0QnqGRdr5iGg9rcDCM7r64C0d0SXSoWjPUW/93s4GwDeaf6GayUsjLggha/6jPv0XmMWtoVCuQu4196A4LHupnjOp8V9dcmBsfA88ElUl1e+3T3GBkvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732192; c=relaxed/simple;
	bh=AXqbfKoRI5pRIirCBGoe3Ff7OaJp2dncy8yBkg4H4Gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+6P8GWy3Sd0FQAccN1BcAS7Bcm5wpgjiaGmB0YvRlPN8RKFhUyvm/za36+NrHRTiWN4bXN9sKZMbsP+YntIEjvYnH9/+CGZcOFxs1E2H3aMg1Rv+6LHHnMFi8dBKpTeAg+MDwf5Pskg6Jcy2XsSdPVGfWhfney4m+83v770xas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3LdYGk1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3LdYGk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F00C4CEF1;
	Fri, 21 Nov 2025 13:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732192;
	bh=AXqbfKoRI5pRIirCBGoe3Ff7OaJp2dncy8yBkg4H4Gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3LdYGk1fXKfVoztwZjeFmILgAcR8oZjcBDBhlJa3xtkJGNlV9R5QUkJstag3JZtF
	 UtG2/Vb4X3x+uB4tJH8YnduyU4yQg5OQPDDDDUZIHHHTOL0+ksRt5dJwEsb2ZhKrfY
	 2jT7gp4eqNjpWzMB2UoiL9lKIrKep7ygsJQmrGLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomeu Vizoso <tomeu@tomeuvizoso.net>,
	Lucas Stach <l.stach@pengutronix.de>,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/529] drm/etnaviv: fix flush sequence logic
Date: Fri, 21 Nov 2025 14:05:35 +0100
Message-ID: <20251121130232.285196476@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Tomeu Vizoso <tomeu@tomeuvizoso.net>

[ Upstream commit a042beac6e6f8ac1e923784cfff98b47cbabb185 ]

The current logic uses the flush sequence from the current address
space. This is harmless when deducing the flush requirements for the
current submit, as either the incoming address space is the same one
as the currently active one or we switch context, in which case the
flush is unconditional.

However, this sequence is also stored as the current flush sequence
of the GPU. If we switch context the stored flush sequence will no
longer belong to the currently active address space. This incoherency
can then cause missed flushes, resulting in translation errors.

Fixes: 27b67278e007 ("drm/etnaviv: rework MMU handling")
Signed-off-by: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Christian Gmeiner <cgmeiner@igalia.com>
Link: https://lore.kernel.org/r/20251021093723.3887980-1-l.stach@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_buffer.c b/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
index b13a17276d07c..88385dc3b30d8 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
@@ -347,7 +347,7 @@ void etnaviv_buffer_queue(struct etnaviv_gpu *gpu, u32 exec_state,
 	u32 link_target, link_dwords;
 	bool switch_context = gpu->exec_state != exec_state;
 	bool switch_mmu_context = gpu->mmu_context != mmu_context;
-	unsigned int new_flush_seq = READ_ONCE(gpu->mmu_context->flush_seq);
+	unsigned int new_flush_seq = READ_ONCE(mmu_context->flush_seq);
 	bool need_flush = switch_mmu_context || gpu->flush_seq != new_flush_seq;
 	bool has_blt = !!(gpu->identity.minor_features5 &
 			  chipMinorFeatures5_BLT_ENGINE);
-- 
2.51.0



