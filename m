Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE0D2DF9F;
	Tue, 20 Feb 2024 21:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465299; cv=none; b=ZNe9LoGuqI3dEbN2pupChKtaJNfwTXTcB2+oRPKKhEu3hXJSmAAYf9ImEI5uUsjKtC04W63CjQtTa0zL+IM8iQvVx7sbjy8jsEZbCUZFrB1IoaqPQimd302zDoi90z9AbcYGs3Snopl5949drBFxAwmOPtUGWu1Xwb7gSC0kT3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465299; c=relaxed/simple;
	bh=0lsSTlG344l0shgp5nOxsDfRrbPnhfDk1fxBgeFTwvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgz5b7ViuFlEPiPxuOe8vWUItfl/wdMyxmq5SRexVHqPDaIl1mkCbmh8eT0uayxyu9da1eoHEap0xWvB6qC2yqetMGB+1wlqejKY5qO2s9+wEoEzlUp8IvYNZh+Tf8OLhwS0I1B8yjwi+W6vbmeYARwMXIAu6Yf+W/hYE7b6f44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ns1VEkSL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ns1VEkSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36056C433F1;
	Tue, 20 Feb 2024 21:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465299;
	bh=0lsSTlG344l0shgp5nOxsDfRrbPnhfDk1fxBgeFTwvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ns1VEkSL9vM7pQ1TLf8mAaCJ+wo9zmSNiU4u1frY9wpgoko+nQMzA0VQPvdWaHpM5
	 PGOdoGUEiL00f8L5NaPLs9NDsxz9Z5WtmC7HLiw5U0Y2vQFJ34oxz+DYmUaG+J1OCX
	 RuAEZVwRxEw1SA0qzGHok76YbrGmFCP7AtERDdbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Dylan Hatch <dylanbhatch@google.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 300/309] fs/proc: do_task_stat: move thread_group_cputime_adjusted() outside of lock_task_sighand()
Date: Tue, 20 Feb 2024 21:57:39 +0100
Message-ID: <20240220205642.478075924@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 60f92acb60a989b14e4b744501a0df0f82ef30a3 upstream.

Patch series "fs/proc: do_task_stat: use sig->stats_".

do_task_stat() has the same problem as getrusage() had before "getrusage:
use sig->stats_lock rather than lock_task_sighand()": a hard lockup.  If
NR_CPUS threads call lock_task_sighand() at the same time and the process
has NR_THREADS, spin_lock_irq will spin with irqs disabled O(NR_CPUS *
NR_THREADS) time.


This patch (of 3):

thread_group_cputime() does its own locking, we can safely shift
thread_group_cputime_adjusted() which does another for_each_thread loop
outside of ->siglock protected section.

Not only this removes for_each_thread() from the critical section with
irqs disabled, this removes another case when stats_lock is taken with
siglock held.  We want to remove this dependency, then we can change the
users of stats_lock to not disable irqs.

Link: https://lkml.kernel.org/r/20240123153313.GA21832@redhat.com
Link: https://lkml.kernel.org/r/20240123153355.GA21854@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/array.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -511,7 +511,7 @@ static int do_task_stat(struct seq_file
 
 	sigemptyset(&sigign);
 	sigemptyset(&sigcatch);
-	cutime = cstime = utime = stime = 0;
+	cutime = cstime = 0;
 	cgtime = gtime = 0;
 
 	if (lock_task_sighand(task, &flags)) {
@@ -546,7 +546,6 @@ static int do_task_stat(struct seq_file
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
-			thread_group_cputime_adjusted(task, &utime, &stime);
 			gtime += sig->gtime;
 
 			if (sig->flags & (SIGNAL_GROUP_EXIT | SIGNAL_STOP_STOPPED))
@@ -562,10 +561,13 @@ static int do_task_stat(struct seq_file
 
 	if (permitted && (!whole || num_threads < 2))
 		wchan = !task_is_running(task);
-	if (!whole) {
+
+	if (whole) {
+		thread_group_cputime_adjusted(task, &utime, &stime);
+	} else {
+		task_cputime_adjusted(task, &utime, &stime);
 		min_flt = task->min_flt;
 		maj_flt = task->maj_flt;
-		task_cputime_adjusted(task, &utime, &stime);
 		gtime = task_gtime(task);
 	}
 


