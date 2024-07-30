Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA7F1A617E;
	Tue, 30 Jul 2024 16:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357180; cv=none; b=aolX+3Smmy0WoUkOf2MpQ4jRz5gdq7zhE+mArLSdb/PXf3w0HA//XrKth2uQG0pP0ZVQR8tuLbMhH+95FqfFVDOc+Y+Xmmah2XgmG6B4HL9Vi1lNQ/m1i2dhYunUaPoLm4XuETWwDAyh3N/MK9XR0upcCkHaXupk+wh2GCn1eTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357180; c=relaxed/simple;
	bh=8qCRcau7r/isL8d2ld6n8WelIEqBEHWgDSwofF3vn8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJtATh+dJqLgPVWSIrEjX9i4t0tdHqm34z5ERwEDBuPfgr81uqqjCdbheIiSq5pgMzj3KuPS66MzD9aHaMTXnpQpZIm+6TKYbURHO78T1I9ikBBRi7vUT22IAFHlKdlQ7o3DEofgNhq+ocFhIKRA6JeDXN6f93ZNKZPOZwJxtlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WwVlaq9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WwVlaq9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C52C32782;
	Tue, 30 Jul 2024 16:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357180;
	bh=8qCRcau7r/isL8d2ld6n8WelIEqBEHWgDSwofF3vn8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WwVlaq9pglzgPTc1stPeXzMhteIOKNN4iw6vfmw1wWHlIc+PurdTtTAMqhlGF71wV
	 q1xFOQHiwUUpPYtc7PH1nwFpr7kfgNJhhzd+MAYlzWpvOxMNPb5l3MiwNrOj5jYmfg
	 kG9NQlbzl6T/zLnuIqEEX9xZznkck8o2hf2N7nNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 230/809] xfrm: fix netdev reference count imbalance
Date: Tue, 30 Jul 2024 17:41:46 +0200
Message-ID: <20240730151733.692273168@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 9199b915e9fad7f5eff6160d24ff6b38e970107d ]

In cited commit, netdev_tracker_alloc() is called for the newly
allocated xfrm state, but dev_hold() is missed, which causes netdev
reference count imbalance, because netdev_put() is called when the
state is freed in xfrm_dev_state_free(). Fix the issue by replacing
netdev_tracker_alloc() with netdev_hold().

Fixes: f8a70afafc17 ("xfrm: add TX datapath support for IPsec packet offload mode")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 936f9348e5f63..67b2a399a48a7 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1331,8 +1331,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 			xso->dev = xdo->dev;
 			xso->real_dev = xdo->real_dev;
 			xso->flags = XFRM_DEV_OFFLOAD_FLAG_ACQ;
-			netdev_tracker_alloc(xso->dev, &xso->dev_tracker,
-					     GFP_ATOMIC);
+			netdev_hold(xso->dev, &xso->dev_tracker, GFP_ATOMIC);
 			error = xso->dev->xfrmdev_ops->xdo_dev_state_add(x, NULL);
 			if (error) {
 				xso->dir = 0;
-- 
2.43.0



