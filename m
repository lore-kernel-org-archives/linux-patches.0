Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49517157059;
	Mon, 29 Jan 2024 17:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548216; cv=none; b=TU2UOD65ziOaWM/F1EbW9Lg0GtUYWwyIkizMy5QQwjvB0H5N8pLazENdArY85id56+8LuGD3ueUW3mvpdqbrxiLL9GgRy0nj99GeBSTOou2ckuNnPskGsnbi20VjqOvl2ZPlvzeOHbi+e43fSFjokLhjb48fLs1Yxa9seeVOgH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548216; c=relaxed/simple;
	bh=fkPpcqPNnlL6E67tP1ealJ2P0fWiRTzDN3E8Mn6YndY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDnGpp6jXiYbB29iMjMg4smiusupUpRmF3sltkTP2ZezUN1ZaIYQDtaJc/PZrbQ9dy6zb16hZqe8fr7Hqzxty3+09GZl9+F4nUHHZaRQVUBFqeugNQoPgMnYMxBIQ/S0B1zL9yVYFq6HyJFHXtURTj77ZpP1AxmwTXHqOTbXoMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ImZNon0Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ImZNon0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD03C43399;
	Mon, 29 Jan 2024 17:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548216;
	bh=fkPpcqPNnlL6E67tP1ealJ2P0fWiRTzDN3E8Mn6YndY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ImZNon0Z8QE0N97Oq4jbQwSkUn1eAvQXdJ/c4BrCk0iAaKv5f3ikicZRSYNfHaj8k
	 8pAs7UwtpZjhwCrpafxKKVjr9bOuX2jau5dbKvVauAIm7eELXbknQdSTWfWAZizs3v
	 BUqVv9e6FlNRfwFdNhliDj8ms24HfXgSLh45ya70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.1 023/185] mips: Fix max_mapnr being uninitialized on early stages
Date: Mon, 29 Jan 2024 09:03:43 -0800
Message-ID: <20240129165959.345084220@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

From: Serge Semin <fancer.lancer@gmail.com>

commit e1a9ae45736989c972a8d1c151bc390678ae6205 upstream.

max_mapnr variable is utilized in the pfn_valid() method in order to
determine the upper PFN space boundary. Having it uninitialized
effectively makes any PFN passed to that method invalid. That in its turn
causes the kernel mm-subsystem occasion malfunctions even after the
max_mapnr variable is actually properly updated. For instance,
pfn_valid() is called in the init_unavailable_range() method in the
framework of the calls-chain on MIPS:
setup_arch()
+-> paging_init()
    +-> free_area_init()
        +-> memmap_init()
            +-> memmap_init_zone_range()
                +-> init_unavailable_range()

Since pfn_valid() always returns "false" value before max_mapnr is
initialized in the mem_init() method, any flatmem page-holes will be left
in the poisoned/uninitialized state including the IO-memory pages. Thus
any further attempts to map/remap the IO-memory by using MMU may fail.
In particular it happened in my case on attempt to map the SRAM region.
The kernel bootup procedure just crashed on the unhandled unaligned access
bug raised in the __update_cache() method:

> Unhandled kernel unaligned access[#1]:
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.7.0-rc1-XXX-dirty #2056
> ...
> Call Trace:
> [<8011ef9c>] __update_cache+0x88/0x1bc
> [<80385944>] ioremap_page_range+0x110/0x2a4
> [<80126948>] ioremap_prot+0x17c/0x1f4
> [<80711b80>] __devm_ioremap+0x8c/0x120
> [<80711e0c>] __devm_ioremap_resource+0xf4/0x218
> [<808bf244>] sram_probe+0x4f4/0x930
> [<80889d20>] platform_probe+0x68/0xec
> ...

Let's fix the problem by initializing the max_mapnr variable as soon as
the required data is available. In particular it can be done right in the
paging_init() method before free_area_init() is called since all the PFN
zone boundaries have already been calculated by that time.

Cc: stable@vger.kernel.org
Signed-off-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/mm/init.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -417,7 +417,12 @@ void __init paging_init(void)
 		       (highend_pfn - max_low_pfn) << (PAGE_SHIFT - 10));
 		max_zone_pfns[ZONE_HIGHMEM] = max_low_pfn;
 	}
+
+	max_mapnr = highend_pfn ? highend_pfn : max_low_pfn;
+#else
+	max_mapnr = max_low_pfn;
 #endif
+	high_memory = (void *) __va(max_low_pfn << PAGE_SHIFT);
 
 	free_area_init(max_zone_pfns);
 }
@@ -453,13 +458,6 @@ void __init mem_init(void)
 	 */
 	BUILD_BUG_ON(IS_ENABLED(CONFIG_32BIT) && (_PFN_SHIFT > PAGE_SHIFT));
 
-#ifdef CONFIG_HIGHMEM
-	max_mapnr = highend_pfn ? highend_pfn : max_low_pfn;
-#else
-	max_mapnr = max_low_pfn;
-#endif
-	high_memory = (void *) __va(max_low_pfn << PAGE_SHIFT);
-
 	maar_init();
 	memblock_free_all();
 	setup_zero_pages();	/* Setup zeroed pages.  */


