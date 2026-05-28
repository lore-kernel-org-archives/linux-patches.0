Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7354B32AAD6;
	Thu, 28 May 2026 20:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000322; cv=none; b=fg1t/WdnFLhbim7l4536rw0vz56ZRXkQy0DrAJTjP88c2nCafVr5yzkR6UzFg6rKGpxHnXfeBUtY07y54rihr6edKYuihqB963Z2CwS7j+bH/s5wVwA9E0b8W645zCqUeoFVfYhfr0kyjyBu9KIMoige0Us1SGRXvdqwbd2Uh58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000322; c=relaxed/simple;
	bh=b9k4RtMF42x0KgCz+9faE6JTOsgxPULwxAy0Or5R5TE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lcbo2L3TDTAnNLwgs5WJmd90OrPy+CEXy36zcBJ5WuJmHp4JDkP/YIeVHpdE9YGGCx5VJk6/SFFVJzZxFlHxxQ7Q/eI2Gzbd9LZTCHBrtkNqvrThl3mQe+gMUNeIQtRYr6MPdrpc7TxAbTMvuY3geRM5jD6zNG4t7Hc56uX0Y6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hjGBxKWa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjGBxKWa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D241A1F000E9;
	Thu, 28 May 2026 20:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000321;
	bh=Vqu+0/CM7x1U+uuBtN1KPrjifIenMobzeVXAGHUPruc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hjGBxKWa33j+mMf67pz56QB3++tUE7PVvRIS8k9nVbuOn0cbf/A3DRfoi8BoRRDql
	 TDc6CVtnXd0WVz/WZS100Xc5SSy1mf5Ul0iHPRAMlrpTiXCUcj7zbwE/aDg9wOKuDt
	 okdrRmoqP9o5aH/+fYXiSimaOnhjZ083byAucXrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 355/377] net: shaper: annotate the data races
Date: Thu, 28 May 2026 21:49:53 +0200
Message-ID: <20260528194648.707214900@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit a3442936dd0523277e20aaf86207c574e755c634 ]

As previously discussed we don't care about making the shaper
state fully RCU-compliant because the hierarchy itself can't
be dumped in one go over Netlink. Let's annotate the reads
and writes to make that clear.

The field-by-field assignments will also be useful for the
next commit which adds explicit "valid" field (which we don't
want to override with the current full struct assignment).

Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260515221325.1685455-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b8d7519352ba ("net: shaper: rework the VALID marking (again)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/shaper/shaper.c | 53 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 15 deletions(-)

diff --git a/net/shaper/shaper.c b/net/shaper/shaper.c
index 23d535f157294..a01de4392eb66 100644
--- a/net/shaper/shaper.c
+++ b/net/shaper/shaper.c
@@ -138,35 +138,58 @@ static int net_shaper_fill_handle(struct sk_buff *msg,
 	return -EMSGSIZE;
 }
 
+static void net_shaper_copy(struct net_shaper *dst,
+			    const struct net_shaper *src)
+{
+	WRITE_ONCE(dst->parent.scope, READ_ONCE(src->parent.scope));
+	WRITE_ONCE(dst->parent.id, READ_ONCE(src->parent.id));
+	WRITE_ONCE(dst->handle.scope, READ_ONCE(src->handle.scope));
+	WRITE_ONCE(dst->handle.id, READ_ONCE(src->handle.id));
+
+	WRITE_ONCE(dst->metric, READ_ONCE(src->metric));
+	WRITE_ONCE(dst->bw_min, READ_ONCE(src->bw_min));
+	WRITE_ONCE(dst->bw_max, READ_ONCE(src->bw_max));
+	WRITE_ONCE(dst->burst, READ_ONCE(src->burst));
+	WRITE_ONCE(dst->priority, READ_ONCE(src->priority));
+	WRITE_ONCE(dst->weight, READ_ONCE(src->weight));
+
+	/* private fields are only used on the write path under the lock */
+	data_race(dst->leaves = src->leaves);
+}
+
 static int
 net_shaper_fill_one(struct sk_buff *msg,
 		    const struct net_shaper_binding *binding,
 		    const struct net_shaper *shaper,
 		    const struct genl_info *info)
 {
+	struct net_shaper cur;
 	void *hdr;
 
 	hdr = genlmsg_iput(msg, info);
 	if (!hdr)
 		return -EMSGSIZE;
 
+	/* Make a copy to avoid data races */
+	net_shaper_copy(&cur, shaper);
+
 	if (net_shaper_fill_binding(msg, binding, NET_SHAPER_A_IFINDEX) ||
-	    net_shaper_fill_handle(msg, &shaper->parent,
+	    net_shaper_fill_handle(msg, &cur.parent,
 				   NET_SHAPER_A_PARENT) ||
-	    net_shaper_fill_handle(msg, &shaper->handle,
+	    net_shaper_fill_handle(msg, &cur.handle,
 				   NET_SHAPER_A_HANDLE) ||
-	    ((shaper->bw_min || shaper->bw_max || shaper->burst) &&
-	     nla_put_u32(msg, NET_SHAPER_A_METRIC, shaper->metric)) ||
-	    (shaper->bw_min &&
-	     nla_put_uint(msg, NET_SHAPER_A_BW_MIN, shaper->bw_min)) ||
-	    (shaper->bw_max &&
-	     nla_put_uint(msg, NET_SHAPER_A_BW_MAX, shaper->bw_max)) ||
-	    (shaper->burst &&
-	     nla_put_uint(msg, NET_SHAPER_A_BURST, shaper->burst)) ||
-	    (shaper->priority &&
-	     nla_put_u32(msg, NET_SHAPER_A_PRIORITY, shaper->priority)) ||
-	    (shaper->weight &&
-	     nla_put_u32(msg, NET_SHAPER_A_WEIGHT, shaper->weight)))
+	    ((cur.bw_min || cur.bw_max || cur.burst) &&
+	     nla_put_u32(msg, NET_SHAPER_A_METRIC, cur.metric)) ||
+	    (cur.bw_min &&
+	     nla_put_uint(msg, NET_SHAPER_A_BW_MIN, cur.bw_min)) ||
+	    (cur.bw_max &&
+	     nla_put_uint(msg, NET_SHAPER_A_BW_MAX, cur.bw_max)) ||
+	    (cur.burst &&
+	     nla_put_uint(msg, NET_SHAPER_A_BURST, cur.burst)) ||
+	    (cur.priority &&
+	     nla_put_u32(msg, NET_SHAPER_A_PRIORITY, cur.priority)) ||
+	    (cur.weight &&
+	     nla_put_u32(msg, NET_SHAPER_A_WEIGHT, cur.weight)))
 		goto nla_put_failure;
 
 	genlmsg_end(msg, hdr);
@@ -424,7 +447,7 @@ static void net_shaper_commit(struct net_shaper_binding *binding,
 		/* Successful update: drop the tentative mark
 		 * and update the hierarchy container.
 		 */
-		*cur = shapers[i];
+		net_shaper_copy(cur, &shapers[i]);
 		smp_wmb();
 		__xa_set_mark(&hierarchy->shapers, index, NET_SHAPER_VALID);
 	}
-- 
2.53.0



