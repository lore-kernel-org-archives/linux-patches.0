Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D32243B6E1;
	Tue, 21 Jul 2026 21:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667838; cv=none; b=mDRzbqgIF03N0A+fygfpByLUuMpw38LtoVfhIcoDWCKdGak5VDyfewpDQVY4y8BYIa5vBK0vmrBZXuhSd9PkNjQ3laVR6gth8aYfox/DexJM7oFlQnw70eq4JjY39KlsVXJgjbusxsbpqKpOHLQNsuB6JvU8qn8TGzNcqFEIQTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667838; c=relaxed/simple;
	bh=S4gqifQwTfw9NvzHiMSOGnjbX5EOEVtyTS2qsIcWSeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMmCFODJNFyq5UWurS/4oIm0s6tU//P0V9e02t9UlSn9jzC3jFid4tcJop4oVKqSngET7QTc434rgjMSfvUkKxQrIKR7NfAj6YnMJBKpH76mVXhR0uSEyDV6DcrbW45qUVMWrZ5ExRQgcO/zJ9gpt3zP571F5EY2uTcn234ZmCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YFgQjH8h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YFgQjH8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7181F000E9;
	Tue, 21 Jul 2026 21:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667835;
	bh=BYIbVP7GwrwxsNONCU3T09ikrnOKxOebZmTaknaQLRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YFgQjH8hs34iq2+T5nzTmCepuz52jXc+oUaLqhWxU8gb6uWsVJZmpWsyL9QqHhvMS
	 o+Go+UrtMAbmrgIXShs0fJ3oN7p5efSmhi9lQ34lYadtEpdp1Lxj0wSsRRNTkV8s8j
	 OVcmfc4XsytA9LlUTNaRYYSLR8xI79+Ag5XVB1xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1212/1266] seqlock: Change do_task_stat() to use scoped_seqlock_read()
Date: Tue, 21 Jul 2026 17:27:29 +0200
Message-ID: <20260721152508.921215195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -483,7 +483,6 @@ static int do_task_stat(struct seq_file
 	unsigned long flags;
 	int exit_code = task->exit_code;
 	struct signal_struct *sig = task->signal;
-	unsigned int seq = 1;
 
 	state = *get_task_state(task);
 	vsize = eip = esp = 0;
@@ -540,10 +539,7 @@ static int do_task_stat(struct seq_file
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
@@ -565,8 +561,7 @@ static int do_task_stat(struct seq_file
 			}
 			rcu_read_unlock();
 		}
-	} while (need_seqretry(&sig->stats_lock, seq));
-	done_seqretry_irqrestore(&sig->stats_lock, seq, flags);
+	}
 
 	if (whole) {
 		thread_group_cputime_adjusted(task, &utime, &stime);


