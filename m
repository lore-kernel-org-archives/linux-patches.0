Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4782419FBB;
	Fri,  4 Sep 2026 06:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502568; cv=none; b=Yn4Ga8ByzHmgsly7pgDFrsb3fKuB+QK8v+MUNXqyPmAr0KlFkn9Ff0AkDYMrEMV0NHY/HX8vLAxX7qqa6G0AbmUu+jnroH4nzJ6RmV1W2wyPormjbZkzsQyxZFG4z+5lAVJ0HuCKyjdm8/2cFfPboKuulAX3XIFxwy+lzFEE30c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502568; c=relaxed/simple;
	bh=ziARoTUxOMOLbsSga5qlPRY49vIMUbYNoSjv0Eyfwwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1ncoM+UuotVXJ5DloZ2KJvUEzaNgDtZ1qtVms3RE/egGtIpq8CnbYgLf33pMXSt6GG4KvxBiDSsZFykhwUnzOzFpGQzER6ggRwn9oA5+7UuaQ2/gM4FC7VI1LN4D5qxWewMV+w7w49UWu7abcwL5fEDIiuh9TCrN+pcrB986os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IGt9MuQl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IGt9MuQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9331F00A3D;
	Fri,  4 Sep 2026 06:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502567;
	bh=p2qG/JHGci/GojUw1L0Bp/Vrj9HwH0dYUnrM7qd/hIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IGt9MuQlDwpmrynIl9Gk9bYPS5NxNRt5imoB8seHJte2RdHG+pZxglJGNnZX/98Pe
	 oj5rZ+m7mK7iXeeMStpKTTQFeB+USgG2gYe42psQ4c8PLxTy+AjL8CMw37VvVS2A0q
	 5numkrNBwyLexDWMWn0GtvAjUabYyaToVm8sjDeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 253/403] arm64: compat: Fix decrementing LDM/STM alignment emulation
Date: Fri,  4 Sep 2026 07:00:56 +0200
Message-ID: <20260904045740.622827463@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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
 arch/arm64/kernel/compat_alignment.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/compat_alignment.c
+++ b/arch/arm64/kernel/compat_alignment.c
@@ -114,8 +114,8 @@ do_alignment_ldrdstrd(unsigned long addr
 static int
 do_alignment_ldmstm(unsigned long addr, u32 instr, struct pt_regs *regs)
 {
-	unsigned int rd, rn, nr_regs, regbits;
-	unsigned long eaddr, newaddr;
+	unsigned int rd, rn, regbits;
+	unsigned long eaddr, newaddr, nr_regs;
 	unsigned int val;
 
 	/* count the number of registers in the mask to be transferred */


