Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C86B1F8911;
	Tue, 17 Dec 2024 17:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456809; cv=none; b=FAonmo6zpZiLVsU2U1dKH94zjj21eBqMhU5qlR8Piv3s2MTefeiMYHlGH1SY3qj5R0yJK0xsFbaDh4QzOFwG/13d16/iVVQ2fG7zb+geL3yUe6jhTK1b0chkGfr5sdinnO9ilP6V4DXEgCuPNAgoxv1LgbrJLJZiCort2PJICyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456809; c=relaxed/simple;
	bh=clOEoNFCt91405Kg84pO3MziNuAt/OCLR7ybBOPgPwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FiZB+DFKYa4Pzs9j0QH1tbNgHfxRsLAFdbrjj9nSP8P+mFzsrx+l+UQdP3h4yPqi3WmzRjB4spcRPp5Vfjsv9wU2XjMevPKGVK9JFCU6WIgJI8Qvi/s9tO2pOknzvcLEtJ72n3MEv+5Yntl755rQG9O/o19c7+XSPB/v7zzHSgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kaOfNMoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kaOfNMoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF036C4CED3;
	Tue, 17 Dec 2024 17:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456809;
	bh=clOEoNFCt91405Kg84pO3MziNuAt/OCLR7ybBOPgPwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kaOfNMoXV1ekhtCcdxSR4Ps+4J8F64eA+L6r27T5TzHZcmyMM/LCvge4UiAM85QLn
	 g8GFQQCkagzCH+mp2KTxXRyNdmAeqPI/1kyHvqEBpwws0hjqZRv2XET8QnbfLdnvOr
	 e6d879NF4BCMxzsCh3t4IRcTcdUCVvF31BV7aaTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Juergen Gross <jgross@suse.com>,
	Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 6.12 169/172] x86/xen: dont do PV iret hypercall through hypercall page
Date: Tue, 17 Dec 2024 18:08:45 +0100
Message-ID: <20241217170553.349153271@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 	UNWIND_HINT_UNDEFINED
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
 


