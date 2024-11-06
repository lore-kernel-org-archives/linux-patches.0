Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40641E103C;
	Wed,  6 Nov 2024 12:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896887; cv=none; b=KPanQyqa9tcl5Y0TOIE2EoWP4N1GxAIvEE9YA+AHJGKkosZV21WLM2NuYSIHrSjJY081wVZlTqrRfxBPPj33+a0mif0Kqgm07QVZAIs/HXuV2Jyfj/mmjQ9tRw98pX/tJB9cb7nte5apMg0Hh2l/3N6ubyOAank7fO+1eGcFwzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896887; c=relaxed/simple;
	bh=eXvWHLIVjvzQCjHzM1lkKEWmp545DsXfQqePglv29nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9RNJSOBAB8Z4xhhloOvSzZq5XJACcJnFedpx7kWFLYs1Gw41ejXFb7F7dJsM7HL2pKUDXI7Yy7D6vTqzfFeHHjHDd/L9d8HyYng1uX9wPf1R/S+ESCO8tJD+0Fevw67abTOcDMTyPD9U9OLXhkbJWsm5Gl71QnNdqQhNkF0K/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEKnDcFp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEKnDcFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9CDC4CECD;
	Wed,  6 Nov 2024 12:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896886;
	bh=eXvWHLIVjvzQCjHzM1lkKEWmp545DsXfQqePglv29nE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEKnDcFp6+5wKn+AJ9coeORa7FA8/xbDzATYzgHgXqtH4mTHVbGUiLCcwA8wNZV32
	 8tNnJYcT6rjGqZxkSi83ccpUDW9qpFLvF4jd6P1oNB5Kq/xM1bXL7swVTK3L0wu1ug
	 f77fclW/F0cXfVF5i6Uuo7qpRpR4F5r3XhcAXIeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Gill <rtgill82@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Brian Gerst <brgerst@gmail.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.10 104/110] x86/bugs: Use code segment selector for VERW operand
Date: Wed,  6 Nov 2024 13:05:10 +0100
Message-ID: <20241106120306.045406897@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit e4d2102018542e3ae5e297bc6e229303abff8a0f upstream.

Robert Gill reported below #GP in 32-bit mode when dosemu software was
executing vm86() system call:

  general protection fault: 0000 [#1] PREEMPT SMP
  CPU: 4 PID: 4610 Comm: dosemu.bin Not tainted 6.6.21-gentoo-x86 #1
  Hardware name: Dell Inc. PowerEdge 1950/0H723K, BIOS 2.7.0 10/30/2010
  EIP: restore_all_switch_stack+0xbe/0xcf
  EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
  ESI: 00000000 EDI: 00000000 EBP: 00000000 ESP: ff8affdc
  DS: 0000 ES: 0000 FS: 0000 GS: 0033 SS: 0068 EFLAGS: 00010046
  CR0: 80050033 CR2: 00c2101c CR3: 04b6d000 CR4: 000406d0
  Call Trace:
   show_regs+0x70/0x78
   die_addr+0x29/0x70
   exc_general_protection+0x13c/0x348
   exc_bounds+0x98/0x98
   handle_exception+0x14d/0x14d
   exc_bounds+0x98/0x98
   restore_all_switch_stack+0xbe/0xcf
   exc_bounds+0x98/0x98
   restore_all_switch_stack+0xbe/0xcf

This only happens in 32-bit mode when VERW based mitigations like MDS/RFDS
are enabled. This is because segment registers with an arbitrary user value
can result in #GP when executing VERW. Intel SDM vol. 2C documents the
following behavior for VERW instruction:

  #GP(0) - If a memory operand effective address is outside the CS, DS, ES,
	   FS, or GS segment limit.

CLEAR_CPU_BUFFERS macro executes VERW instruction before returning to user
space. Use %cs selector to reference VERW operand. This ensures VERW will
not #GP for an arbitrary user %ds.

[ mingo: Fixed the SOB chain. ]

Fixes: a0e2dab44d22 ("x86/entry_32: Add VERW just before userspace transition")
Reported-by: Robert Gill <rtgill82@gmail.com>
Reviewed-by: Andrew Cooper <andrew.cooper3@citrix.com
Cc: stable@vger.kernel.org # 5.10+
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218707
Closes: https://lore.kernel.org/all/8c77ccfd-d561-45a1-8ed5-6b75212c7a58@leemhuis.info/
Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Suggested-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -199,7 +199,16 @@
  */
 .macro CLEAR_CPU_BUFFERS
 	ALTERNATIVE "jmp .Lskip_verw_\@", "", X86_FEATURE_CLEAR_CPU_BUF
-	verw _ASM_RIP(mds_verw_sel)
+#ifdef CONFIG_X86_64
+	verw mds_verw_sel(%rip)
+#else
+	/*
+	 * In 32bit mode, the memory operand must be a %cs reference. The data
+	 * segments may not be usable (vm86 mode), and the stack segment may not
+	 * be flat (ESPFIX32).
+	 */
+	verw %cs:mds_verw_sel
+#endif
 .Lskip_verw_\@:
 .endm
 


