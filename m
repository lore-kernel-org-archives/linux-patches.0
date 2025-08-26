Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196C117A303;
	Tue, 26 Aug 2025 12:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212923; cv=none; b=I4oj4RCXHvkiMD9AhRnL7pTknC9iiTyt7aOnT1nz9HTxq3hz+wdvQDHUtz+V0o5fDK9mzceIYdznJfCfSeWqv97QxMh8fwXMnTiwGRE3SmXCIUNAnvbaWHLygYD3FXt0MG/5GJ5/Abox5+J9tL16SFL8kn6Uwk1qpyaKLp6e4Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212923; c=relaxed/simple;
	bh=ux/gCWa1dt4gruud99HseJaVtyeF99IJrIkJft61kyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNoeRLEiqJbbdmHcxbHWmpWLq4M83rCBhq0nWgyLvr+IF6H9dyWmOd87HhA1vegwpq5vclQqhRIrIQB+kHJZOUApxpsJBF0aeY94151w/pPjijoVgXrzgPtID3mEsu3ghWeAluZ94OCNJdQQ8CFN6kZCdY8F+YtriVCWYeX2Qdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jsWPAku8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jsWPAku8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D796C4CEF1;
	Tue, 26 Aug 2025 12:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212922;
	bh=ux/gCWa1dt4gruud99HseJaVtyeF99IJrIkJft61kyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jsWPAku8MjaAIOaRlPAFwKH/Xe/YasPzQndxKaGhQ+xbstbploQNK56pCEojB6Jhx
	 K6+QQ/eUCJ2/wbrLtwrZ5E0ER9/goOnoV49DCEgJfxA1R14UyYf2UbENNmgh0jdC0A
	 rW0t8y+oB6EvUSWKMclQpUpHAGH2mgPusrBY9NTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 152/587] arm64: Mark kernel as tainted on SAE and SError panic
Date: Tue, 26 Aug 2025 13:05:01 +0200
Message-ID: <20250826110956.815824180@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit d7ce7e3a84642aadf7c4787f7ec4f58eb163d129 ]

Set TAINT_MACHINE_CHECK when SError or Synchronous External Abort (SEA)
interrupts trigger a panic to flag potential hardware faults. This
tainting mechanism aids in debugging and enables correlation of
hardware-related crashes in large-scale deployments.

This change aligns with similar patches[1] that mark machine check
events when the system crashes due to hardware errors.

Link: https://lore.kernel.org/all/20250702-add_tain-v1-1-9187b10914b9@debian.org/ [1]
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20250716-vmcore_hw_error-v2-1-f187f7d62aba@debian.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/traps.c | 1 +
 arch/arm64/mm/fault.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 8b70759cdbb9..610f8a1099f5 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -953,6 +953,7 @@ void __noreturn panic_bad_stack(struct pt_regs *regs, unsigned long esr, unsigne
 
 void __noreturn arm64_serror_panic(struct pt_regs *regs, unsigned long esr)
 {
+	add_taint(TAINT_MACHINE_CHECK, LOCKDEP_STILL_OK);
 	console_verbose();
 
 	pr_crit("SError Interrupt on CPU%d, code 0x%016lx -- %s\n",
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 2e5d1e238af9..893b9485b840 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -753,6 +753,7 @@ static int do_sea(unsigned long far, unsigned long esr, struct pt_regs *regs)
 		 */
 		siaddr  = untagged_addr(far);
 	}
+	add_taint(TAINT_MACHINE_CHECK, LOCKDEP_STILL_OK);
 	arm64_notify_die(inf->name, regs, inf->sig, inf->code, siaddr, esr);
 
 	return 0;
-- 
2.39.5



