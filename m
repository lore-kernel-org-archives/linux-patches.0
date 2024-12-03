Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22E52D7BF;
	Tue,  3 Dec 2024 15:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239471; cv=none; b=EGomRymEVzdlLzef8AEKFInU+oOWKPGRee7B+/6S5z6H5Cx49Ry9Sqfnf7vEV5JGbeFeu86uLpax+ZrYZNuvGmwI2YwvX0xp9INrey2TJP7Qax3nwvjMnGVwgOr6uKvN/H0+oyP4klHSdr6dee3zqwqxLC2KPqFDl/82ur2I5wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239471; c=relaxed/simple;
	bh=bIH1DQ/EmuhHrVVY87X4xLLY+A/Eeoo8vB0ne8KvVRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNemvIY8zXFoHAbpwJYYGs3a75E36AaZPT+AIJ9burS7pvjw3x0sI2F9HlCaBLSf2v/Q+rYx2acWpxquegofAsTH4Smy8jHQ7HGlkr3ahc0wedc3ZPIMgqxG3adlcIpsXB6GUcMWKlnq4aobj+qEbafgpr+IfSF6bho4OYybCGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bx8BrNl3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bx8BrNl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2BDC4CED6;
	Tue,  3 Dec 2024 15:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239471;
	bh=bIH1DQ/EmuhHrVVY87X4xLLY+A/Eeoo8vB0ne8KvVRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bx8BrNl3XasBoZMDcv+tfOw/bHwFTYcD9oNe/rMjURAMyFPJ23zBezSoWuT4l4C7X
	 QKc32TIjRCcbFeZgae+ygRoMLHZhAqQERSi5nEjST+KOse4IOi+kU/WNzgqG1qyPjq
	 nMgx0wz7Gw4ecWWBp1It9Mfflhuq0iL5tQ0O8KMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.11 626/817] net_sched: sch_fq: dont follow the fast path if Tx is behind now
Date: Tue,  3 Dec 2024 15:43:18 +0100
Message-ID: <20241203144020.371540547@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

commit 122aba8c80618eca904490b1733af27fb8f07528 upstream.

Recent kernels cause a lot of TCP retransmissions

[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  2.24 GBytes  19.2 Gbits/sec  2767    442 KBytes
[  5]   1.00-2.00   sec  2.23 GBytes  19.1 Gbits/sec  2312    350 KBytes
                                                      ^^^^

Replacing the qdisc with pfifo makes retransmissions go away.

It appears that a flow may have a delayed packet with a very near
Tx time. Later, we may get busy processing Rx and the target Tx time
will pass, but we won't service Tx since the CPU is busy with Rx.
If Rx sees an ACK and we try to push more data for the delayed flow
we may fastpath the skb, not realizing that there are already "ready
to send" packets for this flow sitting in the qdisc.

Don't trust the fastpath if we are "behind" according to the projected
Tx time for next flow waiting in the Qdisc. Because we consider anything
within the offload window to be okay for fastpath we must consider
the entire offload window as "now".

Qdisc config:

qdisc fq 8001: dev eth0 parent 1234:1 limit 10000p flow_limit 100p \
  buckets 32768 orphan_mask 1023 bands 3 \
  priomap 1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1 \
  weights 589824 196608 65536 quantum 3028b initial_quantum 15140b \
  low_rate_threshold 550Kbit \
  refill_delay 40ms timer_slack 10us horizon 10s horizon_drop

For iperf this change seems to do fine, the reordering is gone.
The fastpath still gets used most of the time:

  gc 0 highprio 0 fastpath 142614 throttled 418309 latency 19.1us
   xx_behind 2731

where "xx_behind" counts how many times we hit the new "return false".

CC: stable@vger.kernel.org
Fixes: 076433bd78d7 ("net_sched: sch_fq: add fast path for mostly idle qdisc")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241124022148.3126719-1-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[stable: drop the offload horizon, it's not supported / 0]
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_fq.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -331,6 +331,12 @@ static bool fq_fastpath_check(const stru
 		 */
 		if (q->internal.qlen >= 8)
 			return false;
+
+		/* Ordering invariants fall apart if some delayed flows
+		 * are ready but we haven't serviced them, yet.
+		 */
+		if (q->time_next_delayed_flow <= now)
+			return false;
 	}
 
 	sk = skb->sk;


