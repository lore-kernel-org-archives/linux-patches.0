Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D821DE89C;
	Mon, 10 Mar 2025 17:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628643; cv=none; b=h+xlT2MYODuLJCihO+8EPf6EVbk2NpSFmM6lQGje8MsB7DDiWfzGoZQDqDJ7oHh50hhhOr/C2+JYkh+l3xwhJS9H9PrmUrxQPKtTg+OfoUuuInVY/vAp5fBNCXaKSFj+7gKRGLPE3SpHA1XtaffDe5KIia0agK52YB/QE30xGOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628643; c=relaxed/simple;
	bh=Fqq5YIP+Lw1VGv46loMRIm1s39nMls1pxstcI4UepCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJwigacGqdsXa+bdQEsOCbKXZqq7QtB5znXLVZlLxDhWpM8uNw2wI4lsQU7nOOuLzejT1eBuybXQHxDkODM3PiaTJ6Q2IPhVkKdnPLcNWJIDDV+r7iFsl0Dk0ItAGelkbhnRdJjxfF3rPuZ5yFJPr2Ij2DpgRSc7D5XGjZBP3lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IrcqpdLL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IrcqpdLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BEFC4CEED;
	Mon, 10 Mar 2025 17:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628642;
	bh=Fqq5YIP+Lw1VGv46loMRIm1s39nMls1pxstcI4UepCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IrcqpdLLnuEcx0ZvW+Oef5WMyJ8bDSpc4SRWRgoqRtZiHQW3BHARt+smRFHSwo8a1
	 8/6jlMsSZF9QHXfbhV0qJE9GV4YYmEFDgXhSmyosSsl0DhyCxVGoXonuxpBuGEnB/z
	 t5xn86dyG9gnxwzNKhy61iPdKJyIs1eFif7/EJX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sui Jingfeng <sui.jingfeng@linux.dev>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/620] drm/etnaviv: Fix page property being used for non writecombine buffers
Date: Mon, 10 Mar 2025 17:57:45 +0100
Message-ID: <20250310170546.333459387@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 87da2278398ae..1d04232293e58 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
@@ -340,6 +340,7 @@ void *etnaviv_gem_vmap(struct drm_gem_object *obj)
 static void *etnaviv_gem_vmap_impl(struct etnaviv_gem_object *obj)
 {
 	struct page **pages;
+	pgprot_t prot;
 
 	lockdep_assert_held(&obj->lock);
 
@@ -347,8 +348,19 @@ static void *etnaviv_gem_vmap_impl(struct etnaviv_gem_object *obj)
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



