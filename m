Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BC432ABC0;
	Thu, 28 May 2026 20:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999150; cv=none; b=JOi+cvm7llaC5O4qmTpakgh96f3OtqfIU2J36Uk5XrNTNLGsJkefFEwk9rS+Jyv1N+PCqNrIAalQICX/oqVxq6c5E0rpGXWFdCy3LB2ezst1ZpT7i29sHWEi82QrL/UN1KMO++1g/3EkFkR1Ukapv5X9fsXHVYmWt9E9LTeJS8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999150; c=relaxed/simple;
	bh=qYWM7s86Hwm0+aNDPm+8IdmpL8oVjpsTGFLlCVPQP8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUuVo4sG8NG+nJH6CNBDKd2YBhR9lY8IeqMjzt56SLOwIii+rJCC/hxHOb0Zt3zGQxY39+1n/4dw4sE1pQPmQaYxiszWB1B6yFjdw4jYEpQpYyMf/52c8t7kyUe1HuplYje1i0Z8s/SGKnlNB7K/HXjsGEX2SOp+6eHyKPw6bhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yzEjjz36; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzEjjz36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0187E1F000E9;
	Thu, 28 May 2026 20:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999149;
	bh=YrXTuG+1kDhwWli3Te6rUlEGO7gW/sxYxWkqhHcQ82o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yzEjjz36aWnSm0/tIYwwRM0iixWDLBubUqJDBihrpA/GrMRs17L28bHbPojzyza63
	 RXL/8eNO3t/wn4+w5r3x9lpg7xsgDBC85aU1pcxRnDHtK7HsplZuVIPhz20VXHDgdR
	 LIk1SBplhEjyjJvv9V49QhGjrFvMwWzhyKmbBM68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 425/461] net: shaper: annotate the data races
Date: Thu, 28 May 2026 21:49:14 +0200
Message-ID: <20260528194659.810270587@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index b1c65110f04d3..520cefdc3d908 100644
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



