Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042774;
	b=KTVbOhcG5V2sPv16P/Lo9BtbiCPuzFNl8h/c7F4R7e6VvQXFTKWAjYNqsEk5eYIisxXd
	 mxAE9mIMgmcXk7zGdx43ePxMy3Tday3z0OGWH3v3wdEFxCe32zN9xUDtR838TM+dE7qc1
	 w4PLdHAqVuvjX1yyV9T2zSSbcSK8VQQgtamI2TQtylAfjLjNEhNByh5qUYE1na1u9Nbny
	 Ua7XhE5cJlLD/K6ME1IysvXfyRoLRIaavhSGl9kxVrc0JCGv3Po226kr9v9wnoJ1iJVr1
	 v9tYB8Y/J5vCqbDnMPBPdc3lPpHrEnzibuJZSCRhAs2Oc2TUFafNiiTOsN+BWijL2FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sdPcccgKqJW8z4xpWxhgRgJ9ojGOnN3Z2nH2xKjwRqo=;
	b=EexLTB41vw0eKmrGJPp9YW9E833G6rASsRIzjXpWNmUaC9X8Gxh+dxAzAxBDH5/P2yJN
	 9sIsuOYmHZQtwOHjU4Z85fiSODXIljOaBW/L78nEoqRpebppXOrWDecws1WyyBfBb9njY
	 r67L+hRtcZgxqfr/fkZTjtUlM944zXrIfzjtXNMeuuRknAF9v8jKoUXHGkhNWuhMYmCG3
	 Oi05dvSLu6SEH72aGxGpnUIbP9LdeyXkzd4m+zivvlbqKMBGSJPEiGp8kVU6fDgZBPTaF
	 zuFK5Cal08KuofWKzlpcQSqauMb0T6zAuuvEdH2dT0kU2PHuWxsSNbk+sxbKMGrdaRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k45VLXl0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BCD606A325;
	Wed, 18 Nov 2026 22:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k45VLXl0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525121F000C5;
	Wed, 18 Nov 2026 22:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042773;
	bh=sdPcccgKqJW8z4xpWxhgRgJ9ojGOnN3Z2nH2xKjwRqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k45VLXl0Dit1uB6u/s5IoGJixEF9LOot2z4jUmr+sYFp/ekDUKNnd50nAwFsO/k0H
	 0L9+XAOBukuEvbqTLI9rHFYwDCGvFUyv4t4bemhrQBaRgBhLU2uQk1narTIRKbwFX8
	 rwTrS2l3wHUwFS8zqJc0z8KnTdbek2ryYjCcIxjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3250/3318] fork: Let nobody keep a task that may not come to life
Date: Wed, 18 Nov 2026 16:04:32 +0100
Message-ID: <20261118150457.146713436@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 5cf0881344cfa0a3b558107741884d8f43269d7b ]

dup_task_struct() sets rcu_users to 2.  From then on bpf_task_acquire()
hands out references to the new task, which BPF programs see as a trusted
pointer long before it is sure to live: in the task_alloc LSM hook and in
ops.init_task() of sched_ext.

If copy_process() fails later on, it undoes what it has done and frees
the task without a look at the count.  A program that has stored its
reference in a map is left with a pointer to freed memory:

  BUG: KASAN: slab-use-after-free in put_task_struct_rcu_user+0x22/0x90

The program is loaded by the administrator, but any user can make a fork
fail, for example at the pids.max of a cgroup.

Honouring the count would not do: the task would stay behind with its mm,
files and credentials freed.  Leave rcu_users at zero until copy_process()
cannot fail any more.  bpf_task_acquire() returns NULL until then, which
its callers have to be prepared for, and which they get for init_task,
whose count has always been zero.  The other users of rcu_users deal with
tasks that have run.

Fixes: 90660309b0c7 ("bpf: Add kfuncs for storing struct task_struct * as a kptr")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fork.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 625f9bd101dbb..6bf25ee0fcb78 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1150,10 +1150,10 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 	dup_user_cpus_ptr(tsk, orig, node);
 
 	/*
-	 * One for the user space visible state that goes away when reaped.
-	 * One for the scheduler.
+	 * Nobody can keep the task while copy_process() may still fail, which
+	 * frees it no matter what.
 	 */
-	refcount_set(&tsk->rcu_users, 2);
+	refcount_set(&tsk->rcu_users, 0);
 	/* One for the rcu users */
 	refcount_set(&tsk->usage, 1);
 #ifdef CONFIG_BLK_DEV_IO_TRACE
@@ -2677,6 +2677,12 @@ __latent_entropy struct task_struct *copy_process(
 
 	/* No more failure paths after this point. */
 
+	/*
+	 * One for the user space visible state that goes away when reaped.
+	 * One for the scheduler.
+	 */
+	refcount_set(&p->rcu_users, 2);
+
 	/*
 	 * Copy seccomp details explicitly here, in case they were changed
 	 * before holding sighand lock.
-- 
2.53.0



