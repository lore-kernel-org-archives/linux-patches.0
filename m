Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596D11442E8;
	Fri,  6 Dec 2024 14:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496794; cv=none; b=A7URzGfs4d58FLRcNNgWvyGpNH8sskdWFW4+T9Kej9mOjMF7RkvEf9OmBRNcq5qieqDlr2HoC9W/Sq5kqtd7oUh8bjpprASduXqtQfEXuILDzObXRQpk3H5rBAlJUURYGK9jzxmYLQ36/Hq+sCjWVSJ4CXlHkU62BSr7mk9HoLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496794; c=relaxed/simple;
	bh=pySCq+AoARyYNiNEGyxoGuiLocxDudvpQReY/lwXC/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkS3ZA8B1QjteQt812zWYpB1LbcATD4W7Z06amBbIo1p5LdztUGYFvYydg9L8FI7zwNfrz4zfFBrsndV2vitA+8BBfaiVYQjru7qMPKuWoYdWvU8EjATJ+IRc45kTaPb7l9qZVOebZpA5iVg+tQnZI9gVWH9tnK+v0DE5iyKc2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2PNusOha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2PNusOha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2593C4CED1;
	Fri,  6 Dec 2024 14:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496794;
	bh=pySCq+AoARyYNiNEGyxoGuiLocxDudvpQReY/lwXC/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2PNusOhayLb6jNCp7NzAe3uegMXRZg9Dh/AedoeCfm0HVQ/hQbmGmb+WY70zBysZ5
	 FXWbAmAZFYRWoTOKUZT5oKdeAzCP0nMQVKONot5u5WfELyNLSiYXE9P2dTRSRFotyK
	 HCV3jBXYazG+Fxnkf8WkXKcQue0o7O4Y6ssjxFsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yejian <zhengyejian@huaweicloud.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/676] x86/unwind/orc: Fix unwind for newly forked tasks
Date: Fri,  6 Dec 2024 15:28:44 +0100
Message-ID: <20241206143657.459680854@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Zheng Yejian <zhengyejian@huaweicloud.com>

[ Upstream commit 3bf19a0fb690022ec22ce87a5afeb1030cbcb56c ]

When arch_stack_walk_reliable() is called to unwind for newly forked
tasks, the return value is negative which means the call stack is
unreliable. This obviously does not meet expectations.

The root cause is that after commit 3aec4ecb3d1f ("x86: Rewrite
 ret_from_fork() in C"), the 'ret_addr' of newly forked task is changed
to 'ret_from_fork_asm' (see copy_thread()), then at the start of the
unwind, it is incorrectly interprets not as a "signal" one because
'ret_from_fork' is still used to determine the initial "signal" (see
__unwind_start()). Then the address gets incorrectly decremented in the
call to orc_find() (see unwind_next_frame()) and resulting in the
incorrect ORC data.

To fix it, check 'ret_from_fork_asm' rather than 'ret_from_fork' in
__unwind_start().

Fixes: 3aec4ecb3d1f ("x86: Rewrite ret_from_fork() in C")
Signed-off-by: Zheng Yejian <zhengyejian@huaweicloud.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/unwind_orc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 7e574cf3bf8a2..7784076819de5 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -723,7 +723,7 @@ void __unwind_start(struct unwind_state *state, struct task_struct *task,
 		state->sp = task->thread.sp + sizeof(*frame);
 		state->bp = READ_ONCE_NOCHECK(frame->bp);
 		state->ip = READ_ONCE_NOCHECK(frame->ret_addr);
-		state->signal = (void *)state->ip == ret_from_fork;
+		state->signal = (void *)state->ip == ret_from_fork_asm;
 	}
 
 	if (get_stack_info((unsigned long *)state->sp, state->task,
-- 
2.43.0



