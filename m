Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C04630C36B;
	Mon, 13 Oct 2025 15:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368062; cv=none; b=GzqXNPYGVZlF7P7PuDkL/9pHO0GdXBrroKzUGSnY/nlIBI0O90rbArs9h4wjAVqGkjJTOm1s5Zn3LT5SyyeshAUGWqPSpPnE4Yg+XTRuPDKJYmeLfaIQlV3S4DSKb3ph8k66pZG9RGquwcA4E5KyesyYxa3MWSlwqIkmZ9KlZto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368062; c=relaxed/simple;
	bh=c5svn4YyWAUmodHEit3PjNSRCewbdWFyL7Ydx0r7zQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VY3/kRqXmow0wSVub7Wz2DrGjEqpSpPJzEJfvLZvcueVqHWlImvReb9GzlfFIZ45DP/EBmDDUYLHqi0ozbAl80fAl7pdpL8GHrQkC3EvDQSzDuq6NRwwXeGsesU0thpgl3dOK4VxnU/qG+15pLNNRoMWl6bA9cK2Ll7m0anuA30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OHPDyQaT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OHPDyQaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82459C4CEE7;
	Mon, 13 Oct 2025 15:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368061;
	bh=c5svn4YyWAUmodHEit3PjNSRCewbdWFyL7Ydx0r7zQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OHPDyQaT4kE5AkScAmIWETke1wpU373zO8PYbw1+yZ1GZeLybhipDiMTEyIEwftRD
	 eVm1PVWNtn5pG1HpNBm1Y9biaxFQnvLyPDZ9a21WbUQDhZuHO+fJup1EUYbsyyuTay
	 oFZ5qtQbKJlixK9K2QzASuh8ZmbW9l2nKNZBue3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Polatel <alip@chesswob.org>,
	Johannes Nixdorf <johannes@nixdorf.dev>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/262] seccomp: Fix a race with WAIT_KILLABLE_RECV if the tracer replies too fast
Date: Mon, 13 Oct 2025 16:42:25 +0200
Message-ID: <20251013144326.246452572@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0cd1f8b5a102e..267b00005eaf2 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -1124,7 +1124,7 @@ static void seccomp_handle_addfd(struct seccomp_kaddfd *addfd, struct seccomp_kn
 static bool should_sleep_killable(struct seccomp_filter *match,
 				  struct seccomp_knotif *n)
 {
-	return match->wait_killable_recv && n->state == SECCOMP_NOTIFY_SENT;
+	return match->wait_killable_recv && n->state >= SECCOMP_NOTIFY_SENT;
 }
 
 static int seccomp_do_user_notification(int this_syscall,
@@ -1171,13 +1171,11 @@ static int seccomp_do_user_notification(int this_syscall,
 
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



