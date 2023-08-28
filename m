Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C06B11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA03C433C7;
	Mon, 28 Aug 2023 10:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219793;
	bh=XpYSADRdeKs/1iC94s2y4DxGeJqUpSASB3VyUsl03iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZunYLFUZNXIePcG30DjRwDOwxPJm8lRWKYgASHEQ0ECQNNIc43//R3GZ5o9eNJq9R
	 pG6gWBny8gv+7hzbIJkTJKcWuOgZoQvbHOjUHK/CS6cbe2pb4UkWgRCaBask+AY9Mo
	 Vm5drUdkcv60M1XwyCpgaTe2tcxVi4VBJFQcn4Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dylan Jhong <dylan@andestech.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Christoph Hellwig <hch@lst.de>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 45/84] mm: add a call to flush_cache_vmap() in vmap_pfn()
Date: Mon, 28 Aug 2023 12:14:02 +0200
Message-ID: <20230828101150.791841642@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101149.146126827@linuxfoundation.org>
References: <20230828101149.146126827@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ghiti <alexghiti@rivosinc.com>

commit a50420c79731fc5cf27ad43719c1091e842a2606 upstream.

flush_cache_vmap() must be called after new vmalloc mappings are installed
in the page table in order to allow architectures to make sure the new
mapping is visible.

It could lead to a panic since on some architectures (like powerpc),
the page table walker could see the wrong pte value and trigger a
spurious page fault that can not be resolved (see commit f1cb8f9beba8
("powerpc/64s/radix: avoid ptesync after set_pte and
ptep_set_access_flags")).

But actually the patch is aiming at riscv: the riscv specification
allows the caching of invalid entries in the TLB, and since we recently
removed the vmalloc page fault handling, we now need to emit a tlb
shootdown whenever a new vmalloc mapping is emitted
(https://lore.kernel.org/linux-riscv/20230725132246.817726-1-alexghiti@rivosinc.com/).
That's a temporary solution, there are ways to avoid that :)

Link: https://lkml.kernel.org/r/20230809164633.1556126-1-alexghiti@rivosinc.com
Fixes: 3e9a9e256b1e ("mm: add a vmap_pfn function")
Reported-by: Dylan Jhong <dylan@andestech.com>
Closes: https://lore.kernel.org/linux-riscv/ZMytNY2J8iyjbPPy@atctrx.andestech.com/
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Reviewed-by: Dylan Jhong <dylan@andestech.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmalloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2453,6 +2453,10 @@ void *vmap_pfn(unsigned long *pfns, unsi
 		free_vm_area(area);
 		return NULL;
 	}
+
+	flush_cache_vmap((unsigned long)area->addr,
+			 (unsigned long)area->addr + count * PAGE_SIZE);
+
 	return area->addr;
 }
 EXPORT_SYMBOL_GPL(vmap_pfn);


