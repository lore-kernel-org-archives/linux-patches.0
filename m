Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE7E1465A7;
	Thu, 13 Jun 2024 11:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279587; cv=none; b=ho5spCBe2buaPa1LkhXXG8/HeKX5fmQXWwCjmRd45SjRNmpTQm40ABbfFW0f1fu3SIRD5m/L+5ogJUOPa9h++zJm/Pvbdwfh1ohY33O6UN1CLKfsEUSBRKFOR4yi+av1Q1XLNbjsGMSo35/sMd56MTmd3B0WqR70eYiwKv+SgMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279587; c=relaxed/simple;
	bh=XcZngvrOiFgiRdXevEXR+PurPTwgf9tTXx6HKoiwjuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iExrOQtWGSn5Uh36pZDzRa+nv+CwF3oCkXuSrp3Kq7mKQ/HNhyHW4SkX638uSh2ojsnVLzBU5iHJc617lZThxTCC6eA5KZe7sR3EsML+FPIDbLBLruZ2hcknrN/ToifROgC4z/BQVXsBVSCLjoeGoGcYo2/QQyuMCLbcEaB5wjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0XMqu1Zv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0XMqu1Zv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9FCC2BBFC;
	Thu, 13 Jun 2024 11:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279587;
	bh=XcZngvrOiFgiRdXevEXR+PurPTwgf9tTXx6HKoiwjuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0XMqu1ZvJ6LDRx+/fk+e0LVQic0npgmHrVth0IpnYWzAzNV9NvS4KsjAzLyRj2NFT
	 Em7684JtqMpcwfREpUJ6GNIDhA7KZHOol0IcWgCLpGK/FucXrGVy9J4LU1xwbf7+aQ
	 qQTFG18dN+46UiaVenFauWJOOfW5PG1MtvJXmtgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank van der Linden <fvdl@google.com>,
	David Hildenbrand <david@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.9 096/157] mm/cma: drop incorrect alignment check in cma_init_reserved_mem
Date: Thu, 13 Jun 2024 13:33:41 +0200
Message-ID: <20240613113231.139277637@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank van der Linden <fvdl@google.com>

commit b174f139bdc8aaaf72f5b67ad1bd512c4868a87e upstream.

cma_init_reserved_mem uses IS_ALIGNED to check if the size represented by
one bit in the cma allocation bitmask is aligned with
CMA_MIN_ALIGNMENT_BYTES (pageblock size).

However, this is too strict, as this will fail if order_per_bit >
pageblock_order, which is a valid configuration.

We could check IS_ALIGNED both ways, but since both numbers are powers of
two, no check is needed at all.

Link: https://lkml.kernel.org/r/20240404162515.527802-1-fvdl@google.com
Fixes: de9e14eebf33 ("drivers: dma-contiguous: add initialization from device tree")
Signed-off-by: Frank van der Linden <fvdl@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/cma.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/cma.c
+++ b/mm/cma.c
@@ -182,10 +182,6 @@ int __init cma_init_reserved_mem(phys_ad
 	if (!size || !memblock_is_region_reserved(base, size))
 		return -EINVAL;
 
-	/* alignment should be aligned with order_per_bit */
-	if (!IS_ALIGNED(CMA_MIN_ALIGNMENT_PAGES, 1 << order_per_bit))
-		return -EINVAL;
-
 	/* ensure minimal alignment required by mm core */
 	if (!IS_ALIGNED(base | size, CMA_MIN_ALIGNMENT_BYTES))
 		return -EINVAL;


