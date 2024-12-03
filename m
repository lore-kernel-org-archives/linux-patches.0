Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C881F8919;
	Tue,  3 Dec 2024 16:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242153; cv=none; b=hyfQOV2YJVUsL7HFq1aR48Y3R65vN8LZtvGCXec3oJx5w5dC+8sbYmwQfrZi17JPmS6eedfCXHueYYyGBdGD1n5wRfFm4yEOm3PkpuLiHpIBvKUlOF7TUnG7NbavuuP2SZqBmSfAGa4wjOhuQnWpy5e7RL3NT1Hqr3/ttdUe4SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242153; c=relaxed/simple;
	bh=UU7pBpyc83pkRwuHopwMxN6yAqRv5I33uiZnfsolPbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fq+SBuQG0678X5qaM/RjfEMa7DkU7vB+MceHDWtCWk2Fh53KIbCyFiC6pu/mrjCjplyZYgrHDYJoEBwrPy+890bQ8aH1aWqpdOvj3uxW/vkaTcPrMBh7y1ZJOOdbkWNezzaCgICDF2PzSj1CTV5/S5LfIqPp/S57R6t0tMn+4rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0frSzVuf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0frSzVuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B108C4CED6;
	Tue,  3 Dec 2024 16:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242152;
	bh=UU7pBpyc83pkRwuHopwMxN6yAqRv5I33uiZnfsolPbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0frSzVuf3hJuTeoq9HKWiGoSKo7Xkcy4f+p65EmyysLKn0nrR/QTnn7YIsDtJqVC3
	 D7oXPyNckwgXEBJ+hZyGng8FIUtLITLEDyz0wpWpGHIBJJMYXkfRUcaHXmeXv+iJGK
	 lQUSVRRLJ3lUthLo06GD+nc3QxBhhBoVqdBxKKLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 623/826] net_sched: sch_fq: dont follow the fast path if Tx is behind now
Date: Tue,  3 Dec 2024 15:45:50 +0100
Message-ID: <20241203144808.056084231@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


