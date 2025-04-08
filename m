Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F98B26981F;
	Tue,  8 Apr 2025 11:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110570; cv=none; b=tcP6rQkGEozLUk2f5N2boXSXLsEFnxpKfmiIfBsgqRcjA7UcKhhm/WRB150Ucfo9oU1pAQRDUIUfmpUOA3fz9sxk+e9qjhH6WM8g8tWZZCA7OOrTsYQ5IFkLjBkLifD/Znm/GZW3QYN9PVvHpBo/vX1dG4kAznvVmYtLYb+rLIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110570; c=relaxed/simple;
	bh=YTX6afzpAhFJTZE2o6YZP19Np1CisDSL6M6nX/bVDsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZEqVN3Pcxawd9c5Z/urM88Vk7sIgEWkPub/9T6gBzyBqC26VM1kMAugJ5pc7cGRW1jPu2xK3LWR9/OAu268R3eyZCfKaIGz22a/Gf+ow+TJYgipyEnmp6dkKz9nI+TJTG1gTykFbhTXLjLn7k6CsWkf3+kuofGemG0cM1wZIPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jI4Gs1y1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jI4Gs1y1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2106CC4CEE5;
	Tue,  8 Apr 2025 11:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110570;
	bh=YTX6afzpAhFJTZE2o6YZP19Np1CisDSL6M6nX/bVDsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jI4Gs1y1lN5v8bIr0mzX4ntCK4M615Q4MZ9fPPDZAXwlP5jZFfElc4PylC3thcmcE
	 iWYG8szBSXbif+CtSD6B+ep8p0/ld1tOvueA1/beEnnSJvq2U0UM6rNpCw405wCapW
	 4kdihFZTIyDlfAhZAC/hIulk5N3YDGKGuc81NAXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 112/731] xfrm: delay initialization of offload path till its actually requested
Date: Tue,  8 Apr 2025 12:40:09 +0200
Message-ID: <20250408104916.882607608@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 585b64f5a62089ef42889b106b063d089feb6599 ]

XFRM offload path is probed even if offload isn't needed at all. Let's
make sure that x->type_offload pointer stays NULL for such path to
reduce ambiguity.

Fixes: 9d389d7f84bb ("xfrm: Add a xfrm type offload.")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h     | 11 ++++++++++-
 net/xfrm/xfrm_device.c | 13 ++++++++-----
 net/xfrm/xfrm_state.c  | 32 ++++++++++++++------------------
 net/xfrm/xfrm_user.c   |  2 +-
 4 files changed, 33 insertions(+), 25 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index ed4b83696c77f..e1eed5d47d072 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -464,6 +464,15 @@ struct xfrm_type_offload {
 
 int xfrm_register_type_offload(const struct xfrm_type_offload *type, unsigned short family);
 void xfrm_unregister_type_offload(const struct xfrm_type_offload *type, unsigned short family);
+void xfrm_set_type_offload(struct xfrm_state *x);
+static inline void xfrm_unset_type_offload(struct xfrm_state *x)
+{
+	if (!x->type_offload)
+		return;
+
+	module_put(x->type_offload->owner);
+	x->type_offload = NULL;
+}
 
 /**
  * struct xfrm_mode_cbs - XFRM mode callbacks
@@ -1760,7 +1769,7 @@ void xfrm_spd_getinfo(struct net *net, struct xfrmk_spdinfo *si);
 u32 xfrm_replay_seqhi(struct xfrm_state *x, __be32 net_seq);
 int xfrm_init_replay(struct xfrm_state *x, struct netlink_ext_ack *extack);
 u32 xfrm_state_mtu(struct xfrm_state *x, int mtu);
-int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload,
+int __xfrm_init_state(struct xfrm_state *x, bool init_replay,
 		      struct netlink_ext_ack *extack);
 int xfrm_init_state(struct xfrm_state *x);
 int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type);
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index d1fa94e52ceae..97c8030cc4173 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -244,11 +244,6 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	xfrm_address_t *daddr;
 	bool is_packet_offload;
 
-	if (!x->type_offload) {
-		NL_SET_ERR_MSG(extack, "Type doesn't support offload");
-		return -EINVAL;
-	}
-
 	if (xuo->flags &
 	    ~(XFRM_OFFLOAD_IPV6 | XFRM_OFFLOAD_INBOUND | XFRM_OFFLOAD_PACKET)) {
 		NL_SET_ERR_MSG(extack, "Unrecognized flags in offload request");
@@ -310,6 +305,13 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 		return -EINVAL;
 	}
 
+	xfrm_set_type_offload(x);
+	if (!x->type_offload) {
+		NL_SET_ERR_MSG(extack, "Type doesn't support offload");
+		dev_put(dev);
+		return -EINVAL;
+	}
+
 	xso->dev = dev;
 	netdev_tracker_alloc(dev, &xso->dev_tracker, GFP_ATOMIC);
 	xso->real_dev = dev;
@@ -332,6 +334,7 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 		netdev_put(dev, &xso->dev_tracker);
 		xso->type = XFRM_DEV_OFFLOAD_UNSPECIFIED;
 
+		xfrm_unset_type_offload(x);
 		/* User explicitly requested packet offload mode and configured
 		 * policy in addition to the XFRM state. So be civil to users,
 		 * and return an error instead of taking fallback path.
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index ad2202fa82f34..69af5964c886c 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -424,18 +424,18 @@ void xfrm_unregister_type_offload(const struct xfrm_type_offload *type,
 }
 EXPORT_SYMBOL(xfrm_unregister_type_offload);
 
-static const struct xfrm_type_offload *
-xfrm_get_type_offload(u8 proto, unsigned short family, bool try_load)
+void xfrm_set_type_offload(struct xfrm_state *x)
 {
 	const struct xfrm_type_offload *type = NULL;
 	struct xfrm_state_afinfo *afinfo;
+	bool try_load = true;
 
 retry:
-	afinfo = xfrm_state_get_afinfo(family);
+	afinfo = xfrm_state_get_afinfo(x->props.family);
 	if (unlikely(afinfo == NULL))
-		return NULL;
+		goto out;
 
-	switch (proto) {
+	switch (x->id.proto) {
 	case IPPROTO_ESP:
 		type = afinfo->type_offload_esp;
 		break;
@@ -449,18 +449,16 @@ xfrm_get_type_offload(u8 proto, unsigned short family, bool try_load)
 	rcu_read_unlock();
 
 	if (!type && try_load) {
-		request_module("xfrm-offload-%d-%d", family, proto);
+		request_module("xfrm-offload-%d-%d", x->props.family,
+			       x->id.proto);
 		try_load = false;
 		goto retry;
 	}
 
-	return type;
-}
-
-static void xfrm_put_type_offload(const struct xfrm_type_offload *type)
-{
-	module_put(type->owner);
+out:
+	x->type_offload = type;
 }
+EXPORT_SYMBOL(xfrm_set_type_offload);
 
 static const struct xfrm_mode xfrm4_mode_map[XFRM_MODE_MAX] = {
 	[XFRM_MODE_BEET] = {
@@ -609,8 +607,6 @@ static void ___xfrm_state_destroy(struct xfrm_state *x)
 	kfree(x->coaddr);
 	kfree(x->replay_esn);
 	kfree(x->preplay_esn);
-	if (x->type_offload)
-		xfrm_put_type_offload(x->type_offload);
 	if (x->type) {
 		x->type->destructor(x);
 		xfrm_put_type(x->type);
@@ -784,6 +780,8 @@ void xfrm_dev_state_free(struct xfrm_state *x)
 	struct xfrm_dev_offload *xso = &x->xso;
 	struct net_device *dev = READ_ONCE(xso->dev);
 
+	xfrm_unset_type_offload(x);
+
 	if (dev && dev->xfrmdev_ops) {
 		spin_lock_bh(&xfrm_state_dev_gc_lock);
 		if (!hlist_unhashed(&x->dev_gclist))
@@ -3122,7 +3120,7 @@ u32 xfrm_state_mtu(struct xfrm_state *x, int mtu)
 }
 EXPORT_SYMBOL_GPL(xfrm_state_mtu);
 
-int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload,
+int __xfrm_init_state(struct xfrm_state *x, bool init_replay,
 		      struct netlink_ext_ack *extack)
 {
 	const struct xfrm_mode *inner_mode;
@@ -3178,8 +3176,6 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload,
 		goto error;
 	}
 
-	x->type_offload = xfrm_get_type_offload(x->id.proto, family, offload);
-
 	err = x->type->init_state(x, extack);
 	if (err)
 		goto error;
@@ -3229,7 +3225,7 @@ int xfrm_init_state(struct xfrm_state *x)
 {
 	int err;
 
-	err = __xfrm_init_state(x, true, false, NULL);
+	err = __xfrm_init_state(x, true, NULL);
 	if (!err)
 		x->km.state = XFRM_STATE_VALID;
 
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 08c6d6f0179fb..82a768500999b 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -907,7 +907,7 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 			goto error;
 	}
 
-	err = __xfrm_init_state(x, false, attrs[XFRMA_OFFLOAD_DEV], extack);
+	err = __xfrm_init_state(x, false, extack);
 	if (err)
 		goto error;
 
-- 
2.39.5



