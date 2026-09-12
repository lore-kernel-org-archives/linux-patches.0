Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C383AEF51;
	Sat, 12 Sep 2026 12:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214751; cv=none; b=BIMggqLNNjw4Wr9DNlcJ0+b10+Hjlz7W4GkQcqAL/RCVuKRnWKEzWkMUMelTLe0SkYmTjQ5mNig3Rl/bAXLYUNAHEHgClJJCD1Mw9i7hxoIJk8WHkMprOaQnze88aOhZ52aRSVeGAIuA845pw04ZV8tLUWRoBltl4ej0jjh7tAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214751; c=relaxed/simple;
	bh=XuxDYDj/abeTesN5j9K+DTR1kWvXyd1wOn+NP4PyADE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHgzaLlY3GrGarTN9dQApwEjaxH+lGd2jUf89gw3HmNuPdvEpBlo5GDmX+KsT0L9mtUdYnOmu4GB4hBIS6xWMkNXDmyb6E5Ijxkido9rJN0ZNpltnv+u83oRP912eZ7eSQ4B+n4cDjvXJvQLQ25QJ1NKaJpIvRhGvjNb7AUKO5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fkflaXhe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fkflaXhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68871F000FF;
	Sat, 12 Sep 2026 12:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214749;
	bh=XagaLFhLYUvN53ZEB4s+fSIsMliz1CUn9WMJg+BgBpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fkflaXhemsIY8u+6pYLwkMIqhh/y7EYJFjc1mCY9UZmiw2pwC+f3+lHwmihlouARE
	 b3X52CLBPP6JCPdKD4ntS9d8A7ztgKF5Q9gk3wxrlFdrh8bpp1WWp3Vi/NOnZb3zrr
	 rLPGY80k7Y6Zi40meZnw10T7QHqNDmpRmXel61Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>,
	Hanlin Song <pgeorge8929@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0391/1376] csky: Fix a4/a5 restoration in syscall trace path
Date: Sat, 12 Sep 2026 08:46:57 +0200
Message-ID: <20260912065616.260525467@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c68cdcc76d60e..3261f46f22442 100644
--- a/arch/csky/kernel/entry.S
+++ b/arch/csky/kernel/entry.S
@@ -93,11 +93,11 @@ csky_syscall_trace:
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



