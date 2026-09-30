Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAE45187DE;
	Wed, 30 Sep 2026 18:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792498; cv=none; b=SXsg+uZtj47jvz+3qdDte0buOz599abShEWXIoO5zi2tk3EcuRTAX0DAttmc43GqKbmQMwSx/odVd+Z8y1o4/pdVSFebV1y5xwjRZ0su0I/InGhEzVIDyfcALkjjV/nYS8lpjOwrNAIc52gFzMiHSsJowHKDa0XzJOZsvRZ+J6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792498; c=relaxed/simple;
	bh=VVzV+en2i34fLNQ6s+LrAbM0n2QVKihmjKBttOmFOfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q95Ifr4V3gjA20Ii7qYR9t+82uITxj3CZ4OuznPGTXsZ+gmLU56R0jDZuOqXq0XHwCsmyZJ3A3+gGKVdqC9NaJB32AhsvdQeauetlAXMMwbui6p75q85+zAFD1Cx1vZiC8gAYXW87PUg7Y1G+6YG2PZ0pyYDgZacMRHsn9k4Sew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HU4fwhIH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HU4fwhIH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29101F000FF;
	Wed, 30 Sep 2026 18:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792497;
	bh=IzTjAYIVul4EmB+xaCgTlVUEdc/2DfSDi2hCalqlsb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HU4fwhIHDw/bWuB1FqYDlDe1MWvQ5sYpP/VMWlbLUYwE+drjznlrv+EPi72SDojUy
	 Ut7ONlZEqfFPjThBNgxT1T70s2p0OPyEiSLObp267sNd21PDb+xvNA6eRJl4zSIuUU
	 T6S2nl12q/YT6+M7Q22B/XEpvbUYqTy1dQgCWonA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 676/752] net/sched: sch_teql: fix shadowed err in __teql_resolve()
Date: Wed, 30 Sep 2026 17:29:06 +0200
Message-ID: <20260930152412.876343042@linuxfoundation.org>
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
index e78a849fb1b0b..00ac4386627c7 100644
--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -242,14 +242,11 @@ __teql_resolve(struct sk_buff *skb, struct sk_buff *skb_res,
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



