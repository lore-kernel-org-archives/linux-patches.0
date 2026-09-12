Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6972D5C68;
	Sat, 12 Sep 2026 16:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229234; cv=none; b=K7EF7tTLkYUpXbh8vKUeRQN7gncgqA5Rg7uVH/dLog252jveY+lKb9h5Y2wdQDyQoZLmNhmdOcdc4Ey1LivXOrcnVeQMcjMC6VEdHM9TvfoTBnpQTXLgzpAVKSn7qrW/H6vBvl+gWlv/3B65rfWNanVkSMaOS1ciy8rBF/uoEuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229234; c=relaxed/simple;
	bh=3ATVEt/wg5mm5yNOfdEBWtuvkvIYETnM4w17tkZpPTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WaA2ZafbKhAiR8id7n5m8fDB9NNXMmUFVIq0jooEZRFO16T8Dp5iiO/3gOYy68UviixWls8HQoHTE89PO1aeOB+jHHttZcayU27CS2Xin7mjbxKst9DPdsLl04h/KJZsChqBAdYhnTjuws3IGv90UjncAxVqw6V9PQ2ZdDnYQew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=epD6vzHT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="epD6vzHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C6E1F00893;
	Sat, 12 Sep 2026 16:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229230;
	bh=5jwC/kv2+5CQEOwLWqY/7Phtt/jGZ5y7ayvnfA4TZg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=epD6vzHTh6wtVDC8iECPvDUfrd9dERL0cQCnt24lDxqvM4i2KdHelFvLpLpxnjNpU
	 tPzqKyQu7RmgYMBCr/AtPwjUUtRu7DAQCnrCEI7a87VitkmFph5+KNtj7BpeWuqbS0
	 GgbBK+MvIZ6r9KEWhCtikUQmoN+nFAtxDoCb8rwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>,
	Hanlin Song <pgeorge8929@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0511/1191] csky: Fix a4/a5 restoration in syscall trace path
Date: Sat, 12 Sep 2026 08:53:59 +0200
Message-ID: <20260912065559.727498737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index 547b4cd1b24b4..566205156ace3 100644
--- a/arch/csky/kernel/entry.S
+++ b/arch/csky/kernel/entry.S
@@ -98,11 +98,11 @@ csky_syscall_trace:
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



