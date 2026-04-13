Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DC7280035;
	Mon, 13 Apr 2026 16:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096521; cv=none; b=JzLhlPZaTH6peRt+Or1akf0xoZQ8QTVmDbV3oTHnekVOK6SybyVZStRGrjtyNK1ewBbjIKaQZws6PWWZl1faV77SksBIdEIfdqKBFaUFrANAArhyeChQDFLcK9+ZGGpHkKp1Q+dmGNE3jeXfH6ERBTL9r4Bd4wCU/gf+xQxLugY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096521; c=relaxed/simple;
	bh=1yJCZIT+3k6zp8KqKSbRdwv4jXDSgW859NtNkWdo4tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQtJlRLLZAdiUf6iIZhHced69mJ8rhOitPASQtokCpDQjHuyBP0IsxjGDOndQwtx9RY+tkq8fl9oBfv5lEsMdgz5AMDmYj2BYw3FEaXdJbOXIHk1pQiDnB8NEKm/5rqa/hRPrGQcOajbY1vicTw18n211cyffape1ppEnzxg52o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bBQQAhb/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bBQQAhb/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B30CC2BCB0;
	Mon, 13 Apr 2026 16:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096521;
	bh=1yJCZIT+3k6zp8KqKSbRdwv4jXDSgW859NtNkWdo4tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bBQQAhb/f7UkznS/8UEXeRbp9pqanaIdAXw4MSZxn6nMDtir0W7dIcalzlbjtMzeT
	 j8OxTAWkZxCC2I0X0CRKkOC62QiitYthT/D42Qmo7jBb9BJEXbu2S2Rc9dUpou4TBK
	 6o9N2qr5Y2p9/+rJ1ifN/2V2jRWrhGkKWpR9j+Q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 11/83] MIPS: Always record SEGBITS in cpu_data.vmbits
Date: Mon, 13 Apr 2026 17:59:39 +0200
Message-ID: <20260413155731.449274704@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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
index 404390bb87eaf..3f11e5218e6c6 100644
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
index fd60837ce50bc..211b578af6aa0 100644
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
index f799c0d723dac..12a095dbf9e2a 100644
--- a/arch/mips/include/asm/mipsregs.h
+++ b/arch/mips/include/asm/mipsregs.h
@@ -1871,6 +1871,8 @@ do {									\
 
 #define read_c0_entryhi()	__read_ulong_c0_register($10, 0)
 #define write_c0_entryhi(val)	__write_ulong_c0_register($10, 0, val)
+#define read_c0_entryhi_64()	__read_64bit_c0_register($10, 0)
+#define write_c0_entryhi_64(val) __write_64bit_c0_register($10, 0, val)
 
 #define read_c0_guestctl1()	__read_32bit_c0_register($10, 4)
 #define write_c0_guestctl1(val)	__write_32bit_c0_register($10, 4, val)
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index 1e49e05ac8b1c..489612ed9d498 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -210,11 +210,14 @@ static inline void set_elf_base_platform(const char *plat)
 
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
index 0c826f729f752..edcf04de0a6fb 100644
--- a/arch/mips/kernel/cpu-r3k-probe.c
+++ b/arch/mips/kernel/cpu-r3k-probe.c
@@ -137,6 +137,8 @@ void cpu_probe(void)
 	else
 		cpu_set_nofpu_opts(c);
 
+	c->vmbits = 31;
+
 	reserve_exception_space(0, 0x400);
 }
 
-- 
2.53.0



