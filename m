Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C321D6DB5;
	Tue, 11 Nov 2025 00:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822428; cv=none; b=Kn07HwcDVnuUxuBpxVb6Qdoy3PBCvOcfsRhYopfPuRPso8leGFqb+hL4lCQu3NO299nDHqLxAVidyqGsbnDLceQ3W23tGKQjtg3vYVX7Pqf/eDHSl27FBVjqxGJIAQ5VjPzWDUp4R9tqJ5qaxKAT9KVHzqd8IrffLAt1py3MOBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822428; c=relaxed/simple;
	bh=SsuAMdHFIM3SJAFlzk8+pMYvUZSlk3rizibuKQvOSLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OC/hCg0Ahnrhi9uCs1CjYbkDql0BLI8FnPQ+fHRmnT82eaPiLL8vRjQiryEe0GUy5zIoS/z/39FYyA9OLVKuclFL7FazQCuDXFvhf73bnjT2e9I9x5Z1EKByQIbuZbGJfD7aJYPS9ISYxxXW41gMTjy4d4ybSnXSSayU7YYYeq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PfOucBAN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PfOucBAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70AEC4CEFB;
	Tue, 11 Nov 2025 00:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822428;
	bh=SsuAMdHFIM3SJAFlzk8+pMYvUZSlk3rizibuKQvOSLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PfOucBANcLq26HnChMoGKWhXbSV36TRMXzkUZbKLs9HYtqBZbhxwW4RszBeUTv4zV
	 ecGeHOZiULNH/zPKohMq7/w/8xt1uRACx7xVcA3IsRC57R3Otom5Dpg3USt2o1FHr1
	 Q5wJBpZ1CGnSUC/3mglR1d84WVRmy/3d+l6i2Ex8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomeu Vizoso <tomeu@tomeuvizoso.net>,
	Lucas Stach <l.stach@pengutronix.de>,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/565] drm/etnaviv: fix flush sequence logic
Date: Tue, 11 Nov 2025 09:38:24 +0900
Message-ID: <20251111004527.987488220@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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



