Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1F4577E41;
	Wed,  9 Sep 2026 14:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963989; cv=none; b=dWrGOOOt9YZ4aGpRIffPc8z0dPuVvLFfaUjn2VVbyumSpKa3/Cikv50Bf+Ss1xg2HGFM3o4yk+j+9DmcMUB4wy4QvwV1qC30UyWter07zcxmZFSCI1t0j6HTukrogPRmS2LLh5osay/XURgrgKowynvYc6l10eA7Gz9DS3wAO54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963989; c=relaxed/simple;
	bh=ZsWYaM3wMIbeeipyeE2ZnzMTXu+YOLnSFc2qQlBkg+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8ajHCHwqexgiPAlVQ0B7Yts4ZMQAoOz3ozuOJYfMfwNuIDC3VYVo4ltIFlfm4TbRYwT6ljPBKS7LMZtlx23ztOBRcyillaXszhKrQy6nPvM72g1JVWe94bDRQlaMclDQ4PJr8rqFkI5CcCxZ3e0zA6ckZRSQiKytQ+qKHJ0C1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VN+u4HMu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VN+u4HMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2320A1F00A3A;
	Wed,  9 Sep 2026 14:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963987;
	bh=yFgqZCvO1b25/ZLjyE7Ln/xWcAbuq3vAVtJbU+/0bdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VN+u4HMu9jEjQ+3mogk7acgwg1Ju27pMciRDD4W8yzad6EIZvs5vgUg2Sorn1pvpK
	 c6vnDLajwhv5tYNRZuxtsj8mfUWMZWRvu/8yx6ZsxmBcNlV7hVegu1WBlFZgW8QUsn
	 sz3wqqTAzqqB4b8QfVFmsd9KkquohWZ7bB99ImDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Gao <gaohan@iscas.ac.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 266/583] LoongArch: Add DIRECT_MAP_PHYSMEM_END definition
Date: Wed,  9 Sep 2026 15:39:11 +0200
Message-ID: <20260909134247.310203931@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Han Gao <gaohan@iscas.ac.cn>

commit 2677f97a67fdbc62a82ce1faa67791f54451d36f upstream.

get_free_mem_region() and mhp_get_pluggable_range() bound their search
to DIRECT_MAP_PHYSMEM_END. LoongArch does not define it, so the fallback
in include/linux/mm.h applies: under CONFIG_SPARSEMEM_VMEMMAP it is
(1ULL << MAX_PHYSMEM_BITS) - 1, a compile-time constant that does not
adapt to the CPU's physical address space bits (cpu_pabits, probed from
CPUCFG1).

The vmemmap window only covers physical space below 2^(cpu_pabits+1)
(i.e. VMEMMAP_SIZE), so on CPUs with fewer physical address bits than
MAX_PHYSMEM_BITS the fallback allows get_free_mem_region() to return
a ZONE_DEVICE region outside the vmemmap window; vmemmap_populate() then
wraps the memmap range around and maps it into low memory, silently
corrupting the page tables. The same search also picked the top-of-
address-space region that crashed memmap_init_zone_device() with amdkfd
on Loongson-3C6000 in 6.16 [1]; the commit 2969b42c8f99 ("LoongArch/mm:
align vmemmap to maximal folio size") keeps that region in bounds on
current Loongson-3C6000 configs, but CPUs with smaller cpu_pabits (e.g.
the Loongson-2K series) are still affected.

Define DIRECT_MAP_PHYSMEM_END as the vmemmap-covered physical range,
(1ULL << (cpu_pabits + 1)) - 1, capped at (1ULL << MAX_PHYSMEM_BITS) - 1
under CONFIG_SPARSEMEM, similar to the commit f3336b48cf9d ("riscv: mm:
Define DIRECT_MAP_PHYSMEM_END").

[1] https://lore.kernel.org/amd-gfx/20250814032153.227285-1-jeffbai@aosc.io/

Cc: stable@vger.kernel.org # v6.13+
Signed-off-by: Han Gao <gaohan@iscas.ac.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/pgtable.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -106,6 +106,13 @@ extern unsigned long empty_zero_page[PAG
 #define KFENCE_AREA_START	(VMEMMAP_END + 1)
 #define KFENCE_AREA_END		(KFENCE_AREA_START + KFENCE_AREA_SIZE - 1)
 
+/* Needed to limit get_free_mem_region() */
+#ifndef CONFIG_SPARSEMEM
+#define DIRECT_MAP_PHYSMEM_END ((1ULL << (cpu_pabits + 1)) - 1)
+#else
+#define DIRECT_MAP_PHYSMEM_END min((1ULL << (cpu_pabits + 1)) - 1, (1ULL << MAX_PHYSMEM_BITS) - 1)
+#endif
+
 #define ptep_get(ptep) READ_ONCE(*(ptep))
 #define pmdp_get(pmdp) READ_ONCE(*(pmdp))
 


