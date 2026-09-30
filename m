Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F60050279A;
	Wed, 30 Sep 2026 15:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782861; cv=none; b=c+aUx9NdT60k7pLVoBzcwO8/2k93Ul9dflyAmPifVLskfwgQOUjW+Kg1hyd3nkS1myIxDCPKSH+eohoPtwBHW+V6inOkjokHK5EQZ72YRgi5F5kiRCsOvcUua+/z2FiqTxCdJW1ve8WMeBnD24RgrAMCUAZnXAQqbK5k3eiTbxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782861; c=relaxed/simple;
	bh=rdgle9xYNqWg3gPtomxQ8e2LEYuvlnLi20I9vG+xsCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=POvnaCkcGymwkDaHukA4XuslwMffFZKdjU0L2cS0UbF4p55PkQJUDz+rQVkCOoSVYxHy5o6EzcLYWOZ+ek3jx63oR8tFGWVkh96Ai9umGW6Xlo+q7lroymTXSp7hme3pMitOVp2RtE4tdfLGT5e58AZKFaO7QS27gUXVRFGX8pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XfmnPrzp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XfmnPrzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CEA51F00899;
	Wed, 30 Sep 2026 15:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782857;
	bh=KYai2Zmz4EICauQoZlqg6rYiD30ycT+vLGgA9QWM/SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XfmnPrzpYcJ0IaeXKzuqEgXmtWQf4kma/r75ZrgYCI+EBazPyg6pAb4Ta26FWmADh
	 8vfVz1aNuc2+Lx8WWkrLWYtcgpqAb+jpVCZwWvE9AFuVtnnEI8YD0Mrb7LLcgo7mWy
	 K/fqN3WA0nHz04TRULZqI2WB2n1l86DUBJw2VDBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 193/595] net/sched: act_api: budget all shared attributes in notify skbs
Date: Wed, 30 Sep 2026 17:21:26 +0200
Message-ID: <20260930152351.891837047@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit 13eb543cebef6d6c3ec42e31afe3856f51b7126b ]

tcf_action_shared_attrs_size() is supposed to return an upper bound on the
netlink attributes every action dump emits outside of TCA_ACT_OPTIONS, so
that tcf_add_notify_msg(), tcf_del_notify_msg() and friends can allocate
an skb large enough for the reply.  It has fallen behind the dump path and
is now an underestimate for every single action.

Attributes, such as, TCA_ACT_IN_HW_COUNT and TCA_STATS_BASIC_HW are
emitted unconditionally and never accounted for. TCA_STATS_PKT64,
TCA_ACT_USED_HW_STATS, TCA_STATS_RATE_EST, TCA_STATS_RATE_EST64 require
specific conditions, but are also not accounted for.

Fix the issue by budgeting all of them so that we have a legitimate
upper bound. Even tough for of them require specific conditions, they
are cheap so, to avoid overcomplicating, we opted to account for them
unconditionally as well to account for a real worst case scenario.

Fixes: 4e76e75d6aba ("net sched actions: calculate add/delete event message size")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260810164357.1653956-1-victor%40mojatatu.com
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/20260824153903.4143642-2-victor@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_api.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index c724eea8cf8c5..0af7de8eaa538 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -192,12 +192,21 @@ static size_t tcf_action_shared_attrs_size(const struct tc_action *act)
 		+ nla_total_size(IFNAMSIZ) /* TCA_ACT_KIND */
 		+ cookie_len /* TCA_ACT_COOKIE */
 		+ nla_total_size(sizeof(struct nla_bitfield32)) /* TCA_ACT_HW_STATS */
+		/* TCA_ACT_USED_HW_STATS */
+		+ nla_total_size(sizeof(struct nla_bitfield32))
+		+ nla_total_size(sizeof(u32)) /* TCA_ACT_IN_HW_COUNT */
 		+ nla_total_size(0) /* TCA_ACT_STATS nested */
 		+ nla_total_size(sizeof(struct nla_bitfield32)) /* TCA_ACT_FLAGS */
 		/* TCA_STATS_BASIC */
 		+ nla_total_size_64bit(sizeof(struct gnet_stats_basic))
-		/* TCA_STATS_PKT64 */
-		+ nla_total_size_64bit(sizeof(u64))
+		/* TCA_STATS_BASIC_HW */
+		+ nla_total_size_64bit(sizeof(struct gnet_stats_basic))
+		/* TCA_STATS_PKT64, emitted by both of the basic copies above */
+		+ 2 * nla_total_size_64bit(sizeof(u64))
+		/* TCA_STATS_RATE_EST */
+		+ nla_total_size_64bit(sizeof(struct gnet_stats_rate_est))
+		/* TCA_STATS_RATE_EST64 */
+		+ nla_total_size_64bit(sizeof(struct gnet_stats_rate_est64))
 		/* TCA_STATS_QUEUE */
 		+ nla_total_size_64bit(sizeof(struct gnet_stats_queue))
 		+ nla_total_size(0) /* TCA_OPTIONS nested */
-- 
2.53.0



