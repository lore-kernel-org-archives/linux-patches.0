Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0FD1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fY/uew50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEC3C433C8;
	Wed,  4 Oct 2023 18:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443860;
	bh=ml+RbCRW4VYkM/9QbBs2gR2g6YWosBOlVZ6Z+eIjHIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fY/uew50PzqNIjBHCSBNK7thDUXPso1u2n1evezMVW0NwbHE+/BrNLFQ+mDTNxV8E
	 OHLKdtbsWzetNX50trRk8TI2R+gCjXIYK+X8bLDRdEOaCOGudNlaRRmLE0KRAyFzGm
	 A7+SXn8NTNHIVwxFwRf/E1hEAj7eFwb8+GtuTmfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Tao <rongtao@cestc.cn>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 045/321] memblock tests: Fix compilation errors.
Date: Wed,  4 Oct 2023 19:53:10 +0200
Message-ID: <20231004175231.255463999@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rong Tao <rongtao@cestc.cn>

[ Upstream commit 4b2d631236931550f2ab0abc9a666958853ae846 ]

This patch fix the follow errors.

commit 61167ad5fecd ("mm: pass nid to reserve_bootmem_region()") pass nid
parameter to reserve_bootmem_region(),

    $ make -C tools/testing/memblock/
    ...
    memblock.c: In function ‘memmap_init_reserved_pages’:
    memblock.c:2111:25: error: too many arguments to function ‘reserve_bootmem_region’
    2111 |                         reserve_bootmem_region(start, end, nid);
         |                         ^~~~~~~~~~~~~~~~~~~~~~
    ../../include/linux/mm.h:32:6: note: declared here
    32 | void reserve_bootmem_region(phys_addr_t start, phys_addr_t end);
       |      ^~~~~~~~~~~~~~~~~~~~~~
    memblock.c:2122:17: error: too many arguments to function ‘reserve_bootmem_region’
    2122 |                 reserve_bootmem_region(start, end, nid);
         |                 ^~~~~~~~~~~~~~~~~~~~~~

commit dcdfdd40fa82 ("mm: Add support for unaccepted memory") call
accept_memory() in memblock.c

    $ make -C tools/testing/memblock/
    ...
    cc -fsanitize=address -fsanitize=undefined  main.o memblock.o \
     lib/slab.o mmzone.o slab.o tests/alloc_nid_api.o \
     tests/alloc_helpers_api.o tests/alloc_api.o tests/basic_api.o \
     tests/common.o tests/alloc_exact_nid_api.o   -o main
    /usr/bin/ld: memblock.o: in function `memblock_alloc_range_nid':
    memblock.c:(.text+0x7ae4): undefined reference to `accept_memory'

Signed-off-by: Rong Tao <rongtao@cestc.cn>
Fixes: dcdfdd40fa82 ("mm: Add support for unaccepted memory")
Fixes: 61167ad5fecd ("mm: pass nid to reserve_bootmem_region()")
Link: https://lore.kernel.org/r/tencent_6F19BC082167F15DF2A8D8BEFE8EF220F60A@qq.com
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/linux/mm.h          | 2 +-
 tools/testing/memblock/internal.h | 4 ++++
 tools/testing/memblock/mmzone.c   | 2 +-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/include/linux/mm.h b/tools/include/linux/mm.h
index a03d9bba51514..2bc94079d6166 100644
--- a/tools/include/linux/mm.h
+++ b/tools/include/linux/mm.h
@@ -29,7 +29,7 @@ static inline void *phys_to_virt(unsigned long address)
 	return __va(address);
 }
 
-void reserve_bootmem_region(phys_addr_t start, phys_addr_t end);
+void reserve_bootmem_region(phys_addr_t start, phys_addr_t end, int nid);
 
 static inline void totalram_pages_inc(void)
 {
diff --git a/tools/testing/memblock/internal.h b/tools/testing/memblock/internal.h
index fdb7f5db73082..f6c6e5474c3af 100644
--- a/tools/testing/memblock/internal.h
+++ b/tools/testing/memblock/internal.h
@@ -20,4 +20,8 @@ void memblock_free_pages(struct page *page, unsigned long pfn,
 {
 }
 
+static inline void accept_memory(phys_addr_t start, phys_addr_t end)
+{
+}
+
 #endif
diff --git a/tools/testing/memblock/mmzone.c b/tools/testing/memblock/mmzone.c
index 7b0909e8b759d..d3d58851864e7 100644
--- a/tools/testing/memblock/mmzone.c
+++ b/tools/testing/memblock/mmzone.c
@@ -11,7 +11,7 @@ struct pglist_data *next_online_pgdat(struct pglist_data *pgdat)
 	return NULL;
 }
 
-void reserve_bootmem_region(phys_addr_t start, phys_addr_t end)
+void reserve_bootmem_region(phys_addr_t start, phys_addr_t end, int nid)
 {
 }
 
-- 
2.40.1



