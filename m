Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE48E3ECBCF;
	Fri,  4 Sep 2026 05:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499599; cv=none; b=YmtbxFxR1O6VXPmZVuIDhXG/kyjGp+1Kqc4jnceRCqfsDQwf6/4msV3QFtYolbSlR6af25CiM0JxYxRtM7NQhgldIWuJKntwfFRMxH1C9bJ9iH7hESVe0xQXflv3Q9JSZ+FXKq3yqYyp8dzW8DsWq4MLh/jnAS9f3pHHLSsVGgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499599; c=relaxed/simple;
	bh=oDqpo3Gt7yZOuMD5DZKaHNSBh94jQPQomMHK4gf3x5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+EEvrsQTtVVpXo4FhE1qjPxIxF/lQdVu5+CVenGsRO57WcG8AQ59yGhFpFodM5UOzTPUdk9PtFpMQ9vLCl/alW0rNPFiSX+t4lXPzIVRNdYz3M5gHyz40GAWO/4Dd3JhnVhyBESTyPH8y2omraI/ecCVc80LrBxMJ2xgxHgK8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=su8geUHk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="su8geUHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F201F00A3D;
	Fri,  4 Sep 2026 05:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499598;
	bh=YYAL9HEl0NLvZFqc39PyDlfF7AmuOk8HG19yj1ReIOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=su8geUHkTgbqcH0vtzLA2sFkQy+q6OBeJ1omuEj9yxPEHF8JhpDX1tXAYoTCOK4ZR
	 DLw98vi1dFPHV9TrVXm3kAJ9XJvJppzHcexZdotYIUKAWKDBNC46EDFIBruotoL8Mi
	 +S1c4OPjm2fNqL7nfHLwLeXcdtciTfjiMMeHMLeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 7.2 474/713] arm64: compat: Fix decrementing LDM/STM alignment emulation
Date: Fri,  4 Sep 2026 06:57:22 +0200
Message-ID: <20260904045814.448275028@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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


