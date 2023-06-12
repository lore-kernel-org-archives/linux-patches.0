Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA07ECC
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07579C4339C;
	Mon, 12 Jun 2023 10:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566197;
	bh=2jvjnTmQczMGMsQcvYQg4v20MwWRSEREyf5mPo5juGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L7Bmq25jTOZ/jN98IJg2CT+rF56HgrOEzHvDb2UCpmOitz4nB2uRNNl/FcZcvzye5
	 eEm+SMQ8RR65rg8Dzfkwjr5mcFbfqDWdl+Zb1gIw01lapkbqVDgNr5woAH4LnNCIU5
	 n0BhKQPOguhG3w7iWcKomFNGeq+fnW3DlJJnFaVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tijs Van Buggenhout <tijs.van.buggenhout@axsguard.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 31/91] netfilter: conntrack: fix NULL pointer dereference in nf_confirm_cthelper
Date: Mon, 12 Jun 2023 12:26:20 +0200
Message-ID: <20230612101703.398593461@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101702.085813286@linuxfoundation.org>
References: <20230612101702.085813286@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tijs Van Buggenhout <tijs.van.buggenhout@axsguard.com>

[ Upstream commit e1f543dc660b44618a1bd72ddb4ca0828a95f7ad ]

An nf_conntrack_helper from nf_conn_help may become NULL after DNAT.

Observed when TCP port 1720 (Q931_PORT), associated with h323 conntrack
helper, is DNAT'ed to another destination port (e.g. 1730), while
nfqueue is being used for final acceptance (e.g. snort).

This happenned after transition from kernel 4.14 to 5.10.161.

Workarounds:
 * keep the same port (1720) in DNAT
 * disable nfqueue
 * disable/unload h323 NAT helper

$ linux-5.10/scripts/decode_stacktrace.sh vmlinux < /tmp/kernel.log
BUG: kernel NULL pointer dereference, address: 0000000000000084
[..]
RIP: 0010:nf_conntrack_update (net/netfilter/nf_conntrack_core.c:2080 net/netfilter/nf_conntrack_core.c:2134) nf_conntrack
[..]
nfqnl_reinject (net/netfilter/nfnetlink_queue.c:237) nfnetlink_queue
nfqnl_recv_verdict (net/netfilter/nfnetlink_queue.c:1230) nfnetlink_queue
nfnetlink_rcv_msg (net/netfilter/nfnetlink.c:241) nfnetlink
[..]

Fixes: ee04805ff54a ("netfilter: conntrack: make conntrack userspace helpers work again")
Signed-off-by: Tijs Van Buggenhout <tijs.van.buggenhout@axsguard.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7ff0da5f998a0..10622760f894a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2224,6 +2224,9 @@ static int nf_confirm_cthelper(struct sk_buff *skb, struct nf_conn *ct,
 		return 0;
 
 	helper = rcu_dereference(help->helper);
+	if (!helper)
+		return 0;
+
 	if (!(helper->flags & NF_CT_HELPER_F_USERSPACE))
 		return 0;
 
-- 
2.39.2



