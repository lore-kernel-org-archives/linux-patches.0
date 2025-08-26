Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7512BE653;
	Tue, 26 Aug 2025 11:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207910; cv=none; b=aL5Ghp/k4cfrQtHmBi/FJ6zfnrUETYp1CGpj9NIQKFMdyi70YJMOEXdMS6XqDOBeOHQhTjrE6eNjeFHtWu8qmZgePWtFQgflverS2bLJj3uvxeQm+NhviJsOB+BPHescXs0cFvvgWmudcu/KbJOUA4sMi8mK04HaAN4lxDNIlfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207910; c=relaxed/simple;
	bh=Aq9oQ+M64b42taiVwtGQyqB7LAwkZ0+/2CYIQsHIMfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQ5Tc0HziTRVBVO1WDAg9CIqRDXG/x215vq6NcAZLGsv+tQFxOWnCxgKR83OK6+WpSq6UdlPAGkL+xv/htF+23cMEHe9FD4PPaZTgP/NTaHN2InQQBtQf3EvEKxtYmew3Stz5B1jmCVYmokdv+lQauP4HpdKlPebY6McMwwPwes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzcWc3bf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzcWc3bf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D10AC4CEF1;
	Tue, 26 Aug 2025 11:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207910;
	bh=Aq9oQ+M64b42taiVwtGQyqB7LAwkZ0+/2CYIQsHIMfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wzcWc3bfXxXrm1GHBgqZNHDhOVmKPTaJ8kiu9REZg3cJfxQvU0OW/0ugNC92Eeqph
	 HliEDTgAElWg2puCko5pFiiKgRbZ1S/XGrVy7+83f2YsrGZhwj6qQ+XOQ2DRnXG+zL
	 3O7jPba4qGMkhZLnAfBJ/CmOsZVC5cXg1xY6taSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhilesh Patil <akhilesh@ee.iitb.ac.in>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 365/457] RDMA/core: Free pfn_list with appropriate kvfree call
Date: Tue, 26 Aug 2025 13:10:49 +0200
Message-ID: <20250826110946.327567551@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhilesh Patil <akhilesh@ee.iitb.ac.in>

[ Upstream commit 111aea0464c20f3eb25a48d5ff6c036e6b416123 ]

Ensure that pfn_list allocated by kvcalloc() is freed using corresponding
kvfree() function. Match memory allocation and free routines kvcalloc -> kvfree.

Fixes: 259e9bd07c57 ("RDMA/core: Avoid hmm_dma_map_alloc() for virtual DMA devices")
Signed-off-by: Akhilesh Patil <akhilesh@ee.iitb.ac.in>
Link: https://patch.msgid.link/aJjcPjL1BVh8QrMN@bhairav-test.ee.iitb.ac.in
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/umem_odp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index b1c44ec1a3f3..572a91a62a7b 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -115,7 +115,7 @@ static int ib_init_umem_odp(struct ib_umem_odp *umem_odp,
 
 out_free_map:
 	if (ib_uses_virt_dma(dev))
-		kfree(map->pfn_list);
+		kvfree(map->pfn_list);
 	else
 		hmm_dma_map_free(dev->dma_device, map);
 	return ret;
@@ -287,7 +287,7 @@ static void ib_umem_odp_free(struct ib_umem_odp *umem_odp)
 	mutex_unlock(&umem_odp->umem_mutex);
 	mmu_interval_notifier_remove(&umem_odp->notifier);
 	if (ib_uses_virt_dma(dev))
-		kfree(umem_odp->map.pfn_list);
+		kvfree(umem_odp->map.pfn_list);
 	else
 		hmm_dma_map_free(dev->dma_device, &umem_odp->map);
 }
-- 
2.50.1



