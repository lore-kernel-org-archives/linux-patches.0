Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6933B19B9;
	Sat, 17 Oct 2026 16:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255221; cv=none; b=S++6HM15TVJ5aO8jKDtxzzOh3kvyOiy7RXK+Ooq3355JbuyfCblfsJav5nKYTj03z4DhDcrq4P6KYAhzLct3RJ69XxDLaxdaUv597owihgTMo3nO4lQrvseTisQsoi/sC7kDgHaSaIo+1oJg5+iWcESpTbwIxE152FpDCpLQjrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255221; c=relaxed/simple;
	bh=9YT7U2RSNm9/8PCe1+5XfWmQXqPK4na9gYPFk/YY188=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWBj8yQ4M0vE7BzNyzRnTZ9gsZuPpcWF87Z9Uoq0j9WToLMp6mqLlciLDYTk/EEbz8YE2uNuiO35QB/2Jsz7esY9S/5MmmRG3Os/oiei8ZPrXDVXbMiD0ZbxfkktA9TZzxzmMSoBUs5JlSoVee2y9cuCK5bf8otz59ue5lx3zDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vgvOQm6i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vgvOQm6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160241F000C4;
	Sat, 17 Oct 2026 16:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255218;
	bh=9z5zE8PMYdU53lyyuADwWhI38BWHknCiTx6q9ZaluGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vgvOQm6iqCZyh5Nk2TH8FJrNfs8jjElomgiXKjCLjGGE7P9M2KPlsmTO159ABKTbr
	 o3UbZlDFp45qUsiUP2PxcZIM5ZS0uWHQ2TBvpHBxIgdzg7Yd+bbmHARoklnJcTd0W1
	 VuqQblfqI3dc6bRYADdyS/HtjvV+xmOwv/GSelHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	slipher <slipher@protonmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Linus Walleij <linusw@kernel.org>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 659/869] ARM: 9481/2: breakpoint: CFI breakpoints only on demand
Date: Sat, 17 Oct 2026 17:58:20 +0200
Message-ID: <20261017160053.893487108@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index a12efd0f43e81..6819d4c1f3521 100644
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



