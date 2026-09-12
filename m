Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28D232B13B;
	Sat, 12 Sep 2026 15:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227329; cv=none; b=YPr1dagle/gnETKB+cNZML+r6vuymzJpB2TOmdepTy1xeCyK3ulIz9sFTaJ6dooykMPJjJCy57wS4vag5ttIwbg2wq+wBSzMfMNkO876O0yZ46aT7fkRo58dNGKCa9tMjeC3x13Wou7tZnaLX4jXaviOfsYRv8qQxbuwu9X1/N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227329; c=relaxed/simple;
	bh=XnrNJMZ3zX4cmCwqNF7aL5Pl3EKpYlv/MYrXb/eqUcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQ5Qfss3Rdaxhi+vZcV7UvUKQZJnPPi8cSo9w433nJbgfW4aPTQqrweE8ibr92Iz7SOzmQxejsZc3H6CxeO1JAAefnad31xTKGVyPsYK0cyw+Owt8C84NucE7UaHw/V67VwpDqiOZeVDPSrd3pTV/68TAMXe4VeLViKpilfJahI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IzAYskNz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IzAYskNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B7F1F000FF;
	Sat, 12 Sep 2026 15:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227327;
	bh=EZNyciOhafBppKBkq0X3Eg1yiJIp9t9LQoQozZEaB30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IzAYskNz06j0npzdTvpHjoxQWLJHELqLTy6Z9jRlEJ/Ek2e5e4ryTI0/mQmRqDgP/
	 Ue8BAoXVyEPjOPUK0p59VQhRHZ003Ow413WL3JpOQaTfjwc+TR7sJxxSHIHCxpjeJu
	 rq3V4//jAqLLPGzhta8a7+hY7fXMCvIkBwPi8lq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 0159/1191] arm64: compat: Fix decrementing LDM/STM alignment emulation
Date: Sat, 12 Sep 2026 08:48:07 +0200
Message-ID: <20260912065551.782729334@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

commit f5b8b9037df387394a73aab47c5437bbac975077 upstream.

The compat alignment emulator inherited unsigned long data addresses from
the 32-bit ARM implementation.

In do_alignment_ldmstm(), nr_regs is an unsigned int holding the transfer
size. The function uses the same address addition for both transfer
directions, negating nr_regs first for a decrementing LDM or STM. The
32-bit negation wraps before the addition, so the handler adds nearly
4 GiB instead of subtracting the transfer size.
The resulting address lies outside the compat task's address space, so
decrementing LDM/STM emulation fails, while incrementing forms work.

For example, a backwards-moving copy routine using decrementing LDM/STM can
take an alignment fault when called with unaligned pointers. The compat
handler should emulate the transfer, but this bug instead causes SIGBUS.

The offset negated in do_alignment_finish_ldst() is offset_union.un, which
is already unsigned long and does not have this width mismatch.

Make nr_regs unsigned long so its negation and the address arithmetic
use the same width.

Fixes: 3fc24ef32d3b ("arm64: compat: Implement misalignment fixups for multiword loads")
Cc: stable@vger.kernel.org
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/compat_alignment.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/compat_alignment.c b/arch/arm64/kernel/compat_alignment.c
index b68e1d328d4c..9b58d0aa38d2 100644
--- a/arch/arm64/kernel/compat_alignment.c
+++ b/arch/arm64/kernel/compat_alignment.c
@@ -114,8 +114,8 @@ do_alignment_ldrdstrd(unsigned long addr, u32 instr, struct pt_regs *regs)
 static int
 do_alignment_ldmstm(unsigned long addr, u32 instr, struct pt_regs *regs)
 {
-	unsigned int rd, rn, nr_regs, regbits;
-	unsigned long eaddr, newaddr;
+	unsigned int rd, rn, regbits;
+	unsigned long eaddr, newaddr, nr_regs;
 	unsigned int val;
 
 	/* count the number of registers in the mask to be transferred */
-- 
2.55.0



