Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC6446AA71;
	Tue, 21 Jul 2026 15:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648493; cv=none; b=jDJJoet7MX8lZCVIpl9amHYrvD7zKtTVMgpkQE1PZ622ZtWX/0AcwB9x50kfMJEQBGm4vYJpzyBWU3mfuEymHYvwpu+OCAUVy/oWIcTeRxj7YfYbET6Bg7em8mymfiIMdWchDVAusyFOnU+ojrudbvuiMYsPjyQkPmN1Xnzjsd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648493; c=relaxed/simple;
	bh=888qHUbGEuwCrBTKwUIBW7yls8moNKABEeLjZtecS3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aitmZX0PFSGmDZRUh/w3TzADcPf0uWsBTOE5v7GHp/P0KGKuTiWBLj2zl0gnncnF0vfOwIIjgm4D5qiINBnuaY9S66vPnzqy5cO91x29uUZgaMvYMZbGktXJfQ6YkD1Dx3gkpqfAK+blaziJNiuty6WG6+F+pplk99TItcod8+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HpkyZ4Uu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HpkyZ4Uu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7991F000E9;
	Tue, 21 Jul 2026 15:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648492;
	bh=4MRu78bqpfP7sXkcJYBIkzgD2WbCJ1NBFum8bxTEOEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HpkyZ4Uu2yNh7Yw3Wu4rX6SHtYVgwQd1hbL3lNBTcPT12DO+pueyZ+8vtZHtLAiSy
	 RlTi6n/f7pHl9j4wXv9HtOtMDCfQy1rdGjjg2/YzTjTOG/VYzMsCtElnPChbkjx1VW
	 2vrJ4qsn+xu01nEke4YrYRxTlVjmDvG+V6vMQj2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0218/2077] net/sched: sch_htb: do not change sch->flags in htb_dump()
Date: Tue, 21 Jul 2026 16:58:11 +0200
Message-ID: <20260721152557.823599163@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9b949fa69129e4b694ed11ee3be6d6edd4a9b8f4 ]

htb_dump() runs without holding qdisc spinlock.

It is illegal to touch sch->flags with non locked RMW,
as concurrent readers might see intermediate wrong values.

Set TCQ_F_OFFLOADED in control path (htb_init()) instead.

Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260514095935.3926276-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_htb.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index c22ccd8eae8c73..f94a44fad4e9d9 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1147,6 +1147,7 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
 	 * parts (especially calling ndo_setup_tc) on errors.
 	 */
 	q->offload = true;
+	sch->flags |= TCQ_F_OFFLOADED;
 
 	return 0;
 }
@@ -1207,11 +1208,6 @@ static int htb_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct nlattr *nest;
 	struct tc_htb_glob gopt;
 
-	if (q->offload)
-		sch->flags |= TCQ_F_OFFLOADED;
-	else
-		sch->flags &= ~TCQ_F_OFFLOADED;
-
 	sch->qstats.overlimits = q->overlimits;
 	/* Its safe to not acquire qdisc lock. As we hold RTNL,
 	 * no change can happen on the qdisc parameters.
-- 
2.53.0



