Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F8236B90A;
	Sat, 12 Sep 2026 17:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232483; cv=none; b=kjhb12ooipQSj1kg2MsW6B0r0R13Pv8FWFhlt5yz+no/U+G41HRlzsRDN+I6QLEwpf6eSKYlNBB8ge66KAwPBbrAS4J/C4WKKfEh9VzrzLq9AG9KjuDusNw3fujUNlSyMsuXIx9svE4BFvsFCR2/tfbKsQUbWtvxXjctkpLFfd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232483; c=relaxed/simple;
	bh=sc6LtDyau6KrIonNoJtET3qMmCW790VjRCX2hFS94MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/ME0GDkWUg7uAviBTj3W5o3sFCyEWZDpHRJHL/GbdXZwUcdVB0Jl6M6KhQdBPH9aBks9q+83DtiEV8ZaLrZ827o8T1OcRzGbjhWKjctnf5kIHhhaiAo86uN9yqIoEJPFN+rtZxX+bsRo0+tt0HkscmZtDviDhI23vk6NhU2Y6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmHdnOot; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmHdnOot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B661F000FF;
	Sat, 12 Sep 2026 17:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232481;
	bh=K3jkfZu38bI5JBNAex2fOP5dc+ka/h49YJVO2YszyXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gmHdnOotNulsJf53M65F9f9aCI7LxeJlvOB2IakN/x3yU1fhwMSHPqgsBI4JSOLDI
	 8BCHsIgQDWoF+KuV6ByUnJCrf0ix+OLa6tHM4plWXpzKnihtIzz22pwxFg8pt+x2B7
	 As9o34gRBPOsM24OowMRaHm93/WuszpcM01pADck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>
Subject: [PATCH 5.15 002/935] alpha: fix ieee_swcr_to_fpcr setting FPCR_DNOD unconditionally
Date: Sat, 12 Sep 2026 08:50:32 +0200
Message-ID: <20260912065526.895150002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Matt Turner <mattst88@gmail.com>

commit 49672d026cc4773608e1222b69b29fd70f41336b upstream.

ieee_swcr_to_fpcr() converts the software IEEE trap-enable and status
bits kept in thread_info.ieee_state into the hardware FPCR format.  It
contained:

	fp |= (~sw & IEEE_TRAP_ENABLE_DNO) << 41;

FPCR_DNOD (bit 47) disables denormal operand traps: with it set the
hardware handles a denormal operand itself, treating it as zero, instead
of trapping for software completion.  The intent was to set DNOD when the
user has not asked for SIGFPE on denormal operands, but
IEEE_TRAP_ENABLE_DNO is clear by default, so ieee_swcr_to_fpcr(0) always
set DNOD.

Instructions built with the software completion suffix therefore never
trapped on a denormal operand.  The hardware silently substituted zero
and produced wrong results, affecting every program compiled with -mieee
and default FPU settings, glibc included.

Set FPCR_DNOD only when IEEE_MAP_DMZ is requested, which is exactly the
case where flushing denormal inputs to zero is what the user asked for.
DNOD then encodes MAP_DMZ, which ieee_fpcr_to_swcr() already recovers
from FPCR_DNZ, so drop its attempt to recover IEEE_TRAP_ENABLE_DNO from
DNOD; the DNO trap enable lives solely in ieee_state.

Both functions are in a uapi header, so the encoding change is visible to
userspace, but nothing outside the kernel is known to depend on DNOD
carrying the DNO trap enable, and the kernel is the only writer of the
FPCR.

This must not be backported on its own.  Re-enabling denormal operand
traps exposes a second bug, fixed in the following patch: those traps
usually find an exact result, and for an exact result the emulator did
not write the FPCR back, leaving hardware-fabricated exception bits
visible to user space.  Taken alone this change would make spurious
exception flags more common.

The bug predates the git history, so there is no commit to reference in a
Fixes tag.

Cc: stable@vger.kernel.org # 5.15+
Signed-off-by: Matt Turner <mattst88@gmail.com>
Reviewed-by: Magnus Lindholm <linmag7@gmail.com>
Tested-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20260803-alpha-fp-exceptions-v1-1-c99d75608e60@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/include/uapi/asm/fpu.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/alpha/include/uapi/asm/fpu.h
+++ b/arch/alpha/include/uapi/asm/fpu.h
@@ -101,7 +101,12 @@ ieee_swcr_to_fpcr(unsigned long sw)
 		      | IEEE_TRAP_ENABLE_OVF)) << 48;
 	fp |= (~sw & (IEEE_TRAP_ENABLE_UNF | IEEE_TRAP_ENABLE_INE)) << 57;
 	fp |= (sw & IEEE_MAP_UMZ ? FPCR_UNDZ | FPCR_UNFD : 0);
-	fp |= (~sw & IEEE_TRAP_ENABLE_DNO) << 41;
+	/*
+	 * Disable denormal operand traps only when denormal inputs are to be
+	 * flushed to zero.  Otherwise they must keep trapping, so that /S
+	 * instructions reach the kernel emulation handler.
+	 */
+	fp |= (sw & IEEE_MAP_DMZ ? FPCR_DNOD : 0);
 	return fp;
 }
 
@@ -116,7 +121,6 @@ ieee_fpcr_to_swcr(unsigned long fp)
 			     | IEEE_TRAP_ENABLE_OVF);
 	sw |= (~fp >> 57) & (IEEE_TRAP_ENABLE_UNF | IEEE_TRAP_ENABLE_INE);
 	sw |= (fp >> 47) & IEEE_MAP_UMZ;
-	sw |= (~fp >> 41) & IEEE_TRAP_ENABLE_DNO;
 	return sw;
 }
 


