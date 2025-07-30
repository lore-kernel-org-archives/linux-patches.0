Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F7C1F09B6;
	Wed, 30 Jul 2025 09:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869040; cv=none; b=ijv132QVvS/PBSe5Pn7yErhGGTQnOmxAUJvUMvqy9Ymf2a56kbVgfn6gtcTJrtwdAc0tUrVOX2vxx3TrFxZQvfj7AcvLa94EpAORvwm+JT+JmAY4M8ryzCjUh0YAj/E1ANEi+cIT3Gn7TUz6OZFqfdIyci9oUv0DyxChc8x1YB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869040; c=relaxed/simple;
	bh=wm2zKLTYvmay6+07Dom2diIVXpsAHr95p0V96zWe8I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlY7imZTief56mOFtPqdqgfNGyBF0DzRsiSDm/ds2+v8kLOh1m8amkDhDcMOYRztaP9hyZO+QIF6/hNJROh8DBjUauJ8j0nYIv+Piv2vgR3BfxxhUJAvhpzawpIo3IbBOGwCtpEL1RkRD2Q3ph0MhvnaU4igSoPHm7uIDt5BAo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E11/Lswu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E11/Lswu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE741C4CEF5;
	Wed, 30 Jul 2025 09:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869040;
	bh=wm2zKLTYvmay6+07Dom2diIVXpsAHr95p0V96zWe8I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E11/LswuVjfKGA6WfCOQeYDwggZ/r+MS2X5fwkfS8rA20GQnBy/BG/4jw37r8aiqz
	 9hym0/NElAJRxxTcQNITOPTdC6rmEmjKEmmI+de63pnLBk6+a9PHPXHzy4h/xKy5+Z
	 7xAYVrxIFkUaQzt3e6AzZVM4mZ3JdgeY/PcFrf2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Leon Romanovsky <leonro@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 22/92] xfrm: always initialize offload path
Date: Wed, 30 Jul 2025 11:35:30 +0200
Message-ID: <20250730093231.467781618@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit c0f21029f123d1b15f8eddc8e3976bf0c8781c43 ]

Offload path is used for GRO with SW IPsec, and not just for HW
offload. So initialize it anyway.

Fixes: 585b64f5a620 ("xfrm: delay initialization of offload path till its actually requested")
Reported-by: Sabrina Dubroca <sd@queasysnail.net>
Closes: https://lore.kernel.org/all/aEGW_5HfPqU1rFjl@krikkit
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h     | 2 +-
 net/xfrm/xfrm_device.c | 1 -
 net/xfrm/xfrm_state.c  | 6 ++----
 net/xfrm/xfrm_user.c   | 1 +
 4 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 1f1861c57e2ad..29a0759d5582c 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -474,7 +474,7 @@ struct xfrm_type_offload {
 
 int xfrm_register_type_offload(const struct xfrm_type_offload *type, unsigned short family);
 void xfrm_unregister_type_offload(const struct xfrm_type_offload *type, unsigned short family);
-void xfrm_set_type_offload(struct xfrm_state *x);
+void xfrm_set_type_offload(struct xfrm_state *x, bool try_load);
 static inline void xfrm_unset_type_offload(struct xfrm_state *x)
 {
 	if (!x->type_offload)
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index f46a9e5764f01..a2d3a5f3b4852 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -305,7 +305,6 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 		return -EINVAL;
 	}
 
-	xfrm_set_type_offload(x);
 	if (!x->type_offload) {
 		NL_SET_ERR_MSG(extack, "Type doesn't support offload");
 		dev_put(dev);
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index cef8d3c20f652..0cf516b4e6d92 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -424,11 +424,10 @@ void xfrm_unregister_type_offload(const struct xfrm_type_offload *type,
 }
 EXPORT_SYMBOL(xfrm_unregister_type_offload);
 
-void xfrm_set_type_offload(struct xfrm_state *x)
+void xfrm_set_type_offload(struct xfrm_state *x, bool try_load)
 {
 	const struct xfrm_type_offload *type = NULL;
 	struct xfrm_state_afinfo *afinfo;
-	bool try_load = true;
 
 retry:
 	afinfo = xfrm_state_get_afinfo(x->props.family);
@@ -607,6 +606,7 @@ static void ___xfrm_state_destroy(struct xfrm_state *x)
 	kfree(x->coaddr);
 	kfree(x->replay_esn);
 	kfree(x->preplay_esn);
+	xfrm_unset_type_offload(x);
 	if (x->type) {
 		x->type->destructor(x);
 		xfrm_put_type(x->type);
@@ -780,8 +780,6 @@ void xfrm_dev_state_free(struct xfrm_state *x)
 	struct xfrm_dev_offload *xso = &x->xso;
 	struct net_device *dev = READ_ONCE(xso->dev);
 
-	xfrm_unset_type_offload(x);
-
 	if (dev && dev->xfrmdev_ops) {
 		spin_lock_bh(&xfrm_state_dev_gc_lock);
 		if (!hlist_unhashed(&x->dev_gclist))
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 614b58cb26ab7..d17ea437a1587 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -977,6 +977,7 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 	/* override default values from above */
 	xfrm_update_ae_params(x, attrs, 0);
 
+	xfrm_set_type_offload(x, attrs[XFRMA_OFFLOAD_DEV]);
 	/* configure the hardware if offload is requested */
 	if (attrs[XFRMA_OFFLOAD_DEV]) {
 		err = xfrm_dev_state_add(net, x,
-- 
2.39.5



