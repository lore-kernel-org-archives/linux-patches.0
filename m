Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B610D254879;
	Mon, 12 May 2025 17:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072302; cv=none; b=AlCRvyGofobmIflHmenuO8FEX7aMdr1ejeZ2e8nJSGpKKZVE0VWjh4cdSp27cIA8T6JThaYduvDtpl/jeQ5nQGHfZC0oGhd+nmmZqLpthTU9e3big6AwiuHg1PkYBm7MOqkVbzYGAq2h+Od4cEU/YJC8advqXTqMcdLiBCsTSog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072302; c=relaxed/simple;
	bh=Y9EMJf6QV7qdKRor6K9SZ/s6gLmnCFfrgxvSQWKdLYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fpEFZRLsGMDpo//gGLcNN/MN0ndFTLokUf/+YWzPMuFT5ZYGzSLsLzbQDVbcB8qH2C4VhFo7BMGV4+0XvCPGCUML1MxpWAqE9tktjr3uu5Pvi7azdYFKGgszUJL/tLw04iuSA0QaDu1+Bv/YGmlJlCLME4yHN5pi8onglwlD9KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsWeYNj9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsWeYNj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AADC4CEE7;
	Mon, 12 May 2025 17:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072302;
	bh=Y9EMJf6QV7qdKRor6K9SZ/s6gLmnCFfrgxvSQWKdLYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dsWeYNj9QegbQ+9V2nUZ6TA6kGmn+DoDNCOIFH3PQgcNKwUmIF2rqhapPCyNonyo3
	 sAiwEAPvYfjfsUTNEUJYcP7K66963tXueIVYDlkTPa+joh2gJ3fFAuCMJBTrhe3g6H
	 0raJ4wnUcIVQx7K7VkkP3JwgYdSCl6dRSMZnO7KM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 166/197] riscv: misaligned: enable IRQs while handling misaligned accesses
Date: Mon, 12 May 2025 19:40:16 +0200
Message-ID: <20250512172051.142678917@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clément Léger <cleger@rivosinc.com>

[ Upstream commit 453805f0a28fc5091e46145e6560c776f7c7a611 ]

We can safely reenable IRQs if coming from userspace. This allows to
access user memory that could potentially trigger a page fault.

Fixes: b686ecdeacf6 ("riscv: misaligned: Restrict user access to kernel memory")
Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20250422162324.956065-3-cleger@rivosinc.com
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/traps.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index b1d991c78a233..9c83848797a78 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -220,19 +220,23 @@ static void do_trap_misaligned(struct pt_regs *regs, enum misaligned_access_type
 {
 	irqentry_state_t state;
 
-	if (user_mode(regs))
+	if (user_mode(regs)) {
 		irqentry_enter_from_user_mode(regs);
-	else
+		local_irq_enable();
+	} else {
 		state = irqentry_nmi_enter(regs);
+	}
 
 	if (misaligned_handler[type].handler(regs))
 		do_trap_error(regs, SIGBUS, BUS_ADRALN, regs->epc,
 			      misaligned_handler[type].type_str);
 
-	if (user_mode(regs))
+	if (user_mode(regs)) {
+		local_irq_disable();
 		irqentry_exit_to_user_mode(regs);
-	else
+	} else {
 		irqentry_nmi_exit(regs, state);
+	}
 }
 
 asmlinkage __visible __trap_section void do_trap_load_misaligned(struct pt_regs *regs)
-- 
2.39.5



