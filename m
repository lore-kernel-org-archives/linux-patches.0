Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92561E6DC7;
	Mon, 21 Oct 2024 10:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507808; cv=none; b=kwFDKhxmfoIjHUUdcTrqfzbltW7hJGOLkfCjv6xPNS1Y/tSBnnKRMmveIkd14SMNO+/Gxj35z++ubR+w71YoEii/6WaFNu1kRqyYs3/wH7VYT1eeEnPLxvID4JZDflkAoMDZyWRttUL8g6W/Kq6lfHGAhN25mBZ6pBn/uGFjse4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507808; c=relaxed/simple;
	bh=IcUAQbIJWknBIPvd1t1c3ZNSUPBg0tGMPbgcwuly+d8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GPWHZMeimdZ05DgY34jsqbqiJ/lAk1SyMiJjjgWxx16VwtaXi9iSRSYC1xOaaPmg2Sc0X13QZdGLo/Y+w/F5c6wDKLXDmeXZcwwIiZuDwio7MbNGd0RUcDBIxh3Ym9T9ELAr/KaeN75CmptZ1XuR7wSmETdrYRb7B17ykbHPk6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r487h5V4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r487h5V4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58358C4CEC7;
	Mon, 21 Oct 2024 10:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507807;
	bh=IcUAQbIJWknBIPvd1t1c3ZNSUPBg0tGMPbgcwuly+d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r487h5V4/6aky8785KewdPWa/222RyjmAaQyzyWYjL4W2nMlb4vJrbm14iR4iKcq7
	 nl8YhIQ50fsBNJ2F3BSFaX0xSfsTJ6F3cF7R1ZpMz+/qdc8rVUf3YkokmdjuIQWG8F
	 VE02b8PEjQpElXcdY6nXsAWN92xuSHUbaTA2kK+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 04/52] arm64: probes: Remove broken LDR (literal) uprobe support
Date: Mon, 21 Oct 2024 12:25:25 +0200
Message-ID: <20241021102241.799804879@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

From: Mark Rutland <mark.rutland@arm.com>

commit acc450aa07099d071b18174c22a1119c57da8227 upstream.

The simulate_ldr_literal() and simulate_ldrsw_literal() functions are
unsafe to use for uprobes. Both functions were originally written for
use with kprobes, and access memory with plain C accesses. When uprobes
was added, these were reused unmodified even though they cannot safely
access user memory.

There are three key problems:

1) The plain C accesses do not have corresponding extable entries, and
   thus if they encounter a fault the kernel will treat these as
   unintentional accesses to user memory, resulting in a BUG() which
   will kill the kernel thread, and likely lead to further issues (e.g.
   lockup or panic()).

2) The plain C accesses are subject to HW PAN and SW PAN, and so when
   either is in use, any attempt to simulate an access to user memory
   will fault. Thus neither simulate_ldr_literal() nor
   simulate_ldrsw_literal() can do anything useful when simulating a
   user instruction on any system with HW PAN or SW PAN.

3) The plain C accesses are privileged, as they run in kernel context,
   and in practice can access a small range of kernel virtual addresses.
   The instructions they simulate have a range of +/-1MiB, and since the
   simulated instructions must itself be a user instructions in the
   TTBR0 address range, these can address the final 1MiB of the TTBR1
   acddress range by wrapping downwards from an address in the first
   1MiB of the TTBR0 address range.

   In contemporary kernels the last 8MiB of TTBR1 address range is
   reserved, and accesses to this will always fault, meaning this is no
   worse than (1).

   Historically, it was theoretically possible for the linear map or
   vmemmap to spill into the final 8MiB of the TTBR1 address range, but
   in practice this is extremely unlikely to occur as this would
   require either:

   * Having enough physical memory to fill the entire linear map all the
     way to the final 1MiB of the TTBR1 address range.

   * Getting unlucky with KASLR randomization of the linear map such
     that the populated region happens to overlap with the last 1MiB of
     the TTBR address range.

   ... and in either case if we were to spill into the final page there
   would be larger problems as the final page would alias with error
   pointers.

Practically speaking, (1) and (2) are the big issues. Given there have
been no reports of problems since the broken code was introduced, it
appears that no-one is relying on probing these instructions with
uprobes.

Avoid these issues by not allowing uprobes on LDR (literal) and LDRSW
(literal), limiting the use of simulate_ldr_literal() and
simulate_ldrsw_literal() to kprobes. Attempts to place uprobes on LDR
(literal) and LDRSW (literal) will be rejected as
arm_probe_decode_insn() will return INSN_REJECTED. In future we can
consider introducing working uprobes support for these instructions, but
this will require more significant work.

Fixes: 9842ceae9fa8 ("arm64: Add uprobe support")
Cc: stable@vger.kernel.org
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20241008155851.801546-2-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/probes/decode-insn.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/arch/arm64/kernel/probes/decode-insn.c
+++ b/arch/arm64/kernel/probes/decode-insn.c
@@ -99,10 +99,6 @@ arm_probe_decode_insn(probe_opcode_t ins
 	    aarch64_insn_is_blr(insn) ||
 	    aarch64_insn_is_ret(insn)) {
 		api->handler = simulate_br_blr_ret;
-	} else if (aarch64_insn_is_ldr_lit(insn)) {
-		api->handler = simulate_ldr_literal;
-	} else if (aarch64_insn_is_ldrsw_lit(insn)) {
-		api->handler = simulate_ldrsw_literal;
 	} else {
 		/*
 		 * Instruction cannot be stepped out-of-line and we don't
@@ -140,6 +136,17 @@ arm_kprobe_decode_insn(kprobe_opcode_t *
 	probe_opcode_t insn = le32_to_cpu(*addr);
 	probe_opcode_t *scan_end = NULL;
 	unsigned long size = 0, offset = 0;
+	struct arch_probe_insn *api = &asi->api;
+
+	if (aarch64_insn_is_ldr_lit(insn)) {
+		api->handler = simulate_ldr_literal;
+		decoded = INSN_GOOD_NO_SLOT;
+	} else if (aarch64_insn_is_ldrsw_lit(insn)) {
+		api->handler = simulate_ldrsw_literal;
+		decoded = INSN_GOOD_NO_SLOT;
+	} else {
+		decoded = arm_probe_decode_insn(insn, &asi->api);
+	}
 
 	/*
 	 * If there's a symbol defined in front of and near enough to
@@ -157,7 +164,6 @@ arm_kprobe_decode_insn(kprobe_opcode_t *
 		else
 			scan_end = addr - MAX_ATOMIC_CONTEXT_SIZE;
 	}
-	decoded = arm_probe_decode_insn(insn, &asi->api);
 
 	if (decoded != INSN_REJECTED && scan_end)
 		if (is_probed_address_atomic(addr - 1, scan_end))


