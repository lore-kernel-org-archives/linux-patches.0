Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3943612D7;
	Tue, 20 Feb 2024 21:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463978; cv=none; b=YRcC7q7h2LRBpi5tSM/dr7NVqYiIK8XbubqsBMg5hM2eRPhB+1Z7asBZXtrwnoWGfjISkED8T/VvUpfc65AB8gddcFbhZfy3fJ6XbHY6qKVkB43cDLSJ+PRkDejnUIc5t+Pb00GAPXfEXqKlxe5AkCeZshabwFdja2SbbkXF+MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463978; c=relaxed/simple;
	bh=V/v1L8Kq0xqUd3ANdG1fNESxeQnX9cVCfmIokliek5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQwK9jC+kQqXXaRsLaTXYW/N7iIu+0X7Yj5+SV4xZ/vFyuq9tMEITm16YrrAZm74QoKLVup1ejgIyeA95Ml21eLLGFbRXLZt2XbobkYKuNZJfFfrUulDgnRzIjry2X0q9uvASy+KBty0ugiK7TymInimMCP27iFB9/K5GhmLjn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1EtDjMhp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1EtDjMhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A71C433C7;
	Tue, 20 Feb 2024 21:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463978;
	bh=V/v1L8Kq0xqUd3ANdG1fNESxeQnX9cVCfmIokliek5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1EtDjMhpfQwDcAifc+P8nlzarTn3Igrsr6gJkRFwqR95wfXmxdqZZjYZwzj6ggzSn
	 FH6UGsAXzO2tlBmTzHE+AlSFFKidL09jPWGlgmHb26UYl1gi/N8CnkiLGYruu3lZ1/
	 o8MdzkTPDv81Oy2P1RemVw8tGyaXHmorArDnFPtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nysal Jan K.A" <nysal@linux.ibm.com>,
	Naveen N Rao <naveen@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.6 184/331] powerpc/64: Set task pt_regs->link to the LR value on scv entry
Date: Tue, 20 Feb 2024 21:55:00 +0100
Message-ID: <20240220205643.327169877@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naveen N Rao <naveen@kernel.org>

commit aad98efd0b121f63a2e1c221dcb4d4850128c697 upstream.

Nysal reported that userspace backtraces are missing in offcputime bcc
tool. As an example:
    $ sudo ./bcc/tools/offcputime.py -uU
    Tracing off-CPU time (us) of user threads by user stack... Hit Ctrl-C to end.

    ^C
	write
	-                python (9107)
	    8

	write
	-                sudo (9105)
	    9

	mmap
	-                python (9107)
	    16

	clock_nanosleep
	-                multipathd (697)
	    3001604

The offcputime bcc tool attaches a bpf program to a kprobe on
finish_task_switch(), which is usually hit on a syscall from userspace.
With the switch to system call vectored, we started setting
pt_regs->link to zero. This is because system call vectored behaves like
a function call with LR pointing to the system call return address, and
with no modification to SRR0/SRR1. The LR value does indicate our next
instruction, so it is being saved as pt_regs->nip, and pt_regs->link is
being set to zero. This is not a problem by itself, but BPF uses perf
callchain infrastructure for capturing stack traces, and that stores LR
as the second entry in the stack trace. perf has code to cope with the
second entry being zero, and skips over it. However, generic userspace
unwinders assume that a zero entry indicates end of the stack trace,
resulting in a truncated userspace stack trace.

Rather than fixing all userspace unwinders to ignore/skip past the
second entry, store the real LR value in pt_regs->link so that there
continues to be a valid, though duplicate entry in the stack trace.

With this change:
    $ sudo ./bcc/tools/offcputime.py -uU
    Tracing off-CPU time (us) of user threads by user stack... Hit Ctrl-C to end.

    ^C
	write
	write
	[unknown]
	[unknown]
	[unknown]
	[unknown]
	[unknown]
	PyObject_VectorcallMethod
	[unknown]
	[unknown]
	PyObject_CallOneArg
	PyFile_WriteObject
	PyFile_WriteString
	[unknown]
	[unknown]
	PyObject_Vectorcall
	_PyEval_EvalFrameDefault
	PyEval_EvalCode
	[unknown]
	[unknown]
	[unknown]
	_PyRun_SimpleFileObject
	_PyRun_AnyFileObject
	Py_RunMain
	[unknown]
	Py_BytesMain
	[unknown]
	__libc_start_main
	-                python (1293)
	    7

	write
	write
	[unknown]
	sudo_ev_loop_v1
	sudo_ev_dispatch_v1
	[unknown]
	[unknown]
	[unknown]
	[unknown]
	__libc_start_main
	-                sudo (1291)
	    7

	syscall
	syscall
	bpf_open_perf_buffer_opts
	[unknown]
	[unknown]
	[unknown]
	[unknown]
	_PyObject_MakeTpCall
	PyObject_Vectorcall
	_PyEval_EvalFrameDefault
	PyEval_EvalCode
	[unknown]
	[unknown]
	[unknown]
	_PyRun_SimpleFileObject
	_PyRun_AnyFileObject
	Py_RunMain
	[unknown]
	Py_BytesMain
	[unknown]
	__libc_start_main
	-                python (1293)
	    11

	clock_nanosleep
	clock_nanosleep
	nanosleep
	sleep
	[unknown]
	[unknown]
	__clone
	-                multipathd (698)
	    3001661

Fixes: 7fa95f9adaee ("powerpc/64s: system call support for scv/rfscv instructions")
Cc: stable@vger.kernel.org
Reported-by: "Nysal Jan K.A" <nysal@linux.ibm.com>
Signed-off-by: Naveen N Rao <naveen@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240202154316.395276-1-naveen@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/interrupt_64.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/interrupt_64.S
+++ b/arch/powerpc/kernel/interrupt_64.S
@@ -52,7 +52,8 @@ _ASM_NOKPROBE_SYMBOL(system_call_vectore
 	mr	r10,r1
 	ld	r1,PACAKSAVE(r13)
 	std	r10,0(r1)
-	std	r11,_NIP(r1)
+	std	r11,_LINK(r1)
+	std	r11,_NIP(r1)	/* Saved LR is also the next instruction */
 	std	r12,_MSR(r1)
 	std	r0,GPR0(r1)
 	std	r10,GPR1(r1)
@@ -70,7 +71,6 @@ _ASM_NOKPROBE_SYMBOL(system_call_vectore
 	std	r9,GPR13(r1)
 	SAVE_NVGPRS(r1)
 	std	r11,_XER(r1)
-	std	r11,_LINK(r1)
 	std	r11,_CTR(r1)
 
 	li	r11,\trapnr


