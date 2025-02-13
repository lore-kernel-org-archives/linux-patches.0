Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8A215539A;
	Thu, 13 Feb 2025 15:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460314; cv=none; b=oSG3QM4U0SU0Me5TfxF2P+u6rgl4QlnroU3NAhMionEm7aEGhwA98jPB1WhqS5KELVXMc1BHX99hFj/JxM4p4gBxtyzp0HWkOtjDTo8Nf6O8CgQms7+Vdvve6Ovo0WP8cjGK2kzhkCqVg7NUvWPaRC2vwgAmYfqez575ETx8FJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460314; c=relaxed/simple;
	bh=2nVip/ek+opnhgHPpZAPDSVsAyzjT+LZu1qI+7yfdSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dn+BUrcv/+vrodP9XtjIV0x+ib1lgB9XSwLflTA8GkAtFBRvH82FV/0q4H9Mm3FJpzF8Uc7hAqGFLjf2EH6EuMe0TnssWzdAzjbtpz4heD4v3qJRwoYHcmW5PC2AX8CNioOE0HHwAj6ee6FayI+9msRyKjT2/hYolOEzHvhuCdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CBzTV4Yl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CBzTV4Yl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9AEC4CEE8;
	Thu, 13 Feb 2025 15:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460313;
	bh=2nVip/ek+opnhgHPpZAPDSVsAyzjT+LZu1qI+7yfdSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CBzTV4YlO9JOeuanLssZdyoyE9GB4DSWK1xd4cfMLiT/HelCLwDHlm4kqrFibrl70
	 y8XrvFMdvdzkLN1y+QIKhDE/IeSbj1iaZhghnFwZvfVNfCbJejPaTjjNIbGWH7SDyU
	 rVwQkkmPjn6E6BZ7deN97TMgbYXRCmdlyKd1dfP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Ottens <martin.ottens@fau.de>,
	Mingi Cho <mincho@theori.io>,
	Cong Wang <cong.wang@bytedance.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/273] netem: Update sch->q.qlen before qdisc_tree_reduce_backlog()
Date: Thu, 13 Feb 2025 15:27:29 +0100
Message-ID: <20250213142410.391113599@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 152dbbe8fd31a..447d3e836a24f 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -748,9 +748,9 @@ static struct sk_buff *netem_dequeue(struct Qdisc *sch)
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



