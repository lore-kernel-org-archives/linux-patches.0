Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5E42EAE6;
	Mon, 23 Dec 2024 16:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969627; cv=none; b=fMkmj+EpGKFdVvs9Gse3ahnEdobssM4Of2uNyMNsPQZWH33J2N0B3XUpgcuSyY1sjn2uMQwaPIWcAvs2k7dQKrO0WGVeXMtFrSb57SYJhyjMsdKQQhNydKLXAmL5qlljU9BYZjnKp/BgClQfq9wiruZAFgdRW1V8QTCsP9Ki234=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969627; c=relaxed/simple;
	bh=9kl65oGysugmx+2SoHMxxfh3ZBK+HJPg1WOVJAtppXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UA9HFeRGwDEJknVhUP5msdr/BinAluQUiPnI7yb2kWhnPnaJQk7cFFVHzV6iLs2/SdivKq4VF0zEL6bbMjjnLmitkCMWOTX+0vNTCXEk2LXgaHuUsLox+zFRnyjIhqIhygXWbyUGen6rhZx2FUQkMTSEp72gGSwCWJLXSPer5wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ICkgtWNy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ICkgtWNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236CEC4CED4;
	Mon, 23 Dec 2024 16:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969626;
	bh=9kl65oGysugmx+2SoHMxxfh3ZBK+HJPg1WOVJAtppXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ICkgtWNyrVr9E7xhk3HcHsqdqnjLgDzHDt2N91gNuXrr3Ve3HiJamfyTeXzPgrXEh
	 uGsXZe1GryZOsqcNlA8qAk4uF4/SG1RmV+SwSJjYxDCJbEqNG6pwO/DrMBqV7ZD7W8
	 38QbIivwOLYPmcRtBxMluPscj1kdSZtDu3PTq5vU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lion Ackermann <nnamrec@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	"David S. Miller" <davem@davemloft.net>,
	Artem Metla <ametla@google.com>
Subject: [PATCH 6.12 001/160] net: sched: fix ordering of qlen adjustment
Date: Mon, 23 Dec 2024 16:56:52 +0100
Message-ID: <20241223155408.657875765@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lion Ackermann <nnamrec@gmail.com>

commit 5eb7de8cd58e73851cd37ff8d0666517d9926948 upstream.

Changes to sch->q.qlen around qdisc_tree_reduce_backlog() need to happen
_before_ a call to said function because otherwise it may fail to notify
parent qdiscs when the child is about to become empty.

Signed-off-by: Lion Ackermann <nnamrec@gmail.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Artem Metla <ametla@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_cake.c  |    2 +-
 net/sched/sch_choke.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1525,7 +1525,6 @@ static unsigned int cake_drop(struct Qdi
 	b->backlogs[idx]    -= len;
 	b->tin_backlog      -= len;
 	sch->qstats.backlog -= len;
-	qdisc_tree_reduce_backlog(sch, 1, len);
 
 	flow->dropped++;
 	b->tin_dropped++;
@@ -1536,6 +1535,7 @@ static unsigned int cake_drop(struct Qdi
 
 	__qdisc_drop(skb, to_free);
 	sch->q.qlen--;
+	qdisc_tree_reduce_backlog(sch, 1, len);
 
 	cake_heapify(q, 0);
 
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -123,10 +123,10 @@ static void choke_drop_by_idx(struct Qdi
 	if (idx == q->tail)
 		choke_zap_tail_holes(q);
 
+	--sch->q.qlen;
 	qdisc_qstats_backlog_dec(sch, skb);
 	qdisc_tree_reduce_backlog(sch, 1, qdisc_pkt_len(skb));
 	qdisc_drop(skb, sch, to_free);
-	--sch->q.qlen;
 }
 
 struct choke_skb_cb {


