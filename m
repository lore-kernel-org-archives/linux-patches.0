Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044F335EDC8;
	Fri,  9 Jan 2026 12:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962733; cv=none; b=TZzfzSr/f6ugGILo5eOMeKiIGNuk7SbS4eH6sKVQdtX5AqZpqSRXrqvJYx6K5Fa7UOO2+l9TwlwdOBydgEcurreAJDQVkVnEQqze7MJxpbt8v4/aUl21XNrbUlLRKrd+eaKUgfvrzNqFI/gVM9quRInCvMc923E7ApzktomD/zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962733; c=relaxed/simple;
	bh=y7qXcGS7D/HhqRgUcNL28fXYTB3OH/mrEAIuGSLHXog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Roc4gCBdmgLncpkaB7CVwhtVyiZbDt5YYGyDjFE8QNwN2KRNnz/IShUDb3CelG9f+5x1vq2TskpkOBI2fgewxupVgD0Zq5XMPEiWvBjVEZAXki88eiFq0TsGWJ69KWNMnh/qQ57SsUsDy0hVXYjCmzVUwZa53/6MKk5MFBxx8uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kSWO/16l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kSWO/16l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86357C16AAE;
	Fri,  9 Jan 2026 12:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962732;
	bh=y7qXcGS7D/HhqRgUcNL28fXYTB3OH/mrEAIuGSLHXog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kSWO/16leVtcep8Ap/khndFm9i9u5xCK5kiviokWAhReblJ9t+I0OKJo4DuqLcYBw
	 /8G22mva4QfaaphXE9CjuWMeetah9QFvCA/sSS54bItsx/XywhChWBwhsrR81qmabK
	 s6Vh69WE4IhR5l5cXVE4/eCBksP4kYrTA1jyttv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@stackframe.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 469/634] parisc: entry: set W bit for !compat tasks in syscall_restore_rfi()
Date: Fri,  9 Jan 2026 12:42:27 +0100
Message-ID: <20260109112135.197933775@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -258,6 +258,8 @@ int main(void)
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
@@ -1824,6 +1824,10 @@ syscall_restore_rfi:
 	extru,= %r19,TIF_BLOCKSTEP_PA_BIT,1,%r0
 	depi	-1,7,1,%r20			   /* T bit */
 
+#ifdef CONFIG_64BIT
+	extru,<> %r19,TIF_32BIT_PA_BIT,1,%r0
+	depi	-1,4,1,%r20			   /* W bit */
+#endif
 	STREG	%r20,TASK_PT_PSW(%r1)
 
 	/* Always store space registers, since sr3 can be changed (e.g. fork) */
@@ -1837,7 +1841,6 @@ syscall_restore_rfi:
 	STREG   %r25,TASK_PT_IASQ0(%r1)
 	STREG   %r25,TASK_PT_IASQ1(%r1)
 
-	/* XXX W bit??? */
 	/* Now if old D bit is clear, it means we didn't save all registers
 	 * on syscall entry, so do that now.  This only happens on TRACEME
 	 * calls, or if someone attached to us while we were on a syscall.


