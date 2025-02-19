Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BB11E3DE7;
	Wed, 19 Feb 2025 09:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956879; cv=none; b=SwckveGDS3Ny6Qx9eF3HW0CCee7RL2RB5NNNHqLV9un+7dbaVF2+seoR1sLScn+qo+0Sqrs1b1jiDQwtYjgiMV0nk4EjQGh1N7aWmFbA8NIMAO7To+minzwFPdjracO4RdS5eVz3j0Mj0kBIK5eX92sGRryyE42QNKrx9W0aL6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956879; c=relaxed/simple;
	bh=fQIwmghrFolkSajr7C0YDwyYzX6rXw5Exb/tis46aDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NT3A9feWtC+iKbRM9eYOVnnu3TsVxvbdHraH+MC9rID4mWLI0F/4NACMP/IIdLeQQlZklEwSFapu7khZCTtt7jhgHyZzajR8Wh/kYPnjGXqrFUJPJT94e3pN1RC5FK7Cm8FX+5E7mO+cHI0ZRGuaC7yZCudJWpV1G5hKjzHha4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+hs3WNB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+hs3WNB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4108EC4CEE6;
	Wed, 19 Feb 2025 09:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956878;
	bh=fQIwmghrFolkSajr7C0YDwyYzX6rXw5Exb/tis46aDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0+hs3WNBQyxVtz+GGbNSS2f+qQEmzvWsjTTNOpXtIEnJhA/EThS7Mvv2qBRwCex/x
	 aczHyyVhHCR3w1l1gHtKEjbsSRr+Z3VXBmMHiqdAtNXKzdGuSsoHJmzAnpYGRkD2kG
	 YzujvnuHQTm/kjwYC9V4qdW3Tr9zhvvLpPLx5MLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Ottens <martin.ottens@fau.de>,
	Mingi Cho <mincho@theori.io>,
	Cong Wang <cong.wang@bytedance.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 332/578] netem: Update sch->q.qlen before qdisc_tree_reduce_backlog()
Date: Wed, 19 Feb 2025 09:25:36 +0100
Message-ID: <20250219082706.077522113@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f47ab622399f3..cb38e58ee771d 100644
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



