Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2ED51F893D;
	Tue,  3 Dec 2024 15:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240272; cv=none; b=Tx6SQnDk0Twwk7LS0S2jvw9yuIXegwAOFi52cz/BM6Cho8tvSzdvDQj6f2Uq4tewxwvxWq9CAsUVV4eQGc02QhoLJ8syQGxcf1jJv6CPYcrqCVzLw+RTcPkufbkJF0T4on+VKD2LEBT10kTAkqv/eD1Vp5EJ1cGSIbTSp2t4GeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240272; c=relaxed/simple;
	bh=MB2BBAjxas9KjuctjAh0zhVo92DAlUxkjqbF+kRQ8/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HEsL1NYBwtWinuVhdEDeZ1IlmlrYmnxyV1/SDJVl0mGBcv59x5Og8TZT3wRanHW1Ud0cmzQ2O3Ot/zQHRMNNpi/8J/vFkkXqbpRBkzaEahCpoj+9Dk8E9am8OJlQUCl3NqGHOJJ2KJGBMPBhW3pda+pPOdJmbIDU4Tga5p/zuyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXVFyYxU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXVFyYxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE87C4CECF;
	Tue,  3 Dec 2024 15:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240272;
	bh=MB2BBAjxas9KjuctjAh0zhVo92DAlUxkjqbF+kRQ8/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vXVFyYxULOz497h291bj1NC2qozUSoS/MaKkr+DRd/hTkfBtvONU4huxR8eYZ13o1
	 C42jQMm8zB78bkdtFo0miMQIcEX29k7hZ1j94vZpgbBh4j5bGzYL93KufoByr/0HXV
	 rkEobNF9B433U6yWviIWKTsX3OTVhPNckgvcb9hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yejian <zhengyejian@huaweicloud.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/826] x86/unwind/orc: Fix unwind for newly forked tasks
Date: Tue,  3 Dec 2024 15:36:50 +0100
Message-ID: <20241203144746.960179988@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d00c28aaa5be4..d4705a348a804 100644
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



