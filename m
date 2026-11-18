Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057030;
	b=sFf8J0VBI/bYnh+pwqpvAI5eY5WAdKgLJ6pylCqhhTJQFwJur1j/gZfbvpkF1U2aZViC
	 KSuwjI8SHF1R96V9XVq8/ZJuWjW4XR0dOQAhv9BVhYvoRkvvd1XjFwtTfTrn9vPVGVk69
	 ln8vQFx1r1uCB8DhZXuWVd4/LLkmtjeRdfgQixBeGWFToUhgAe+V9aEtdcBvN9ObkAgrU
	 tRdh/KOxBe0U3LRrFIxscMVu9XBRUyYNEql27MIgN915s9veaMkK7ZlEgnR7p2aFf0YX8
	 j5V86HaOJtRmUrXI2RH6Uwdh5NIk8YD5gRyL6jFUgirzZRnZtNmZ7BEoGFw9Tfh+Diw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057030;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nymIuwX15qE0wz+hE/DYFhvl++SOs/gWNItByddNyPE=;
	b=rKlv0+nhnaBFSMcCBlf9rZgiF+5rHBrCIocz1jc/4mtJgcqHmGsNoGtxTN3XJ31PFFjO
	 eYBkcG0ddhopqfX2CQmEORkizyjYFGialCUuvyX/o0B1WX4l+poo/hqyG447xXZqRfheQ
	 lrRVxDbEdlop6LUgyvPtJRs7djmiRhaFAVUa837hLl73gL27AMG11BWAZPy02knx+BzEf
	 pxn8GVqpppJAShXLU0McPIhSLhpJEE2EBeekMwCWuyWmcwg41As3XTI39kKyndaQIk21u
	 38qHheEn/WklCsN8mOjdxDc/vDhKb5L/PNNlOujiYw+wig0E778+xXKbMXhh+H39j+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iiST9kKn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF561606A330;
	Thu, 19 Nov 2026 02:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iiST9kKn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA131F000C4;
	Thu, 19 Nov 2026 02:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057030;
	bh=nymIuwX15qE0wz+hE/DYFhvl++SOs/gWNItByddNyPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iiST9kKnx8tpreliTBy70cW4J48CcATsWimJvp07gqZxEVMeG+47Q5zvOOBh6dXqX
	 4IOt7s4zpAncKaTJaX4uzkg/RHJFTWO18KXlabMTx45iB4jiHnY1Glxi2rbVaia5dk
	 m+R2STxyIi/t38VW+Tuq2cRIvI3I3dmkKsQ0BIe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Steven Price <steven.price@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.15 2198/2214] irqchip/gic-v3-its: Fix over allocation in itt_alloc_pool()
Date: Wed, 18 Nov 2026 16:04:34 +0100
Message-ID: <20261118150138.223886642@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Price <steven.price@arm.com>

commit bc88d44bd7e45b992cf8c2c2ffbc7bb3e24db4a7 upstream.

itt_alloc_pool() calls its_alloc_pages_node() to allocate an individual
page to add to the pool (for allocations <PAGE_SIZE). However the final
argument of its_alloc_pages_node() is the page order not the number of
pages. Currently it allocates two pages and leaks the second page.
Fix it by passing 0 instead (1 << 0 = 1 page).

Fixes: b08e2f42e86b ("irqchip/gic-v3-its: Share ITS tables with a non-trusted hypervisor")
Reported-by: Shanker Donthineni <sdonthineni@nvidia.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/1f6e19c4-1fb9-43ab-a8a2-a465c9cff84b@arm.com
Closes: https://lore.kernel.org/r/ed65312a-245c-4fa5-91ad-5d620cab7c6b%40nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3-its.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -264,7 +264,7 @@ static void *itt_alloc_pool(int node, in
 		if (addr)
 			break;
 
-		page = its_alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 1);
+		page = its_alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
 		if (!page)
 			break;
 


