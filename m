Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1BF29711B;
	Mon, 12 May 2025 18:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073082; cv=none; b=mnMnZ7CR/WKGa3P62nKUqjWWByiIhilJpZ1asYqBEsBsyfW14APvK3/wRid1I/pCt6j7qv+zdmndhxSxDX/Z8wq21CD0tnFJba3uNgkPbvWjNFGohtcMH4HxAd5lS62vVbkTd60Tt/sD8NMHu9uT/zdCXE2pyG7wlKAAe4VmZy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073082; c=relaxed/simple;
	bh=2xEXV0MVWEJ1UQv5lCGBAte92AKwBCxBuDTezMvrEFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Apkvh9EbhEkQVWgiSJRK0UbsltUimwua+aZ/o/Q7Pc3jTdXVF6H9AKDjptK9hh2SAg9wHy453dR6kpq6kJySqPQumZeBt0QSiLhO/C3owGHQuZtro9z9PLqXOuWAKx3Ub/hu2SLoSNhsgzMLhQmsWctI/seGSacaT8/mjFyJSgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FJ4/kiSD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJ4/kiSD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25DDC4CEF0;
	Mon, 12 May 2025 18:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073082;
	bh=2xEXV0MVWEJ1UQv5lCGBAte92AKwBCxBuDTezMvrEFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJ4/kiSDYiPD749vcQuPfzd5Q06dALyIMAKEZJzrjYHfw5UsD4jmvf0Plmhrd8AJZ
	 J8h6KuMusZA4GUUOd6hmN6QDp+2oBQ1sFimlkogasvZJlp5l1upYLL8t/CLRSogSIC
	 Cxluh0W4uUPao9DUgbkiw0cPEsu96arFHRTmJ1dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 148/184] riscv: misaligned: enable IRQs while handling misaligned accesses
Date: Mon, 12 May 2025 19:45:49 +0200
Message-ID: <20250512172047.842502638@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



