Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F731171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9755DC433C7;
	Mon, 21 Aug 2023 20:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648346;
	bh=PkHkmBpYcbyg0XiF+lN1MRv1L3XZW1VvVzv+oNDJH9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bigtr/HDv4nVXMkDUS3kcIAQYZLp6RJrk6CLyrKSJSnMaiQSzdTMVbGpk9CYOXWov
	 wux6oWHkv+u8ynXAud9KtfLB/Ov5z90VigK2GYfMoE/H/J50CB64gfM4SOhbEu0fsD
	 Ba/cTKGk8OECV7XgiTKYa+koFsd80YfFt2cZIBOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 142/234] xfrm: dont skip free of empty state in acquire policy
Date: Mon, 21 Aug 2023 21:41:45 +0200
Message-ID: <20230821194135.104468180@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit f3ec2b5d879ef5bbcb24678914641343cb6399a2 ]

In destruction flow, the assignment of NULL to xso->dev
caused to skip of xfrm_dev_state_free() call, which was
called in xfrm_state_put(to_put) routine.

Instead of open-coded variant of xfrm_dev_state_delete() and
xfrm_dev_state_free(), let's use them directly.

Fixes: f8a70afafc17 ("xfrm: add TX datapath support for IPsec packet offload mode")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h    | 1 +
 net/xfrm/xfrm_state.c | 8 ++------
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 151ca95dd08db..363c7d5105542 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1984,6 +1984,7 @@ static inline void xfrm_dev_state_free(struct xfrm_state *x)
 		if (dev->xfrmdev_ops->xdo_dev_state_free)
 			dev->xfrmdev_ops->xdo_dev_state_free(x);
 		xso->dev = NULL;
+		xso->type = XFRM_DEV_OFFLOAD_UNSPECIFIED;
 		netdev_put(dev, &xso->dev_tracker);
 	}
 }
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 49e63eea841dd..bda5327bf34df 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1324,12 +1324,8 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 			struct xfrm_dev_offload *xso = &x->xso;
 
 			if (xso->type == XFRM_DEV_OFFLOAD_PACKET) {
-				xso->dev->xfrmdev_ops->xdo_dev_state_delete(x);
-				xso->dir = 0;
-				netdev_put(xso->dev, &xso->dev_tracker);
-				xso->dev = NULL;
-				xso->real_dev = NULL;
-				xso->type = XFRM_DEV_OFFLOAD_UNSPECIFIED;
+				xfrm_dev_state_delete(x);
+				xfrm_dev_state_free(x);
 			}
 #endif
 			x->km.state = XFRM_STATE_DEAD;
-- 
2.40.1



