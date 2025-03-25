Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1144525C717;
	Tue, 25 Mar 2025 12:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906260; cv=none; b=uU3GS4uFyZXFgkP20ymMCsBJ0aWjoycOTI4mNyrXYA/h5bhxjBqmam1WhoIrq6IM1mEhj43bxGiRvSkBybuyHXVWuHIBFwyH1bbzyYVaWKGcW5Bbo9K9Et4aAPtUjYdPEWt9QRl4KjzbC5ahxd9tzX9juW9VulQcjrbBwDNgi5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906260; c=relaxed/simple;
	bh=he2HYiAAnHOMYLX4QYDfddtxUcK70wb0KmqDPkCBTlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwrAadBFeZbdPzgcb+uSHO/bRfIeA0mLnFGsGB5EOfPN3ZEEC1/brYwp+6ekFJOBIx/eQW5OwRROdltnCDAEEuhl+/pX7kgYTxPOqFDkYy+ieCpEgWKi9sPCVniWKKOAgRlg1VT4sWGtI0RLE+SkcJO4aAKcWUYdUMvA9JmbYbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+E1ouhS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+E1ouhS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93F5C4CEE4;
	Tue, 25 Mar 2025 12:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906259;
	bh=he2HYiAAnHOMYLX4QYDfddtxUcK70wb0KmqDPkCBTlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+E1ouhS00tIW0/p930cYBie7XrjeTgbpTS+ObXdxK3U2xrWiZNOm/t8NiHv+ff2V
	 ya54sN+T0GQk2ixo3MzrxBZpVtwKHAopx0T0/6lu98zWD8OWwRCCR0ymEnubksZOdF
	 MuhLesNRxnetBKI6A/Q0i43fyOndrCWtQdKtGYSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/116] dma-mapping: fix missing clear bdr in check_ram_in_range_map()
Date: Tue, 25 Mar 2025 08:21:49 -0400
Message-ID: <20250325122149.785195450@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 8324993f60305e50f27b98358b01b9837e10d159 ]

As discussed in [1], if 'bdr' is set once, it would never get
cleared, hence 0 is always returned.

Refactor the range check hunk into a new helper dma_find_range(),
which allows 'bdr' to be cleared in each iteration.

Link: https://lore.kernel.org/all/64931fac-085b-4ff3-9314-84bac2fa9bdb@quicinc.com/ # [1]
Fixes: a409d9600959 ("dma-mapping: fix dma_addressing_limited() if dma_range_map can't cover all system RAM")
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Link: https://lore.kernel.org/r/20250307030350.69144-1-quic_bqiang@quicinc.com
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/direct.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 5b4e6d3bf7bcc..b8fe0b3d0ffb6 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -584,6 +584,22 @@ int dma_direct_supported(struct device *dev, u64 mask)
 	return mask >= phys_to_dma_unencrypted(dev, min_mask);
 }
 
+static const struct bus_dma_region *dma_find_range(struct device *dev,
+						   unsigned long start_pfn)
+{
+	const struct bus_dma_region *m;
+
+	for (m = dev->dma_range_map; PFN_DOWN(m->size); m++) {
+		unsigned long cpu_start_pfn = PFN_DOWN(m->cpu_start);
+
+		if (start_pfn >= cpu_start_pfn &&
+		    start_pfn - cpu_start_pfn < PFN_DOWN(m->size))
+			return m;
+	}
+
+	return NULL;
+}
+
 /*
  * To check whether all ram resource ranges are covered by dma range map
  * Returns 0 when further check is needed
@@ -593,20 +609,12 @@ static int check_ram_in_range_map(unsigned long start_pfn,
 				  unsigned long nr_pages, void *data)
 {
 	unsigned long end_pfn = start_pfn + nr_pages;
-	const struct bus_dma_region *bdr = NULL;
-	const struct bus_dma_region *m;
 	struct device *dev = data;
 
 	while (start_pfn < end_pfn) {
-		for (m = dev->dma_range_map; PFN_DOWN(m->size); m++) {
-			unsigned long cpu_start_pfn = PFN_DOWN(m->cpu_start);
+		const struct bus_dma_region *bdr;
 
-			if (start_pfn >= cpu_start_pfn &&
-			    start_pfn - cpu_start_pfn < PFN_DOWN(m->size)) {
-				bdr = m;
-				break;
-			}
-		}
+		bdr = dma_find_range(dev, start_pfn);
 		if (!bdr)
 			return 1;
 
-- 
2.39.5



