Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1535E2BEFFF;
	Wed,  8 Apr 2026 18:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673882; cv=none; b=t4Rl/Sf2yu7qg/uoBXyzImaxRSYh1vhIJlYucHn750M4HfJL7YtJpnCeBIGQ+VNw8gipEaH5GhsR2elwuAjAL3632byfHt2FmhNxBxpf0Ylosm3uAwEISEC9WyeFd5ishGeYqCPjMqVIDPMC3kfTZmJLGHVXw/Kidoh2sUYdxis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673882; c=relaxed/simple;
	bh=5dweHuRdvT022ZfN6OLeC2hkhstfrb/vHyL/dngZqJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rSCDsaiGfm7fmbjn4ik4if9xR6ejVzGDfKUVH3XZPp6LWxJLbsG3VyVGoblR8M7UGO37uIGG97bHFtUX7Fp536wJ7yr8QHu0oLy39dVRSlk94HYhlEu0SiIS0wPtaxaj06f2E5f77Yw5sjr+lyaTjWBNodt9QOfap9IqGbqUU0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PE81m2Fy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PE81m2Fy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05F1C19421;
	Wed,  8 Apr 2026 18:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673882;
	bh=5dweHuRdvT022ZfN6OLeC2hkhstfrb/vHyL/dngZqJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PE81m2FyHa1PnIjRqoZKyVUabE/ERl8dPVQkcXnj7KZaGVg2KYrzyNAjVKsKpuJMb
	 iBGO7uj2dZl1Yoxx67LFlA/f3Z3CsWAGIrvktkO2KrvHXH8Ue1hFBQ/OrKtwTkaZt5
	 /ra4X33QYlTt7OgaNz2OIo/AkCKaWpoljaEt/Njg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.12 125/242] MIPS: SiByte: Bring back cache initialisation
Date: Wed,  8 Apr 2026 20:02:45 +0200
Message-ID: <20260408175931.765741961@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit d62cf1511743526f530a4c169424e50c757f5a5e upstream.

Bring back cache initialisation for Broadcom SiByte SB1 cores, which has
been removed causing the kernel to hang at bootstrap right after:

Dentry cache hash table entries: 524288 (order: 8, 4194304 bytes, linear)
Inode-cache hash table entries: 262144 (order: 7, 2097152 bytes, linear)

The cause of the problem is R4k cache handlers are also used by Broadcom
SiByte SB1 cores, however with a different cache error exception handler
and therefore not using CPU_R4K_CACHE_TLB:

obj-$(CONFIG_CPU_R4K_CACHE_TLB) += c-r4k.o cex-gen.o tlb-r4k.o
obj-$(CONFIG_CPU_SB1)           += c-r4k.o cerr-sb1.o cex-sb1.o tlb-r4k.o

(from arch/mips/mm/Makefile).

Fixes: bbe4f634f48c ("mips: fix r3k_cache_init build regression")
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Cc: stable@vger.kernel.org # v6.8+
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/mm/cache.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/mips/mm/cache.c
+++ b/arch/mips/mm/cache.c
@@ -207,7 +207,8 @@ void cpu_cache_init(void)
 {
 	if (IS_ENABLED(CONFIG_CPU_R3000) && cpu_has_3k_cache)
 		r3k_cache_init();
-	if (IS_ENABLED(CONFIG_CPU_R4K_CACHE_TLB) && cpu_has_4k_cache)
+	if ((IS_ENABLED(CONFIG_CPU_R4K_CACHE_TLB) ||
+	     IS_ENABLED(CONFIG_CPU_SB1)) && cpu_has_4k_cache)
 		r4k_cache_init();
 
 	if (IS_ENABLED(CONFIG_CPU_CAVIUM_OCTEON) && cpu_has_octeon_cache)


