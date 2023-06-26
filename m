Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1979E134C7
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C050C433C8;
	Mon, 26 Jun 2023 18:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803559;
	bh=Hvl/mQyThRdD9ButtZMhVUgxXtKcwlbSIb4GSy4nPCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BypKMc3l09nbRFqyLVc0478VcMyd+CljTHplTDZC1hbS+0l/9DyEN77bYCslgoad9
	 W10uTxkwKWXhH91hWgWlDP6AFOdE0cMz1r/4eQjgzjXyd2toKIXxNxETThhgDWNEya
	 3JXeuz8SJfgfbY6+KYfj24tEdj330jjOpmKWm1bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Simon Horman <simon.horman@corigine.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 103/199] xfrm: add missed call to delete offloaded policies
Date: Mon, 26 Jun 2023 20:10:09 +0200
Message-ID: <20230626180810.160323167@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
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

[ Upstream commit bf06fcf4be0feefebd27deb8b60ad262f4230489 ]

Offloaded policies are deleted through two flows: netdev is going
down and policy flush.

In both cases, the code lacks relevant call to delete offloaded policy.

Fixes: 919e43fad516 ("xfrm: add an interface to offload policy")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index ff58ce6c030ca..e7617c9959c31 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1831,6 +1831,7 @@ int xfrm_policy_flush(struct net *net, u8 type, bool task_valid)
 
 		__xfrm_policy_unlink(pol, dir);
 		spin_unlock_bh(&net->xfrm.xfrm_policy_lock);
+		xfrm_dev_policy_delete(pol);
 		cnt++;
 		xfrm_audit_policy_delete(pol, 1, task_valid);
 		xfrm_policy_kill(pol);
@@ -1869,6 +1870,7 @@ int xfrm_dev_policy_flush(struct net *net, struct net_device *dev,
 
 		__xfrm_policy_unlink(pol, dir);
 		spin_unlock_bh(&net->xfrm.xfrm_policy_lock);
+		xfrm_dev_policy_delete(pol);
 		cnt++;
 		xfrm_audit_policy_delete(pol, 1, task_valid);
 		xfrm_policy_kill(pol);
-- 
2.39.2



