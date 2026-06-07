Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751CF1DE8AE;
	Sun,  7 Jun 2026 10:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826964; cv=none; b=FQbQNLaEenCW38Sba+p1yI+RqV2jVzlqz/5qfkTLJ+nakEYPoMwAADaTY/b3puCBndepXe5e/xUvoZbgejGyZ8ILxyt8ZRBhoBRhWOAt2DKOPg4V2kxMprGriB8hNGnSc9y7PxhMxf4sgMFPrcWCySeJNqqcs5G8kdi8od0cXII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826964; c=relaxed/simple;
	bh=fWSgz1vO17P2X+maX2iaPnCZF3c0z7aZYowp6qTRLog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VCbrB+E1JulicAXnLa3uJGo8EwjaknQyBj5jlBqVzNiYx7Pfy7EhABX59ToEaqgxLg9FubP9yEoIW4PAGH5MCgRduBnVlv9Ds9heySl9dg0V0nk7v8viMSUW/Yt1ZBOXxjN6R5t+EPkb9/x8AKMzmSI+CY3UicwIN5WSVM/g0OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GkSwGFAu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GkSwGFAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB601F00893;
	Sun,  7 Jun 2026 10:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826963;
	bh=LGTRzKudbO2l0JEBAzPvDDcQ2Bk0cRxTvf4t+IUy1EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GkSwGFAuKGfEOcUH99UlHHM17LCN2I/fmqpCNjzU+bIZUlv5Y8dwJKso2t3pdb2eu
	 uQT76ugNq5nkI9cpGq90Jf1arFgFXCbjWxRJHiUioG54MKdJUXiddTK/cBnMG9Tijx
	 rNMs4R/ZlZTW8hUs/UyboVqDKxT3eN47vzw/qP8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Kees Cook <kees@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/307] arm64: Introduce esr_is_ubsan_brk()
Date: Sun,  7 Jun 2026 11:56:47 +0200
Message-ID: <20260607095728.012999876@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Mostafa Saleh <smostafa@google.com>

[ Upstream commit dc1fd37a7f501731e488c1c6f86b2f591632a4ad ]

Soon, KVM is going to use this logic for hypervisor panics,
so add it in a wrapper that can be used by the hypervisor exit
handler to decode hyp panics.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Kees Cook <kees@kernel.org>
Link: https://lore.kernel.org/r/20250430162713.1997569-2-smostafa@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/esr.h | 5 +++++
 arch/arm64/kernel/traps.c    | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 5f4dc6364dbb9d..b0520b18192c5a 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -409,6 +409,11 @@ static inline bool esr_is_cfi_brk(unsigned long esr)
 	       (esr_brk_comment(esr) & ~CFI_BRK_IMM_MASK) == CFI_BRK_IMM_BASE;
 }
 
+static inline bool esr_is_ubsan_brk(unsigned long esr)
+{
+	return (esr_brk_comment(esr) & ~UBSAN_BRK_MASK) == UBSAN_BRK_IMM;
+}
+
 static inline bool esr_fsc_is_translation_fault(unsigned long esr)
 {
 	esr = esr & ESR_ELx_FSC;
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index e2e8ffa65aa586..5e138cf5d4ade3 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -1136,7 +1136,7 @@ int __init early_brk64(unsigned long addr, unsigned long esr,
 		return kasan_handler(regs, esr) != DBG_HOOK_HANDLED;
 #endif
 #ifdef CONFIG_UBSAN_TRAP
-	if ((esr_brk_comment(esr) & ~UBSAN_BRK_MASK) == UBSAN_BRK_IMM)
+	if (esr_is_ubsan_brk(esr))
 		return ubsan_handler(regs, esr) != DBG_HOOK_HANDLED;
 #endif
 	return bug_handler(regs, esr) != DBG_HOOK_HANDLED;
-- 
2.53.0



