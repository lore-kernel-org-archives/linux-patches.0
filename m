Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210593;
	b=uPksyYHacdWyDjOBb2GgvALfLi/vVynjl3UcdRa+oRy+12kqEuxERjfTh1xRM/PqxY9v
	 ca3+xAcFpNU6GmD/rJhajSDtAqyeedYgl8eRfRs/9Yd4lrdzRMdmWJGLE7UgdZGgRYRHN
	 pjyZSAsrybjlfshZwgUL2bSb7XFSEzRNRetgj8Yy3yspgsrAHeRvFMHkb/LfbP+ax+fWR
	 QSnR6QOvpRN8Q2Up0mfpawnKzqv7tTS0AbNO042hq+UK5lHTzXaSvHRNbwDE2vv4tV8Yw
	 FoBjjUOUACoADcdjceE495HSsM628JVv0Gz+7dzNjmAoj8Ot/W5Z4KxhV/wjdctMb3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2YlKXodVOYPSXt5QStkpnJk0vpLDTFAXNl5QhxxaF8A=;
	b=z2gTQhsWD+7xb8cAuux1ZIg+Tm6y/2I0M5xgiUeoDHneU2QSOBgqgAsarkEMwZQs+dfP
	 Fdkddp4e8S+UwWvCYNaKt2D3UenSQZZ1JOM0RDrpyMwZepQ+0hySkDJRi/fsPJ/edAuNq
	 0zh4QvTL37dXKbjWi5PNcH0yw15C/M1P/MBBH2tb3CY5IQgGaWtYHI6EqblTJ91BLSkp/
	 NUstwA0iOClvBsk6iKBt1d3gjXCZ78rB69+ljesqLe0cnAhxQGOuKqemvw9CuoEuKGJug
	 F6GJWfSghXxK/PXmMQQWEbjGo7EauxFbMXSwtbuIdLr47ympYM9GHFqoUqJtFtqzJ0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lHbDP1Ol;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CB0606A31C;
	Wed, 28 Oct 2026 18:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lHbDP1Ol
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C494C1F01825;
	Wed, 28 Oct 2026 18:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210592;
	bh=2YlKXodVOYPSXt5QStkpnJk0vpLDTFAXNl5QhxxaF8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lHbDP1OlxALPSW6BbpyJXCPThFFB70g3YhNCjvY34+GdoMXGwz6WK4UIyzNoIkXGd
	 PHUsrnrVF0jk96cb6bx4EgiXqKnB70fnrIIwT+4JTJWPFeFEV29tOMJWyqxaordgYE
	 0ceG8ovW3q7ZrCks5pp4zmAW95wQbwt8riJOl3KQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/571] ftrace: Synchronize the initialization of ftrace_ops
Date: Wed, 28 Oct 2026 17:53:45 +0100
Message-ID: <20261028170009.878157625@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 644f5e060eb8a..fdc4006631657 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -69,6 +69,8 @@
 #define INIT_OPS_HASH(opsname)	\
 	.func_hash		= &opsname.local_hash,			\
 	.local_hash.regex_lock	= __MUTEX_INITIALIZER(opsname.local_hash.regex_lock),
+/* Used only to synchronize the initialization of ftrace_ops */
+static DEFINE_MUTEX(ops_mutex);
 #else
 #define INIT_OPS_HASH(opsname)
 #endif
@@ -131,10 +133,17 @@ static void ftrace_ops_no_ops(unsigned long ip, unsigned long parent_ip);
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



