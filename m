Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E7A7D3EE;
	Wed, 21 Feb 2024 14:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524807; cv=none; b=f/8PbHiaoTaCceZ0YrbyeNcO6VZbG9lqk6f6K6CpCvHMFcVWGb71M28aYQ8ar/VrcMx4sX2HiWrrHh0/ZdNi6lVHEzohrpk8yDJlJw5uMNtwJ2XDIS6A5iTmbMChIuX8vswBeqxg9nIeqlWw66B/uwk4HENzOYTvc1ybZ9PoGJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524807; c=relaxed/simple;
	bh=q10YDg5zNg3dURRyBUjLPzUuzjqRIR1SdqUbWQnJo+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNso0xgwnxuTkuujD2ipoCv33ZMAxWp8jze/OjOZhbWLOHpWdktyuizITmL4mApqLZ6tmu2ShfJJU80FOeDVLjWpkO40S177nWvgjMAwEpfNEdjSVc+WPbEPT9edgZx3BlmtpBW/V51HLlgFuNSS4yx/u4sO9C89wFMyg7KAebA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iSAZlzud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iSAZlzud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53679C433F1;
	Wed, 21 Feb 2024 14:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524807;
	bh=q10YDg5zNg3dURRyBUjLPzUuzjqRIR1SdqUbWQnJo+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iSAZlzud6jPAdz5/4669hai+a4lcallg7Y8BLZMpxZ+11mZnxm7OdbAjs9M1fvdFG
	 NV+cghMJjMrst7MsQKorRwbP+Hi8TWO6jnqETUu29e1dyR5UetrzvosPRQburNBhTR
	 LEK2BmRvqUlYXAbmckMIJXv1BUzs1SHWLfrXFrgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 355/379] mips: Fix max_mapnr being uninitialized on early stages
Date: Wed, 21 Feb 2024 14:08:54 +0100
Message-ID: <20240221130005.541478652@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

From: Serge Semin <fancer.lancer@gmail.com>

[ Upstream commit e1a9ae45736989c972a8d1c151bc390678ae6205 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/mm/init.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index 07e84a774938..32e7b869a291 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -421,7 +421,12 @@ void __init paging_init(void)
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
@@ -457,16 +462,6 @@ void __init mem_init(void)
 	 */
 	BUILD_BUG_ON(IS_ENABLED(CONFIG_32BIT) && (_PFN_SHIFT > PAGE_SHIFT));
 
-#ifdef CONFIG_HIGHMEM
-#ifdef CONFIG_DISCONTIGMEM
-#error "CONFIG_HIGHMEM and CONFIG_DISCONTIGMEM dont work together yet"
-#endif
-	max_mapnr = highend_pfn ? highend_pfn : max_low_pfn;
-#else
-	max_mapnr = max_low_pfn;
-#endif
-	high_memory = (void *) __va(max_low_pfn << PAGE_SHIFT);
-
 	maar_init();
 	memblock_free_all();
 	setup_zero_pages();	/* Setup zeroed pages.  */
-- 
2.43.0



