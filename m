Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A268747141D;
	Tue, 21 Jul 2026 20:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664422; cv=none; b=mweDph1ULQs1L7Wd6BAuWTH1N+cPQkcg9N6T1pkucyNf+YcloAOh1Jdxd47hPas0+2EJ2EzEeik/L5iVVHyaJW5dM9j6D5w4Asqfth9ke/pU2pUfEyb6TdX4Jd4H7eBrTzyB2FTunhoQ8hSj8+EvYtzTfxT1cFRFKat+3rbyEgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664422; c=relaxed/simple;
	bh=P0zqhv/kON3Hu5tvVfoemTll2y56iiffna2QW6w3bB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlMSKv2zHuQjxTUBwPKBi2buseClVvu/0cPnWTuxPGzHCrDv/zLVsubA7yqvs5GyXh+DW/ZRPB+s1JV4k/Dq/QeHipC8sFIXrtL17pmeQ5CurlXUEaS62ihZZFZG6Z8xp8VrsEMGExV0ER9fWUspGhBy/jHuJLthM8emPg3HViQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2TzNm00y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2TzNm00y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0738B1F00A3A;
	Tue, 21 Jul 2026 20:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664421;
	bh=PjJa13l/jbJ3hWaOoIyD+s3ZaN75DDWu44DdhwHiqZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2TzNm00yIVfnBufiqxdcGqAa7fee0h828HXwj9Ua5NRXrK8IExer56fOWN4AXKPdh
	 WE6NZPjOEIqo5QSKSJwvW6dsYB4yPcihmr8QVEU8NZ21Xxls8TTYuuVyezOdP42YBK
	 W7pZh88u7vNZ2I82whgpxzdGmwxrkr0sFi103qvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1192/1276] seqlock: Change do_task_stat() to use scoped_seqlock_read()
Date: Tue, 21 Jul 2026 17:27:15 +0200
Message-ID: <20260721152512.725665112@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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


