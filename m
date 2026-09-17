Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03A77081A;
	Thu, 17 Sep 2026 18:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668835; cv=none; b=VhNs/EBcPS+SOCZHOHw5D6uOyOytY83Kp/CypeHFP+59QsnvHS2INHKdyYZKZpZNOG8cp/yMHELb28DhCMlWA0WqJS5bSooVNBetTMOdDC0E2zXQLnmHwEI9g72dw7kCIuLuRNC4EUvjERriemGQyZ2kgFrusgyApyYs3XRN4XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668835; c=relaxed/simple;
	bh=9KWx1QY79MLKJ7BZwysWU86fdpcEm4q5xoQ7HnjgpD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmyMTgpgO19ws8fUka1iU5M7sPlI5AURPfwxnyh8zKNbRD7rl7vpaYuOf18rheNo7gKraeD4Phch7MxE/Tj0IG0Och+EsccS//cSRkPGUq1zTJdIf88E1xfPjuBNFxkiXjWb+k9znXFigLK17KkwjAyoLn+evdTbLeF/2vA9gW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCkjkSjA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCkjkSjA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018D81F000FF;
	Thu, 17 Sep 2026 18:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668833;
	bh=UeFAgbw++xUHeL9gUeT0XHVTiPefTdPe2vBZUD28sq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MCkjkSjA6Vj4y3YjN/3ihoV+FYPH5vOwgO+Gnat9jkg/43W9zl+6ImaVGcPdORmGq
	 01JAF/s9HPmBCD2SzWCRpF5bZsdn9sJOoIfvxQ7SzDhF50rR+VNVJMU+z8PFipatNL
	 RSvsSGfkfYac745RDJRX7EeQofCUc1qBCawIjc2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0518/1102] net/sched: act_api: budget all shared attributes in notify skbs
Date: Thu, 17 Sep 2026 16:07:41 +0100
Message-ID: <20260917151552.774726015@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a5330dfef4123..ba770defd54d8 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -443,12 +443,21 @@ static size_t tcf_action_shared_attrs_size(const struct tc_action *act)
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
 		+ nla_total_size(0) /* TCA_ACT_OPTIONS nested */
-- 
2.53.0



