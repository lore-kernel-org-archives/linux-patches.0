Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8232C0270;
	Thu, 15 Jan 2026 17:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498411; cv=none; b=TKUEL8mYVKkQkyZGBZqwre0FJZ0d6rTMbK8LE7Kel/5p3KNfDBRlD1TuL2lLJFuTst7j5spz6Yh71wjiHenBdb7hQtK3bd2RC/m6nhVIF/i3ZmpFQ1EICraqlMwXGG45WfK6JNF5B8GF8ZjyGHovVGJgItPlx4vJVfRuDgSS8LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498411; c=relaxed/simple;
	bh=rnDdDxrNiD0EdkOEpDZHD4JIZT4v1jqMamisH94hGag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ARNblq4Y4lycbhbzGQSsliLYnYlWo8ien9azNJeYBuehcXy3slkiPUEXjB4mQAvLIi05eym6oImTA/48Dj/TnIKWI3Xz9EIP0C7hEqHfzKZN2rEtpjgIRTpr5/QlELDzHiW3V4mwKctl/YWhuDp0n9vo2c5VAbHfIQb9sygKYg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nSK2Z09+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nSK2Z09+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF666C19422;
	Thu, 15 Jan 2026 17:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498411;
	bh=rnDdDxrNiD0EdkOEpDZHD4JIZT4v1jqMamisH94hGag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nSK2Z09+QFOQd4fsXEf9WcPbDA+ZjkMLslwT2X3oirgF2a6xuvWdazs1aSpGxon5G
	 a5owVWVIx9fEogH1WkJHI6MW9gj5wHnb9awsVqOVpDp0U2pikMwneJ3eyVAbWmri68
	 3rwfUGN9bLXB4oNuva4uoD9QXq2Dg1odIJXE5D7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@stackframe.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 389/554] parisc: entry: set W bit for !compat tasks in syscall_restore_rfi()
Date: Thu, 15 Jan 2026 17:47:35 +0100
Message-ID: <20260115164300.318376735@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -260,6 +260,8 @@ int main(void)
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


