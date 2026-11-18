Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036860;
	b=2pWrd5c0QvDLFkvmyi/XcoAEXsnL8rB1l1YyBU3f5+d2vB2O71Ogh70zmXwLMtnYgRKq
	 K7bJSmDKh65JgvsF+QLRQSmG0yTPXIYC0zBSESJO7rhLp5DIByY7RyTfEwwcBgNrSw4xn
	 /PSD1Haxd6Dj2pgHxfXVSm13Pl2LY9CyruyKw8aXfOq4Dhklb6CVzSMWrHyRbrgAiIwWl
	 E/lA46Ste8QW9Kuo+FvNMLwLk8sDyPpFHUn1YTA6Gdbu4k9oiPT65QpqmPZcYYfj7ePtj
	 bz8Jf1hKt3E86uQxEV8pYu6rLkrXmEJxzJ77aoreApWBWbj6pNbRu5cEE5+t5/gWj0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kcnesHdBZlvOWPbWqjPOBaUVOYNHKlEqo0v+VsuzDg4=;
	b=hnSqG+03R2Eu/fDA4n6RWrBm3WAcMA1F3gN1sUbfy+kxmuVe3duyx+6rCqyAVmDzg18E
	 C+lQ8cbBB0wRaX+gvRUJITRTtB6+8K3mU7e5sWM65fzWUUekUYjwlB5cGKkZNcqsY01Pq
	 eCPL6jCZQLNLygDD6e7I+eh+AA501YLC/hnvbtlHKjum1ICiLgumnZfHfkzPl1oBEzI9+
	 oGHLrdDKshivfhPymdDDyLauo9SNUCcCZIJQWW4CJV7qaEu7fOByCigm+8w4C0l29zWjN
	 th8YigH26ThkXduWMbabrw2DeidrXspfayDg48LQOLLFMZ4MyqveclRdDX8IgMIg8Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gpB7Bw/z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7475D606A31C;
	Wed, 18 Nov 2026 21:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gpB7Bw/z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93471F000C4;
	Wed, 18 Nov 2026 21:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036860;
	bh=kcnesHdBZlvOWPbWqjPOBaUVOYNHKlEqo0v+VsuzDg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gpB7Bw/zQuLHNlYGCpYCMCcQBI6cCR2hyD7mtja8+HmIA7ta82/TDpjrFAOBT+EbX
	 qlDu5VjhHFy26bPUgBDBKyv1DaMVRjY6OiLCk9cb8rg/Ii92Ic9aBKglLsiGW/2Yj7
	 BvmiYWhob+C1XHxGnuUKoFymns3Sv2XeIeaFtO4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.6 1210/3318] cgroup: dont kill migrated processes through their exiting threads
Date: Wed, 18 Nov 2026 15:30:32 +0100
Message-ID: <20261118150356.469961307@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit 5f4a3f743acc96987ae5c2e966947942c34ba56c ]

Since commit da13e0e72a73 ("cgroup: fix cgroup.kill for exited thread
group leader"), __cgroup_kill() visits every thread in the cgroup and
sends SIGKILL with PIDTYPE_TGID, so each visited thread takes down its
whole thread group.

A thread that has started exiting can stay in a cgroup after its process
has been moved out of it. cgroup_migrate_add_task() skips PF_EXITING
tasks, and the thread is only unlinked by cgroup_task_dead() after its
final context switch. mm_release() clears the thread's clear_child_tid
word and wakes the joiner well before that, so pthread_join() can return
while the thread is still in the old cgroup.

If cgroup.kill is written in that window, __cgroup_kill() finds the
exiting thread and complete_signal() passes the group-wide SIGKILL on to
a live thread, killing a process that already left the cgroup. The cgroup
selftest test_stress.sh runs into this: test_cgcore_proc_migration()
joins its threads, moves itself back to the root cgroup, and cg_destroy()
falls back to cgroup.kill on the old cgroup when rmdir() fails with
EBUSY, so test_core kills itself. KernelCI has been reporting
"with_stress.sh: line 94: ... Killed" on several arm64 boards since the
commit reached linux-next.

Keep visiting every thread, but go back to sending SIGKILL to the thread
that was found. A SIGKILL sent to a live thread still kills its whole
thread group, so both cases fixed by that commit stay fixed, and
task_can_queue_signal() drops one sent to a thread that is already
exiting.

Fixes: da13e0e72a73 ("cgroup: fix cgroup.kill for exited thread group leader")
Cc: stable@vger.kernel.org # v5.14+
Link: https://lore.kernel.org/all/179272264722.329188.4773475583351189022@6e52bff8000c/
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index ce51a032e7e0c..637eefb081892 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3986,7 +3986,7 @@ static void __cgroup_kill(struct cgroup *cgrp)
 		if (__fatal_signal_pending(task))
 			continue;
 
-		do_send_sig_info(SIGKILL, SEND_SIG_NOINFO, task, PIDTYPE_TGID);
+		send_sig(SIGKILL, task, 0);
 	}
 	css_task_iter_end(&it);
 }
-- 
2.53.0



