Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE1E38E113;
	Sat, 12 Sep 2026 19:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242334; cv=none; b=ErKN1PXrXgkBlmyUh1TM33gUMPgJpqqJf528Zsb7QhPmNcsFe5imVud5CR+LPRXkvLtzi5nYNLj9xdWrQ358heLW7JqgJeUCCNgOEhXqloqt2xJz7HNZ/2WIhC2ZfuP0Id0j4lUTCRwORBW71UOYSauOCbc7QKggAv6A27sjDf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242334; c=relaxed/simple;
	bh=itVXp/utg7u3k9hbg3cPcrf30IqmXfin0f/fvHRGWqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwielxlUs17aaNchrI8XUzZweg7uyVgJ1zBYcMqWcIsucJ/uuGV/IOiXWNqAg1iJ1RYfxkcL4YTGi6obFOet8L6NVeujMuJtea1PvIW3j03QrGWyKuGtXHqZuneCl7EpmM6QTuILx77D2l6/2uwPAaa8pVS7PL0GP6Z0TUKLjHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ua5bwPE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ua5bwPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1221F000FF;
	Sat, 12 Sep 2026 19:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242333;
	bh=5FZE2Hiu4TEH54f23NArWUg1kKKGq0pMoiNHliaf05U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ua5bwPEoOo1QTHLrNVgpmWTeCz7T6ehU9qdn0ODDCVxxR7UcqZctUeV4xx2ycWjg
	 XlDdHsqZHFDE60VcWGAvt7GpM7wRGpGVzWPQP3rXFDhGDSKcyMnYM6cRkOYdwzwM8x
	 arJNqE6Ja3oz6/XV5S+Xptm2ox0sZ8ZibgkHKeNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>,
	Hanlin Song <pgeorge8929@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 366/798] csky: Fix a4/a5 restoration in syscall trace path
Date: Sat, 12 Sep 2026 08:59:54 +0200
Message-ID: <20260912065525.546457958@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Hanlin Song <pgeorge8929@gmail.com>

[ Upstream commit abb81e5ce7d995baa41556b8125fa59e28ba3be8 ]

The syscall trace path reloads syscall arguments from pt_regs before
calling the syscall handler. On C-SKY ABIv2, the 5th and 6th syscall
arguments are prepared as stack arguments before invoking syscallid.

The current code adjusts sp before loading LSAVE_A4 and LSAVE_A5. Since
those offsets are relative to the original pt_regs base, loading them
after changing sp fetches the wrong slots. As a result, traced syscalls
that use the 5th or 6th argument may receive corrupted arguments.

This is visible with mmap2(), which takes six arguments. A small
PTRACE_SYSCALL reproducer opens a file and maps one page with:

  mmap(NULL, 4096, PROT_READ | PROT_EXEC, MAP_PRIVATE, fd, 0)

Before the fix, the traced child fails the mmap and exits with 12.
After the fix, the mapping succeeds and the child exits with 0.

Fix the trace path by loading a4/a5 from pt_regs before changing sp.

Tested on: ck860f, linux-4.19.15, C-SKY abiv2

Fixes: e0bbb53843b5 ("csky: Fixup abiv2 syscall_trace break a4 & a5")
Suggested-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Hanlin Song <pgeorge8929@gmail.com>
Signed-off-by: Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/csky/kernel/entry.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/csky/kernel/entry.S b/arch/csky/kernel/entry.S
index 5a5cabd076e16..6a9e0d304d2c5 100644
--- a/arch/csky/kernel/entry.S
+++ b/arch/csky/kernel/entry.S
@@ -196,11 +196,11 @@ csky_syscall_trace:
 	ldw	a2, (sp, LSAVE_A2)
 	ldw	a3, (sp, LSAVE_A3)
 #if defined(__CSKYABIV2__)
-	subi	sp, 8
 	ldw	r9, (sp, LSAVE_A4)
+	ldw	r10, (sp, LSAVE_A5)
+	subi	sp, 8
 	stw	r9, (sp, 0x0)
-	ldw	r9, (sp, LSAVE_A5)
-	stw	r9, (sp, 0x4)
+	stw	r10, (sp, 0x4)
 	jsr	syscallid                     /* Do system call */
 	addi	sp, 8
 #else
-- 
2.53.0



