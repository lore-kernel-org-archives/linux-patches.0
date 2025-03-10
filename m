Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0982D023;
	Mon, 10 Mar 2025 17:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629389; cv=none; b=MEf5yFW/Sq1Q2sl9pfVattH2amSgs5j6h03A+gfh4t8TbvGtM3SUE1mN7PBvvoZoOe9lrkLAOpw+qeyvy28mf15LccY6dMnbijEulz3lIRrju3uKotxPdGSKxEZ9WeIPFc/MdTa2zCx/88e2ZBs6nGP9Wv593qpEBhnjH5LvXn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629389; c=relaxed/simple;
	bh=N4CvQvDRZWfi1iPA9PsRt311EZpU2+cr3Ib8Noj9HXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbg+fptoHuGCoeTf7tz2p2RHBNMY3dQxWjK+Qw/QaTbRg/e7OmJTYmLd/6YQ34THwHrRKJKD2GOaxvDKXBB3z4NtsySl530Pqa+o0b3B/J7HMHB//flLaMhu4AyUYXMF7wcdrvDEBrQ4Vo64wMSxRXlh6mohUW4aJV75rwm0xqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQ3sNpcr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQ3sNpcr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98AEFC4CEE5;
	Mon, 10 Mar 2025 17:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629389;
	bh=N4CvQvDRZWfi1iPA9PsRt311EZpU2+cr3Ib8Noj9HXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQ3sNpcrmVELH8HF+UlVZUf8w5hBlfQ0E4LT6EIZvtHLa//RVgMuWyBNnIV8SD/hX
	 a7RxtEPkdpCg30ZFUJ1AESk3j6F1MBvsMFgsd85vXn3Pj8jHf3NKnTppzy3W3EeIhJ
	 Xw027It6I0JNqz58RGBCWJV7iLF5kchAUZazWJnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Ottens <martin.ottens@fau.de>,
	Mingi Cho <mincho@theori.io>,
	Cong Wang <cong.wang@bytedance.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 250/620] netem: Update sch->q.qlen before qdisc_tree_reduce_backlog()
Date: Mon, 10 Mar 2025 18:01:36 +0100
Message-ID: <20250310170555.493617174@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f459e34684ad3..22f5d9421f6a6 100644
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



