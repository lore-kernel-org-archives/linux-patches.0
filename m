Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC7A12FB31;
	Wed, 19 Jun 2024 13:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802562; cv=none; b=Y3c1IG2IeAKmYjjaHy1kMmivhaiinnAw1+c6vaWw9lZ8U8jWC03sc9t01xIJb8RZTiPUY1C27O9Ce1bJOUeh9GuykN5vU453FkHygKJZEsvMs5ifvL/mM3kOSHRsBlHWuaX8SnLHkMS6wK0sc50E31nUWzZi3Y0gDi/P3HkdxHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802562; c=relaxed/simple;
	bh=sn6p4YHvUShK1RGQETdSDG6YYEM8ZZSdsf12s3neq4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZrigZ6rSq4XDerOHHCuHfyEr9b+/DEJwg3wP4SRNUa1jsaqWZCEh2n0Tg2S0vlOcUx2ccASZTpYvDDoksbl4QWQijQJBTtw6Pqv8CZvc7o2dS3OzkePFcDNLfVauepEcWz/2382K+eFyHH0P7ZkUQrD7mCjd1uJIrueLYocjTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AoNQX5Qj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AoNQX5Qj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87495C2BBFC;
	Wed, 19 Jun 2024 13:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802561;
	bh=sn6p4YHvUShK1RGQETdSDG6YYEM8ZZSdsf12s3neq4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AoNQX5Qj6Z4PP8JDc7RG+RspVqk4rjgtZTrmeqrMPmOW7Qnrt5XbvEPuR0K/fmfsE
	 ZcgqGK/uKZJG1L3OEX/aSYDgclC056ZCJo3oKciebgoHgtCKsOEj9bK0unX3iOhWmf
	 iBiK9Ulbw+gEmrE15fTkxgoSXIszMPWIFGKgHPBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"will@kernel.org, mhklinux@outlook.com, petr.tesarik1@huawei-partners.com, nicolinc@nvidia.com, hch@lst.de, Fabio Estevam" <festevam@denx.de>,
	Will Deacon <will@kernel.org>,
	Michael Kelley <mhklinux@outlook.com>,
	Petr Tesarik <petr.tesarik1@huawei-partners.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Fabio Estevam <festevam@denx.de>
Subject: [PATCH 6.6 238/267] swiotlb: Enforce page alignment in swiotlb_alloc()
Date: Wed, 19 Jun 2024 14:56:29 +0200
Message-ID: <20240619125615.456031183@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Will Deacon <will@kernel.org>

commit 823353b7cf0ea9dfb09f5181d5fb2825d727200b upstream.

When allocating pages from a restricted DMA pool in swiotlb_alloc(),
the buffer address is blindly converted to a 'struct page *' that is
returned to the caller. In the unlikely event of an allocation bug,
page-unaligned addresses are not detected and slots can silently be
double-allocated.

Add a simple check of the buffer alignment in swiotlb_alloc() to make
debugging a little easier if something has gone wonky.

Cc: stable@vger.kernel.org # v6.6+
Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Petr Tesarik <petr.tesarik1@huawei-partners.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/dma/swiotlb.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -1627,6 +1627,12 @@ struct page *swiotlb_alloc(struct device
 		return NULL;
 
 	tlb_addr = slot_addr(pool->start, index);
+	if (unlikely(!PAGE_ALIGNED(tlb_addr))) {
+		dev_WARN_ONCE(dev, 1, "Cannot allocate pages from non page-aligned swiotlb addr 0x%pa.\n",
+			      &tlb_addr);
+		swiotlb_release_slots(dev, tlb_addr);
+		return NULL;
+	}
 
 	return pfn_to_page(PFN_DOWN(tlb_addr));
 }


