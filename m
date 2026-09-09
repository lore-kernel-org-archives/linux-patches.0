Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9A453D0B8;
	Wed,  9 Sep 2026 14:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962571; cv=none; b=XHm9e85dRoDa4+NfPKFUP/dFicqFV9i7ma8wmF5fKi6u2UO5o/IavxtPzNmOINLrTvuSFFVwPpJcFrHghroapNigqj8Ya+eV9F2Jj7HcnG3wtpAvEmpdBcQ75cj1lSFJuEkFu1PV++EsHek+EwTYKUtPKh+ISQNk/H+4j55c0z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962571; c=relaxed/simple;
	bh=wjELHO/5RBqDynFEntWbgBcmeCHfZdMljqnvPeDZoSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLdpGOF0iDDT5aFQgxPYzoWe+PIDTfy63Sx7j4mc5vAHTM1fzK6rrxI1jEpJWtAQrYJs/2yjz/pkXMf4HeB+e4k0CQDSFRljOF06nhxH/vhRhA7hKt2IcN35Dc+S+hPiTQNOIA+ug4RhoYRXnMWV3HKlm5U92wkttpt2eCekmU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ONpxWF5J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ONpxWF5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66B81F00A3A;
	Wed,  9 Sep 2026 14:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962570;
	bh=EdGPWSEup/poIEV7abivW0ZBypvdi6PCiAyIhtyP7sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ONpxWF5JvIdo+/t+WfTADAXXKhAKgvny9Y8XGIHM/XvjkK1IBlv9BDHho3cBA7gkf
	 vcJ6HyhBV0kUtCv4ii13Ci5L/coBZKKs3AeJ+Bxtak3S0rsCyTLN6xXiCCAXVYNdEc
	 9BPvQxlRReGullaG26GN9oh85wYlRHh1KSf8Vd4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Gao <gaohan@iscas.ac.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.2 335/556] LoongArch: Add DIRECT_MAP_PHYSMEM_END definition
Date: Wed,  9 Sep 2026 15:40:15 +0200
Message-ID: <20260909134242.444426021@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -125,6 +125,13 @@ struct vm_area_struct;
 
 #endif
 
+/* Needed to limit get_free_mem_region() */
+#ifndef CONFIG_SPARSEMEM
+#define DIRECT_MAP_PHYSMEM_END ((1ULL << (cpu_pabits + 1)) - 1)
+#else
+#define DIRECT_MAP_PHYSMEM_END min((1ULL << (cpu_pabits + 1)) - 1, (1ULL << MAX_PHYSMEM_BITS) - 1)
+#endif
+
 #define ptep_get(ptep) READ_ONCE(*(ptep))
 #define pmdp_get(pmdp) READ_ONCE(*(pmdp))
 


