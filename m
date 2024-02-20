Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952EB152DE0;
	Tue, 20 Feb 2024 21:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464094; cv=none; b=W2oix8R8tAjAxeIUF/RJp3M/3i6nmJIoga55eKRefvtGV+u9QoKMHeLPtWtqW1nXGmyiFIosYL4Cu/gPjXTMHT5Ns/4B0Lx9D4boDkMkpIbfL9zbrDy2I75Q4sAayMzmxZRJSjlZmaga9bnRx1BEsFMA2CqNRVYPBnkW1+JWRms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464094; c=relaxed/simple;
	bh=Je3p7mVddS6eShJQtm69I1uAZdB37jx6OLX3FFjGZtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/QytAN/twNNEhvNPA8rjAoLvcrC5Hf093OVpK2Uzpp2resSRJLPsuHPxBrybqEDtf7tIPMFXZGvh7Sl1ADT+G4Ihka0wanfM5zD/nIs2IwRtS+MkSOZsuzr4OShx9WcwkcLfdB/eHsdiOrzpbTq9ZxIGx2KO/dYqs+adgUgV8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0OWwCwxZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0OWwCwxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115BCC433F1;
	Tue, 20 Feb 2024 21:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464094;
	bh=Je3p7mVddS6eShJQtm69I1uAZdB37jx6OLX3FFjGZtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0OWwCwxZPePSqGPuk2WOJgdym1K/wP2vSpFYz4yW7Nbl+JY0Y1xf54Qs/Jady8ZP5
	 3SIJJgDyTp4aoJnmF2U16/Ay9IHg1rzd/ismTMVO5j2ZSDSRZ9WnEtNKEnIyWcEzr/
	 sIfThytiNhm9Zs/FJHjyo5u0aeH69x3wZp0EvV8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Dylan Hatch <dylanbhatch@google.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 250/331] fs/proc: do_task_stat: move thread_group_cputime_adjusted() outside of lock_task_sighand()
Date: Tue, 20 Feb 2024 21:56:06 +0100
Message-ID: <20240220205645.690069437@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -545,7 +545,6 @@ static int do_task_stat(struct seq_file
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
-			thread_group_cputime_adjusted(task, &utime, &stime);
 			gtime += sig->gtime;
 
 			if (sig->flags & (SIGNAL_GROUP_EXIT | SIGNAL_STOP_STOPPED))
@@ -561,10 +560,13 @@ static int do_task_stat(struct seq_file
 
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
 


