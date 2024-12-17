Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139FE1F868C;
	Tue, 17 Dec 2024 17:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455907; cv=none; b=r+TzVZvJBYVxHYA0OyHiZtmjGV+vvKIworjZlZBPLrkojnnvhxS7R28SEWUo9R5glhAhmh2UnTSein/XPVTzAiiYG89R0o7RLSn5Mr5mbu0XT5wbpDugzX2HD5FGalGzD75qEH6JXTWhBBKCA98sMTHP7UMNlZedxhHLJHfqiLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455907; c=relaxed/simple;
	bh=KIrjWYx1hfeLCxxIIz5ExVvXfb3GExemC4J5AngKHRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ix/tSUp9J/WRBCbw5Hd3oAg3epRXNJpbAYzYfttCNVud0hXCptgdQG7BCDKDPk14ZWyBzWUAX3GfvEvn+wwR3Z99i9OYzRsZXcnm5XLphtL3/qFYfgL+ybL5KkEO+DiOO3TjZCjWpUgCcvDvQAhCx2V5KL+jVf4iYBBEIh8SOV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jYA1AfsX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jYA1AfsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854C1C4CED7;
	Tue, 17 Dec 2024 17:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455906;
	bh=KIrjWYx1hfeLCxxIIz5ExVvXfb3GExemC4J5AngKHRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jYA1AfsXtM9/OjvBaNaSC5adxQURLV17oWibh2fbHF8ljSg26cMUevw4/6BpOEoQr
	 InE5nHaD2hXJDC1um4rqxTE43+VFu9skX/ha7ZaFue2Dw7MkeTddFxeR3/PUPRKqjU
	 8RhuYfx3b2FyjmgAoQemOd3KtOZSoDBkatamzCTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Juergen Gross <jgross@suse.com>,
	Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 6.1 72/76] x86/xen: dont do PV iret hypercall through hypercall page
Date: Tue, 17 Dec 2024 18:07:52 +0100
Message-ID: <20241217170529.507084783@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

commit a2796dff62d6c6bfc5fbebdf2bee0d5ac0438906 upstream.

Instead of jumping to the Xen hypercall page for doing the iret
hypercall, directly code the required sequence in xen-asm.S.

This is done in preparation of no longer using hypercall page at all,
as it has shown to cause problems with speculation mitigations.

This is part of XSA-466 / CVE-2024-53241.

Reported-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/xen/xen-asm.S |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -176,7 +176,6 @@ SYM_CODE_START(xen_early_idt_handler_arr
 SYM_CODE_END(xen_early_idt_handler_array)
 	__FINIT
 
-hypercall_iret = hypercall_page + __HYPERVISOR_iret * 32
 /*
  * Xen64 iret frame:
  *
@@ -186,17 +185,28 @@ hypercall_iret = hypercall_page + __HYPE
  *	cs
  *	rip		<-- standard iret frame
  *
- *	flags
+ *	flags		<-- xen_iret must push from here on
  *
- *	rcx		}
- *	r11		}<-- pushed by hypercall page
- * rsp->rax		}
+ *	rcx
+ *	r11
+ * rsp->rax
  */
+.macro xen_hypercall_iret
+	pushq $0	/* Flags */
+	push %rcx
+	push %r11
+	push %rax
+	mov  $__HYPERVISOR_iret, %eax
+	syscall		/* Do the IRET. */
+#ifdef CONFIG_MITIGATION_SLS
+	int3
+#endif
+.endm
+
 SYM_CODE_START(xen_iret)
 	UNWIND_HINT_EMPTY
 	ANNOTATE_NOENDBR
-	pushq $0
-	jmp hypercall_iret
+	xen_hypercall_iret
 SYM_CODE_END(xen_iret)
 
 /*
@@ -301,8 +311,7 @@ SYM_CODE_START(xen_entry_SYSENTER_compat
 	ENDBR
 	lea 16(%rsp), %rsp	/* strip %rcx, %r11 */
 	mov $-ENOSYS, %rax
-	pushq $0
-	jmp hypercall_iret
+	xen_hypercall_iret
 SYM_CODE_END(xen_entry_SYSENTER_compat)
 SYM_CODE_END(xen_entry_SYSCALL_compat)
 


