Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA69B46D2CA;
	Tue, 21 Jul 2026 18:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658239; cv=none; b=lptgnzO202CgBhJQXge6auqpraiB8y7WajcJaAkujCF1G2wUrAAPKRDfg+tcLeskiPbH2LX8BdBOtvf3M2aFcZsJi/IL7263rv2vFtcjr57FEFKzkzudhvCVGcg7wRX3aWM67aayq5mJ2r0JJLS823gBoJqjm9diAt7v67At5sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658239; c=relaxed/simple;
	bh=uwH6J7aJMWqRTgGAbQGQfuGoqs5CXCJm6/ryV7FHpLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/bC4wY2wSWDbeWMSg7ewP7RvItM1Eua8TDaB31Op2KwDaA7rxMvihHdSz+f9saDmeKE3eVdm6eSy2LM9owAPGgTazR9mt+J8R5ajhxmAfiY4FEaY0ISoZii+c3p6h3fq8WsfezlndMrs+7g1b4rH+2OlkAnU488McjgSNWOrIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sjEvbQCA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sjEvbQCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F39A1F000E9;
	Tue, 21 Jul 2026 18:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658237;
	bh=oTb8nTngVVUyXGIt+365gRlF0t/c1LGUARnSsW8gOeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sjEvbQCAjSOsEVioRQKQ+NOo4BjB6xnbbxdOP0rEUJ5OR/CMTEx71NwUm45sEJxyW
	 oYcChFzbrFElob65C2zR4GS9fKivZbRqAr5E+J320ii3t0UMZN/Tio+hPgRIyOwRin
	 n1y2R4RRTXF7UQF2KDvQ/BF1WvIIiqoKqDK69FOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+61ce80689253f42e6d80@syzkaller.appspotmail.com,
	Jiri Olsa <jolsa@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1025/1611] uprobes/x86: Use proper mm_struct in __in_uprobe_trampoline
Date: Tue, 21 Jul 2026 17:19:01 +0200
Message-ID: <20260721152538.446674881@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 169328645663bae30e9abad4012d52441e085a71 ]

In the unregister path we use __in_uprobe_trampoline check with
current->mm for the VMA lookup, which is wrong, because we are
in the tracer context, not the traced process.

Add mm_struct pointer argument to __in_uprobe_trampoline and
changing related callers to pass proper mm_struct pointer.

Fixes: ba2bfc97b462 ("uprobes/x86: Add support to optimize uprobes")
Reported-by: syzbot+61ce80689253f42e6d80@syzkaller.appspotmail.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Tested-by: syzbot+61ce80689253f42e6d80@syzkaller.appspotmail.com
Link: https://patch.msgid.link/20260701111337.53943-2-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/uprobes.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 852d54b2e41372..ae347e3837851e 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -761,9 +761,9 @@ void arch_uprobe_clear_state(struct mm_struct *mm)
 		destroy_uprobe_trampoline(tramp);
 }
 
-static bool __in_uprobe_trampoline(unsigned long ip)
+static bool __in_uprobe_trampoline(struct mm_struct *mm, unsigned long ip)
 {
-	struct vm_area_struct *vma = vma_lookup(current->mm, ip);
+	struct vm_area_struct *vma = vma_lookup(mm, ip);
 
 	return vma && vma_is_special_mapping(vma, &tramp_mapping);
 }
@@ -776,14 +776,14 @@ static bool in_uprobe_trampoline(unsigned long ip)
 
 	rcu_read_lock();
 	if (mmap_lock_speculate_try_begin(mm, &seq)) {
-		found = __in_uprobe_trampoline(ip);
+		found = __in_uprobe_trampoline(mm, ip);
 		retry = mmap_lock_speculate_retry(mm, seq);
 	}
 	rcu_read_unlock();
 
 	if (retry) {
 		mmap_read_lock(mm);
-		found = __in_uprobe_trampoline(ip);
+		found = __in_uprobe_trampoline(mm, ip);
 		mmap_read_unlock(mm);
 	}
 	return found;
@@ -1044,7 +1044,7 @@ static int copy_from_vaddr(struct mm_struct *mm, unsigned long vaddr, void *dst,
 	return 0;
 }
 
-static bool __is_optimized(uprobe_opcode_t *insn, unsigned long vaddr)
+static bool __is_optimized(struct mm_struct *mm, uprobe_opcode_t *insn, unsigned long vaddr)
 {
 	struct __packed __arch_relative_insn {
 		u8 op;
@@ -1053,7 +1053,7 @@ static bool __is_optimized(uprobe_opcode_t *insn, unsigned long vaddr)
 
 	if (!is_call_insn(insn))
 		return false;
-	return __in_uprobe_trampoline(vaddr + 5 + call->raddr);
+	return __in_uprobe_trampoline(mm, vaddr + 5 + call->raddr);
 }
 
 static int is_optimized(struct mm_struct *mm, unsigned long vaddr)
@@ -1064,7 +1064,7 @@ static int is_optimized(struct mm_struct *mm, unsigned long vaddr)
 	err = copy_from_vaddr(mm, vaddr, &insn, 5);
 	if (err)
 		return err;
-	return __is_optimized((uprobe_opcode_t *)&insn, vaddr);
+	return __is_optimized(mm, (uprobe_opcode_t *)&insn, vaddr);
 }
 
 static bool should_optimize(struct arch_uprobe *auprobe)
-- 
2.53.0



