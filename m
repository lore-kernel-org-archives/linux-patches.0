Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A283E2CA6;
	Thu, 13 Jun 2024 12:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282990; cv=none; b=TelLTLGR9KFp0fAgV9N2hUTS6JTh8UTz/Xaozh7e6FKclh08trp3qYqNE+o/P1fmN7FuHDk2ebwxpfnymoceO7RrDIA968OvXJ3KaNawSmtZjvhuDcwcimJzP00fVfSwHZmHuaYo6RqDrcvxcfmyonhCnZzrzW2JZQADJYQTIY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282990; c=relaxed/simple;
	bh=T2HjcWZue6wbV+R7+Ht14Hy3XprA0jx+9bP7+LpcZSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hv7tBT07ZEjYJDGLX248CaoiUI4ei29G4Ugqh/PK0bAn5cY861ZZ79zidzRVNfVYB/wuJ+NTqH50nmqBnWulk/wEc4rTWYYpOxYyFxryiQWakt+Qk2ODhzrHzIjcPay1frNUiIDSLMQEqLQJTLXWlF+PDatwO9D8x3r/+EGi0bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FQbCDD2b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FQbCDD2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C305EC2BBFC;
	Thu, 13 Jun 2024 12:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282990;
	bh=T2HjcWZue6wbV+R7+Ht14Hy3XprA0jx+9bP7+LpcZSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FQbCDD2bCyg4UzrZ/pQd/VXrw60kS0aW8PbCPmuTbpflwloiJRkMiKCCY5W0WFGNk
	 uqREH+iJU8yWz+UdTD3JQhbnmWAFEAO+QCu/9k2AEiNamJGnptdyq24nsrOUo9dkc/
	 OGep2IvN7uSf0TUI7kJ8e6R1IjrAR++HHa/n/rUI=
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
Subject: [PATCH 6.1 62/85] mm/cma: drop incorrect alignment check in cma_init_reserved_mem
Date: Thu, 13 Jun 2024 13:36:00 +0200
Message-ID: <20240613113216.532241738@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -186,10 +186,6 @@ int __init cma_init_reserved_mem(phys_ad
 	if (!size || !memblock_is_region_reserved(base, size))
 		return -EINVAL;
 
-	/* alignment should be aligned with order_per_bit */
-	if (!IS_ALIGNED(CMA_MIN_ALIGNMENT_PAGES, 1 << order_per_bit))
-		return -EINVAL;
-
 	/* ensure minimal alignment required by mm core */
 	if (!IS_ALIGNED(base | size, CMA_MIN_ALIGNMENT_BYTES))
 		return -EINVAL;


