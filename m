Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D461D12DDA1;
	Mon, 18 Aug 2025 13:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522052; cv=none; b=okMP6sp3uFTdDQZosJ3jWW7P7wlQGUWW5kE8aC/TYolBEgcoC8BYo201H4jMEDj7v/TDUGvt+LAth3JaxW1fRBatvNXkru8/IxkTuKY7rk5Y9fhHzN/yIzpOroAZ5MTDM8HHW6sa+777ISnf7ptiJDtPF5IcDtkt9Fzq5IgSsbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522052; c=relaxed/simple;
	bh=4lMs02/2t853vVRJ+dpOwRwKp/SzNk3TY2apRC/TkTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R44qJrQqosrdWzoMeXZuA0asa73M61CGaYlx3LL2JwpH/syPc/6ucdZRXb1JNY/TbDkg+kEdU6hHCIiA4bg07fYk2KAMdU4LnQgEqt1Q/DYdX383XuCiBTcLp2v6D+1205dX22h1KuOv8lyY0LNK6eEb4ifFRxd3MdEVCM0vWXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qCceGfTG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qCceGfTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438A1C4CEF1;
	Mon, 18 Aug 2025 13:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522052;
	bh=4lMs02/2t853vVRJ+dpOwRwKp/SzNk3TY2apRC/TkTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qCceGfTGCc1ZRmXkTvcvpWNo6u0CtAJqfXMsZyvHyjGrIfE7WsfckfuPpzU7DKK+d
	 ZkDzfiIv5nR7oZwDfupAnEqvBXHrG9rSs7LxN1IX4J3Dn6JvStCf1ZkzZmOLxXllI0
	 1cQ36BiYoFWZMSTRlgJpkpzzxnTizznOlvBpX5lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 183/444] arm64: Mark kernel as tainted on SAE and SError panic
Date: Mon, 18 Aug 2025 14:43:29 +0200
Message-ID: <20250818124455.732906201@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 563cbce11126..e2e8ffa65aa5 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -921,6 +921,7 @@ void __noreturn panic_bad_stack(struct pt_regs *regs, unsigned long esr, unsigne
 
 void __noreturn arm64_serror_panic(struct pt_regs *regs, unsigned long esr)
 {
+	add_taint(TAINT_MACHINE_CHECK, LOCKDEP_STILL_OK);
 	console_verbose();
 
 	pr_crit("SError Interrupt on CPU%d, code 0x%016lx -- %s\n",
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 850307b49bab..2d1ebc0c3437 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -798,6 +798,7 @@ static int do_sea(unsigned long far, unsigned long esr, struct pt_regs *regs)
 		 */
 		siaddr  = untagged_addr(far);
 	}
+	add_taint(TAINT_MACHINE_CHECK, LOCKDEP_STILL_OK);
 	arm64_notify_die(inf->name, regs, inf->sig, inf->code, siaddr, esr);
 
 	return 0;
-- 
2.39.5



