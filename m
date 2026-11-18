Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033155;
	b=fgG6grFZT2y3EUgAzSWYwTvj5xD2FFjQpLOTz1cqX1ecsX2HBNtvBEfzjIhpgMkaPszb
	 zcyZQrETgR1u9JKStI/xA31ZP2F4Q371rHLpOprq/VCbNgSB9z8l1IAh9PK05ld7tihkh
	 ThnIPrRH2o7Ykp+vD9Eu05RB0Yp+GiPcej/4wiHhCQz/ScJ+pwjKHzLCEtKx9vgovfp6b
	 vkLWsl5GkdZhOzFBlOsV8oR8d4/SdexeRA5waMEucYtjiBam8k8NmOAcYEMO2P2KGZofI
	 WcZh6yBnjExykEeKQ+Xyb96gJVEzX77ebZ7yWundwJETVrwLS1ht7GcO1z2/4RD363g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hUugiSjmVccuk8SEKvqtwDiA5MZ9wCJQxOXlfsuwRSQ=;
	b=X6T3oCz3lAQEqKHXTyMAUXWWA0eBp4CAffOyqhNEapUX7wV9fJXZa4kvVQgZhV72wczh
	 ns3e8H8Ou9em6e+oUWrbx9XDmbWQGzcU1Df8odEcCkEKTrH/dqZNSpBOyTyk4yaHt5TxY
	 mBH8J2h8dCKRpYbsggCTVA1HBWE7nwDWMLpGhDcb0di69s90KQCHJcsET1qViUwKHBkBp
	 h+nhrm4FdiYiX4R49s+F3zQLQrZh8iDkHtKm33kZ5eQ0lk/SqNJgvEJFi42c7HefiQu4O
	 dW9Uk3H75ePsCZqJJVtONgwxDNBaG/CO2uMutZ6xfvoLEJngu2jkeN10SiSRizV/txQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K8fK6a3s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B41606A31C;
	Wed, 18 Nov 2026 20:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K8fK6a3s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785661F000C9;
	Wed, 18 Nov 2026 20:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033155;
	bh=hUugiSjmVccuk8SEKvqtwDiA5MZ9wCJQxOXlfsuwRSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K8fK6a3stBFerxyoq2qAZj25MxrV19gHSfdulXF/0PMhT/3RW3X61DVLsllF55hyj
	 jYgulQoNRoWDSjuotsr8eE3ZmCTACxg0mIIc/FKan5tuymQl2DS0e3HBzETEMPrmc7
	 SyW6MblMiJg7ajMYwM237V/xLSmLK4TQxi/GIxMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1667/1756] fork: Let nobody keep a task that may not come to life
Date: Wed, 18 Nov 2026 16:03:14 +0100
Message-ID: <20261118150116.072285175@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f3ba045debeda..1f1bb6e341f07 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1162,10 +1162,10 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
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
@@ -2584,6 +2584,12 @@ __latent_entropy struct task_struct *copy_process(
 
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



