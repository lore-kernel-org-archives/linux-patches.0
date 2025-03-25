Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A6525D54A;
	Tue, 25 Mar 2025 12:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905905; cv=none; b=Ix4KxDGiS6WkqD/PQ+cF5/khzjn6juF006NC19YlH5bmQ8pVFqhhEYd+rifloBMHzka1ceJPfchPk2tTSq4oyCJvkS9xLhmTotqh4Ys0D9IN2DozFAYfAywZKLCGiM00X8Uj2Pm2ueXEfiYAU6WGDjOegusmmBfZdcetQLhXxHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905905; c=relaxed/simple;
	bh=cjk2z2kGuYtesOrFoKl+1PbIAQncOIbq4GObz/7QQ5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JpVMxHaf80lt0pWixdJE9UQKIUobA/ByRb71+zJWFrCEygCQhtOwxHNidxVN+5Kr/9IW0yyurWsn/1bGWbcLOjmbnUG6rTVHYyIvkM7XiwA4xEiGuN0gY1eQDSmQ8zkP+EL6S6JV9I9nkWCQoSdxPx6g4d6ZFItYKc72MMEofHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B64YIa4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B64YIa4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E96C4CEE4;
	Tue, 25 Mar 2025 12:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905905;
	bh=cjk2z2kGuYtesOrFoKl+1PbIAQncOIbq4GObz/7QQ5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B64YIa4p+kdJzLqsMULZ0lai1qVn3Hjkp5SFNXAXjmSQczSZmzPT60KaI+D2zRHyT
	 xeL/TyEc6oQQiQ8FOv/YCDmUC3Xldi01vCE+qKSmlDMBRlBORw4UP2fxIcZnk3QTj0
	 fip6D9l1isD+gB48OljmIr+bzjiNwqpj7m5EnP2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 021/119] dma-mapping: fix missing clear bdr in check_ram_in_range_map()
Date: Tue, 25 Mar 2025 08:21:19 -0400
Message-ID: <20250325122149.611672548@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



