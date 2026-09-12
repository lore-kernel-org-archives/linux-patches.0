Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94FF43932A;
	Sat, 12 Sep 2026 10:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209817; cv=none; b=t/Atm7/ozYZs5vs/NzYJfQlzpVVPh1d51A+rHz2gL+k/pgkzkXvoGNPL0Ez6EdrkQB386eHyry41tDydADGOQ40Ho3HiyRN41CFixrTb9SVR/QZGsBLlnILmAwPtUnvY39XKQWXljMJbKAXBRfxRqywk2Hv55vo9oUka1Zq+0ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209817; c=relaxed/simple;
	bh=04cWWNalua9OzrsbmO4/XUYmD7cA1VEqpwBLKzj1MTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRkswXLy08yBDQaL7oDp9kfL6AIcI6ch6NeVkhcbcCIi2fdZFJGOv8AY2lfIe3XFVi+u0JCjt9warTK5meOJ+4W8SHGNCbw21Et8vVV/oERw5YAYOUhJLcuWk3ZQry63K+wqP+iWfTJt+Aur2oL9OfNw4A3MUzX0jv1Two+vyO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KBbp/R4w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KBbp/R4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081AD1F000FF;
	Sat, 12 Sep 2026 10:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209814;
	bh=8Oh5jdC5Z445AoAMuAfm9j4Sxnyke0k/0M+O8pG9/BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KBbp/R4wLbWfrytQKVYeqr0/WR1aQLLXodat8TwDPHjvk9bi+r4ANUath7JLfYY9C
	 gSLg9SQ/Oo0VOULngoWtlaa1afIVQWm7p6NQcDQz6r2LGztMu0HU5vxc0iKh05t+LE
	 5Y1eLWlDJ0W2hMIDUOBxw20Jdi1Ans/kDY/Z+8nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	slipher <slipher@protonmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Linus Walleij <linusw@kernel.org>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0898/1518] ARM: 9481/2: breakpoint: CFI breakpoints only on demand
Date: Sat, 12 Sep 2026 08:51:07 +0200
Message-ID: <20260912065643.767898518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 8ed9bff906cf8036531d1559f10e82733a52b41f ]

This removes the stub hw_breakpoint_cfi_handler() from ARM, making
it not steal breakpoint type 0x03 (ARM_ENTRY_CFI_BREAKPOINT) unless
CFI is actively used in the kernel.

When not instrumenting with CFI, or when a breakpoint is issued in
userspace, we fall through to return 1 from hw_breakpoint_pending()
"unhandled fault" so userspace can make use of this breakpoint.

Tested with LKDTM and this command line:
echo CFI_FORWARD_PROTO > /sys/kernel/debug/provoke-crash/DIRECT
still works as expected.

Closes: https://lore.kernel.org/lkml/kJqktbpLphg_Pk5I5SPptgTLjl3E3eq5mN5UzCslyFj7Q1Irp-wDid4mj5eQVd2iZtRGXgeZd8goq195EkXdjyt864YMc8mVb2B9NGH91NQ=@protonmail.com/

Fixes: c3f89986fde7 ("ARM: 9391/2: hw_breakpoint: Handle CFI breakpoints")
Reported-by: slipher <slipher@protonmail.com>
Suggested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/hw_breakpoint.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
index cd4b34c96e35e..38feb30dfb5f8 100644
--- a/arch/arm/kernel/hw_breakpoint.c
+++ b/arch/arm/kernel/hw_breakpoint.c
@@ -929,10 +929,6 @@ static void hw_breakpoint_cfi_handler(struct pt_regs *regs)
 		break;
 	}
 }
-#else
-static void hw_breakpoint_cfi_handler(struct pt_regs *regs)
-{
-}
 #endif
 
 /*
@@ -964,9 +960,14 @@ static int hw_breakpoint_pending(unsigned long addr, unsigned int fsr,
 	case ARM_ENTRY_SYNC_WATCHPOINT:
 		watchpoint_handler(addr, fsr, regs);
 		break;
+#ifdef CONFIG_CFI
 	case ARM_ENTRY_CFI_BREAKPOINT:
-		hw_breakpoint_cfi_handler(regs);
+		if (user_mode(regs))
+			ret = 1; /* Don't handle userspace BKPT */
+		else
+			hw_breakpoint_cfi_handler(regs);
 		break;
+#endif
 	default:
 		ret = 1; /* Unhandled fault. */
 	}
-- 
2.53.0



