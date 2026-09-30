Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06EB445D93F;
	Wed, 30 Sep 2026 16:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784942; cv=none; b=MRZONjont9uJxBN9RUpnvhGsnZFOLKdO1Nm9p2qMj3WBpMnBzd9S94Eonn4cnQNCsUfl4nlhALygmE5sdMc20Rafr7gITPfOSPvv2GaZz7tVPmgxn2h6N2u4Zfntaey2vPYH0TpqhS3wZv2RKD8GtEUhXJkKyhispg9RA3P8E8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784942; c=relaxed/simple;
	bh=xPYbcYnq/LORjYsO2I6VSMY7RWQW4RDopkAC0ny5hoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rz55/qyyjJXO1NyJrFbIRfC7xg8c0dFVhO/7HnHD3Dh7vFCA2htFe3DKFZOy3qeM75lJhG+f2TLfOHZYKZ+xr8tbui7wTzlLd0ShpC/ISGUjwN9cNZ2LjBQ1ZUmfkxHs0s3IZYIOLr1lv7OwwYEL5EtijFJ+fku1Rvd7kld2oZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XIOyH977; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XIOyH977"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C0F1F00898;
	Wed, 30 Sep 2026 16:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784937;
	bh=VzrHSILHHwJd63obQ5cml1ye6VL0joKNai1ErUI7C4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XIOyH977MzPszT9bB0BGmYkb+pKgoW2mKZPqRY2NTKRTsIZ+AWrIZ//AwmSp1C9ii
	 3crfAakEZZuMnRCS8vOuEuuTUY+NY4xFM8MykSOz6WlXB8Q7gLuCfleATWg7ErcjCI
	 aNM0HJADGGNEbiOiPRxPiECDCqm9/nMVMOSPBb6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 331/982] net/sched: act_api: dont open code max()
Date: Wed, 30 Sep 2026 17:17:47 +0200
Message-ID: <20260930152423.928573380@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Tammela <pctammela@mojatatu.com>

[ Upstream commit c73724bfde0932cb0cafff2855e8ce81e12fd594 ]

Use max() in a couple of places that are open coding it with the
ternary operator.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20231208192847.714940-5-pctammela@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 251367a0a331 ("net/sched: act_api: fix skb sizing and action leak on reoffload delete")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_api.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 26dd0158f14ef..e68c1cacb5e58 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1843,8 +1843,7 @@ tcf_reoffload_del_notify(struct net *net, struct tc_action *action)
 	struct sk_buff *skb;
 	int ret;
 
-	skb = alloc_skb(attr_size <= NLMSG_GOODSIZE ? NLMSG_GOODSIZE : attr_size,
-			GFP_KERNEL);
+	skb = alloc_skb(max(attr_size, NLMSG_GOODSIZE), GFP_KERNEL);
 	if (!skb)
 		return -ENOBUFS;
 
@@ -1929,8 +1928,7 @@ tcf_del_notify(struct net *net, struct nlmsghdr *n, struct tc_action *actions[],
 	int ret;
 	struct sk_buff *skb;
 
-	skb = alloc_skb(attr_size <= NLMSG_GOODSIZE ? NLMSG_GOODSIZE : attr_size,
-			GFP_KERNEL);
+	skb = alloc_skb(max(attr_size, NLMSG_GOODSIZE), GFP_KERNEL);
 	if (!skb)
 		return -ENOBUFS;
 
@@ -2009,8 +2007,7 @@ tcf_add_notify(struct net *net, struct nlmsghdr *n, struct tc_action *actions[],
 {
 	struct sk_buff *skb;
 
-	skb = alloc_skb(attr_size <= NLMSG_GOODSIZE ? NLMSG_GOODSIZE : attr_size,
-			GFP_KERNEL);
+	skb = alloc_skb(max(attr_size, NLMSG_GOODSIZE), GFP_KERNEL);
 	if (!skb)
 		return -ENOBUFS;
 
-- 
2.53.0



