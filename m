Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627F71A617E;
	Tue, 30 Jul 2024 16:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357190; cv=none; b=BvEFIoxl9Opk1p6krxKi+4RaBSgEMRO0mNtV3BfYQgkM5nXdvZ3NIWF5H1xdrNcpuGZfpWfk0l93q8rUSSYJBGu7nQjxXpEvgpSEOXJTi976YtexGT3ORyrxRWkfmSs6rgni8kN9YhzVk3N4xG8Xy9GWx9Ju3jCs8DrtG4qrwIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357190; c=relaxed/simple;
	bh=l2g4YjY6FS0dXfS+1vTCN4BshcT12srYe665In2wvOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LW+CJWic4uoWR/Gm8f/iXmlZGkJuANHTE1147FdwWf3kHc3FrM7Egv/Z+LVI2rR+/yFveDehcHjVXyVIh/KiMiNbKpukswvTx6c3K1C+/wdKFMIKU8WgLlHU9fm0x73zwh+drJpp3QGws3aAxDjjlMh924HjWtKMaSedSj57iig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1TWMhXpL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1TWMhXpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09A0C32782;
	Tue, 30 Jul 2024 16:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357190;
	bh=l2g4YjY6FS0dXfS+1vTCN4BshcT12srYe665In2wvOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1TWMhXpL7bPjqkAHzymnYhwFNHveth+IZVqngpJGFhknOM/vyZcb3We2uHTb/3pc/
	 60H2VYze7aJvoIDUm9UX1rDrSvBk13zxtE2K/Q2aMm61273Il9EouLl3t8ZBc1eruc
	 1/6vcJLT59enDF76rRPy5NRbmk3UmDji7DAvVnOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 231/809] xfrm: call xfrm_dev_policy_delete when kill policy
Date: Tue, 30 Jul 2024 17:41:47 +0200
Message-ID: <20240730151733.730771449@linuxfoundation.org>
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

[ Upstream commit 89a2aefe4b084686c2ffc1ee939585111ea4fc0f ]

xfrm_policy_kill() is called at different places to delete xfrm
policy. It will call xfrm_pol_put(). But xfrm_dev_policy_delete() is
not called to free the policy offloaded to hardware.

The three commits cited here are to handle this issue by calling
xfrm_dev_policy_delete() outside xfrm_get_policy(). But they didn't
cover all the cases. An example, which is not handled for now, is
xfrm_policy_insert(). It is called when XFRM_MSG_UPDPOLICY request is
received. Old policy is replaced by new one, but the offloaded policy
is not deleted, so driver doesn't have the chance to release hardware
resources.

To resolve this issue for all cases, move xfrm_dev_policy_delete()
into xfrm_policy_kill(), so the offloaded policy can be deleted from
hardware when it is called, which avoids hardware resources leakage.

Fixes: 919e43fad516 ("xfrm: add an interface to offload policy")
Fixes: bf06fcf4be0f ("xfrm: add missed call to delete offloaded policies")
Fixes: 982c3aca8bac ("xfrm: delete offloaded policy")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c | 5 ++---
 net/xfrm/xfrm_user.c   | 1 -
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 66e07de2de35c..56b88ad88db6f 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -452,6 +452,8 @@ EXPORT_SYMBOL(xfrm_policy_destroy);
 
 static void xfrm_policy_kill(struct xfrm_policy *policy)
 {
+	xfrm_dev_policy_delete(policy);
+
 	write_lock_bh(&policy->lock);
 	policy->walk.dead = 1;
 	write_unlock_bh(&policy->lock);
@@ -1850,7 +1852,6 @@ int xfrm_policy_flush(struct net *net, u8 type, bool task_valid)
 
 		__xfrm_policy_unlink(pol, dir);
 		spin_unlock_bh(&net->xfrm.xfrm_policy_lock);
-		xfrm_dev_policy_delete(pol);
 		cnt++;
 		xfrm_audit_policy_delete(pol, 1, task_valid);
 		xfrm_policy_kill(pol);
@@ -1891,7 +1892,6 @@ int xfrm_dev_policy_flush(struct net *net, struct net_device *dev,
 
 		__xfrm_policy_unlink(pol, dir);
 		spin_unlock_bh(&net->xfrm.xfrm_policy_lock);
-		xfrm_dev_policy_delete(pol);
 		cnt++;
 		xfrm_audit_policy_delete(pol, 1, task_valid);
 		xfrm_policy_kill(pol);
@@ -2342,7 +2342,6 @@ int xfrm_policy_delete(struct xfrm_policy *pol, int dir)
 	pol = __xfrm_policy_unlink(pol, dir);
 	spin_unlock_bh(&net->xfrm.xfrm_policy_lock);
 	if (pol) {
-		xfrm_dev_policy_delete(pol);
 		xfrm_policy_kill(pol);
 		return 0;
 	}
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index e83c687bd64ee..77355422ce82a 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2455,7 +2455,6 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 					    NETLINK_CB(skb).portid);
 		}
 	} else {
-		xfrm_dev_policy_delete(xp);
 		xfrm_audit_policy_delete(xp, err ? 0 : 1, true);
 
 		if (err != 0)
-- 
2.43.0



