Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A6A25A640;
	Sat, 12 Sep 2026 15:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227751; cv=none; b=pMu6tRSL/W2qb3TRhyMl4D7WsTK5VlaW0wvcX374p6HpQnbVizaiqgFJgEbaAWeeIJTiM8siN7k8lIEXE2NboOuqC1qbG8MZhrLSAx8oqsi2BJAw+LBCfew40PX+0HCpIELB7GKU42W7xP/2I7EecFySTEYwl/k/Y/D4TKL3URE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227751; c=relaxed/simple;
	bh=JVHgYCdsjeuagMHsJo/fDNL3hbRZ2hdLsEsPCPSDiWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLlobTn90Ttg4hc5tLKXNs2bb87cnL2GrZIeWLnqTzATcaFpD8rsS6YwzpTxkyVeeOBkLw7F4UE2aimlbz/FRrki8VJfIYCl8zmdli0IaCPIIJN7mzHLN7/M5gWiO6XmasQgN6GPUaUmbHjI8l0ECJkqS7KlxuKkac0eepi1Rww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+iweJ7e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+iweJ7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0391F000FF;
	Sat, 12 Sep 2026 15:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227749;
	bh=i1WP7JJcU9H1e42HJriqRYnM5EItVqF4xw66k77FDRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0+iweJ7eBCPdhqmUVbzaIiOhttklUQCnRIcjRVQjI4IF8qA9Kqez82j0rQEGtLM+d
	 luBx0epTY17/DJePZhgFGyWwZ2tq1RI0SgIW/W52CGRsd+M1qRcEo25XHj+cO7zM5i
	 KzxhEwz4iNavR6MxHjg3+Sc4zcBJDh9+5JlQy1ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Oleg Nesterov <oleg@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Adrian Huang <adrianhuang0701@gmail.com>,
	Aleksandr Nogikh <nogikh@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 0246/1191] signal: avoid shared siginfo namespace rewrites
Date: Sat, 12 Sep 2026 08:49:34 +0200
Message-ID: <20260912065553.741188880@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bradley Morgan <include@grrlz.net>

commit d19cdc167e696714509e87d3f7ae765b6e164589 upstream.

send_signal_locked() rewrites sender ids for the target namespace.  Group
sends reuse the same siginfo, so one recipient can affect the next.

Copy the siginfo before changing it.

Link: https://lore.kernel.org/86a8857d58d43ee26a8b365b837fd24830343494.1782159692.git.include@grrlz.net
Fixes: 7a0cf094944e ("signal: Correct namespace fixups of si_pid and si_uid")
Signed-off-by: Bradley Morgan <include@grrlz.net>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Adrian Huang <adrianhuang0701@gmail.com>
Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/signal.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1225,6 +1225,7 @@ static inline bool has_si_pid_and_uid(st
 int send_signal_locked(int sig, struct kernel_siginfo *info,
 		       struct task_struct *t, enum pid_type type)
 {
+	struct kernel_siginfo rewritten;
 	/* Should SIGKILL or SIGSTOP be received by a pid namespace init? */
 	bool force = false;
 
@@ -1238,6 +1239,9 @@ int send_signal_locked(int sig, struct k
 		/* SIGKILL and SIGSTOP is special or has ids */
 		struct user_namespace *t_user_ns;
 
+		rewritten = *info;
+		info = &rewritten;
+
 		rcu_read_lock();
 		t_user_ns = task_cred_xxx(t, user_ns);
 		if (current_user_ns() != t_user_ns) {


