Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A3D171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9546EC433D2;
	Mon, 22 May 2023 19:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784779;
	bh=ZJGyKJX+SJn7/ogkf8kjQ039MZHB/DIAntQZJF7LQlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fpsfs7Bm7VWG0SBpXBGfhIK72yJkTtY9hcGKAOpWOSYGbroxm6ZpqqsaIFcP1THP7
	 HOobmErBAIx2ifn/ffXhGqxQcY3HOgmQP0AK7coNbdAkMLe3pZmvpZq50PcRqa7Cko
	 XVwTZiWUI+tuGoHiWtOt6J+BzvDGZ4n0TKDddlOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Simon Horman <simon.horman@corigine.com>,
	Eric Dumazet <edumazet@google.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 200/364] xfrm: Fix leak of dev tracker
Date: Mon, 22 May 2023 20:08:25 +0100
Message-Id: <20230522190417.730362672@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
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

[ Upstream commit ec8f32ad9a65a8cbb465b69e154aaec9d2fe45c4 ]

At the stage of direction checks, the netdev reference tracker is
already initialized, but released with wrong *_put() call.

Fixes: 919e43fad516 ("xfrm: add an interface to offload policy")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 95f1436bf6a2e..e2ca50bfca24f 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -378,7 +378,7 @@ int xfrm_dev_policy_add(struct net *net, struct xfrm_policy *xp,
 		break;
 	default:
 		xdo->dev = NULL;
-		dev_put(dev);
+		netdev_put(dev, &xdo->dev_tracker);
 		NL_SET_ERR_MSG(extack, "Unrecognized offload direction");
 		return -EINVAL;
 	}
-- 
2.39.2



