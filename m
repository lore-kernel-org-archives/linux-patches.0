Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C813D1CB5;
	Thu, 15 Jan 2026 17:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499690; cv=none; b=HyPvBcBN+3n6TULuKN5C7wup6VhBTN3bmVjMkjDeY9MfuXqoXkZTdNbAzj+OFglWBpT2ztgJnaCGdfjRDtpXND0sWzCxIqmlYWroVcJXJ0c5xeN//qQm50MqaQvYtoDBwQ4gjyp8sOvcmLb4I+VYaMi5qv+3szayARS6DPcR0Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499690; c=relaxed/simple;
	bh=eF2Acnhms8BvdSNUNBdAqEj4M0u2N8uAe6rSFpCC5FA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ra9XUD57pjo83rJ84I2mFcvsfQRDgw/uB1JezQxwspLd2nn1T7JjGsRnchrTlHG9EcW9ItwHGxwgFC65YPbHMO6eapPQNRYUtvHW1qaF2dSq+KWYTf/hsTXZq8iAtEJaNC+urXv4+5GjgkCdRg7jQ9+iyToEnjM2iqFEjqZJjCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qk32/46e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qk32/46e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC8CC116D0;
	Thu, 15 Jan 2026 17:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499689;
	bh=eF2Acnhms8BvdSNUNBdAqEj4M0u2N8uAe6rSFpCC5FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qk32/46e+2KlFRoIdwkHk08P5OvXE20gJ+O+HLtBgJWgZOoJbiJaHNcng+nwFV42W
	 sSTCqL4RX0nRrYX6SyJH30aBOPW/jqmevFdZSJAICNAAlGz1v+n75wcuHIyz/TjR2+
	 Ho51tboJjQDEGVdvBobbn05WsY5C5TAHkZRHJ/1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@stackframe.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 316/451] parisc: entry: set W bit for !compat tasks in syscall_restore_rfi()
Date: Thu, 15 Jan 2026 17:48:37 +0100
Message-ID: <20260115164242.332790793@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Schnelle <svens@stackframe.org>

commit 5fb1d3ce3e74a4530042795e1e065422295f1371 upstream.

When the kernel leaves to userspace via syscall_restore_rfi(), the
W bit is not set in the new PSW. This doesn't cause any problems
because there's no 64 bit userspace for parisc. Simple static binaries
are usually loaded at addresses way below the 32 bit limit so the W bit
doesn't matter.

Fix this by setting the W bit when TIF_32BIT is not set.

Signed-off-by: Sven Schnelle <svens@stackframe.org>
Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/asm-offsets.c |    2 ++
 arch/parisc/kernel/entry.S       |    5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/arch/parisc/kernel/asm-offsets.c
+++ b/arch/parisc/kernel/asm-offsets.c
@@ -262,6 +262,8 @@ int main(void)
 	BLANK();
 	DEFINE(TIF_BLOCKSTEP_PA_BIT, 31-TIF_BLOCKSTEP);
 	DEFINE(TIF_SINGLESTEP_PA_BIT, 31-TIF_SINGLESTEP);
+	DEFINE(TIF_32BIT_PA_BIT, 31-TIF_32BIT);
+
 	BLANK();
 	DEFINE(ASM_PMD_SHIFT, PMD_SHIFT);
 	DEFINE(ASM_PGDIR_SHIFT, PGDIR_SHIFT);
--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -1913,6 +1913,10 @@ syscall_restore_rfi:
 	extru,= %r19,TIF_BLOCKSTEP_PA_BIT,1,%r0
 	depi	-1,7,1,%r20			   /* T bit */
 
+#ifdef CONFIG_64BIT
+	extru,<> %r19,TIF_32BIT_PA_BIT,1,%r0
+	depi	-1,4,1,%r20			   /* W bit */
+#endif
 	STREG	%r20,TASK_PT_PSW(%r1)
 
 	/* Always store space registers, since sr3 can be changed (e.g. fork) */
@@ -1926,7 +1930,6 @@ syscall_restore_rfi:
 	STREG   %r25,TASK_PT_IASQ0(%r1)
 	STREG   %r25,TASK_PT_IASQ1(%r1)
 
-	/* XXX W bit??? */
 	/* Now if old D bit is clear, it means we didn't save all registers
 	 * on syscall entry, so do that now.  This only happens on TRACEME
 	 * calls, or if someone attached to us while we were on a syscall.


