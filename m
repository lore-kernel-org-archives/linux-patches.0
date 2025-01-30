Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773331BDA95;
	Thu, 30 Jan 2025 14:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246823; cv=none; b=k4XT3BrskBv68KfCarl1Q7PoTYC/UVKnvmiAJf3UJNqEEDscFJPVTIPdqQbH9kJ68AnX4AhlZ11LluJUN48MYOphviiZLKvOGkJsOBS9RxXv7q1mze/K25s61D5Vl53Bo3u5C5TELX0dttYtI3kvFy6UzmsNuafhP2zNYcDjO8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246823; c=relaxed/simple;
	bh=kKUrsvo4kCY2s8Og9lAHFGuPwnPWj3r8dDwXg04dgZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SNdNTnkbCjnanwfalP8WC2cIeZ6+s5xJsLusdgimYt7U0rvjePrrY7QLWI3pr7WlxvNYt+KI73eidB5YERFiWeMF2fxljiySz9ksOHQ2gKayTsXbjsQcb9YTRtq1mLREwuyytggR2jumfWzk/nII57Z6Gzn5O9/sRw7h3fiRHNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TMFUdSmK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TMFUdSmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A84C4CED2;
	Thu, 30 Jan 2025 14:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246823;
	bh=kKUrsvo4kCY2s8Og9lAHFGuPwnPWj3r8dDwXg04dgZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TMFUdSmK3UNcsojlGWeqvRSZGIPL/KVfymsvmJC1eUDEP/eWJ13DCji8DzDo6WdrL
	 LJHnOat0JXrqUvD3xr4C9kz+VqDvs/XukxRoS0fsp0hOG7FWFYib/MgNWMSFLsDWHF
	 bJVGRMMDWAoAvWOtjZBzqZvF3q3SjTCSmOT90E0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mattias Nissler <mnissler@rivosinc.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 50/91] riscv: Avoid enabling interrupts in die()
Date: Thu, 30 Jan 2025 15:01:09 +0100
Message-ID: <20250130140135.671836424@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mattias Nissler <mnissler@rivosinc.com>

[ Upstream commit 130aee3fd9981297ff9354e5d5609cd59aafbbea ]

While working on something else, I noticed that the kernel would start
accepting interrupts again after crashing in an interrupt handler. Since
the kernel is already in inconsistent state, enabling interrupts is
dangerous and opens up risk of kernel state deteriorating further.
Interrupts do get enabled via what looks like an unintended side effect of
spin_unlock_irq, so switch to the more cautious
spin_lock_irqsave/spin_unlock_irqrestore instead.

Fixes: 76d2a0493a17 ("RISC-V: Init and Halt Code")
Signed-off-by: Mattias Nissler <mnissler@rivosinc.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Link: https://lore.kernel.org/r/20230215144828.3370316-1-mnissler@rivosinc.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Stable-dep-of: 6a97f4118ac0 ("riscv: Fix sleeping in invalid context in die()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/traps.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 533087439e80..d255d88cf522 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -30,10 +30,11 @@ void die(struct pt_regs *regs, const char *str)
 	static int die_counter;
 	int ret;
 	long cause;
+	unsigned long flags;
 
 	oops_enter();
 
-	spin_lock_irq(&die_lock);
+	spin_lock_irqsave(&die_lock, flags);
 	console_verbose();
 	bust_spinlocks(1);
 
@@ -50,7 +51,7 @@ void die(struct pt_regs *regs, const char *str)
 
 	bust_spinlocks(0);
 	add_taint(TAINT_DIE, LOCKDEP_NOW_UNRELIABLE);
-	spin_unlock_irq(&die_lock);
+	spin_unlock_irqrestore(&die_lock, flags);
 	oops_exit();
 
 	if (in_interrupt())
-- 
2.39.5



