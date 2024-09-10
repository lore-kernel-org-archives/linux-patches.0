Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71407143880;
	Tue, 10 Sep 2024 10:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964856; cv=none; b=MsjsHUK7Q8Pji5/D/edULmrEFdLnudtrC8AlKupiLc+K7zilLWq/OhLv/ox5N/vLsVxgdlHKXWPXwdf1rD8/4RL5N4CTur/3C186syiD/Aqm5m1Fj22YvpXE/i7tYVfns5uy5f6zEjDBvznyj/+GVzO85E05dbN5XNd+ikX1vMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964856; c=relaxed/simple;
	bh=v6cFdsjkX9u6spYtB8cPbuyFv2k354SP5LgR0A+8K+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e82k8CQEL+afsNdiOibctvc7qUbFp+E23GViIE2GbbZxbf8Kg/LIQ24zCqMlwpFb0tifhF85AZCc0sgFqFYVFqDcLIf1R3R+x3CXkzo+dUz5KpFf4AuQeA8Jj/HnRchdY3irbEYpZ7re63aK20kgucHCD+BCnt6M23nhDxdwnes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=quiVIiS7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="quiVIiS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA87CC4CEC3;
	Tue, 10 Sep 2024 10:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964856;
	bh=v6cFdsjkX9u6spYtB8cPbuyFv2k354SP5LgR0A+8K+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=quiVIiS7U3U4/mVbLGpbA16UQcgjHBtE4OZdChP2g07lFUrP8ConDRhfVWLMfmJ6c
	 AvzARuP2a9UXOP4acWQa/iTy3IZrOHY7Ujk+IXq0kerEUQnXOZCaIL1RQveLhLMz0p
	 +xV5fRqfM1n+X2twrNbBA5bNCQbJXtjktQuOPXmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Budimir Markovic <markovicbudimir@gmail.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 054/186] sch/netem: fix use after free in netem_dequeue
Date: Tue, 10 Sep 2024 11:32:29 +0200
Message-ID: <20240910092556.720444753@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


