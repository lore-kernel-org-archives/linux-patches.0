Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8F6371049;
	Wed, 30 Sep 2026 19:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796914; cv=none; b=IPOEsfycB/hyxKo8vdaZwqkrcf3wv+e6puqXw7HTG+EKTa2NO3karY9NCC2GdQQ37xN8Z6a0BmCNT/VmKivFo7Ukudp5wKBWWczHXiqngulCu0vRsSxuHVwJb0iHxaGnp/X1uZEZDtZmeIHGGPl544K5P/uWb9l1ZnSqQ5jeoHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796914; c=relaxed/simple;
	bh=yObAM8HXNWu3V+WSvG64L8zwa7rJ0TEDi+UDgBgiMNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNOYNbMnuo+MILwEoYGnHH4g87X/AB8FSUk7pwtZaU2QfEOImS18wysrtTIJtSgRe00UCKZBAIJ1ieSoDF3nq0idXxSwQ+20xBq+5cM9D3tIgeFTYXFcDNZoHfzn4JXr08eNgeWdJ7jjQRMcSywedAyyivPhWuEVPhLm72W0ud4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iDfvdSDC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDfvdSDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA8F1F000FF;
	Wed, 30 Sep 2026 19:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796913;
	bh=me+wHsT2Fvn5lr4RaANs/uhh2wfr+JfHS/50+Jl/SWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iDfvdSDCXuDrBYUYpAgHrB0INybDUNJgM2IGxmNhP/qamKFeRU7x8RSN5qgriaIkL
	 Y21mBtdfzOBC0N/CkSVkze+kDxY/Q6nYgqnsu8T+2c2AWbcVgv+MjxXGtBGHUT7Rya
	 n042CKXEGAoeaRyyhFXgjHhziCGu3zx+JOW6NtHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1080/1193] net/sched: sch_teql: fix shadowed err in __teql_resolve()
Date: Wed, 30 Sep 2026 17:29:24 +0200
Message-ID: <20260930152458.226365760@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 907b978e82cb4c1c245fc2985bb27c5d5c88c8f6 ]

__teql_resolve() declares an inner 'int err;' inside the
'if (neigh_event_send(n, skb_res) == 0)' block, shadowing the outer
'int err = 0;'. As a result, a negative return from dev_hard_header()
is written to the inner variable and __teql_resolve() still returns 0.

Remove the shadowed variable and set the outer err to -EINVAL when
dev_hard_header() returns a negative error.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Closes: https://lore.kernel.org/netdev/179022851638.2160803.1808206741379444999@kernel.org/
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260924082951.1599377-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_teql.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/sched/sch_teql.c b/net/sched/sch_teql.c
index ace524afdcf5c..a308d42c69f65 100644
--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -265,14 +265,11 @@ __teql_resolve(struct sk_buff *skb, struct sk_buff *skb_res,
 	}
 
 	if (neigh_event_send(n, skb_res) == 0) {
-		int err;
 		char haddr[MAX_ADDR_LEN];
 
 		neigh_ha_snapshot(haddr, n, dev);
-		err = dev_hard_header(skb, dev, ntohs(skb_protocol(skb, false)),
-				      haddr, NULL, skb->len);
-
-		if (err < 0)
+		if (dev_hard_header(skb, dev, ntohs(skb_protocol(skb, false)),
+				    haddr, NULL, skb->len) < 0)
 			err = -EINVAL;
 	} else {
 		err = (skb_res == NULL) ? -EAGAIN : 1;
-- 
2.53.0



