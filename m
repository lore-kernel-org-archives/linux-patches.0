Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3767D20F8F;
	Fri, 21 Jul 2023 19:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0000C433C9;
	Fri, 21 Jul 2023 19:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967609;
	bh=yCtRCcKJvemSyJ7Qpgn3h+W1BSH1bLS7t//DEQ3eAmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBvFsCsZ34HS+D9KMDmthRPCtkpRRBLk6DSd87iNZdD5Mvg7PLLvwHEL3Pp3+MUBZ
	 w0CoiDzF08qQjDedXDFqs9GzGBAU4P7mEqcmh5Z0KnNNa8t/dyP4bUH4pa0gcdJajz
	 cZX4r2Hqp9CjLW+aW2a4qMdHCjD+QgdKS1FvZbC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Christoph Hellwig <hch@lst.de>,
	iommu@lists.linux.dev,
	Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org
Subject: [PATCH 6.1 222/223] swiotlb: mark swiotlb_memblock_alloc() as __init
Date: Fri, 21 Jul 2023 18:07:55 +0200
Message-ID: <20230721160530.333242277@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

commit 9b07d27d0fbb7f7441aa986859a0f53ec93a0335 upstream.

swiotlb_memblock_alloc() calls memblock_alloc(), which calls
(__init) memblock_alloc_try_nid(). However, swiotlb_membloc_alloc()
can be marked as __init since it is only called by swiotlb_init_remap(),
which is already marked as __init. This prevents a modpost build
warning/error:

WARNING: modpost: vmlinux.o: section mismatch in reference: swiotlb_memblock_alloc (section: .text) -> memblock_alloc_try_nid (section: .init.text)
WARNING: modpost: vmlinux.o: section mismatch in reference: swiotlb_memblock_alloc (section: .text) -> memblock_alloc_try_nid (section: .init.text)

This fixes the build warning/error seen on ARM64, PPC64, S390, i386,
and x86_64.

Fixes: 8d58aa484920 ("swiotlb: reduce the swiotlb buffer size on allocation failure")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: iommu@lists.linux.dev
Cc: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/dma/swiotlb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -324,7 +324,8 @@ static void swiotlb_init_io_tlb_mem(stru
 	return;
 }
 
-static void *swiotlb_memblock_alloc(unsigned long nslabs, unsigned int flags,
+static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
+		unsigned int flags,
 		int (*remap)(void *tlb, unsigned long nslabs))
 {
 	size_t bytes = PAGE_ALIGN(nslabs << IO_TLB_SHIFT);


