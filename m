Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6F7350A3A;
	Tue, 21 Oct 2025 20:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077239; cv=none; b=lhcIBCHQjUQ1fsvJAS4mFQYiKFrcihNARZIwZP7gG1VPvmC5uYaYE9u2akgmcv1UVEpaKGUkxBVWv0ulnrREb/kNHMfnMP4bL1XNcDFBnNUJBmx/VOckytFEzl0D5PvTlIofckfpRqrWOMFy/5EuHWOe/ky7yDYt5WJ0spRLN1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077239; c=relaxed/simple;
	bh=odj37KxaX44bRaOwfZcQbQDy59iihkxIllgbaQcYax4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3k06sBlga8REgAIRYX+J+qTGlpOYRaaohzGlRbKEfEvyAUlF8D2WLNp9FSfG1aecYcO1YfZpPcWywoaeYLBJ3M/p4hrZ+Twj21WshtHvQCmtVE2bS+gYUEMC5qfWiZ/lv+oh/rt4LquREsrVcvxVTasTgePqLg6KHQFY+6NRzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sGiT9WiV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sGiT9WiV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001D6C4CEF5;
	Tue, 21 Oct 2025 20:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077239;
	bh=odj37KxaX44bRaOwfZcQbQDy59iihkxIllgbaQcYax4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sGiT9WiVhnvnv/3sFSXYUQTn95Gvcpt8MBGTXRC61x/6eLxxds2zR/+uqIUr+SFQC
	 iO8I6swbqLjz3Luxu/LhdBnpT/Q3e7sVpWty0e2tUp7z3JuVkQB3J3oW1CihxdzQKE
	 6qAWR5510R3V84O+t+a+VsxwSm4d3Jfzd1/6a9j0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 6.17 006/159] arm64/sysreg: Fix GIC CDEOI instruction encoding
Date: Tue, 21 Oct 2025 21:49:43 +0200
Message-ID: <20251021195043.337475949@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Pieralisi <lpieralisi@kernel.org>

commit e9ad390a4812fd60c1da46823f7a6f84f2411f0c upstream.

The GIC CDEOI system instruction requires the Rt field to be set to 0b11111
otherwise the instruction behaviour becomes CONSTRAINED UNPREDICTABLE.

Currenly, its usage is encoded as a system register write, with a constant
0 value:

write_sysreg_s(0, GICV5_OP_GIC_CDEOI)

While compiling with GCC, the 0 constant value, through these asm
constraints and modifiers ('x' modifier and 'Z' constraint combo):

asm volatile(__msr_s(r, "%x0") : : "rZ" (__val));

forces the compiler to issue the XZR register for the MSR operation (ie
that corresponds to Rt == 0b11111) issuing the right instruction encoding.

Unfortunately LLVM does not yet understand that modifier/constraint
combo so it ends up issuing a different register from XZR for the MSR
source, which in turns means that it encodes the GIC CDEOI instruction
wrongly and the instruction behaviour becomes CONSTRAINED UNPREDICTABLE
that we must prevent.

Add a conditional to write_sysreg_s() macro that detects whether it
is passed a constant 0 value and issues an MSR write with XZR as source
register - explicitly doing what the asm modifier/constraint is meant to
achieve through constraints/modifiers, fixing the LLVM compilation issue.

Fixes: 7ec80fb3f025 ("irqchip/gic-v5: Add GICv5 PPI support")
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Cc: Sascha Bischoff <sascha.bischoff@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/sysreg.h |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1231,10 +1231,19 @@
 	__val;								\
 })
 
+/*
+ * The "Z" constraint combined with the "%x0" template should be enough
+ * to force XZR generation if (v) is a constant 0 value but LLVM does not
+ * yet understand that modifier/constraint combo so a conditional is required
+ * to nudge the compiler into using XZR as a source for a 0 constant value.
+ */
 #define write_sysreg_s(v, r) do {					\
 	u64 __val = (u64)(v);						\
 	u32 __maybe_unused __check_r = (u32)(r);			\
-	asm volatile(__msr_s(r, "%x0") : : "rZ" (__val));		\
+	if (__builtin_constant_p(__val) && __val == 0)			\
+		asm volatile(__msr_s(r, "xzr"));			\
+	else								\
+		asm volatile(__msr_s(r, "%x0") : : "r" (__val));	\
 } while (0)
 
 /*


