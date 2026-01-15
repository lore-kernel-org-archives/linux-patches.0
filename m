Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B4E3BFE5F;
	Thu, 15 Jan 2026 17:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499187; cv=none; b=i89W0gDOh13TXgho0izfgF7me7upEP3eQorZpxELe2itFeZ1ct2VXfbrBTrT0s8bkPiuZAjTuT2bZzjh2VwQNFESK8kL/4+nvuHJgpP2rDRKE9Avp8jUsjPn+j//KmJatP3GYHGYRGZKbQMumgtNR2GlyE/haD3mjO74Kqrvw+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499187; c=relaxed/simple;
	bh=NlbeCjbWejR/LWEvw8z8ucC2K0eGs59CISV2iB0XTaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cynO1CREuX3Fu2HIjbMR/KkzBys0iXs+JPKmekTFL/l3o1O7Ok/UfEuzy3Sx/hdqv0GcKZd76I8nA3XxLFL9nvhCOQ1xXBds7XRyFohy8BKHbMUZmR4f+gPlQ++r5Y5T3u35miwX8QTlrZghTXI9CLmtCAO2bYHrML7cREhA5S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BNCGPPde; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BNCGPPde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3529DC116D0;
	Thu, 15 Jan 2026 17:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499186;
	bh=NlbeCjbWejR/LWEvw8z8ucC2K0eGs59CISV2iB0XTaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BNCGPPdeIYzZTRhvtB9MO8/a3mHCPP7e/Gf5hzXr7lMe5ama1mGqrW7n0TPHZH5IH
	 OYIesB6ZkOYoOMCFzLmiF+t7Hkoa3n+innm8Rwi4QQ43PQ9xtzcaztIaI3s/jvrjZJ
	 9cUotl3Iq1DeRkwcChq+QFpJQI3Yo173eBFCuuHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 139/451] dma/pool: eliminate alloc_pages warning in atomic_pool_expand
Date: Thu, 15 Jan 2026 17:45:40 +0100
Message-ID: <20260115164235.946564655@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Kleikamp <dave.kleikamp@oracle.com>

[ Upstream commit 463d439becb81383f3a5a5d840800131f265a09c ]

atomic_pool_expand iteratively tries the allocation while decrementing
the page order. There is no need to issue a warning if an attempted
allocation fails.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Fixes: d7e673ec2c8e ("dma-pool: Only allocate from CMA when in same memory zone")
[mszyprow: fixed typo]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20251202152810.142370-1-dave.kleikamp@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/pool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index 8396a2c5fb9a5..32efef1660096 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -96,7 +96,7 @@ static int atomic_pool_expand(struct gen_pool *pool, size_t pool_size,
 			page = dma_alloc_from_contiguous(NULL, 1 << order,
 							 order, false);
 		if (!page)
-			page = alloc_pages(gfp, order);
+			page = alloc_pages(gfp | __GFP_NOWARN, order);
 	} while (!page && order-- > 0);
 	if (!page)
 		goto out;
-- 
2.51.0



