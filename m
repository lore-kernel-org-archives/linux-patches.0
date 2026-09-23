Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374F0485CC7;
	Wed, 23 Sep 2026 14:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172781; cv=none; b=kJl9IB9+yN8LEJE7JQ2aZZwGtmNWIQ3VpToX+y5Qtogwz7Ry3sTHD/Nppb6CkOC3/hra2Wj0IVeadfGEIVvxtWyRY/P7kxa/ndmsomhvFPTR1h0ZP3fxz9SKyx/t5p09SjgVsHzV3z3Sb7UzkKPJQMqqLvfpM9nbKY7SR5ljaz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172781; c=relaxed/simple;
	bh=z+PqWw0gj+ijSIqFVPgUx8kokrxa5iUiXt9PW9PeiPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZAA8EqeaqnZZKlj4qvdIcE+I7GEjWL+BZMlD7+je4vRq6JollovdZ9OlOPzIIxu6SGaSrsJDr5SNex5qzAEnxxDCDBqUdWbcg2YuOWCyORapClCqZn2H/kdW3rACjOIDA2K2LmhrpbQGA0z+pEBdLqrAN720jRBzi64sK4QO5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VJ7Ko7Yc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VJ7Ko7Yc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735EE1F000FF;
	Wed, 23 Sep 2026 14:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172780;
	bh=vXHDZQ1+guJ+iGQVFE92N8aooomRUpOQg+kI3Nl56iM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VJ7Ko7YcT0az/r9hJaCLYpYfXldVtDcQLaMZ1TV55KeaznC1Yw5pxUeG/k6CmNb13
	 GKBTGi7031fse2FKlzVJNzbflFDlLBRNHMDtmeNmvgUidaDItSM/2ISLgx0CEfRFHB
	 lJJG07e08qC4BUfsTzuffwG8ZhoOfuUgy46wCGvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Sean Anderson <sean.anderson@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 060/438] dma-mapping: dont trace the DMA address when the allocation fails
Date: Wed, 23 Sep 2026 16:01:21 +0200
Message-ID: <20260923140646.343346178@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit 92c6a8d6470f7e7aa86c1f144818d8fa4fcbd5aa ]

dma_alloc_attrs() passes *dma_handle to trace_dma_alloc() without
checking whether the allocation succeeded. No backend writes it on
failure: dma_direct_alloc(), iommu_dma_alloc() and the dma_map_ops
instances assign it only on the path that returns a buffer. Callers
usually pass an uninitialized automatic variable, so a failed allocation
records whatever the stack held, next to the virt_addr=(null) that marks
the record as an error:

 dma_alloc: dmatrace dir=BIDIRECTIONAL dma_addr=deadbeefdeadbeef
 size=1099511627776 virt_addr=0000000000000000

The device coherent pool path reaches the same call: a non-zero return
from dma_alloc_from_dev_coherent() means the request was handled, not
that it succeeded, so cpu_addr is NULL and dma_handle is untouched once
the pool runs out.

For an allocation event a NULL virt_addr already means the request
failed, so the address field carries nothing. Report 0 for it in the
event class rather than at each call site, which covers dma_alloc_pages()
and dma_alloc_sgt_err() as well.

Fixes: 038eb433dc14 ("dma-mapping: add tracing for dma-mapping API calls")
Fixes: 68b6dbf1f441 ("dma-mapping: trace more error paths")
Suggested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Link: https://lore.kernel.org/r/20260907120124.603373-1-donggeunyoo.kernel@gmail.com
Reviewed-by: Sean Anderson <sean.anderson@linux.dev>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/dma.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/dma.h b/include/trace/events/dma.h
index 31c9ddf72c9d3..daef2c176ecd8 100644
--- a/include/trace/events/dma.h
+++ b/include/trace/events/dma.h
@@ -133,7 +133,7 @@ DECLARE_EVENT_CLASS(dma_alloc_class,
 	TP_fast_assign(
 		__assign_str(device);
 		__entry->virt_addr = virt_addr;
-		__entry->dma_addr = dma_addr;
+		__entry->dma_addr = virt_addr ? dma_addr : 0;
 		__entry->size = size;
 		__entry->flags = flags;
 		__entry->dir = dir;
-- 
2.53.0



