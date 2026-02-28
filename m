Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C6B355049
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300969; cv=none; b=cCYs9T3SdWtmYqKtNfrPcgPFUiPdn9hX1+0lG4O35UWM4b+NlMTmQAEXW8Y/k7Hm+ugyBDkAi+T68lWUm5qpMAeTOTmjH9HK4POZ6a1QtKaH77LlSSU7cH+0iQckeV0Wi/mLE5Lh0rha1kPB72LSaylw90tWfQS9pAppaK5026c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300969; c=relaxed/simple;
	bh=j5xNUslQNcpWHSQ8UAeGt65hKPEGFjMUP9W6SWona0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSuNe8dnpR0K1dpYjYo0/RjAilRH7r6MwKeTZs9PXlqRqmimPOfBdP0qYAKz5dft4I9Sg7SPrmpSbqkSq5Iyrqa8X/IzCMP7GOv6k79urXjrqUzHcCmyKRyOEeEe6rFMF//azbQdWC8LC1sEdaptzAsfz77szTVquAyNdj1/62I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HnRn+1MC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HnRn+1MC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C96CC116D0;
	Sat, 28 Feb 2026 17:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300969;
	bh=j5xNUslQNcpWHSQ8UAeGt65hKPEGFjMUP9W6SWona0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HnRn+1MCF9/Rxg0MdYxFJBfcacctZZ5keBnVeJagCbY1C3tPUCxFKMRZoyYqXvGmb
	 D4QG9t4iPnufGTJ/QmRoMoQp9f7QZFeQoayCeKYQoJonlLenEzkGmYnBCh1tvCl8Wq
	 Y/jTxFC9sPSK5BfEKtg1u7TEo048Qxi+gOISHI0w9AvW5PIG4SDvtFn12awzuNfJj5
	 s7nPI/MPGzjcIJQKpXISm5hRynftYhqFZkKrVZFNLsRzzLmwTKl17yDgCvmVgbXzHb
	 5FR5TSNBPh6+FjntyiiU9RkTy7LlkQsT+wNDthtlsHcBNXweG70SvWl0UYRq0D2psz
	 Xb3P9NR80XHfg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Joel Fernandes <joelagnelf@nvidia.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Christian Loehle <christian.loehle@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 095/752] sched/debug: Fix updating of ppos on server write ops
Date: Sat, 28 Feb 2026 12:36:46 -0500
Message-ID: <20260228174750.1542406-95-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Joel Fernandes <joelagnelf@nvidia.com>

[ Upstream commit 6080fb211672aec6ce8f2f5a2e0b4eae736f2027 ]

Updating "ppos" on error conditions does not make much sense. The pattern
is to return the error code directly without modifying the position, or
modify the position on success and return the number of bytes written.

Since on success, the return value of apply is 0, there is no point in
modifying ppos either. Fix it by removing all this and just returning
error code or number of bytes written on success.

Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Acked-by: Tejun Heo <tj@kernel.org>
Tested-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/20260126100050.3854740-3-arighi@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/debug.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 41caa22e0680a..93f009e1076d8 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -345,8 +345,8 @@ static ssize_t sched_fair_server_write(struct file *filp, const char __user *ubu
 	long cpu = (long) ((struct seq_file *) filp->private_data)->private;
 	struct rq *rq = cpu_rq(cpu);
 	u64 runtime, period;
+	int retval = 0;
 	size_t err;
-	int retval;
 	u64 value;
 
 	err = kstrtoull_from_user(ubuf, cnt, 10, &value);
@@ -380,8 +380,6 @@ static ssize_t sched_fair_server_write(struct file *filp, const char __user *ubu
 		dl_server_stop(&rq->fair_server);
 
 		retval = dl_server_apply_params(&rq->fair_server, runtime, period, 0);
-		if (retval)
-			cnt = retval;
 
 		if (!runtime)
 			printk_deferred("Fair server disabled in CPU %d, system may crash due to starvation.\n",
@@ -389,6 +387,9 @@ static ssize_t sched_fair_server_write(struct file *filp, const char __user *ubu
 
 		if (rq->cfs.h_nr_queued)
 			dl_server_start(&rq->fair_server);
+
+		if (retval < 0)
+			return retval;
 	}
 
 	*ppos += cnt;
-- 
2.51.0

