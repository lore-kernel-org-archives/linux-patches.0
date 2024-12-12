Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129DE223E8D;
	Thu, 12 Dec 2024 17:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025734; cv=none; b=cw8uub46kHMAJAf80ERcd42rz7Fz/1yAKbOrdaB7ow6H6/RW1CX/zRdJCWSfslPecyRADzVABzDet+4/qTI+WptDDe9E2N5jtnKCcCaYVvazVZRTQqFtxaoITopLEcyj2sCp0qmEM/Rup4V1MyLHooZJ4z8lUeqNCcgDxGdeANA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025734; c=relaxed/simple;
	bh=SSlEWGdS+Hd1jocAN+CkZb9FS6K8aYSlGefZKKZ9tr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQ/JwWgcG3nxZKc8dJ00h9Dn4O3gmu2/Luid1fzz+RL/LL4HvtlZNeHem47Jw8ex+MSrrBKJ1lFfRPBQ+9vUVuhiIYDKnTwJrr0xZTHcGAHPKXpMvpFyVbUdsO1mc6lbDleTCepV5gT4Tx3/GmYB+dcNXuMJZhKy41fnWmq4jRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eH+iTB/h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eH+iTB/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8F2C4CECE;
	Thu, 12 Dec 2024 17:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025733;
	bh=SSlEWGdS+Hd1jocAN+CkZb9FS6K8aYSlGefZKKZ9tr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eH+iTB/hirxJrfpEEUpVqmwqfr5yBCQkJ1KLwGfpctpICp4cAxYBF0g3cxmYV9yCc
	 x/m1BMZsgco6U0ACKxZBjBUf/g3Q/NsG55JKO0M4vZcVtNe3iu7r10SAMAZdaCYC7I
	 bCTC4SL8/7KUuhBMGdcXX2dW/merV2ttBnGUHJLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jslaby@suse.cz>,
	Borislav Petkov <bp@suse.de>,
	Andy Lutomirski <luto@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Juergen Gross <jgross@suse.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	x86-ml <x86@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 242/321] x86/asm: Reorder early variables
Date: Thu, 12 Dec 2024 16:02:40 +0100
Message-ID: <20241212144239.534882826@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit 1a8770b746bd05ef68217989cd723b2c24d2208d ]

Moving early_recursion_flag (4 bytes) after early_level4_pgt (4k) and
early_dynamic_pgts (256k) saves 4k which are used for alignment of
early_level4_pgt after early_recursion_flag.

The real improvement is merely on the source code side. Previously it
was:
* __INITDATA + .balign
* early_recursion_flag variable
* a ton of CPP MACROS
* __INITDATA (again)
* early_top_pgt and early_recursion_flag variables
* .data

Now, it is a bit simpler:
* a ton of CPP MACROS
* __INITDATA + .balign
* early_top_pgt and early_recursion_flag variables
* early_recursion_flag variable
* .data

On the binary level the change looks like this:
Before:
 (sections)
  12 .init.data    00042000  0000000000000000  0000000000000000 00008000  2**12
 (symbols)
  000000       4 OBJECT  GLOBAL DEFAULT   22 early_recursion_flag
  001000    4096 OBJECT  GLOBAL DEFAULT   22 early_top_pgt
  002000 0x40000 OBJECT  GLOBAL DEFAULT   22 early_dynamic_pgts

After:
 (sections)
  12 .init.data    00041004  0000000000000000  0000000000000000 00008000  2**12
 (symbols)
  000000    4096 OBJECT  GLOBAL DEFAULT   22 early_top_pgt
  001000 0x40000 OBJECT  GLOBAL DEFAULT   22 early_dynamic_pgts
  041000       4 OBJECT  GLOBAL DEFAULT   22 early_recursion_flag

So the resulting vmlinux is smaller by 4k with my toolchain as many
other variables can be placed after early_recursion_flag to fill the
rest of the page. Note that this is only .init data, so it is freed
right after being booted anyway. Savings on-disk are none -- compression
of zeros is easy, so the size of bzImage is the same pre and post the
change.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20191003095238.29831-1-jslaby@suse.cz
Stable-dep-of: 3b2f2d22fb42 ("crypto: x86/aegis128 - access 32-bit arguments as 32-bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/head_64.S | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index f3d3e9646a99b..f00d7c0c1c86b 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -335,12 +335,6 @@ early_idt_handler_common:
 	jmp restore_regs_and_return_to_kernel
 END(early_idt_handler_common)
 
-	__INITDATA
-
-	.balign 4
-GLOBAL(early_recursion_flag)
-	.long 0
-
 #define NEXT_PAGE(name) \
 	.balign	PAGE_SIZE; \
 GLOBAL(name)
@@ -375,6 +369,8 @@ GLOBAL(name)
 	.endr
 
 	__INITDATA
+	.balign 4
+
 NEXT_PGD_PAGE(early_top_pgt)
 	.fill	512,8,0
 	.fill	PTI_USER_PGD_FILL,8,0
@@ -382,6 +378,9 @@ NEXT_PGD_PAGE(early_top_pgt)
 NEXT_PAGE(early_dynamic_pgts)
 	.fill	512*EARLY_DYNAMIC_PAGE_TABLES,8,0
 
+GLOBAL(early_recursion_flag)
+	.long 0
+
 	.data
 
 #if defined(CONFIG_XEN_PV) || defined(CONFIG_PVH)
-- 
2.43.0



