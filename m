Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3306621A4A8;
	Tue, 12 Nov 2024 10:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408397; cv=none; b=Z0L/lKu+awau4ZdHixd7f92u7tgeghwOHljTcP0tTTQk4JlafGXLulWaI5jkjOukvKsz38aVWlqFcjfC6YNOUHwNFgMFomaHtZqq+wqr5vNaO57Av1kuOvEAqxnt0ysNxpIGn01/tOCMiY6/ajIm8SmQCHunVLjvAz9v66tcT6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408397; c=relaxed/simple;
	bh=qXngbfb8J0jflgj43O3oE5d2Kp/eccgg3IgbgnW7LQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDvRRljeLNlUUfAYTEOrxvAV+G2HtmSYPed81hstrOK0c0jRr679UOv1O0sgJ5W0iIwE86Q4tm36zcl2z3F1Guwy3xFj+UesepZAzWNjGiH0kCkL/XMINDBNxIUpUqUlQNImLzOYIuKF059CuJ7VuNRK5W6pNcIBurMS+8F+CSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NuZH1SJ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NuZH1SJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BAFC4CECD;
	Tue, 12 Nov 2024 10:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408397;
	bh=qXngbfb8J0jflgj43O3oE5d2Kp/eccgg3IgbgnW7LQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NuZH1SJ7ec4oLHZR2/F9Sr3y04rGUySF/eNPQ0ZUpBXIhxpm9j+ZATiojPRf+h2+Q
	 lPlob1uM4RmZhOQpQI8oYEHPDVkXvTy36VEGCqditqVjx6koXx7bmCcTw3mX8N5hhh
	 27aqVc3D9YU8fZPVbnc46poszhZbJ3GsOkd+wbMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrei Vagin <avagin@google.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Alexey Gladkov <legion@kernel.org>,
	Kees Cook <kees@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 149/184] signal: restore the override_rlimit logic
Date: Tue, 12 Nov 2024 11:21:47 +0100
Message-ID: <20241112101906.588407045@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Gushchin <roman.gushchin@linux.dev>

commit 9e05e5c7ee8758141d2db7e8fea2cab34500c6ed upstream.

Prior to commit d64696905554 ("Reimplement RLIMIT_SIGPENDING on top of
ucounts") UCOUNT_RLIMIT_SIGPENDING rlimit was not enforced for a class of
signals.  However now it's enforced unconditionally, even if
override_rlimit is set.  This behavior change caused production issues.

For example, if the limit is reached and a process receives a SIGSEGV
signal, sigqueue_alloc fails to allocate the necessary resources for the
signal delivery, preventing the signal from being delivered with siginfo.
This prevents the process from correctly identifying the fault address and
handling the error.  From the user-space perspective, applications are
unaware that the limit has been reached and that the siginfo is
effectively 'corrupted'.  This can lead to unpredictable behavior and
crashes, as we observed with java applications.

Fix this by passing override_rlimit into inc_rlimit_get_ucounts() and skip
the comparison to max there if override_rlimit is set.  This effectively
restores the old behavior.

Link: https://lkml.kernel.org/r/20241104195419.3962584-1-roman.gushchin@linux.dev
Fixes: d64696905554 ("Reimplement RLIMIT_SIGPENDING on top of ucounts")
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Co-developed-by: Andrei Vagin <avagin@google.com>
Signed-off-by: Andrei Vagin <avagin@google.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Alexey Gladkov <legion@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/user_namespace.h |    3 ++-
 kernel/signal.c                |    3 ++-
 kernel/ucount.c                |    6 ++++--
 3 files changed, 8 insertions(+), 4 deletions(-)

--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -139,7 +139,8 @@ static inline long get_rlimit_value(stru
 
 long inc_rlimit_ucounts(struct ucounts *ucounts, enum rlimit_type type, long v);
 bool dec_rlimit_ucounts(struct ucounts *ucounts, enum rlimit_type type, long v);
-long inc_rlimit_get_ucounts(struct ucounts *ucounts, enum rlimit_type type);
+long inc_rlimit_get_ucounts(struct ucounts *ucounts, enum rlimit_type type,
+			    bool override_rlimit);
 void dec_rlimit_put_ucounts(struct ucounts *ucounts, enum rlimit_type type);
 bool is_rlimit_overlimit(struct ucounts *ucounts, enum rlimit_type type, unsigned long max);
 
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -419,7 +419,8 @@ __sigqueue_alloc(int sig, struct task_st
 	 */
 	rcu_read_lock();
 	ucounts = task_ucounts(t);
-	sigpending = inc_rlimit_get_ucounts(ucounts, UCOUNT_RLIMIT_SIGPENDING);
+	sigpending = inc_rlimit_get_ucounts(ucounts, UCOUNT_RLIMIT_SIGPENDING,
+					    override_rlimit);
 	rcu_read_unlock();
 	if (!sigpending)
 		return NULL;
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -307,7 +307,8 @@ void dec_rlimit_put_ucounts(struct ucoun
 	do_dec_rlimit_put_ucounts(ucounts, NULL, type);
 }
 
-long inc_rlimit_get_ucounts(struct ucounts *ucounts, enum rlimit_type type)
+long inc_rlimit_get_ucounts(struct ucounts *ucounts, enum rlimit_type type,
+			    bool override_rlimit)
 {
 	/* Caller must hold a reference to ucounts */
 	struct ucounts *iter;
@@ -320,7 +321,8 @@ long inc_rlimit_get_ucounts(struct ucoun
 			goto unwind;
 		if (iter == ucounts)
 			ret = new;
-		max = get_userns_rlimit_max(iter->ns, type);
+		if (!override_rlimit)
+			max = get_userns_rlimit_max(iter->ns, type);
 		/*
 		 * Grab an extra ucount reference for the caller when
 		 * the rlimit count was previously 0.


