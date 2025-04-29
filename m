Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2371325332D;
	Tue, 29 Apr 2025 17:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949336; cv=none; b=Ov5ax2AmEZ9TxDL0vZSb/sZT3nbFY427KXLtmhoRwbMWeE2epADk2DzawmE8rKkKPjw6RZ+XpPLjtrFXSz1s5v45n17DatoX7U2ZOXa4s5p2p1SFkvDWgLrJ54h7w/Fi9D3Z6PCcKO75XuoUU4G/SQi9AxtrXP3v9FruDN0grBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949336; c=relaxed/simple;
	bh=4HNIH3FI1knwA4tP+iPLttXPim2mU7qUVEZbtDzbQa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MViPMP0IfdpcwrFjBsSUiz7dJqllcm1LbnLrfOApmFfyAo6rwIkpSxC5y1j1xlXEqisuy2od3FyxA0gdx6gDI13Duii8CHkxq53OC02oBF4vHijviZusV6ba12a2nY4AOK+1CS4m61XYwgE5S7HplUvUkK5hRYIDAPlHT2jA0dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jyHsK5Xh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jyHsK5Xh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8755DC4CEE3;
	Tue, 29 Apr 2025 17:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949336;
	bh=4HNIH3FI1knwA4tP+iPLttXPim2mU7qUVEZbtDzbQa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jyHsK5XhOrQrj5soh8lMBPk7WHW9YhMjUR36AztEaRCyg6Rbgw1uQ5zs+GiQTMQ1E
	 Na963pezD0IPvK4VMjw0cN4ranxnzgrPUj4VqFtuKMfqjLp4JuRlhO3gzw6O0t7qun
	 F4Gh3p2QbcQqEU6t+1RyBceE3iUHtoODYXAksl1k=
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
Subject: [PATCH 5.15 247/373] fs/proc: do_task_stat: use sig->stats_lock to gather the threads/children stats
Date: Tue, 29 Apr 2025 18:42:04 +0200
Message-ID: <20250429161133.283702860@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/proc/array.c |   53 +++++++++++++++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 24 deletions(-)

--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -462,12 +462,12 @@ static int do_task_stat(struct seq_file
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
@@ -495,12 +495,8 @@ static int do_task_stat(struct seq_file
 
 	sigemptyset(&sigign);
 	sigemptyset(&sigcatch);
-	cutime = cstime = 0;
-	cgtime = gtime = 0;
 
 	if (lock_task_sighand(task, &flags)) {
-		struct signal_struct *sig = task->signal;
-
 		if (sig->tty) {
 			struct pid *pgrp = tty_get_pgrp(sig->tty);
 			tty_pgrp = pid_nr_ns(pgrp, ns);
@@ -511,36 +507,45 @@ static int do_task_stat(struct seq_file
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
+		wchan = !task_is_running(task);
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
-
-			min_flt += sig->min_flt;
-			maj_flt += sig->maj_flt;
-			gtime += sig->gtime;
+			rcu_read_unlock();
 		}
-
-		sid = task_session_nr_ns(task, ns);
-		ppid = task_tgid_nr_ns(task->real_parent, ns);
-		pgid = task_pgrp_nr_ns(task, ns);
-
-		unlock_task_sighand(task, &flags);
-	}
-
-	if (permitted && (!whole || num_threads < 2))
-		wchan = !task_is_running(task);
+	} while (need_seqretry(&sig->stats_lock, seq));
+	done_seqretry_irqrestore(&sig->stats_lock, seq, flags);
 
 	if (whole) {
 		thread_group_cputime_adjusted(task, &utime, &stime);


