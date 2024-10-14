Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BACB19F43B;
	Mon, 14 Oct 2024 15:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919980; cv=none; b=JDXZxef45fVRnrj7VZVwvoclUqFyXOQsteroFrnIDGGWNVF7kBlQUC2mLKomKz7602stezVFlLmzpxU/WeXHMcJHW2sC5XfxR5sB6IOmiFQU5nInw/XCOnNCLI75eJxqqamIPv9MPJxqlFOpUcRUwoxmNwDdAHw+EPd7qdw6vyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919980; c=relaxed/simple;
	bh=MZb96Sup1b7A0vP+DGVU5v+qPm5qwr9eqdcA3IpntC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GdbypCGn4xCgNBUh+nP8UjWcvFS0GgFbRBZe9vSzqZMP+PkCfav9Lk9/h215FvXisFc07PAzlY0gpnWZTrrOhJVJM14Jbo4xvNs6Jiw2XN3lPxzqsF+2a9DRYClOJ2NAFUu4jl/IwWSgXLHesFPeOYpMcmak7tr0L1TCHYwuZ/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=At6Vb5hA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="At6Vb5hA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E25CC4CEC3;
	Mon, 14 Oct 2024 15:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919980;
	bh=MZb96Sup1b7A0vP+DGVU5v+qPm5qwr9eqdcA3IpntC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=At6Vb5hAp/t81PoVQRMv/+kt6h9NUTbg9VdTJqXFVunYr3HHOYyiDXeuVShuH7XCr
	 I78M/KWdwPZWJfLqoTZWRHxNusn7aYeLWYv+Uh5h/As9TK4ZGlng+Np+nv/4+cFl1d
	 HYgvvNFl08B1GwwUy4Dz1XByesc+PjhUyg72ToM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 762/798] mctp: Handle error of rtnl_register_module().
Date: Mon, 14 Oct 2024 16:21:56 +0200
Message-ID: <20241014141248.004288078@linuxfoundation.org>
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

[ Upstream commit d51705614f668254cc5def7490df76f9680b4659 ]

Since introduced, mctp has been ignoring the returned value of
rtnl_register_module(), which could fail silently.

Handling the error allows users to view a module as an all-or-nothing
thing in terms of the rtnetlink functionality.  This prevents syzkaller
from reporting spurious errors from its tests, where OOM often occurs
and module is automatically loaded.

Let's handle the errors by rtnl_register_many().

Fixes: 583be982d934 ("mctp: Add device handling and netlink interface")
Fixes: 831119f88781 ("mctp: Add neighbour netlink interface")
Fixes: 06d2f4c583a7 ("mctp: Add netlink route management")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Jeremy Kerr <jk@codeconstruct.com.au>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/mctp.h |  2 +-
 net/mctp/af_mctp.c |  6 +++++-
 net/mctp/device.c  | 30 ++++++++++++++++++------------
 net/mctp/neigh.c   | 31 +++++++++++++++++++------------
 net/mctp/route.c   | 33 +++++++++++++++++++++++----------
 5 files changed, 66 insertions(+), 36 deletions(-)

diff --git a/include/net/mctp.h b/include/net/mctp.h
index 7ed84054f4623..afeda2ad22d6d 100644
--- a/include/net/mctp.h
+++ b/include/net/mctp.h
@@ -293,7 +293,7 @@ void mctp_neigh_remove_dev(struct mctp_dev *mdev);
 int mctp_routes_init(void);
 void mctp_routes_exit(void);
 
-void mctp_device_init(void);
+int mctp_device_init(void);
 void mctp_device_exit(void);
 
 #endif /* __NET_MCTP_H */
diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index 3150f3f0c8725..2316e7772b785 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -677,10 +677,14 @@ static __init int mctp_init(void)
 	if (rc)
 		goto err_unreg_routes;
 
-	mctp_device_init();
+	rc = mctp_device_init();
+	if (rc)
+		goto err_unreg_neigh;
 
 	return 0;
 
+err_unreg_neigh:
+	mctp_neigh_exit();
 err_unreg_routes:
 	mctp_routes_exit();
 err_unreg_proto:
diff --git a/net/mctp/device.c b/net/mctp/device.c
index acb97b2574289..85cc5f31f1e7c 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -524,25 +524,31 @@ static struct notifier_block mctp_dev_nb = {
 	.priority = ADDRCONF_NOTIFY_PRIORITY,
 };
 
-void __init mctp_device_init(void)
+static const struct rtnl_msg_handler mctp_device_rtnl_msg_handlers[] = {
+	{THIS_MODULE, PF_MCTP, RTM_NEWADDR, mctp_rtm_newaddr, NULL, 0},
+	{THIS_MODULE, PF_MCTP, RTM_DELADDR, mctp_rtm_deladdr, NULL, 0},
+	{THIS_MODULE, PF_MCTP, RTM_GETADDR, NULL, mctp_dump_addrinfo, 0},
+};
+
+int __init mctp_device_init(void)
 {
-	register_netdevice_notifier(&mctp_dev_nb);
+	int err;
 
-	rtnl_register_module(THIS_MODULE, PF_MCTP, RTM_GETADDR,
-			     NULL, mctp_dump_addrinfo, 0);
-	rtnl_register_module(THIS_MODULE, PF_MCTP, RTM_NEWADDR,
-			     mctp_rtm_newaddr, NULL, 0);
-	rtnl_register_module(THIS_MODULE, PF_MCTP, RTM_DELADDR,
-			     mctp_rtm_deladdr, NULL, 0);
+	register_netdevice_notifier(&mctp_dev_nb);
 	rtnl_af_register(&mctp_af_ops);
+
+	err = rtnl_register_many(mctp_device_rtnl_msg_handlers);
+	if (err) {
+		rtnl_af_unregister(&mctp_af_ops);
+		unregister_netdevice_notifier(&mctp_dev_nb);
+	}
+
+	return err;
 }
 
 void __exit mctp_device_exit(void)
 {
+	rtnl_unregister_many(mctp_device_rtnl_msg_handlers);
 	rtnl_af_unregister(&mctp_af_ops);
-	rtnl_unregister(PF_MCTP, RTM_DELADDR);
-	rtnl_unregister(PF_MCTP, RTM_NEWADDR);
-	rtnl_unregister(PF_MCTP, RTM_GETADDR);
-
 	unregister_netdevice_notifier(&mctp_dev_nb);
 }
diff --git a/net/mctp/neigh.c b/net/mctp/neigh.c
index ffa0f9e0983fb..590f642413e4e 100644
--- a/net/mctp/neigh.c
+++ b/net/mctp/neigh.c
@@ -322,22 +322,29 @@ static struct pernet_operations mctp_net_ops = {
 	.exit = mctp_neigh_net_exit,
 };
 
+static const struct rtnl_msg_handler mctp_neigh_rtnl_msg_handlers[] = {
+	{THIS_MODULE, PF_MCTP, RTM_NEWNEIGH, mctp_rtm_newneigh, NULL, 0},
+	{THIS_MODULE, PF_MCTP, RTM_DELNEIGH, mctp_rtm_delneigh, NULL, 0},
+	{THIS_MODULE, PF_MCTP, RTM_GETNEIGH, NULL, mctp_rtm_getneigh, 0},
+};
+
 int __init mctp_neigh_init(void)
 {
-	rtnl_register_module(THIS_MODULE, PF_MCTP, RTM_NEWNEIGH,
-			     mctp_rtm_newneigh, NULL, 0);
-	rtnl_register_module(THIS_MODULE, PF_MCTP, RTM_DELNEIGH,
-			     mctp_rtm_delneigh, NULL, 0);
-	rtnl_register_module(THIS_MODULE, PF_MCTP, RTM_GETNEIGH,
-			     NULL, mctp_rtm_getneigh, 0);
-
-	return register_pernet_subsys(&mctp_net_ops);
+	int err;
+
+	err = register_pernet_subsys(&mctp_net_ops);
+	if (err)
+		return err;
+
+	err = rtnl_register_many(mctp_neigh_rtnl_msg_handlers);
+	if (err)
+		unregister_pernet_subsys(&mctp_net_ops);
+
+	return err;
 }
 
-void __exit mctp_neigh_exit(void)
+void mctp_neigh_exit(void)
 {
+	rtnl_unregister_many(mctp_neigh_rtnl_msg_handlers);
 	unregister_pernet_subsys(&mctp_net_ops);
-	rtnl_unregister(PF_MCTP, RTM_GETNEIGH);
-	rtnl_unregister(PF_MCTP, RTM_DELNEIGH);
-	rtnl_unregister(PF_MCTP, RTM_NEWNEIGH);
 }
diff --git a/net/mctp/route.c b/net/mctp/route.c
index 05ab4fddc82e9..ea7cb9973128d 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -1413,26 +1413,39 @@ static struct pernet_operations mctp_net_ops = {
 	.exit = mctp_routes_net_exit,
 };
 
+static const struct rtnl_msg_handler mctp_route_rtnl_msg_handlers[] = {
+	{THIS_MODULE, PF_MCTP, RTM_NEWROUTE, mctp_newroute, NULL, 0},
+	{THIS_MODULE, PF_MCTP, RTM_DELROUTE, mctp_delroute, NULL, 0},
+	{THIS_MODULE, PF_MCTP, RTM_GETROUTE, NULL, mctp_dump_rtinfo, 0},
+};
+
 int __init mctp_routes_init(void)
 {
+	int err;
+
 	dev_add_pack(&mctp_packet_type);
 
-	rtnl_register_module(THIS_MODULE, PF_MCTP, RTM_GETROUTE,
-			     NULL, mctp_dump_rtinfo, 0);
-	rtnl_register_module(THIS_MODULE, PF_MCTP, RTM_NEWROUTE,
-			     mctp_newroute, NULL, 0);
-	rtnl_register_module(THIS_MODULE, PF_MCTP, RTM_DELROUTE,
-			     mctp_delroute, NULL, 0);
+	err = register_pernet_subsys(&mctp_net_ops);
+	if (err)
+		goto err_pernet;
+
+	err = rtnl_register_many(mctp_route_rtnl_msg_handlers);
+	if (err)
+		goto err_rtnl;
 
-	return register_pernet_subsys(&mctp_net_ops);
+	return 0;
+
+err_rtnl:
+	unregister_pernet_subsys(&mctp_net_ops);
+err_pernet:
+	dev_remove_pack(&mctp_packet_type);
+	return err;
 }
 
 void mctp_routes_exit(void)
 {
+	rtnl_unregister_many(mctp_route_rtnl_msg_handlers);
 	unregister_pernet_subsys(&mctp_net_ops);
-	rtnl_unregister(PF_MCTP, RTM_DELROUTE);
-	rtnl_unregister(PF_MCTP, RTM_NEWROUTE);
-	rtnl_unregister(PF_MCTP, RTM_GETROUTE);
 	dev_remove_pack(&mctp_packet_type);
 }
 
-- 
2.43.0



