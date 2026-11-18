Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022196;
	b=qAOmIhdse+k0Wem5X1C6XdlMcylqiyujFtBiTRK/exKXpdvysgCQcteWBNqTYp0NbQO3
	 ppAPxGPjnRN3VY4a5D3mnEV6pRYl0TuDO9kjDD02ebB/esYuakGQo1UUTLxsWdkEz0zox
	 iJcDWe5db8Rnd5GR8gtrEDp8JZkChQOP/2jhAzcqMl3QInmiyXOOO97z2JlWbYibg6tl8
	 UQgtrhMPgnXhXAZsAzKLsM/0tioLnX2+Mj8v/k+RXEw+vEyg7JPNlr4qytg/FWES/na3H
	 GD/3dSzTjF+Y9gElXZ/h6n4G9vF5g+76LMI09s9zzckDud/3SdPCUnbTzGRSKP+wVDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XAPndJCNiFr1so/2PC02lQgiDXp8nwm4chhEJojPtuY=;
	b=vxM2W/5iYYr8PC3EeFLcKPM32NcH6E6UTjdMHaTyJjBixu0pkq75vRanU9CjWHFlbHO3
	 OfMkMYlR2u1t+H0G3uF4oR3S9O2JcKJbrqGtIf9osBtv3QxGWSGOCtlKSqLoyXwrX9yHS
	 JKaEG0XtTTUrBS9LyeB9B1nz/8Wfa+8f7zc3aVV7eShQBTGlMuGpIjFS5kgyXsrmwcGcR
	 Dc8a9bp/ENaqmc8XEN5DNd09KtSqceHtBo6rbX5wWmiy+mEOIGSlXFBVp4ixFTslpXT9R
	 vJe1PdiXrEsxwsIUt9C4yFELrYeu9ksceatD9NdYLr+qmgWeQbByB/QAI3TCHrz06og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DI5+Rb+r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB2C606A31C;
	Wed, 18 Nov 2026 17:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DI5+Rb+r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752F31F000C4;
	Wed, 18 Nov 2026 17:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022196;
	bh=XAPndJCNiFr1so/2PC02lQgiDXp8nwm4chhEJojPtuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DI5+Rb+rv7XlET2YNm12FvjlvlE7OKgAjnhjJf6MlOSH+WpE52M8/OZC8G6BZn3yX
	 Qr80htzEBH03vCLOphhs4u+kOGY36XX7COC8mQywWpvmxnmfaKoNDbhvM4aocFGolf
	 ODvO/fUYN4dgKoxfT7XTdYo8e0+4EBrxFhvq09ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2574/2651] fork: Let nobody keep a task that may not come to life
Date: Wed, 18 Nov 2026 16:03:34 +0100
Message-ID: <20261118150417.027854199@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 48d7ca0644042..ddd3dbc0850b7 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -971,10 +971,10 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
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
@@ -2522,6 +2522,12 @@ __latent_entropy struct task_struct *copy_process(
 
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



