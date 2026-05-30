Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F041349CCF;
	Sat, 30 May 2026 17:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162725; cv=none; b=rZqJCZ953nRfTkGf2DwlM1lpUXXKqwFEsRaHvA+hdoR4XPGWusY4Wet37qAwdI7mnumb0blTGrBPCsFaX5NUYbffTxCovfWojDJT5PNyF80WwjTmqXzXU7p497Dprhd6c46BU/0l2ZQwVkRRRZqPaaDgd/wr+Oeg+bhbugrNs3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162725; c=relaxed/simple;
	bh=JluxlJWycZ5XtOqcIrIkAjbNcSX3kL3ZW/i/0o4IsiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZKN4BirgHrOFqw6ecdiksLIXAe+QY9L8LWYmDWl3Sllvn670Eubwe1wfHoO+ro0gxaYb4WJZP1aeQVYGwHv6F/JU4vs88Azows0Lr0jN8ePdYsNkjZ1NZ26POGs77mJtzdRopoeByHXC4/wzAWf3ktztKDfcHYYnh0piIt6wVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FCJrWnKS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FCJrWnKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ADC21F00893;
	Sat, 30 May 2026 17:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162724;
	bh=Wu/PsfPJ9xthmc74SLy7HPCdwvaRfThZFFvJQu3rK74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FCJrWnKS32us6EH0RSbdcpWQ07drw5bRZWMyjaSaka5CMGYFmYorHfC4SHvXrKZZI
	 tcpL1BuvE3xZyBeZymPfzgPR5yDfOQu5k3H/JDCKLMlbSaK+Y6dOlypj4LlLCIxHH9
	 FXK+I8cs+SOq9V+cNdxpGFZa+3wsVIGF4JM5OPD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/776] MIPS: Always record SEGBITS in cpu_data.vmbits
Date: Sat, 30 May 2026 17:55:59 +0200
Message-ID: <20260530160241.470111032@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 8374c2cb83b95b3c92f129fd56527225c20a058c upstream.

With a 32-bit kernel running on 64-bit MIPS hardware the hardcoded value
of `cpu_vmbits' only records the size of compatibility useg and does not
reflect the size of native xuseg or the complete range of values allowed
in the VPN2 field of TLB entries.

An upcoming change will need the actual VPN2 value range permitted even
in 32-bit kernel configurations, so always include the `vmbits' member
in `struct cpuinfo_mips' and probe for SEGBITS when running on 64-bit
hardware and resorting to the currently hardcoded value of 31 on 32-bit
processors.  No functional change for users of `cpu_vmbits'.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/cpu-features.h |  1 -
 arch/mips/include/asm/cpu-info.h     |  2 --
 arch/mips/include/asm/mipsregs.h     |  2 ++
 arch/mips/kernel/cpu-probe.c         | 13 ++++++++-----
 arch/mips/kernel/cpu-r3k-probe.c     |  2 ++
 5 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/mips/include/asm/cpu-features.h b/arch/mips/include/asm/cpu-features.h
index e69833213e792..c1baf1b06ccec 100644
--- a/arch/mips/include/asm/cpu-features.h
+++ b/arch/mips/include/asm/cpu-features.h
@@ -484,7 +484,6 @@
 # endif
 # ifndef cpu_vmbits
 # define cpu_vmbits cpu_data[0].vmbits
-# define __NEED_VMBITS_PROBE
 # endif
 #endif
 
diff --git a/arch/mips/include/asm/cpu-info.h b/arch/mips/include/asm/cpu-info.h
index a600670d00e97..1aee44124f118 100644
--- a/arch/mips/include/asm/cpu-info.h
+++ b/arch/mips/include/asm/cpu-info.h
@@ -80,9 +80,7 @@ struct cpuinfo_mips {
 	int			srsets; /* Shadow register sets */
 	int			package;/* physical package number */
 	unsigned int		globalnumber;
-#ifdef CONFIG_64BIT
 	int			vmbits; /* Virtual memory size in bits */
-#endif
 	void			*data;	/* Additional data */
 	unsigned int		watch_reg_count;   /* Number that exist */
 	unsigned int		watch_reg_use_cnt; /* Usable by ptrace */
diff --git a/arch/mips/include/asm/mipsregs.h b/arch/mips/include/asm/mipsregs.h
index acdf8c69220b0..a1bb5f16d4497 100644
--- a/arch/mips/include/asm/mipsregs.h
+++ b/arch/mips/include/asm/mipsregs.h
@@ -1719,6 +1719,8 @@ do {									\
 
 #define read_c0_entryhi()	__read_ulong_c0_register($10, 0)
 #define write_c0_entryhi(val)	__write_ulong_c0_register($10, 0, val)
+#define read_c0_entryhi_64()	__read_64bit_c0_register($10, 0)
+#define write_c0_entryhi_64(val) __write_64bit_c0_register($10, 0, val)
 
 #define read_c0_guestctl1()	__read_32bit_c0_register($10, 4)
 #define write_c0_guestctl1(val)	__write_32bit_c0_register($10, 4, val)
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index f258c5f15f903..464258c6ab464 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -208,11 +208,14 @@ static inline void set_elf_base_platform(const char *plat)
 
 static inline void cpu_probe_vmbits(struct cpuinfo_mips *c)
 {
-#ifdef __NEED_VMBITS_PROBE
-	write_c0_entryhi(0x3fffffffffffe000ULL);
-	back_to_back_c0_hazard();
-	c->vmbits = fls64(read_c0_entryhi() & 0x3fffffffffffe000ULL);
-#endif
+	int vmbits = 31;
+
+	if (cpu_has_64bits) {
+		write_c0_entryhi_64(0x3fffffffffffe000ULL);
+		back_to_back_c0_hazard();
+		vmbits = fls64(read_c0_entryhi_64() & 0x3fffffffffffe000ULL);
+	}
+	c->vmbits = vmbits;
 }
 
 static void set_isa(struct cpuinfo_mips *c, unsigned int isa)
diff --git a/arch/mips/kernel/cpu-r3k-probe.c b/arch/mips/kernel/cpu-r3k-probe.c
index af654771918cd..3c9d5a2fd7928 100644
--- a/arch/mips/kernel/cpu-r3k-probe.c
+++ b/arch/mips/kernel/cpu-r3k-probe.c
@@ -160,6 +160,8 @@ void cpu_probe(void)
 	else
 		cpu_set_nofpu_opts(c);
 
+	c->vmbits = 31;
+
 	reserve_exception_space(0, 0x400);
 }
 
-- 
2.53.0



