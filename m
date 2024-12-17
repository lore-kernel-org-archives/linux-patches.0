Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61A41F76A1;
	Tue, 17 Dec 2024 17:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455701; cv=none; b=YD6ad38KSYg77tqFuf2jWDnQFWnd3oq7YzX9zf9EBt8QPVApKhQeCo1x0S9zOINJdkxoFlsJgAMe5PTT4HdLAtS2M44wdKZ9tdlr5XUYgGULKJ1qQpouFMS2OI6JWFejrgegB3L2MCcUBUqUEXPP3aiJdUikWJZahhA+u7JYVZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455701; c=relaxed/simple;
	bh=qvPPyYcd8MI5RrBo/KDft6sNOEiMzOkEd5KCVhMYZYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bj5QPWkHRXi73sDLKHdzsEvoITAvP/xpBX4u3sqoq7pnkDrSNhowhHKROxYSgwjvYEn7AiiXO5e3+QeIbII2D3xNmUQKfxTRQvf3WNdPqVMcLbJLZbukIcRHYlAZYBR0NKKU8233XWebNjbpHaZwljcY/KjAucpv5AtSt0mJZ9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J4DJgArK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4DJgArK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F83EC4CED3;
	Tue, 17 Dec 2024 17:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455700;
	bh=qvPPyYcd8MI5RrBo/KDft6sNOEiMzOkEd5KCVhMYZYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4DJgArKFBFJgJ7fvX4Z7lNF4noIVO/9QB/8FUWA5uotiwaIf3TiJm7cZbiKuDRE8
	 +0zFPTipm7JxvFyxQ21ql54FFsynbuKQBWOAv4KoAT7e7nj+d6QkXS15XZA64NHT8d
	 +R4EPSGM8NndL8Zbk5OaQfQmlouEEhCapEtMLrEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Juergen Gross <jgross@suse.com>,
	Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 5.15 47/51] x86/xen: dont do PV iret hypercall through hypercall page
Date: Tue, 17 Dec 2024 18:07:40 +0100
Message-ID: <20241217170522.404331339@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -170,7 +170,6 @@ SYM_CODE_START(xen_early_idt_handler_arr
 SYM_CODE_END(xen_early_idt_handler_array)
 	__FINIT
 
-hypercall_iret = hypercall_page + __HYPERVISOR_iret * 32
 /*
  * Xen64 iret frame:
  *
@@ -180,16 +179,27 @@ hypercall_iret = hypercall_page + __HYPE
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
-	pushq $0
-	jmp hypercall_iret
+	xen_hypercall_iret
 SYM_CODE_END(xen_iret)
 
 /*
@@ -290,8 +300,7 @@ SYM_CODE_START(xen_entry_SYSENTER_compat
 	UNWIND_HINT_ENTRY
 	lea 16(%rsp), %rsp	/* strip %rcx, %r11 */
 	mov $-ENOSYS, %rax
-	pushq $0
-	jmp hypercall_iret
+	xen_hypercall_iret
 SYM_CODE_END(xen_entry_SYSENTER_compat)
 SYM_CODE_END(xen_entry_SYSCALL_compat)
 


