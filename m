Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864AD1ABEA7;
	Mon, 14 Oct 2024 15:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919976; cv=none; b=aolYnvFWDvouJcBnGibUafPnLvvl6IuxpOTJJXrg0Mx3XKGHpGkEtAJSj3Fa319hOwV6IlGs11+hms6YbmAL1LWry3gd1w3xeOk/xtIH490h6fMlbliFnwNJ1PkizXd/w9c+LjWFCS8kd8KL/AFewjD5XAovYo6FwQ+ZpfvR0qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919976; c=relaxed/simple;
	bh=MTlfc8OEAN07rzWijtdwyYjJz2f98CwDDkcS6Nq+TRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjGp6cMraqGX3fpmK9nzv7MvBTbAyToCCnNHxqqybBCZbBFUdho3iBtKmhisUNfpnaydsBYEBCT8iUnvYtzUq2x7m/pNmBDTfHfzOfZG/6dh2IzxALbpg9FHFQa8pV78KFCkEMoTKxod3Q9q2nSxCG102TuX8ZPfGgqLC4my6nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WkpbvkBh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WkpbvkBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB31C4CEC3;
	Mon, 14 Oct 2024 15:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919976;
	bh=MTlfc8OEAN07rzWijtdwyYjJz2f98CwDDkcS6Nq+TRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WkpbvkBhQFTue7mGdTdCJBVmxvpr0azdSz7ry30uK0mQa9vCkB6VV+rSSLIADDZla
	 imPDlHLeCiN94h3Sz26SS+AF22KPiK8TjuBg9qzcx2q4lPYUzYb5GF/lFCPeu1UzXP
	 0kcR4KKLW4ytqyLuZAbeOu/BCkake2FDlMzKDZJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 761/798] vxlan: Handle error of rtnl_register_module().
Date: Mon, 14 Oct 2024 16:21:55 +0200
Message-ID: <20241014141247.965893793@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 78b7b991838a4a6baeaad934addc4db2c5917eb8 ]

Since introduced, vxlan_vnifilter_init() has been ignoring the
returned value of rtnl_register_module(), which could fail silently.

Handling the error allows users to view a module as an all-or-nothing
thing in terms of the rtnetlink functionality.  This prevents syzkaller
from reporting spurious errors from its tests, where OOM often occurs
and module is automatically loaded.

Let's handle the errors by rtnl_register_many().

Fixes: f9c4bb0b245c ("vxlan: vni filtering support on collect metadata device")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c      |  6 +++++-
 drivers/net/vxlan/vxlan_private.h   |  2 +-
 drivers/net/vxlan/vxlan_vnifilter.c | 19 +++++++++----------
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 61224a5a877cb..155d335c80a7e 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -4803,9 +4803,13 @@ static int __init vxlan_init_module(void)
 	if (rc)
 		goto out4;
 
-	vxlan_vnifilter_init();
+	rc = vxlan_vnifilter_init();
+	if (rc)
+		goto out5;
 
 	return 0;
+out5:
+	rtnl_link_unregister(&vxlan_link_ops);
 out4:
 	unregister_switchdev_notifier(&vxlan_switchdev_notifier_block);
 out3:
diff --git a/drivers/net/vxlan/vxlan_private.h b/drivers/net/vxlan/vxlan_private.h
index 599c3b4fdd5ed..b0e8c6d290579 100644
--- a/drivers/net/vxlan/vxlan_private.h
+++ b/drivers/net/vxlan/vxlan_private.h
@@ -134,7 +134,7 @@ int vxlan_vni_in_use(struct net *src_net, struct vxlan_dev *vxlan,
 int vxlan_vnigroup_init(struct vxlan_dev *vxlan);
 void vxlan_vnigroup_uninit(struct vxlan_dev *vxlan);
 
-void vxlan_vnifilter_init(void);
+int vxlan_vnifilter_init(void);
 void vxlan_vnifilter_uninit(void);
 void vxlan_vnifilter_count(struct vxlan_dev *vxlan, __be32 vni,
 			   struct vxlan_vni_node *vninode,
diff --git a/drivers/net/vxlan/vxlan_vnifilter.c b/drivers/net/vxlan/vxlan_vnifilter.c
index c5cf55030158f..3d113d709d194 100644
--- a/drivers/net/vxlan/vxlan_vnifilter.c
+++ b/drivers/net/vxlan/vxlan_vnifilter.c
@@ -992,19 +992,18 @@ static int vxlan_vnifilter_process(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
-void vxlan_vnifilter_init(void)
+static const struct rtnl_msg_handler vxlan_vnifilter_rtnl_msg_handlers[] = {
+	{THIS_MODULE, PF_BRIDGE, RTM_GETTUNNEL, NULL, vxlan_vnifilter_dump, 0},
+	{THIS_MODULE, PF_BRIDGE, RTM_NEWTUNNEL, vxlan_vnifilter_process, NULL, 0},
+	{THIS_MODULE, PF_BRIDGE, RTM_DELTUNNEL, vxlan_vnifilter_process, NULL, 0},
+};
+
+int vxlan_vnifilter_init(void)
 {
-	rtnl_register_module(THIS_MODULE, PF_BRIDGE, RTM_GETTUNNEL, NULL,
-			     vxlan_vnifilter_dump, 0);
-	rtnl_register_module(THIS_MODULE, PF_BRIDGE, RTM_NEWTUNNEL,
-			     vxlan_vnifilter_process, NULL, 0);
-	rtnl_register_module(THIS_MODULE, PF_BRIDGE, RTM_DELTUNNEL,
-			     vxlan_vnifilter_process, NULL, 0);
+	return rtnl_register_many(vxlan_vnifilter_rtnl_msg_handlers);
 }
 
 void vxlan_vnifilter_uninit(void)
 {
-	rtnl_unregister(PF_BRIDGE, RTM_GETTUNNEL);
-	rtnl_unregister(PF_BRIDGE, RTM_NEWTUNNEL);
-	rtnl_unregister(PF_BRIDGE, RTM_DELTUNNEL);
+	rtnl_unregister_many(vxlan_vnifilter_rtnl_msg_handlers);
 }
-- 
2.43.0



