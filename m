Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E61A30E84B;
	Mon, 13 Oct 2025 15:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368788; cv=none; b=VrbrXaNBRriZhmUmlXxVNt7emItMD7q9IC7ZEDCsUodNX6x8JIsFMqRYpQC+wMq3cchxH43N61e/pRm1QkD8dgwrvOOXxjkU7eZo+bmSbCOPwP0MCb6I1p+t49/UoClgG3cQW0ucb/NrnSMHQ+8RTmpsWh/39C4+23gXGCm0VHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368788; c=relaxed/simple;
	bh=rg0meAkcirKzq2+IcIMaPVJYcjEF+lhHdgAZU2gkT60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OsmijBEs+whEW6qrNWqsyrJj3ZO5kTVpmfD5r4Z8yjQCSwpZFwImcGF1dQYA86Gcrjq2AZLVOLsCAFeu2vILDkS3/+Lb12FfUYaLEjGVm8G4A5MJg5fUGPYAjdLuiI95no8HNw0Q4OQ3pEXmCBnvlDQd7kkucQ5UgBWy6AsDAlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ykyItOpb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ykyItOpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831F3C4CEE7;
	Mon, 13 Oct 2025 15:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368787;
	bh=rg0meAkcirKzq2+IcIMaPVJYcjEF+lhHdgAZU2gkT60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ykyItOpbw+KeS79lcDmeMIJbLeTWelrEjGKyxG8QXujgRoaaJE/nNhIfGAM10akOu
	 6731lyjyzL9PeSko59d+rMw868oxMLSlA8vzO/q1QgfNNh5lD0v0wfl9uGgyjHuXpc
	 EL/dB9lrkhgphZTVplB/q6vOd8EGuweHYtSdF3e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Polatel <alip@chesswob.org>,
	Johannes Nixdorf <johannes@nixdorf.dev>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 006/563] seccomp: Fix a race with WAIT_KILLABLE_RECV if the tracer replies too fast
Date: Mon, 13 Oct 2025 16:37:47 +0200
Message-ID: <20251013144411.520249768@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 41aa761c7738c..3bbfba30a777a 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -1139,7 +1139,7 @@ static void seccomp_handle_addfd(struct seccomp_kaddfd *addfd, struct seccomp_kn
 static bool should_sleep_killable(struct seccomp_filter *match,
 				  struct seccomp_knotif *n)
 {
-	return match->wait_killable_recv && n->state == SECCOMP_NOTIFY_SENT;
+	return match->wait_killable_recv && n->state >= SECCOMP_NOTIFY_SENT;
 }
 
 static int seccomp_do_user_notification(int this_syscall,
@@ -1186,13 +1186,11 @@ static int seccomp_do_user_notification(int this_syscall,
 
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



