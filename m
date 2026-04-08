Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B4637F01B;
	Wed,  8 Apr 2026 18:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674659; cv=none; b=uo6fKtiTqlsxBD4SbQ/pCKlSVJNpmSCDaoW0Nhtq9tjGlW3iz92vflVl6g1IopWWLCOBO9+R41QdnEZ8Ony5SKhanq60Vj5+SnlFDTzOYQHtE6apNE0HT8ivdIRZthfrVC/QuyuISFdhjTrsltjisPZe2cBoME6GM5URrrKVOLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674659; c=relaxed/simple;
	bh=XnZGJPoPuesh6prm8Va91VrHW05AoAP4YLqmqqQm22M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c817642vgBIRl84G676UBRv2c9JqEm78397YFd6yPyb/GfrD7J7tKBH3OhynO/YXZ8hgCT8H4uD1ZQVooaLqsfC9zwe/CXYljkwZbXKGkCPTJQO4A2auDPkhi9w1g4hzmEiHL/8OW9F11y5yboFwV03roYCv4maIb77dxlVG9Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V3E6zo4E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V3E6zo4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3880FC19421;
	Wed,  8 Apr 2026 18:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674659;
	bh=XnZGJPoPuesh6prm8Va91VrHW05AoAP4YLqmqqQm22M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V3E6zo4E3fHhU2R0GJSZ4g7vSMs19Y00yPKCz6sSU1Mq3gYfcdRlruPkgN7T7UIM1
	 WHtQx6Tov2hihs4g/Ns1g3XVyl+OSUhhbgecyXzR3H8RKGAbJDcJZ+qNKLf5xIaHkq
	 2P7WFU1i7NG7g853orscbr6P7+sJpgvShmm49q7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.19 184/311] MIPS: SiByte: Bring back cache initialisation
Date: Wed,  8 Apr 2026 20:03:04 +0200
Message-ID: <20260408175946.281528662@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


