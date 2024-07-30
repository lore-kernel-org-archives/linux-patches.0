Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A120F1A6169;
	Tue, 30 Jul 2024 16:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356492; cv=none; b=qVA6LcIsMF/rlA1NnUBJIhb1TjqjdtA/JWuBu6Cp3OFmLt6JrThTK6ExK3UaU+sZZvu6+LxLejgUKjo22kLJjkuvcfa7MO5Dw9VYf4hVNeJkxy1mxtPGpKe6sji9KiiQZHjx3enqfQlAPyN7ubh5nYo2fWFCKg0wv0uJBkFo7OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356492; c=relaxed/simple;
	bh=VZ1KNVu/D1ejiqua6CaBjEU/n7ZSLHLd4LFmceNA6W4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LG79VcwuTx3NVm35y3xJFSwO/nScW1K1xcU0YbSSqX9Ng9P+ST1hrul3irbe2vC74TIDr/0vkXl1tpQNLlqoZJi9i6iZtejHXs43JfB2c6pkcoYs7d3vRUxlZ6bG5Ia7mYIu6/cRWuN/P8BAn75gbgb+pp4WbA58hhLkuc3KsBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/pwa/WD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/pwa/WD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24014C32782;
	Tue, 30 Jul 2024 16:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356492;
	bh=VZ1KNVu/D1ejiqua6CaBjEU/n7ZSLHLd4LFmceNA6W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/pwa/WDe3+j18CKC2t3QA4FB7Lg89qvxQPDs7yOrpaJcRMzo23ijAzbU+vu+sp83
	 HJSudmxdYdhZut4EsOAqCWdVipvgMtbrkbngEZ4NnVn4dh+eiHF2sFw+BrWaw1U+hY
	 dsl9dRgc5ufdv+rK7MPtF8fyvhP6TVvl7ENL/lWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 153/568] xfrm: fix netdev reference count imbalance
Date: Tue, 30 Jul 2024 17:44:20 +0200
Message-ID: <20240730151645.855144243@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7692d587e59b8..8a6e8656d014f 100644
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



