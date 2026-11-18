Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028215;
	b=icSphjl0DjgxG3bnPQ7HtMruFPUFGIV9u+huKvexZs0f0NIWYj82nas/wI5iQ26ItOpc
	 nqzYDK1SUGQxdXFc2jBHVZQsBR41krqawwSgFoYMoHWclrTzEVJUSk0/ApC8ELilYh4zD
	 9FbT3GJN2pICniSapMkqTYvSsJCUYV9xf/jQzV4P2ioKN3NhZ+jKm9ZK9hEkUkVyl2baW
	 JbImyvk0ojVgE5fkAbjReG7dIWkpwzBIo/V1Y2OwhEBDoUii0C27MttwMrikE6gpid3Nz
	 Fwf+fNR8ZfIiQ3RptaHyehLodhYoUjewEkGKT+WiyqogMcSZuThgH7MFB3PaeAr1EGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028215;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WNZAO2D25ajgK52Dr3n0rd0UFajApZHk891aXTVVekk=;
	b=GVn62ML3/OjV6sifcWyZclcHd1CYlCQBxdCMDB7wFwj3GjoHxRTCZy+68UU4Lw4mr6c6
	 uO/+ZkQJUkQ4kichP3aj+8pfI218i6Y6aFca4Yujtg2yV9ZBzbH8gZqqxAEyxu87g8kNi
	 osCv7xEUNmp3RLcdNZaR7aenqa6cB44k81yLuFR1HC227mUzLtTder3Qnl36GGWSoEi75
	 X1YLm6Bv01mgqw7zjcZrC/09Bd3DP1lageuzR9160yYyBIhMm63BdefUqdy+kE3f5rSFQ
	 EFQX0VfS3gZEMm/cJzTWXKe6awKY5k6VxlvX66cbIPh5fkpxeIs5QLzOHbaThCVkwww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dnQcGOdr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7796606A31C;
	Wed, 18 Nov 2026 18:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dnQcGOdr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E0D1F000C4;
	Wed, 18 Nov 2026 18:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028215;
	bh=WNZAO2D25ajgK52Dr3n0rd0UFajApZHk891aXTVVekk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dnQcGOdr0zTNe4lkKK/vILT9vy5OxhyAZV2gCoeye6Vy6LeI7qL3sWFkVqmqA57qK
	 0N7x1IhcqNFltoZeRLN/4XTjIRWUtbEJd3mEyXTFSBd/y/uOBOmq0PJSJoAd3g9U3S
	 d1imzzFY4L/WFjUSQipv7CxKmHzZsttRglVPO5iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2066/2151] fork: Let nobody keep a task that may not come to life
Date: Wed, 18 Nov 2026 16:03:21 +0100
Message-ID: <20261118150236.981458761@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e38d2de6c6b52..0c46d69fab6f1 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -917,10 +917,10 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
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
@@ -2378,6 +2378,12 @@ __latent_entropy struct task_struct *copy_process(
 
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



