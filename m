Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7B6308F2E;
	Mon, 13 Oct 2025 14:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760366978; cv=none; b=LgkUkrJYVdG/Gv/UGZ0Zvg7Xf86TlwsTIyuc004X9c5HbzPw5p4Qc7mSAHBP6MWkzm9qYwIus/G3avDpiZe73hvwEndxa3lhOuy3NBIapIVYOhSW141DPxnYkMSL4rJL4FvFZetRnQEpoJUSbnQLtI0BiUCn2Xxyiyox1sqfPSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760366978; c=relaxed/simple;
	bh=UCHit4OlGhvvUTJWV6vPgkFrdsqNol+4AY0qYW68s20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nO1eIpDojs3ZBR2MecPmhdg032AaEU6jjv4Aq3F4AV8r6snqVHlYB5XDCohO0/6PutGxBIeaIPT4/NJMHCuKyFOuvP9A47CAASb2GS2bTCFLvwbcyI2tPqX3rzdCchj/hKoWxg9v7jd8OwP+HKmrqumtZfDB/gL9RRwwT5IPLnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xdA6JJWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xdA6JJWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93EB1C4CEE7;
	Mon, 13 Oct 2025 14:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760366978;
	bh=UCHit4OlGhvvUTJWV6vPgkFrdsqNol+4AY0qYW68s20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xdA6JJWVhbXAsC+8yl6d3vN8xH3GSF2B51HHTdNn2ar+4O3fpdgKimQW5enEE11Qy
	 BKN895RhrRpyV54n4C/OK83mUEJBqm4Z9zzV13ZFqkHDz0nnsp2kA6y4PQHVIiDsZl
	 7LJzYTymc9Jn99Bnb6iClcJOaIjIp4o1zkUvStco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Polatel <alip@chesswob.org>,
	Johannes Nixdorf <johannes@nixdorf.dev>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/196] seccomp: Fix a race with WAIT_KILLABLE_RECV if the tracer replies too fast
Date: Mon, 13 Oct 2025 16:43:41 +0200
Message-ID: <20251013144316.323309757@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

From: Johannes Nixdorf <johannes@nixdorf.dev>

[ Upstream commit cce436aafc2abad691fdd37de63ec8a4490b42ce ]

Normally the tracee starts in SECCOMP_NOTIFY_INIT, sends an
event to the tracer, and starts to wait interruptibly. With
SECCOMP_FILTER_FLAG_WAIT_KILLABLE_RECV, if the tracer receives the
message (SECCOMP_NOTIFY_SENT is reached) while the tracee was waiting
and is subsequently interrupted, the tracee begins to wait again
uninterruptibly (but killable).

This fails if SECCOMP_NOTIFY_REPLIED is reached before the tracee
is interrupted, as the check only considered SECCOMP_NOTIFY_SENT as a
condition to begin waiting again. In this case the tracee is interrupted
even though the tracer already acted on its behalf. This breaks the
assumption SECCOMP_FILTER_FLAG_WAIT_KILLABLE_RECV wanted to ensure,
namely that the tracer can be sure the syscall is not interrupted or
restarted on the tracee after it is received on the tracer. Fix this
by also considering SECCOMP_NOTIFY_REPLIED when evaluating whether to
switch to uninterruptible waiting.

With the condition changed the loop in seccomp_do_user_notification()
would exit immediately after deciding that noninterruptible waiting
is required if the operation already reached SECCOMP_NOTIFY_REPLIED,
skipping the code that processes pending addfd commands first. Prevent
this by executing the remaining loop body one last time in this case.

Fixes: c2aa2dfef243 ("seccomp: Add wait_killable semantic to seccomp user notifier")
Reported-by: Ali Polatel <alip@chesswob.org>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220291
Signed-off-by: Johannes Nixdorf <johannes@nixdorf.dev>
Link: https://lore.kernel.org/r/20250725-seccomp-races-v2-1-cf8b9d139596@nixdorf.dev
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/seccomp.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index e9852d1b4a5ec..8dcb585ae78c1 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -1090,7 +1090,7 @@ static void seccomp_handle_addfd(struct seccomp_kaddfd *addfd, struct seccomp_kn
 static bool should_sleep_killable(struct seccomp_filter *match,
 				  struct seccomp_knotif *n)
 {
-	return match->wait_killable_recv && n->state == SECCOMP_NOTIFY_SENT;
+	return match->wait_killable_recv && n->state >= SECCOMP_NOTIFY_SENT;
 }
 
 static int seccomp_do_user_notification(int this_syscall,
@@ -1134,13 +1134,11 @@ static int seccomp_do_user_notification(int this_syscall,
 
 		if (err != 0) {
 			/*
-			 * Check to see if the notifcation got picked up and
-			 * whether we should switch to wait killable.
+			 * Check to see whether we should switch to wait
+			 * killable. Only return the interrupted error if not.
 			 */
-			if (!wait_killable && should_sleep_killable(match, &n))
-				continue;
-
-			goto interrupted;
+			if (!(!wait_killable && should_sleep_killable(match, &n)))
+				goto interrupted;
 		}
 
 		addfd = list_first_entry_or_null(&n.addfd,
-- 
2.51.0



