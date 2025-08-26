Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D9B35CEB7;
	Tue, 26 Aug 2025 14:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219430; cv=none; b=ng/u39EH99lGzdv2noTvBUcilXcK1XRe6tMxrWcPSDrcIs0YGT/TcXeEIz0Y29wULSQobPjCKvUJymqGmDfNwcgrpWWu5wjh+mC+L+eVL94nEfiUZXL0O007xFPzMKGNLlDlpZ5ENN3PYnKEFcRO2D0ECso4HgnRrImHjnxreNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219430; c=relaxed/simple;
	bh=WG8Wni87ldT3sV5IProCi1bLLCs5vzkBg9z5dj2XoF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRdumGAkvHcoVaLuHRf5l+dnh70aM+4F0H9XJrAPm0/3YSXpAaNF7nltaJcxlL5ZcUJlO0mD3BxddFcQ9fbMBmHUlHNBenSEQkPrDE8URQfU8qlJ8JQOLwXRiEJEDB0ZbLcxw9qguATRhpKRnhsJU7kUMDZmXUvIOzvdjQYgBNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIS8RQIg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIS8RQIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E91DC4CEF1;
	Tue, 26 Aug 2025 14:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219430;
	bh=WG8Wni87ldT3sV5IProCi1bLLCs5vzkBg9z5dj2XoF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIS8RQIgemXgALVfPH/t6cNTRpmOX+8M0GnNJak2Udumm7mFtbagyAleBhlHAc/1k
	 xH5HaxFmcKIfgotfCgQcadHKjXlnz4YBd3HUafd4orYjR94K40hS5k20wTP99Ca7Gc
	 BguMkjg+ebPNmFJoH1rkyjzg/rkm8TF3n/aAk1lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>
Subject: [PATCH 5.4 378/403] codel: remove sch->q.qlen check before qdisc_tree_reduce_backlog()
Date: Tue, 26 Aug 2025 13:11:44 +0200
Message-ID: <20250826110917.462248859@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <xiyou.wangcong@gmail.com>

commit 342debc12183b51773b3345ba267e9263bdfaaef upstream.

After making all ->qlen_notify() callbacks idempotent, now it is safe to
remove the check of qlen!=0 from both fq_codel_dequeue() and
codel_qdisc_dequeue().

Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Fixes: 4b549a2ef4be ("fq_codel: Fair Queue Codel AQM")
Fixes: 76e3cc126bb2 ("codel: Controlled Delay AQM")
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250403211636.166257-1-xiyou.wangcong@gmail.com
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_codel.c    |    5 +----
 net/sched/sch_fq_codel.c |    6 ++----
 2 files changed, 3 insertions(+), 8 deletions(-)

--- a/net/sched/sch_codel.c
+++ b/net/sched/sch_codel.c
@@ -95,10 +95,7 @@ static struct sk_buff *codel_qdisc_deque
 			    &q->stats, qdisc_pkt_len, codel_get_enqueue_time,
 			    drop_func, dequeue_func);
 
-	/* We cant call qdisc_tree_reduce_backlog() if our qlen is 0,
-	 * or HTB crashes. Defer it for next round.
-	 */
-	if (q->stats.drop_count && sch->q.qlen) {
+	if (q->stats.drop_count) {
 		qdisc_tree_reduce_backlog(sch, q->stats.drop_count, q->stats.drop_len);
 		q->stats.drop_count = 0;
 		q->stats.drop_len = 0;
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -315,10 +315,8 @@ begin:
 	}
 	qdisc_bstats_update(sch, skb);
 	flow->deficit -= qdisc_pkt_len(skb);
-	/* We cant call qdisc_tree_reduce_backlog() if our qlen is 0,
-	 * or HTB crashes. Defer it for next round.
-	 */
-	if (q->cstats.drop_count && sch->q.qlen) {
+
+	if (q->cstats.drop_count) {
 		qdisc_tree_reduce_backlog(sch, q->cstats.drop_count,
 					  q->cstats.drop_len);
 		q->cstats.drop_count = 0;


