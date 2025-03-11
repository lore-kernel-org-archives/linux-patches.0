Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96D825E473;
	Tue, 11 Mar 2025 15:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706439; cv=none; b=drK8GUfJ/dLvXqzFFllemICj5f9QynxVudUB4ItdqONoqS7lqEB5SFIAoEXhkskS/6RCXS1vetUHIzU2z5qcY+6CpwR8nIQf1ON39u7y5x8SEThs0pEmnzeVypO1LBqDD0Q3QY52kYRzXkRxUao6hUamTe+f5s38g7W1U5W1K8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706439; c=relaxed/simple;
	bh=as8gJBDh5AsvZDHvWsjuXsp0TuqWFg5nZ5JZCb6QuCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+Qr+aihpVMe8KuJnNTKJY/Nz3kxgn+6HbIf/vLJCP0Sr5bs/jaFG16FgZfrRd8kDbwM+7Y4Lff2ufCO8W04kTIBEp0yiqLjLJZF0UQNwfJstF5IxuRi1SArVYLTfTlpiEooHPv9D4leo8X9oVLZZAHAh+NLeMkxQitmlW/E+qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ce1FrcYM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ce1FrcYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66680C4CEE9;
	Tue, 11 Mar 2025 15:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706438;
	bh=as8gJBDh5AsvZDHvWsjuXsp0TuqWFg5nZ5JZCb6QuCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ce1FrcYM2SZC3FuUGKdBD+5vzodSUtQ9mI+S1Pw9kTCPedKPu5YyF+GwFiHpoL3fs
	 vP6yA3WmYEiyDLJC3jhwTRDVLaEeNzX25KQJXd+3Mfw7+C5mLnuTkjgWzUtZKKadNf
	 +zf2iaswOCRDo2xzGzy0FTKeoI5oG1sVJbLi1A0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sui Jingfeng <sui.jingfeng@linux.dev>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/462] drm/etnaviv: Fix page property being used for non writecombine buffers
Date: Tue, 11 Mar 2025 15:54:34 +0100
Message-ID: <20250311145758.681342616@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sui Jingfeng <sui.jingfeng@linux.dev>

[ Upstream commit 834f304192834d6f0941954f3277ae0ba11a9a86 ]

In the etnaviv_gem_vmap_impl() function, the driver vmap whatever buffers
with write combine(WC) page property, this is incorrect. Cached buffers
should be mapped with the cached page property and uncached buffers should
be mapped with the uncached page property.

Fixes: a0a5ab3e99b8 ("drm/etnaviv: call correct function when trying to vmap a DMABUF")
Signed-off-by: Sui Jingfeng <sui.jingfeng@linux.dev>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gem.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gem.c b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
index aa372982335e9..bdd3564634e79 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
@@ -351,6 +351,7 @@ void *etnaviv_gem_vmap(struct drm_gem_object *obj)
 static void *etnaviv_gem_vmap_impl(struct etnaviv_gem_object *obj)
 {
 	struct page **pages;
+	pgprot_t prot;
 
 	lockdep_assert_held(&obj->lock);
 
@@ -358,8 +359,19 @@ static void *etnaviv_gem_vmap_impl(struct etnaviv_gem_object *obj)
 	if (IS_ERR(pages))
 		return NULL;
 
-	return vmap(pages, obj->base.size >> PAGE_SHIFT,
-			VM_MAP, pgprot_writecombine(PAGE_KERNEL));
+	switch (obj->flags & ETNA_BO_CACHE_MASK) {
+	case ETNA_BO_CACHED:
+		prot = PAGE_KERNEL;
+		break;
+	case ETNA_BO_UNCACHED:
+		prot = pgprot_noncached(PAGE_KERNEL);
+		break;
+	case ETNA_BO_WC:
+	default:
+		prot = pgprot_writecombine(PAGE_KERNEL);
+	}
+
+	return vmap(pages, obj->base.size >> PAGE_SHIFT, VM_MAP, prot);
 }
 
 static inline enum dma_data_direction etnaviv_op_to_dma_dir(u32 op)
-- 
2.39.5



