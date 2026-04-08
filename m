Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1D528C87C;
	Wed,  8 Apr 2026 18:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673261; cv=none; b=aM95C7NrBSOv1Q0+K2UTwPtu7K3ozBbueWQzY51gBQGaX+1WUOiyJYsaVfY0xlGVs9msY4DItEAOmGDdq1FSXntllZ5CRr6R7pPdILqdp/ydZUPYuGcCKJ5POZ0amJG0XyS+9DEM6oRIGyjMamZsyypBk+vnGi1ESBzLJP2f3n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673261; c=relaxed/simple;
	bh=FJL1FTkalpvy/ZJt5VFSD5ZEbd0Z0uUPW5HUzNfyrpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Umu/CAr6VhjjJsPiE1kx4lsv81QP7AIt2yqM0B9DU+4AEPeaq7lvU/8pZ4HC1DfVlAMPRAsvhkPE0CWuT1Tbp8cZro3OZPK6+Y8CMtNV861jLKqGAbw7eVIQGU3MXPCEIaAFMBwfplku39F6KxGDHIDKt0q/ExfKpXp07PsAjqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n/W9o/6v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n/W9o/6v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2124DC19421;
	Wed,  8 Apr 2026 18:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673261;
	bh=FJL1FTkalpvy/ZJt5VFSD5ZEbd0Z0uUPW5HUzNfyrpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n/W9o/6vwRKAbhoUc4sYHJVC/5fFzKNXXsi9DYCVAZj0yQxePubSL8KnbioWzY0GG
	 04itOt5WkSaISRN2O4HZykQdLQdEf3bD9f4csFZ2a3f6BKIPYMh34kgSHBymGjNjy7
	 5CR+O6Ie+QMCAjvQPCbO0/SxcA/qx/z4N+QX2HkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.18 146/277] MIPS: SiByte: Bring back cache initialisation
Date: Wed,  8 Apr 2026 20:02:11 +0200
Message-ID: <20260408175939.324626710@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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


