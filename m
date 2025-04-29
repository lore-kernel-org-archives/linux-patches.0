Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FC51C6B4;
	Tue, 29 Apr 2025 17:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947151; cv=none; b=B2lAAIqJtwcTjYAKv3J1An5SK0BCyl5CH1OtxRCfcOqbAPSJKBJilA73OCmgwJrrGHyU535c4DwzDFZfkYg9TC8kxGMC6lNjeB2f7Ff12994e2hMU4qoFoILCRAWVcEa4eLTeUKkb/rOqcN+NjWpvwHWKyFzOSqieX458b9nOIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947151; c=relaxed/simple;
	bh=x8zX1dKKYmiysVLc2drCDZepGSzl2ct+wy9EggFF90w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAwxQLwiezyA3rPHVu9lA2FPEK2JMJPY+ISgguUIzv2tteXQSlCy1rFSVUsB+sNmo2z7PpkVIwIQbOWYlSfmzDY/kdTl7tDzZY7ZZAlrKLORej2LKhrdQlbiQU4gIZtPgh4P9YHiYqhQMKL09clP/d+VRvN5+PQP8B/CLZvQTQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w5uRWxoD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w5uRWxoD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14FFC4CEE3;
	Tue, 29 Apr 2025 17:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947151;
	bh=x8zX1dKKYmiysVLc2drCDZepGSzl2ct+wy9EggFF90w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w5uRWxoDHskZibb7waANL8yphavw2tcja5c7meh6YBAYvfrE6QfuG9//ACOSubk0V
	 8NyL703bMpXXGpfm1RkQ7wv9yTBZDoAskgzhRdMn5LxgGgbgsiY/aiwYTzS8AORbcf
	 pEFL7iOiQpgdNiVjnmasvcQCTmAEClbyG5S+uNms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Dylan Hatch <dylanbhatch@google.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	David Sauerwein <dssauerw@amazon.de>
Subject: [PATCH 5.10 188/286] fs/proc: do_task_stat: use sig->stats_lock to gather the threads/children stats
Date: Tue, 29 Apr 2025 18:41:32 +0200
Message-ID: <20250429161115.703237828@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 7601df8031fd67310af891897ef6cc0df4209305 upstream.

lock_task_sighand() can trigger a hard lockup.  If NR_CPUS threads call
do_task_stat() at the same time and the process has NR_THREADS, it will
spin with irqs disabled O(NR_CPUS * NR_THREADS) time.

Change do_task_stat() to use sig->stats_lock to gather the statistics
outside of ->siglock protected section, in the likely case this code will
run lockless.

Link: https://lkml.kernel.org/r/20240123153357.GA21857@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: David Sauerwein <dssauerw@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/array.c |   52 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 22 deletions(-)

--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -443,12 +443,12 @@ static int do_task_stat(struct seq_file
 	int permitted;
 	struct mm_struct *mm;
 	unsigned long long start_time;
-	unsigned long cmin_flt = 0, cmaj_flt = 0;
-	unsigned long  min_flt = 0,  maj_flt = 0;
-	u64 cutime, cstime, utime, stime;
-	u64 cgtime, gtime;
+	unsigned long cmin_flt, cmaj_flt, min_flt, maj_flt;
+	u64 cutime, cstime, cgtime, utime, stime, gtime;
 	unsigned long rsslim = 0;
 	unsigned long flags;
+	struct signal_struct *sig = task->signal;
+	unsigned int seq = 1;
 
 	state = *get_task_state(task);
 	vsize = eip = esp = 0;
@@ -476,12 +476,9 @@ static int do_task_stat(struct seq_file
 
 	sigemptyset(&sigign);
 	sigemptyset(&sigcatch);
-	cutime = cstime = utime = stime = 0;
-	cgtime = gtime = 0;
+	utime = stime = 0;
 
 	if (lock_task_sighand(task, &flags)) {
-		struct signal_struct *sig = task->signal;
-
 		if (sig->tty) {
 			struct pid *pgrp = tty_get_pgrp(sig->tty);
 			tty_pgrp = pid_nr_ns(pgrp, ns);
@@ -492,37 +489,48 @@ static int do_task_stat(struct seq_file
 		num_threads = get_nr_threads(task);
 		collect_sigign_sigcatch(task, &sigign, &sigcatch);
 
+		rsslim = READ_ONCE(sig->rlim[RLIMIT_RSS].rlim_cur);
+
+		sid = task_session_nr_ns(task, ns);
+		ppid = task_tgid_nr_ns(task->real_parent, ns);
+		pgid = task_pgrp_nr_ns(task, ns);
+
+		unlock_task_sighand(task, &flags);
+	}
+
+	if (permitted && (!whole || num_threads < 2))
+		wchan = get_wchan(task);
+
+	do {
+		seq++; /* 2 on the 1st/lockless path, otherwise odd */
+		flags = read_seqbegin_or_lock_irqsave(&sig->stats_lock, &seq);
+
 		cmin_flt = sig->cmin_flt;
 		cmaj_flt = sig->cmaj_flt;
 		cutime = sig->cutime;
 		cstime = sig->cstime;
 		cgtime = sig->cgtime;
-		rsslim = READ_ONCE(sig->rlim[RLIMIT_RSS].rlim_cur);
 
-		/* add up live thread stats at the group level */
 		if (whole) {
 			struct task_struct *t = task;
+
+			min_flt = sig->min_flt;
+			maj_flt = sig->maj_flt;
+			gtime = sig->gtime;
+
+			rcu_read_lock();
 			do {
 				min_flt += t->min_flt;
 				maj_flt += t->maj_flt;
 				gtime += task_gtime(t);
 			} while_each_thread(task, t);
+			rcu_read_unlock();
 
-			min_flt += sig->min_flt;
-			maj_flt += sig->maj_flt;
 			thread_group_cputime_adjusted(task, &utime, &stime);
-			gtime += sig->gtime;
 		}
+	} while (need_seqretry(&sig->stats_lock, seq));
+	done_seqretry_irqrestore(&sig->stats_lock, seq, flags);
 
-		sid = task_session_nr_ns(task, ns);
-		ppid = task_tgid_nr_ns(task->real_parent, ns);
-		pgid = task_pgrp_nr_ns(task, ns);
-
-		unlock_task_sighand(task, &flags);
-	}
-
-	if (permitted && (!whole || num_threads < 2))
-		wchan = get_wchan(task);
 	if (!whole) {
 		min_flt = task->min_flt;
 		maj_flt = task->maj_flt;


