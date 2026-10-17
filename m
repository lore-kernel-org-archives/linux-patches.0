Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD743391E51;
	Sat, 17 Oct 2026 16:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255978; cv=none; b=eS9oTiPdSQsJMwKxY/chx2lyy/qFLEHBNMU2BPHHtFqDZQsVQeTjjTWIOT9aU9eM70kYjdcMXcNScgyDocd+WlR3h39CujIBfEdpAkjOsJHiVZRk7JC5NRwznmP5TFl+MAn6nRj4NFKKxE0ojDrD1FMA/O+FUlzoM+4uGWX6hmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255978; c=relaxed/simple;
	bh=DWEqpdiAPVsiHdcfMlu6sr4ZwP/5g3UW9v+1pNz4HrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8COhBuGPo2lxLVNSzZD0Nw9mEnydjrszb5XUq5CXhNT3fIUOK6AYl7N2US4BlhON7blV17zNZP3havR1on/rXcWCXzEUUqZWCdq4sezt64B2XUYYkXOcNeTjeEhv5aSKOWPn22vb+8nYqenF2JcjIJcyx32vpUVE+6JCVpzc5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZf6Q4sz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZf6Q4sz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CAE1F000C4;
	Sat, 17 Oct 2026 16:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255977;
	bh=FDsQFiaH+zJvGi9XeMHVinTemXrddDlQ/D+SUSSQFb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QZf6Q4szAs3gJEa6DC5NSNe3sVFb55S5Ca7YvRfM679P8zAL/lKst6RUCg+e4OXMT
	 B8HEmcrgEX+ssSQt+5o34oY6E+RMAMn3prJUsvQj0OH5btZnXogkx3SPrr3H+Rv80y
	 r3fA0VrE91QO9wGOJENHVpHw2UkyeawMt3gefdAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0085/1674] ftrace: Synchronize the initialization of ftrace_ops
Date: Sat, 17 Oct 2026 17:39:17 +0200
Message-ID: <20261017160433.316670339@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 4617721c502b2ddaa4e324e86da4997edf738fa5 ]

There's some internal state that ftrace_ops needs to have set, but since
it can be declared outside of the ftrace.c code, it calls
ftrace_ops_init() on the ops in every global function. The issue is that
if two tasks call it on the same ops at the same time it is possible to
have the initialization of one corrupt the initialization of the other
call.

Create a ops_mutex to use to synchronize every initialization of the
ftrace_ops. The mutex is taken within checking the ftrace_ops flag that
states it was initializied but the flag is checked again after the mutex
has been taken. Checking first outside the mutex allows it to shortcut
having to take the mutex. But then the check needs to be done again after
the mute is taken in case of races.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260902095501.6b59af20@gandalf.local.home
Fixes: f04f24fb7e48d ("ftrace, kprobes: Fix a deadlock on ftrace_regex_lock")
Reported-by: sashiko-bot@kernel.org
Close: https://lore.kernel.org/all/20260829025528.49A831F000E9@smtp.kernel.org/
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ adjusted INIT_OPS_HASH macro context for the missing subop_list member. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ftrace.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 115f4232d688d..ad61bd1cba551 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -75,6 +75,8 @@
 #define INIT_OPS_HASH(opsname)	\
 	.func_hash		= &opsname.local_hash,			\
 	.local_hash.regex_lock	= __MUTEX_INITIALIZER(opsname.local_hash.regex_lock),
+/* Used only to synchronize the initialization of ftrace_ops */
+static DEFINE_MUTEX(ops_mutex);
 #else
 #define INIT_OPS_HASH(opsname)
 #endif
@@ -159,10 +161,17 @@ const struct ftrace_ops ftrace_nop_ops = {
 static inline void ftrace_ops_init(struct ftrace_ops *ops)
 {
 #ifdef CONFIG_DYNAMIC_FTRACE
-	if (!(ops->flags & FTRACE_OPS_FL_INITIALIZED)) {
+	unsigned long flags = smp_load_acquire(&ops->flags);
+
+	if (!(flags & FTRACE_OPS_FL_INITIALIZED)) {
+		guard(mutex)(&ops_mutex);
+		/* Could have been initialized before lock taken */
+		if (unlikely(ops->flags & FTRACE_OPS_FL_INITIALIZED))
+			return;
 		mutex_init(&ops->local_hash.regex_lock);
 		ops->func_hash = &ops->local_hash;
-		ops->flags |= FTRACE_OPS_FL_INITIALIZED;
+		flags = ops->flags | FTRACE_OPS_FL_INITIALIZED;
+		smp_store_release(&ops->flags, flags);
 	}
 #endif
 }
-- 
2.53.0



