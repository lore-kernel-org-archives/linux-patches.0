Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4177124113D;
	Tue, 11 Nov 2025 00:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822276; cv=none; b=G39gos9fmQhkW+/lH6vn6pifzsMnhOgIdP9rfd+eQFMFrzimLvWkYcf0l40ANuiB3rH2e3vAuZ00LmGRdabX/C0tkMp0vryBqgIefC0VCln22zTZZZO5dRk00WnYesRqv9JiOvRKgoPQp5CsGXxEgECcA6vEm7Nhvb6cAjApleI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822276; c=relaxed/simple;
	bh=wlxCFQBya+qzMl4TtmWf2ewDzqGceLzFw5exlwvAOy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMS7vH4eq3/oNQUdvrUatPpxxq6q7c2e2d+6CH8Wbx+jirM17C/oNlOoPofylRnmhzs1d9BOSGFKusMh0TE+X9dkBj6eFjBAzpT4lGRlJ5dHTth1fuLQrRTvqP/UuKOzaEUG0aJUfjcsK236oJ5aww9GOUTQNJiqDXz34xM5QUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7PIsgJ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7PIsgJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4868C113D0;
	Tue, 11 Nov 2025 00:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822276;
	bh=wlxCFQBya+qzMl4TtmWf2ewDzqGceLzFw5exlwvAOy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7PIsgJ7WaU0+/ylE4Dy4+azLq4fisSq8TtkXHvUmYp8itPf9vn4bSLB6/c+aAu/g
	 RNOnWf2HuYBFdnUasD7FysGhjWBC8Hlajxqfq7y8btWL7TFnrvl9qrQYvmWCWouKg0
	 SLtxrF6IWxO410dVUeTIDcz4d9BnMMwTiHFXv2wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomeu Vizoso <tomeu@tomeuvizoso.net>,
	Lucas Stach <l.stach@pengutronix.de>,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 071/849] drm/etnaviv: fix flush sequence logic
Date: Tue, 11 Nov 2025 09:34:01 +0900
Message-ID: <20251111004538.141575237@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



