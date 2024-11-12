Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E38720DD7E;
	Tue, 12 Nov 2024 10:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407540; cv=none; b=uZN0Z/oN9g6Vuj/OXcYMNoGzZUY86M3ZZ0roULEcHsgsK2oISdf1EBFzUB4tGKsvLNT6sC7qiyLI/A5la8KM/+e2BpYC31SOagcK/74dtJEWsnaxUBDCKYnsD5LxZpUEWcYQ03N0gznXzKL3BqALVOoh6yBo/Cz+d9gQDmn5oHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407540; c=relaxed/simple;
	bh=HzFgUk1g9/Cz/MM12ddiFPO1JIfHwL0PyLimYvRroJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETC9eaaYqkVb/qW+rX8B6A2oD6K6Qu2NyKplpCB33Ah7cBeoFT0Q9vFoj5fQJmRRyhTl45Mg6F8J0W9dwUgwqUX9jRTS16xNwXGCtpZIslSM5bhdqTP/7xOxb1lbV0R6Mm75oSXebugAzerkn3dA4uAsKJNHVJ6HpgKpwA0y5fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVyCvAZU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVyCvAZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED0EC4CECD;
	Tue, 12 Nov 2024 10:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407540;
	bh=HzFgUk1g9/Cz/MM12ddiFPO1JIfHwL0PyLimYvRroJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVyCvAZUn5BHRVWi5xq2RSbZd8StvH63W39j3P4LolpeVEZIU42o4i6v8BXBhE508
	 Lb6gpJNbxKC4PvKrMYiKkKm3HhzYKE6XNAbmYl/oz16F3jcNOa6/OHUpodUJ/I74F8
	 NjXhVwSY1Oz5XvnvVtdMqgdp/niKg6GG/YeJ48I8=
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
Subject: [PATCH 6.1 83/98] signal: restore the override_rlimit logic
Date: Tue, 12 Nov 2024 11:21:38 +0100
Message-ID: <20241112101847.412138827@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -131,7 +131,8 @@ static inline long get_rlimit_value(stru
 
 long inc_rlimit_ucounts(struct ucounts *ucounts, enum rlimit_type type, long v);
 bool dec_rlimit_ucounts(struct ucounts *ucounts, enum rlimit_type type, long v);
-long inc_rlimit_get_ucounts(struct ucounts *ucounts, enum rlimit_type type);
+long inc_rlimit_get_ucounts(struct ucounts *ucounts, enum rlimit_type type,
+			    bool override_rlimit);
 void dec_rlimit_put_ucounts(struct ucounts *ucounts, enum rlimit_type type);
 bool is_rlimit_overlimit(struct ucounts *ucounts, enum rlimit_type type, unsigned long max);
 
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -426,7 +426,8 @@ __sigqueue_alloc(int sig, struct task_st
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


