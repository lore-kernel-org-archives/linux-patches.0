Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09228217704;
	Sat, 30 May 2026 18:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165266; cv=none; b=bDEqEdDHYqktEmGSeCWX/2Kes4MojWclA2DPABMbhe6ScsVEDVvov27dDu3iIcG9PACLvwSZfF5XYMElpi1xVZJ/IH/7OItRJEucgM14oj1BOcViFpiweaEvFRUEmB3HASszyUbURZwHmkS5f3SD4eVwBXEHUzWFRIeknev0hw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165266; c=relaxed/simple;
	bh=rkFDNr+jDyeMAEphaSOUOdVWZJucGeoX81m687pXZMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLoAw4wmH+0oncDmuAiu5u7egRuOxnLtjPeWGwCnFIJNo9NKGZ0IX19qwd+OeygTdzc2KoWuP4Gm9O8SoQ5BLB+I7AmUWyhNq1ejTRoZt8XWZSAZVP+onfug0Y19ku+iTOv0tOnEZYf6KDGPy2W/2Stsxop6icjIjf7P0ROpj74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v324qf0N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v324qf0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CBBB1F00893;
	Sat, 30 May 2026 18:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165264;
	bh=y6a2uhl8aYWeJ2zpe05Unp+PmfiAxz3s7rBDvc6EmJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v324qf0NBhGSZA+jzOeJWu0EurVyRqWYUbop4JGJ9Sb4PDrchp38U5hgtYIbk/IPn
	 Zw3EAxCC8m1UTqtSPSBtgfs3tQQi5LVfaJAYss7oI6xH7K8+AnEyIaajdUtgRQ2rtN
	 +tPzOD+vlDmEcM4PNzFGzLtr8ei8KqptHiEkwrro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/589] xfrm: Wait for RCU readers during policy netns exit
Date: Sat, 30 May 2026 17:58:28 +0200
Message-ID: <20260530160225.295450347@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 069daad4f2ae9c5c108131995529d5f02392c446 ]

xfrm_policy_fini() frees the policy_bydst hash tables after flushing the
policy work items and deleting all policies, but it does not wait for
concurrent RCU readers to leave their read-side critical sections first.

The policy_bydst tables are published via rcu_assign_pointer() and are
looked up through rcu_dereference_check(), so netns teardown must also
wait for an RCU grace period before freeing the table memory.

Fix this by adding synchronize_rcu() before freeing the policy hash tables.

Fixes: e1e551bc5630 ("xfrm: policy: prepare policy_bydst hash for rcu lookups")
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index c4ebfaa0b2ed0..56956abd38180 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -4166,6 +4166,8 @@ static void xfrm_policy_fini(struct net *net)
 #endif
 	xfrm_policy_flush(net, XFRM_POLICY_TYPE_MAIN, false);
 
+	synchronize_rcu();
+
 	WARN_ON(!list_empty(&net->xfrm.policy_all));
 
 	for (dir = 0; dir < XFRM_POLICY_MAX; dir++) {
-- 
2.53.0



