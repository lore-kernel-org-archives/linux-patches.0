Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C02E3E022C;
	Thu, 17 Sep 2026 17:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665187; cv=none; b=ou9rVThw/p6+B1xVLFYXKdwot1xi1qjIn1zl1Y3bdx4GPuGVrf0sZEpM29826nkC+JYi47nTzmX3IDdPPpFeu3vb3pKPtX1AUnGd7k1kgl4m2LAKWONEE2AxExVdB6OxemXgldYQaw25Anokt/sJ0vssK+cV5BBF+tDFuij+YPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665187; c=relaxed/simple;
	bh=GCBXAjXroTtCCKqi6fdfKb3fOLt68mLzvEZjgF0c0tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YItmR+dIIOVa65AGp9ueUy9Mrd8RaBdIp1txwCy1urXaH6X5JrQTwvjcydSJ6oovwNkMrhUyXTSf15aYh5myvvLxiHS+QqjfwrSg2csdJ8EhHDqoFT5x1W3UF4mWx5raJqxUDAlzn/OpbqnWcGYv/ry23HyxrNT+CwYOZB3gMpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PYhYL0mR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PYhYL0mR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7AF1F00893;
	Thu, 17 Sep 2026 17:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665186;
	bh=aEV+EIrQXXvXbA0plMrV0ksVCU+nPmtmaKTzVoMI5qM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PYhYL0mRgI+8KoeKCVUZz9hqGS+IdYOSPn0v24tSIU6ZFhTAS5j9BlLQVZxveY8Re
	 yr3mrnEYA/Y7Yd/j0u8dkExqqA9c8AEYE+LJg6SwOQjvwwsmdMYMAdkT9oERbbmlEo
	 k3iEOUsu98sQcMVNYhfQjYWsfCPeDbO2q3I1Mwa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0621/1250] net/sched: act_api: budget all shared attributes in notify skbs
Date: Thu, 17 Sep 2026 16:06:56 +0100
Message-ID: <20260917151608.706788874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6fc6a986a7991..c1b1316c96eb2 100644
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



