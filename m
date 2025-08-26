Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D584634DCCC;
	Tue, 26 Aug 2025 13:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214397; cv=none; b=bgCR4WLFuQg3WDmjgKIAtIeEguSsOEuLTCTNwgGfC1C778g5McZ5bm4b2BIY0+34j32XJWBUgK1rITtoKNk76dtZbqj0TPzs7pfzwxvLyqYw3F3IFcGEQvdt5Ce7lNKf7xVqfTPXedNeI72J+rYmgFXbj8ki+Rfh3wevRqxUDPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214397; c=relaxed/simple;
	bh=U8GOPHrS9rWVmM9qF9lfJOt7x+C3J+AtK8sXwNa3nFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pkYTOFUyhnLMs0MCiiWcmFriKwp0pvqHBeQedKNRtHtdSFpPZT8T6by0Erx8i8BI2rQUY2Pj4UaQrULJJDFkVj9WdnKlVDfDjV7PAIwPLvWkw2UoWW+O4aAbCdmF4hajEzCcSujIR8U6oz/SIoTOu9Ib7cw3qGhUKfuFQ8oSYgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3sLZJDn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3sLZJDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B34C113D0;
	Tue, 26 Aug 2025 13:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214397;
	bh=U8GOPHrS9rWVmM9qF9lfJOt7x+C3J+AtK8sXwNa3nFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3sLZJDnNqv+BzP6iI3KhIAZp5oIy5FoxSvw8jy6yO1fv+IOVeQiZdOoMXnJkdan0
	 zC71QDLDgTNAEyZwJcjqz59uymR4J1DuFKm5YfPaH+7ZMq/+N5t10i8vEX9SmqTfXJ
	 cIIT0XcKm0NP0tzfeSs9QbXRRA7sXPFRrcwwngH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 123/482] arm64: Mark kernel as tainted on SAE and SError panic
Date: Tue, 26 Aug 2025 13:06:16 +0200
Message-ID: <20250826110933.861496586@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 23d281ed7621..09489e92ff94 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -911,6 +911,7 @@ void panic_bad_stack(struct pt_regs *regs, unsigned long esr, unsigned long far)
 
 void __noreturn arm64_serror_panic(struct pt_regs *regs, unsigned long esr)
 {
+	add_taint(TAINT_MACHINE_CHECK, LOCKDEP_STILL_OK);
 	console_verbose();
 
 	pr_crit("SError Interrupt on CPU%d, code 0x%016lx -- %s\n",
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 6b6b8a82f294..0776c98ad27f 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -710,6 +710,7 @@ static int do_sea(unsigned long far, unsigned long esr, struct pt_regs *regs)
 		 */
 		siaddr  = untagged_addr(far);
 	}
+	add_taint(TAINT_MACHINE_CHECK, LOCKDEP_STILL_OK);
 	arm64_notify_die(inf->name, regs, inf->sig, inf->code, siaddr, esr);
 
 	return 0;
-- 
2.39.5



