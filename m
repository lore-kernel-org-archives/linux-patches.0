Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D160F4594E;
	Wed, 30 Sep 2026 18:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791268; cv=none; b=b6iOERBezPy0hYJ86Nv7UH8hADjNfcCSliqYHNc00xklzsrZX1ZDue2gisgYUKv5haMRWr8A9Xmupx43oISkpJij5vXDp0S5WhrnSprQGhU5nd2eRFwAAcafzfuMlFABt8gNVr5ei4vfcFr+WEbvKSUo+q7ri4Fb9gEGLg/4giE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791268; c=relaxed/simple;
	bh=4/cj3hD5hi27oYZi4KvnL3W2cYavzzOKYznx+2/sy6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDf6KO+zcS2R05QHz/0RE7bKtMx/PpHHYFj7JM8fWhXP0uOWrNH46BZnwm5K4kO5RiK5FpY6QIlcDvAIEoctCefYylLQomoKU3bkSUfTKGUGlHqDO6/ckjCJuRNG5NGSjiiqg366A1WGNlXF8OlwzepN1+pDYGjOhTs8LRXUAOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVGljiEz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVGljiEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4691F000FF;
	Wed, 30 Sep 2026 18:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791266;
	bh=DS042EsCa9uXUIK1vr3xu+vm9Is93ruO+a2yDrJMgmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QVGljiEzERXqIzwegqxxF4GPwRNT68JdDlPbPS0kSolgC1ByhIb41PQQLFz7Gh9AL
	 61xBR4y0pLm4ACAnXuDy+q0iW1m/JuwRJh4M/wjmnoRQQESrRscHX1S/LaVHh8ajYQ
	 H5BJt/bvtGsbJ5wxycz08bTJTPAie5gXRIvakhGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 242/752] net/sched: act_api: budget all shared attributes in notify skbs
Date: Wed, 30 Sep 2026 17:21:52 +0200
Message-ID: <20260930152403.505645278@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 20944a2e162e7..bdbb62537b6c3 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -208,12 +208,21 @@ static size_t tcf_action_shared_attrs_size(const struct tc_action *act)
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



