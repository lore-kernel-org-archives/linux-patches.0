Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9417746D08F;
	Tue, 21 Jul 2026 18:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659545; cv=none; b=BEt3hv/SrE8bSgf/LZTrbteITS7ygdQTYUEvG6XpOcCaiQHRvZYskIlNDMmtHI/4vf3O9qcASB+E90aSpwJdyv9h31YsgvXHZ2SdKb9CBK5gcFtGfl7I9VjlvQVZ56OUKLXt0CCjoQsS/x8zbnQeTXC8yeToDGVCumhf3Ltjwbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659545; c=relaxed/simple;
	bh=SAXHtU+CoJjrsmd+5au7r0AFEvMYUN+NnnOsxnBJeyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HaRS9ZbMFobz3ywhDtgb7Bk0n4jOIAIGYUvWTpaQn2zUK8B0YvfLhcsEVjtjeiGLGtTusa9iei4CBK7z+O805KM7PLrf2N562hzh0YqLEKq8tXP5nXBa6fD4IESsOUupanosryNHGflIRMrYoo8YZWG4xX1JTRDFK8AWc/A307M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZNmBzW5e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNmBzW5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C4F1F000E9;
	Tue, 21 Jul 2026 18:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659544;
	bh=w8X8xmLmXtEsUizn+3ulSxF9sf19RmwwTTQiHnZ5R98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZNmBzW5eLBHhufYmZcmvYSt+07+YNc90NNTEwO/u1LDEL5SwbHLinwE9+TZviOkk3
	 vT8Uo2P1rQzQ/rTokl+UuOaB1miWL3A5L0y84Rh6pe4gJ2l9cAYk6bntgHhGesbtxN
	 UyzHrfSRex/LAXWXC3+1ESs+DLldGQqMWfx4aOQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1560/1611] seqlock: Change do_task_stat() to use scoped_seqlock_read()
Date: Tue, 21 Jul 2026 17:27:56 +0200
Message-ID: <20260721152550.547563184@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit b76f72bea2c601afec81829ea427fc0d20f83216 ]

To simplify the code and make it more readable.

[peterz: change to new interface]
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Stable-dep-of: 6650527444da ("proc: protect ptrace_may_access() with exec_update_lock (part 1)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/array.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -481,7 +481,6 @@ static int do_task_stat(struct seq_file
 	unsigned long flags;
 	int exit_code = task->exit_code;
 	struct signal_struct *sig = task->signal;
-	unsigned int seq = 1;
 
 	state = *get_task_state(task);
 	vsize = eip = esp = 0;
@@ -538,10 +537,7 @@ static int do_task_stat(struct seq_file
 	if (permitted && (!whole || num_threads < 2))
 		wchan = !task_is_running(task);
 
-	do {
-		seq++; /* 2 on the 1st/lockless path, otherwise odd */
-		flags = read_seqbegin_or_lock_irqsave(&sig->stats_lock, &seq);
-
+	scoped_seqlock_read (&sig->stats_lock, ss_lock_irqsave) {
 		cmin_flt = sig->cmin_flt;
 		cmaj_flt = sig->cmaj_flt;
 		cutime = sig->cutime;
@@ -563,8 +559,7 @@ static int do_task_stat(struct seq_file
 			}
 			rcu_read_unlock();
 		}
-	} while (need_seqretry(&sig->stats_lock, seq));
-	done_seqretry_irqrestore(&sig->stats_lock, seq, flags);
+	}
 
 	if (whole) {
 		thread_group_cputime_adjusted(task, &utime, &stime);


