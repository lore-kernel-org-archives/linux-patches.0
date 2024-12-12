Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6A121CFEA;
	Thu, 12 Dec 2024 15:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018005; cv=none; b=K8iDBnsidSOnwV5urht2ELqwZ05YrLp/KcdBQlFkg3jMToRtPF2LO2/b94+fPRXtoVj/wg5mBSTKsaeHm5biUiJNTgR6xiRwdEHzuCMptApbjibpuNh1dZNtVks2WnUUTCFX0KzPsbuHR45fX1zTfTjuEUVtt0uQKJM1AHipze8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018005; c=relaxed/simple;
	bh=0wnz53vN/UgV7QxvEJguY4ERtQOnpivkqC3kfgIGLwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0q1pKZqsPSJmmNGtK1fVWMhD9XqtehIdo2jvyPfjT7YLAXgoXyCKwzfxB9CjoU1PuaVIJtE5U5yJfRfkvahankKOsGomdKxJBO/1N/Jqm1YswcCJ6EGFs99UPENpDSgK3qKQ4WXF7rC4MaqaIGCVH+pQaetHnjLvMVwL7Xv4As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rrki6gPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rrki6gPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69DDC4CED0;
	Thu, 12 Dec 2024 15:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018005;
	bh=0wnz53vN/UgV7QxvEJguY4ERtQOnpivkqC3kfgIGLwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rrki6gPdbeDaQXyd0zISQhLNG93RsOFyIdP3ynfECqoJigVuatUDIoulsPu6EAZuf
	 55kYmopHEcHVTvSJMV5YIJk8KHdVnCy3/7EPWD0fhBsTT2hW2mxzEMPqsIBv+EDH2e
	 rZHFQTvqSfbQBSykdwBXQOZRsvvAIvW/9qu/JbPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.6 171/356] x86/kexec: Restore GDT on return from ::preserve_context kexec
Date: Thu, 12 Dec 2024 15:58:10 +0100
Message-ID: <20241212144251.392375675@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: David Woodhouse <dwmw@amazon.co.uk>

commit 07fa619f2a40c221ea27747a3323cabc59ab25eb upstream.

The restore_processor_state() function explicitly states that "the asm code
that gets us here will have restored a usable GDT". That wasn't true in the
case of returning from a ::preserve_context kexec. Make it so.

Without this, the kernel was depending on the called function to reload a
GDT which is appropriate for the kernel before returning.

Test program:

 #include <unistd.h>
 #include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <linux/kexec.h>
 #include <linux/reboot.h>
 #include <sys/reboot.h>
 #include <sys/syscall.h>

 int main (void)
 {
        struct kexec_segment segment = {};
	unsigned char purgatory[] = {
		0x66, 0xba, 0xf8, 0x03,	// mov $0x3f8, %dx
		0xb0, 0x42,		// mov $0x42, %al
		0xee,			// outb %al, (%dx)
		0xc3,			// ret
	};
	int ret;

	segment.buf = &purgatory;
	segment.bufsz = sizeof(purgatory);
	segment.mem = (void *)0x400000;
	segment.memsz = 0x1000;
	ret = syscall(__NR_kexec_load, 0x400000, 1, &segment, KEXEC_PRESERVE_CONTEXT);
	if (ret) {
		perror("kexec_load");
		exit(1);
	}

	ret = syscall(__NR_reboot, LINUX_REBOOT_MAGIC1, LINUX_REBOOT_MAGIC2, LINUX_REBOOT_CMD_KEXEC);
	if (ret) {
		perror("kexec reboot");
		exit(1);
	}
	printf("Success\n");
	return 0;
 }

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20241205153343.3275139-2-dwmw2@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/relocate_kernel_64.S |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -240,6 +240,13 @@ SYM_CODE_START_LOCAL_NOALIGN(virtual_map
 	movq	CR0(%r8), %r8
 	movq	%rax, %cr3
 	movq	%r8, %cr0
+
+#ifdef CONFIG_KEXEC_JUMP
+	/* Saved in save_processor_state. */
+	movq    $saved_context, %rax
+	lgdt    saved_context_gdt_desc(%rax)
+#endif
+
 	movq	%rbp, %rax
 
 	popf


