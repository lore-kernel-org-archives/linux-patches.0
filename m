Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F94330311;
	Mon, 29 Dec 2025 16:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025432; cv=none; b=D2CRgYfWFoSnqcFHDFoS9MbFlBgidxCmR9G+Ig2y2P8nqXiVl+JgoHNeM/V0NIk4CIedV8tZzxq37gwWHHSu7olT0Jn1/739D5ur1ceOIVtfwrI8G9WeLqCAjMuHV29CVFCGbf/LejFB0H1k+9HP1Qn6YlErpNPEgyXngLFwWhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025432; c=relaxed/simple;
	bh=JU3oKkWb+A+g8p0JmhtocXPyCBn26rMsyfNDdE971Cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5whXTgJoLUHwEsT2k9ut1rd0BH0HgaDQvwub5+nfI66qRs+S/JXG6zjUBFI+vyS+7iYfpJ7iXNUvMnec1MhcxwSGN4lvVAmE1VFW20UdMDSL/a+ecjF9qAbNSStl5Dcu02YJ3Z1QjuhLjYUrv9ASdUbixWb1LBJif4ThoZW4qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KsF1o431; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KsF1o431"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80F4C4CEF7;
	Mon, 29 Dec 2025 16:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025432;
	bh=JU3oKkWb+A+g8p0JmhtocXPyCBn26rMsyfNDdE971Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KsF1o431DUvP4I83pr0wlAitjib5PmWqJIXt9zoRppxw3g/TeTv06sl7whOJKtgxx
	 EBeYof1z32fXG/hJxi2bwotewsEM28FXI3xzXG+//ahMUX12iUV/F2mJmfKdhHVsRF
	 PE5LPmwTY6kRnk3AoPfkxxhh2HpARL5+tp5u0URk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 212/430] MIPS: ftrace: Fix memory corruption when kernel is located beyond 32 bits
Date: Mon, 29 Dec 2025 17:10:14 +0100
Message-ID: <20251229160732.155919869@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Gregory CLEMENT <gregory.clement@bootlin.com>

[ Upstream commit 36dac9a3dda1f2bae343191bc16b910c603cac25 ]

Since commit e424054000878 ("MIPS: Tracing: Reduce the overhead of
dynamic Function Tracer"), the macro UASM_i_LA_mostly has been used,
and this macro can generate more than 2 instructions. At the same
time, the code in ftrace assumes that no more than 2 instructions can
be generated, which is why it stores them in an int[2] array. However,
as previously noted, the macro UASM_i_LA_mostly (and now UASM_i_LA)
causes a buffer overflow when _mcount is beyond 32 bits. This leads to
corruption of the variables located in the __read_mostly section.

This corruption was observed because the variable
__cpu_primary_thread_mask was corrupted, causing a hang very early
during boot.

This fix prevents the corruption by avoiding the generation of
instructions if they could exceed 2 instructions in
length. Fortunately, insn_la_mcount is only used if the instrumented
code is located outside the kernel code section, so dynamic ftrace can
still be used, albeit in a more limited scope. This is still
preferable to corrupting memory and/or crashing the kernel.

Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/ftrace.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/mips/kernel/ftrace.c b/arch/mips/kernel/ftrace.c
index f39e85fd58fa..b15615b28569 100644
--- a/arch/mips/kernel/ftrace.c
+++ b/arch/mips/kernel/ftrace.c
@@ -54,10 +54,20 @@ static inline void ftrace_dyn_arch_init_insns(void)
 	u32 *buf;
 	unsigned int v1;
 
-	/* la v1, _mcount */
-	v1 = 3;
-	buf = (u32 *)&insn_la_mcount[0];
-	UASM_i_LA(&buf, v1, MCOUNT_ADDR);
+	/* If we are not in compat space, the number of generated
+	 * instructions will exceed the maximum expected limit of 2.
+	 * To prevent buffer overflow, we avoid generating them.
+	 * insn_la_mcount will not be used later in ftrace_make_call.
+	 */
+	if (uasm_in_compat_space_p(MCOUNT_ADDR)) {
+		/* la v1, _mcount */
+		v1 = 3;
+		buf = (u32 *)&insn_la_mcount[0];
+		UASM_i_LA(&buf, v1, MCOUNT_ADDR);
+	} else {
+		pr_warn("ftrace: mcount address beyond 32 bits is not supported (%lX)\n",
+			MCOUNT_ADDR);
+	}
 
 	/* jal (ftrace_caller + 8), jump over the first two instruction */
 	buf = (u32 *)&insn_jal_ftrace_caller;
@@ -189,6 +199,13 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	unsigned int new;
 	unsigned long ip = rec->ip;
 
+	/* When the code to patch does not belong to the kernel code
+	 * space, we must use insn_la_mcount. However, if MCOUNT_ADDR
+	 * is not in compat space, insn_la_mcount is not usable.
+	 */
+	if (!core_kernel_text(ip) && !uasm_in_compat_space_p(MCOUNT_ADDR))
+		return -EFAULT;
+
 	new = core_kernel_text(ip) ? insn_jal_ftrace_caller : insn_la_mcount[0];
 
 #ifdef CONFIG_64BIT
-- 
2.51.0



