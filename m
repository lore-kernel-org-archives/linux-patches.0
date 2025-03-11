Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7ECB25D8E8;
	Tue, 11 Mar 2025 15:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705672; cv=none; b=aQ4SfZEPw248Ev7lJR/kHa8T3AyIwJxR+AlHJkJJkPflkG6/TrlnKMUWeqphRCVdpDGto2AaoKnMKDMRi1uKD4GX4VaO6+KAMZN63W6NgWu9kXug22tq7TFhlxKAygtCK8nz/iZS5DSmSVruYaCRrma1MKLXlHOQ5ft2xHxM5wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705672; c=relaxed/simple;
	bh=7us1H0Y8ZXGLq8oBNN6b8ovgQUoNgCFTaY19bVyZ51s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sw7nSOae1FxN5t+6h1/HCJZlbChzI4oI5bNdl71pKFdliC+ZQLNa6C3ZaEdbj2n1awKXG4soy3Jgs92zkO40/ApO12t0CZyLN4L9oMvBs43C4qvJOw4KHqOIR0WueTjMLsZN0/6M/lISkiZB0bB/Fwxpb73foZ6JHR07P/jC2kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DllIP9Sr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DllIP9Sr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB769C4CEE9;
	Tue, 11 Mar 2025 15:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705670;
	bh=7us1H0Y8ZXGLq8oBNN6b8ovgQUoNgCFTaY19bVyZ51s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DllIP9SrAU5P88VWPoUiH0otAqoUACxrhfk9gNTeGnMgE2QNEjchgUeYIFWUAV/Ov
	 RLUQmMNyAI0uegepVBmb2uemyPT2ZiSurHvMIZ8bHvXPshzX+169RtRhBEx906st3v
	 FDfvNdsSIxlDq4qpiFCmCfUPU5Cf+4GqIAA6mlM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Ottens <martin.ottens@fau.de>,
	Mingi Cho <mincho@theori.io>,
	Cong Wang <cong.wang@bytedance.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 115/328] netem: Update sch->q.qlen before qdisc_tree_reduce_backlog()
Date: Tue, 11 Mar 2025 15:58:05 +0100
Message-ID: <20250311145719.467358510@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit 638ba5089324796c2ee49af10427459c2de35f71 ]

qdisc_tree_reduce_backlog() notifies parent qdisc only if child
qdisc becomes empty, therefore we need to reduce the backlog of the
child qdisc before calling it. Otherwise it would miss the opportunity
to call cops->qlen_notify(), in the case of DRR, it resulted in UAF
since DRR uses ->qlen_notify() to maintain its active list.

Fixes: f8d4bc455047 ("net/sched: netem: account for backlog updates from child qdisc")
Cc: Martin Ottens <martin.ottens@fau.de>
Reported-by: Mingi Cho <mincho@theori.io>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Link: https://patch.msgid.link/20250204005841.223511-4-xiyou.wangcong@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_netem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 73c952d482752..27bd18c74e858 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -739,9 +739,9 @@ static struct sk_buff *netem_dequeue(struct Qdisc *sch)
 				if (err != NET_XMIT_SUCCESS) {
 					if (net_xmit_drop_count(err))
 						qdisc_qstats_drop(sch);
-					qdisc_tree_reduce_backlog(sch, 1, pkt_len);
 					sch->qstats.backlog -= pkt_len;
 					sch->q.qlen--;
+					qdisc_tree_reduce_backlog(sch, 1, pkt_len);
 				}
 				goto tfifo_dequeue;
 			}
-- 
2.39.5



