Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324A5335561;
	Fri,  9 Jan 2026 12:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960087; cv=none; b=s0DkdlB4zSMEtZeeSs7cXh3ycJcetPs1KXozsQs2hYYk/OWTyXYk4eIzylFPvxG+z2IS+Dws1k8FeggQ2KAJXvGJvkhUrajFCay0nt2p6LSbskx9OrLaZGupF7rdzW26984fyvbNMsSKFiPPcfMF+DXMNV9TVRwFi4RLKMgMSko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960087; c=relaxed/simple;
	bh=V556lk7IU/IvJsWI9zNNFkR99szWxHuYrueSc/NF0ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpjfYy10eP6ioIlvR31dA/onnvP2Ezo2hDc8EY/2Tp5biM1IP1X/vRJU7JWGoBTEca1Le4y+x2UbnBYXto9iIRuDEkCWwxqMFWyPI49wQBWSKEv5PHxqgwi8tRbx7Q2cepmm/V70uElhmNObN7rt2/OQSfjK1o9wdCffoBBiG5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+cda4Ed; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+cda4Ed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24C7C4CEF1;
	Fri,  9 Jan 2026 12:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960087;
	bh=V556lk7IU/IvJsWI9zNNFkR99szWxHuYrueSc/NF0ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+cda4EdzGrcT75nllgH6kezuR74O5XmHZM5s/YW0w1Pr22oe+rP2/s61jYi0AtlM
	 P0Tgbh7BH662YnRjdYZUV4khuroOq8rWNe4gVA10qnTdfbfu23/53YyLgXZzWsj+Tt
	 93o+eOT4qrrH96IfJeMJaZ+AWWrsOzKVMQwNIZb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 279/737] dma/pool: eliminate alloc_pages warning in atomic_pool_expand
Date: Fri,  9 Jan 2026 12:36:58 +0100
Message-ID: <20260109112144.505340400@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
index 6b0be9598a973..b3b9c7ec5fc54 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -93,7 +93,7 @@ static int atomic_pool_expand(struct gen_pool *pool, size_t pool_size,
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



