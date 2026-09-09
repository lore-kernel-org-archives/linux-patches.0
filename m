Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D694DF4DC;
	Wed,  9 Sep 2026 13:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961891; cv=none; b=GC0EFWbm5Vc81VBJszOB6mWonGKCgKuuRRVxpaXpVm+d25DAOn37vMSlziZV+d7sHcr9iKoaTSQ9/nAnG4SHyoOepxgutQp+YK+YEg1pvF762BdCZjA//KfTSIijA1NK0CM57KtvRHm1FksGZ6tKoJyJbKUSQHRAzogua1zIqjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961891; c=relaxed/simple;
	bh=NBqV8RCvVFu8Q7UAt1sJuWG/PbzbkW3eQN5cfrJjC38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHX/Qrc03SezOWRJzLgoYU4cUsWvc33fp7Ct3zYa3gpgyiEoIpPnZsZS6XT413jCD1Ve2j7Q7EvDmk6jqOCvbV036QsgL4/dH7z3YYxbCG/Q6ql2h7pcOy3MKkry3libPKJZAm1zuMUKaOeaadpxzae8UnbXGNv8Zzf7r/MNDpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cHMkiAh2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cHMkiAh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6521F00A3A;
	Wed,  9 Sep 2026 13:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961889;
	bh=1ZyZFfsUmood6M/Ehz19Ixy4+fJJkS0ZB+3amF1VOyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cHMkiAh2Hrb1WmivZwOPcsaA9X4SY5zjTeuqGjMAN8tLFGfDAaLAQh5oKkG6mbxtn
	 rg6Mlthyk0swY8fHYiHZsUzhpfJ1ZmFrfCHNxlwW1FE8ezHZ6xe47ZbeKO5VKerWcS
	 L9PTYZlayttLNoEdBA0FpFQbk+JIY1be3D5MjZL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 101/556] ftrace: Synchronize the initialization of ftrace_ops
Date: Wed,  9 Sep 2026 15:36:21 +0200
Message-ID: <20260909134234.049324478@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 4617721c502b2ddaa4e324e86da4997edf738fa5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -75,6 +75,8 @@
 	.func_hash		= &opsname.local_hash,			\
 	.local_hash.regex_lock	= __MUTEX_INITIALIZER(opsname.local_hash.regex_lock), \
 	.subop_list		= LIST_HEAD_INIT(opsname.subop_list),
+/* Used only to synchronize the initialization of ftrace_ops */
+static DEFINE_MUTEX(ops_mutex);
 #else
 #define INIT_OPS_HASH(opsname)
 #endif
@@ -159,11 +161,18 @@ const struct ftrace_ops ftrace_nop_ops =
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
 		INIT_LIST_HEAD(&ops->subop_list);
 		ops->func_hash = &ops->local_hash;
-		ops->flags |= FTRACE_OPS_FL_INITIALIZED;
+		flags = ops->flags | FTRACE_OPS_FL_INITIALIZED;
+		smp_store_release(&ops->flags, flags);
 	}
 #endif
 }


