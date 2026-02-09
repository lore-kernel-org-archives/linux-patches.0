Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83760285060;
	Mon,  9 Feb 2026 14:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647563; cv=none; b=Vn7UJ4K7NrrjK0RTsKVQ4GgxyovOP8Wo5EtucA0rHfwe6bVluy6jAlmukMS0/yNBJ87AbZxo1GirHEQGq2Z/CK85ulVnmcgshnZk420PLrWiSZRIB/Pu+ClGWc8JWs0sW7Dhq3Qp38mo53fB8yvJuIiKgC9Pnl4g9AF69zjuomo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647563; c=relaxed/simple;
	bh=WP2bIag5LYqg3polU6G0/Z1CsoETWZ1CXk//5VK+caU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqqSCfDeDULr177B4W0E5K7XFQHtE/FVrQv0PtQ2YSRD9nQp0ZsZ2IT1aNYBrI9u9HvsWgRodXXGwM06csCAj0/0Zr9DeMWdQSCB2YLxuGNXQgXYfmVGcj4+mPC2RWOT5j0Uod2VRIm96XdWZ57WR0tgLxVRBMA+eY09Sx1CAMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jTnp8GlT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jTnp8GlT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB15C116C6;
	Mon,  9 Feb 2026 14:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647563;
	bh=WP2bIag5LYqg3polU6G0/Z1CsoETWZ1CXk//5VK+caU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jTnp8GlTh+o4uH1m8Vw5/tJ9OxdFdQ9mQ3x98j4oJ3WEUL35PZzGLIdy8E8Ve+KLM
	 /qjwzZ6wtRTNh5yyl37HvTLS0/lqDNLQjsgV1YX7JayP4z9sDyv9WPuG/3+zXJJhoV
	 6Pdnk/SlShB79VjZQfrrXUqXU2x5U9X2UBj7VyXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 138/175] net: rss: fix reporting RXH_XFRM_NO_CHANGE as input_xfrm for contexts
Date: Mon,  9 Feb 2026 15:23:31 +0100
Message-ID: <20260209142325.472490406@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

[ Upstream commit 1c172febdf065375359b2b95156e476bfee30b60 ]

Initializing input_xfrm to RXH_XFRM_NO_CHANGE in RSS contexts is
problematic. I think I did this to make it clear that the context
does not have its own settings applied. But unlike ETH_RSS_HASH_NO_CHANGE
which is zero, RXH_XFRM_NO_CHANGE is 0xff. We need to be careful
when reading the value back, and remember to treat 0xff as 0.

Remove the initialization and switch to storing 0. This lets us
also remove the workaround in ethnl_rss_set(). Get side does not
need any adjustments and context get no longer reports:

  RSS input transformation:
    symmetric-xor: on
    symmetric-or-xor: on
    Unknown bits in RSS input transformation: 0xfc

for NICs which don't support input_xfrm.

Remove the init of hfunc to ETH_RSS_HASH_NO_CHANGE while at it.
As already mentioned this is a noop since ETH_RSS_HASH_NO_CHANGE
is 0 and struct is zalloc'd. But as this fix exemplifies storing
NO_CHANGE as state is fragile.

This issue is implicitly caught by running our selftests because
YNL in selftests errors out on unknown bits.

Fixes: d3e2c7bab124 ("ethtool: rss: support setting input-xfrm via Netlink")
Link: https://patch.msgid.link/20260130190311.811129-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/common.c | 3 ---
 net/ethtool/rss.c    | 9 ++-------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 55223ebc2a7e6..146c7eaedc5ac 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -854,9 +854,6 @@ ethtool_rxfh_ctx_alloc(const struct ethtool_ops *ops,
 	ctx->key_off = key_off;
 	ctx->priv_size = ops->rxfh_priv_size;
 
-	ctx->hfunc = ETH_RSS_HASH_NO_CHANGE;
-	ctx->input_xfrm = RXH_XFRM_NO_CHANGE;
-
 	return ctx;
 }
 
diff --git a/net/ethtool/rss.c b/net/ethtool/rss.c
index 4dced53be4b3b..da5934cceb075 100644
--- a/net/ethtool/rss.c
+++ b/net/ethtool/rss.c
@@ -824,8 +824,8 @@ rss_set_ctx_update(struct ethtool_rxfh_context *ctx, struct nlattr **tb,
 static int
 ethnl_rss_set(struct ethnl_req_info *req_info, struct genl_info *info)
 {
-	bool indir_reset = false, indir_mod, xfrm_sym = false;
 	struct rss_req_info *request = RSS_REQINFO(req_info);
+	bool indir_reset = false, indir_mod, xfrm_sym;
 	struct ethtool_rxfh_context *ctx = NULL;
 	struct net_device *dev = req_info->dev;
 	bool mod = false, fields_mod = false;
@@ -860,12 +860,7 @@ ethnl_rss_set(struct ethnl_req_info *req_info, struct genl_info *info)
 
 	rxfh.input_xfrm = data.input_xfrm;
 	ethnl_update_u8(&rxfh.input_xfrm, tb[ETHTOOL_A_RSS_INPUT_XFRM], &mod);
-	/* For drivers which don't support input_xfrm it will be set to 0xff
-	 * in the RSS context info. In all other case input_xfrm != 0 means
-	 * symmetric hashing is requested.
-	 */
-	if (!request->rss_context || ops->rxfh_per_ctx_key)
-		xfrm_sym = rxfh.input_xfrm || data.input_xfrm;
+	xfrm_sym = rxfh.input_xfrm || data.input_xfrm;
 	if (rxfh.input_xfrm == data.input_xfrm)
 		rxfh.input_xfrm = RXH_XFRM_NO_CHANGE;
 
-- 
2.51.0



