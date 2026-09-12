Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D916E29D288;
	Sat, 12 Sep 2026 12:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217279; cv=none; b=o9K/ckxxION01bUwS8mh3KU1DD7BkXwN4y0hvJ6QYtQyQbft4f8bloArRO3uuSx6zuEy+wZYtTDTYBhBiWIlA9zp2E1OvX5FvTH0mH6yMD29WOwAZyJmFDVLVhGlkBTABJ0fW66wi8xk1aF1Isyp6m66rygvvr4lgwDrGGNvpjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217279; c=relaxed/simple;
	bh=9YT7U2RSNm9/8PCe1+5XfWmQXqPK4na9gYPFk/YY188=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J5Pr33MzffxPFGDcscOgt5xh6Z15fjcULR2mfXsQd9bXYTnWE9PR9qifENpMr91tva0LViSMJP/6dtV9P1mVqnU9h5JcXisx/8fkBihlQSyCEFoELhKZNZ2ZTEIElHs8H7DW5vBEnUWpaFoD4heNOAG3a4SLbfUD9zKsTQhmIvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y99sFygz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y99sFygz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C481F000FF;
	Sat, 12 Sep 2026 12:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217277;
	bh=9z5zE8PMYdU53lyyuADwWhI38BWHknCiTx6q9ZaluGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y99sFygzb3CDuCeCa2Y51gq3b/4PBjQ/nSlxEQyiQoxdBJDazsnUhDpc6074yTNDf
	 tGlHjadoxE6ZhUUA4hyWrRAiw9NXqVlPWq8M0gzhmRHqDlQ41hgS8xTU8h8wAhIqmF
	 Y26BRGdzvquuTN5gREkpOqyrDn0DtiFSTgAB5u+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	slipher <slipher@protonmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Linus Walleij <linusw@kernel.org>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0908/1376] ARM: 9481/2: breakpoint: CFI breakpoints only on demand
Date: Sat, 12 Sep 2026 08:55:34 +0200
Message-ID: <20260912065627.803846640@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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



