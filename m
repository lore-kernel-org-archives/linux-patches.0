Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A78E53365;
	Thu, 12 Dec 2024 17:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023894; cv=none; b=OMtkUYMeFxhkzpKXdDQyWEEKu4p5GeoSsHeW+nKiek7QSqY2KQbu8Ne12yHML0bW3BbcOPlIBJ0wLSIqU2ie5D/F8CYoaeA6E/drYEAUBKXQUqXH+CFUiLApdi84I3KUN4MJMCefWdXuwOAdhCSPZmlQd5WZbsTDTdgpqyRc1u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023894; c=relaxed/simple;
	bh=T5s6RwOR1w5e9eqYCNi7IOOBGEJ7eInVKqRpJ3sCPWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z26uwAXDG/i9gQFBKwkBgQCf6kcYsplzZ5ZonuH3PnTDmwsXJZ8LMQ2AFiHSEp1NzSOHID9z3KDDmWpuvyT3WBjX5HCb7+IceYUgJZ/Fj40X1QFdbxDF54PLVZ/a5pBW157y14u4pe99p9It7FF5lW28iT8FGyYZ6GBkqhaat1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bpnwfEno; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bpnwfEno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71436C4CECE;
	Thu, 12 Dec 2024 17:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023893;
	bh=T5s6RwOR1w5e9eqYCNi7IOOBGEJ7eInVKqRpJ3sCPWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bpnwfEnohUiO3HbgAwWYiSUt6TzpIGyYFHVpwq8dxHGk9hsAird3AbEi1JFzBXZxH
	 p6ZkAHuQ4UyYjSqcdg1MAPzJfRKgTZNG7XfLWpRH0vYWSj1AfRvb2V3VbyHGHDloo7
	 IDeUdiwICt7c85B/+LW87FPnSiAafaaNOBlScEy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raed Salem <raeds@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/459] xfrm: store and rely on direction to construct offload flags
Date: Thu, 12 Dec 2024 15:57:34 +0100
Message-ID: <20241212144258.095201112@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 482db2f1dd211f73ad9d71e33ae15c1df6379982 ]

XFRM state doesn't need anything from flags except to understand
direction, so store it separately. For future patches, such change
will allow us to reuse xfrm_dev_offload for policy offload too, which
has three possible directions instead of two.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Stable-dep-of: 2cf567f421db ("netdevsim: copy addresses for both in and out paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h     | 6 ++++++
 net/xfrm/xfrm_device.c | 8 +++++++-
 net/xfrm/xfrm_user.c   | 3 ++-
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 987c603806aee..2c1feca282036 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -126,12 +126,18 @@ struct xfrm_state_walk {
 	struct xfrm_address_filter *filter;
 };
 
+enum {
+	XFRM_DEV_OFFLOAD_IN = 1,
+	XFRM_DEV_OFFLOAD_OUT,
+};
+
 struct xfrm_dev_offload {
 	struct net_device	*dev;
 	struct net_device	*real_dev;
 	unsigned long		offload_handle;
 	unsigned int		num_exthdrs;
 	u8			flags;
+	u8			dir : 2;
 };
 
 struct xfrm_mode {
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 61aa0fd9d2a0c..7690d23bcf8bb 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -129,7 +129,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 
 	sp = skb_sec_path(skb);
 	x = sp->xvec[sp->len - 1];
-	if (xo->flags & XFRM_GRO || x->xso.flags & XFRM_OFFLOAD_INBOUND)
+	if (xo->flags & XFRM_GRO || x->xso.dir == XFRM_DEV_OFFLOAD_IN)
 		return skb;
 
 	/* This skb was already validated on the upper/virtual dev */
@@ -285,11 +285,17 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	/* Don't forward bit that is not implemented */
 	xso->flags = xuo->flags & ~XFRM_OFFLOAD_IPV6;
 
+	if (xuo->flags & XFRM_OFFLOAD_INBOUND)
+		xso->dir = XFRM_DEV_OFFLOAD_IN;
+	else
+		xso->dir = XFRM_DEV_OFFLOAD_OUT;
+
 	err = dev->xfrmdev_ops->xdo_dev_state_add(x);
 	if (err) {
 		xso->num_exthdrs = 0;
 		xso->flags = 0;
 		xso->dev = NULL;
+		xso->dir = 0;
 		xso->real_dev = NULL;
 		dev_put(dev);
 
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index b12a305a2d7a4..aa509857b6660 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -855,7 +855,8 @@ static int copy_user_offload(struct xfrm_dev_offload *xso, struct sk_buff *skb)
 	xuo = nla_data(attr);
 	memset(xuo, 0, sizeof(*xuo));
 	xuo->ifindex = xso->dev->ifindex;
-	xuo->flags = xso->flags;
+	if (xso->dir == XFRM_DEV_OFFLOAD_IN)
+		xuo->flags = XFRM_OFFLOAD_INBOUND;
 
 	return 0;
 }
-- 
2.43.0



