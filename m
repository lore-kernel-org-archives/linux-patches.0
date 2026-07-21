Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2359F414A1C;
	Tue, 21 Jul 2026 21:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670665; cv=none; b=iCIY+QkPWLEASNHddCMHDhhi00oDN4dnfSzcUe+BOhH4GRtsXA8Cm2K2cPV0z5CdHP6sCgzn+QQOti+0XnhcCSrxIHRALL8rzH8hF4wm8/zdNxzOizklLIJHVyfwP9tZWIa4nm1Vv/T2HwQzZnsvx85n2dESKdJk8B47v8quea0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670665; c=relaxed/simple;
	bh=+00Be7ceEjLcAqQ/SDIzmsUv/zJi8EjxCsrCufLSTFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwdcUq/QtrdvuTGFeab4zrmi5exbRlaW9PvyZmfETbKMLf6e3t2DU5aKf2R+7rR5ThtEMK3MDykeD79gUqhmYTOPlETTU0vd6Oqvj3GsNFN0YabhARisN8MBqOG8Nxyx6osu6uXmeJ/OukP5UPYvHZ2U9DUPJ5ExOboHRRu34SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XnJV9fRs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XnJV9fRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809AD1F000E9;
	Tue, 21 Jul 2026 21:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670664;
	bh=ZJivGAl2vCNmea9VFOCFTJMZwyyIu8+BxZrSzR3aJGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XnJV9fRsLr0hj3uGgaRLaXbe0kWI+oOZEboFH75uy0qOJBFp+0aFlEhO73BxH2TwN
	 D99GNc4NKP5LuybBKAffjQ5unLf58uCAun2Pr4bfgAZBiZ6gRyXipPm8NSjfmsI4tY
	 ST7X0KMTwE6Nk4rd/8bC8Ce7tQXZlJWqWFpjBto0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1016/1067] seqlock: Change do_task_stat() to use scoped_seqlock_read()
Date: Tue, 21 Jul 2026 17:26:57 +0200
Message-ID: <20260721152447.299845973@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -473,7 +473,6 @@ static int do_task_stat(struct seq_file
 	unsigned long flags;
 	int exit_code = task->exit_code;
 	struct signal_struct *sig = task->signal;
-	unsigned int seq = 1;
 
 	state = *get_task_state(task);
 	vsize = eip = esp = 0;
@@ -530,10 +529,7 @@ static int do_task_stat(struct seq_file
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
@@ -555,8 +551,7 @@ static int do_task_stat(struct seq_file
 			}
 			rcu_read_unlock();
 		}
-	} while (need_seqretry(&sig->stats_lock, seq));
-	done_seqretry_irqrestore(&sig->stats_lock, seq, flags);
+	}
 
 	if (whole) {
 		thread_group_cputime_adjusted(task, &utime, &stime);


