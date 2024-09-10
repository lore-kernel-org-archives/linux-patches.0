Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AAF1885A5;
	Tue, 10 Sep 2024 10:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962725; cv=none; b=n7q4HEahqfdyaxfmzTDmw3jS7/bwZD9rBeJGHNkh2YyFGg9xjVL3qTq8+rFdBXMZKrkb6H7ce+7RnyQMK0T9TOdQX9XX2UDkG2MUPsQBf1CPPwitlGJdu5YTOS6AVdUbZ6DnmpgfjIHke7pblNajypBWT0puKgv4jcvxlJkb07k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962725; c=relaxed/simple;
	bh=XXRA0mBpTqniW9/tijckUyUC/wcAzA0+M8YDdz7iXBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KC+q5ylyFKLzaJg0uDf4Qt9BzhQStzgehiOjAtTkSBEY6zHqVdzfDmhm8075msR/T647v7cHYPEiBptIhgwvWNlHaWJ5LOnG5sYqwUkUPpH1QAVqPDtSZ211nXfZn6VtxlVWV12GXhPSxTC8RyvKM+/CYBURMDxEvPLQxog0HUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TUdy2Yeu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TUdy2Yeu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC80C4CEC6;
	Tue, 10 Sep 2024 10:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962725;
	bh=XXRA0mBpTqniW9/tijckUyUC/wcAzA0+M8YDdz7iXBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TUdy2YeuBDfUz98NeeoBUMjPhjswICX3yOjOP5KFbe3/neBRvBmJ0uLTzLWfuhGsg
	 BDFnTi9TbtDN0h253qb4jBGSI1ToF6oMY1ZNVwTTmgddlHByS62yworj6mleExOCyc
	 lrE9VdWp0bqPbeCUctAS813W7f543RsXme7vwB6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Budimir Markovic <markovicbudimir@gmail.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 001/192] sch/netem: fix use after free in netem_dequeue
Date: Tue, 10 Sep 2024 11:30:25 +0200
Message-ID: <20240910092557.944134672@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Hemminger <stephen@networkplumber.org>

commit 3b3a2a9c6349e25a025d2330f479bc33a6ccb54a upstream.

If netem_dequeue() enqueues packet to inner qdisc and that qdisc
returns __NET_XMIT_STOLEN. The packet is dropped but
qdisc_tree_reduce_backlog() is not called to update the parent's
q.qlen, leading to the similar use-after-free as Commit
e04991a48dbaf382 ("netem: fix return value if duplicate enqueue
fails")

Commands to trigger KASAN UaF:

ip link add type dummy
ip link set lo up
ip link set dummy0 up
tc qdisc add dev lo parent root handle 1: drr
tc filter add dev lo parent 1: basic classid 1:1
tc class add dev lo classid 1:1 drr
tc qdisc add dev lo parent 1:1 handle 2: netem
tc qdisc add dev lo parent 2: handle 3: drr
tc filter add dev lo parent 3: basic classid 3:1 action mirred egress
redirect dev dummy0
tc class add dev lo classid 3:1 drr
ping -c1 -W0.01 localhost # Trigger bug
tc class del dev lo classid 1:1
tc class add dev lo classid 1:1 drr
ping -c1 -W0.01 localhost # UaF

Fixes: 50612537e9ab ("netem: fix classful handling")
Reported-by: Budimir Markovic <markovicbudimir@gmail.com>
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Link: https://patch.msgid.link/20240901182438.4992-1-stephen@networkplumber.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_netem.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -733,11 +733,10 @@ deliver:
 
 				err = qdisc_enqueue(skb, q->qdisc, &to_free);
 				kfree_skb_list(to_free);
-				if (err != NET_XMIT_SUCCESS &&
-				    net_xmit_drop_count(err)) {
-					qdisc_qstats_drop(sch);
-					qdisc_tree_reduce_backlog(sch, 1,
-								  pkt_len);
+				if (err != NET_XMIT_SUCCESS) {
+					if (net_xmit_drop_count(err))
+						qdisc_qstats_drop(sch);
+					qdisc_tree_reduce_backlog(sch, 1, pkt_len);
 				}
 				goto tfifo_dequeue;
 			}


