Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC71B25F7B9;
	Thu, 28 May 2026 20:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000358; cv=none; b=rfEX0m1igDF5jsreg7EzNIgwhnegnyoO8545YSN7gsskJKSd3DfSSMKooN2WndxBEI5KoMUoPHS6GJURBr0AdCaTDhXb2eHqbNMCMeBxsmjg2DEvpfbo8HHT0N+pNk8MTwCdROIXbZfAK54tphGgTx560LyaXL9NIniIVjdcKqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000358; c=relaxed/simple;
	bh=5S0JcrHqSXBplwqJ3SMyZGywdumIaFmjBKlb3c4CA1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HG0q5rG4ykK9hyE101BKPl8jk1IqET0DCUzUZ6Obbfv3yf7f/rjxLQ19nz4Pz6H3z7cuqcvOBCbMrzHHEyCG4KWJ9f8CaymQBBt5ZhoJrY4xfOvKVzxL5DEzFIbQwZCtB0+kEzVY9td+dQGcaSF3zYZ8Ic5cLpJ/mSCbTdb+18c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gaLgfCiO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gaLgfCiO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF641F000E9;
	Thu, 28 May 2026 20:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000357;
	bh=dzFWxreiYZ1Qi06heBa6xo9sh45XUX9RfKxII02EeZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gaLgfCiOKr8FP8qlghPaR8wSFbiced0lhsF+3dnVdPYI2qi+SJ8ULbKZSxsJ2X+4Q
	 9pNm/NTd4A2Xh0f1x3M7sPlEf2Ly36JqH7vAct75ca/7tzhYS0rezizcglpxp+HbnW
	 kFwRiFX74Zt/iJC/YAtTIMtlLjh5Ohipy2idM8M8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuri Andriaccio <yurand2000@gmail.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Lukas Beckmann <lbckmnn@mailbox.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/272] sched/deadline: Always stop dl-server before changing parameters
Date: Thu, 28 May 2026 21:46:31 +0200
Message-ID: <20260528194629.863626682@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Juri Lelli <juri.lelli@redhat.com>

commit bb4700adc3abec34c0a38b64f66258e4e233fc16 upstream.

Commit cccb45d7c4295 ("sched/deadline: Less agressive dl_server
handling") reduced dl-server overhead by delaying disabling servers only
after there are no fair task around for a whole period, which means that
deadline entities are not dequeued right away on a server stop event.
However, the delay opens up a window in which a request for changing
server parameters can break per-runqueue running_bw tracking, as
reported by Yuri.

Close the problematic window by unconditionally calling dl_server_stop()
before applying the new parameters (ensuring deadline entities go
through an actual dequeue).

Fixes: cccb45d7c4295 ("sched/deadline: Less agressive dl_server handling")
Reported-by: Yuri Andriaccio <yurand2000@gmail.com>
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Valentin Schneider <vschneid@redhat.com>
Link: https://lore.kernel.org/r/20250721-upstream-fix-dlserver-lessaggressive-b4-v1-1-4ebc10c87e40@redhat.com
Signed-off-by: Lukas Beckmann <lbckmnn@mailbox.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/debug.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 7d14e9fa53ac3..564ea17ae405e 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -378,10 +378,8 @@ static ssize_t sched_fair_server_write(struct file *filp, const char __user *ubu
 			return  -EINVAL;
 		}
 
-		if (rq->cfs.h_nr_queued) {
-			update_rq_clock(rq);
-			dl_server_stop(&rq->fair_server);
-		}
+		update_rq_clock(rq);
+		dl_server_stop(&rq->fair_server);
 
 		retval = dl_server_apply_params(&rq->fair_server, runtime, period, 0);
 
-- 
2.53.0



