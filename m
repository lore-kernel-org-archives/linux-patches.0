Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997D5610B;
	Mon, 14 Oct 2024 14:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916310; cv=none; b=ldo+rYnNie44XzmcRJCoWSbXVlHuYpwH3gd1Mpntv/mj7Zs7Oqm4aCNd/gZQbA1JVV2s97zQ9lrSoH1k8A1wcE6oBdYYcQOByqSOCc1hGvYiRDtYsrrOWzpz5qWM+q6qY0dMITMJcD7tJkeu20Bo/TAM1AW309RpkoHJeg4ZmBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916310; c=relaxed/simple;
	bh=po3OwcMN/bNdUl1IBtqJmy4joCrWx0ex9pzeoaFHXFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8x3i6YGo1UNEc2UAi6yy4/LH9eg1Wa/P+7CtxicVFHiMKAAmP7VkVsR749BDJHumboMdZBCYwcJZozUv4snW/8rnb1z8zmKcz3sCvyaTZgSxFKmdxyzHjFr2IpQZYktneLzGNPn0af3P3ga0rW3kUtLSBD2cq7YL2wWPmeKPLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VvO6uket; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VvO6uket"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23724C4CEC3;
	Mon, 14 Oct 2024 14:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916310;
	bh=po3OwcMN/bNdUl1IBtqJmy4joCrWx0ex9pzeoaFHXFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VvO6uket3iHAmaSw+6Wzfl1etlxmyWd1pBYydFIr1Vn0Pl0pxJFjttxgNj6MqvuE9
	 SiUApR17UyoR/LGbIGyZ3g2qp68KfilJP7VIMo+XA5e2TVyVVkygON3bP2FcEgDhjz
	 bbb2FXSatcziXElkPXtEfWsoU7/OuBQAtHkg3N6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 145/214] mpls: Handle error of rtnl_register_module().
Date: Mon, 14 Oct 2024 16:20:08 +0200
Message-ID: <20241014141050.644711662@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 5be2062e3080e3ff6707816caa445ec0c6eaacf7 ]

Since introduced, mpls_init() has been ignoring the returned
value of rtnl_register_module(), which could fail silently.

Handling the error allows users to view a module as an all-or-nothing
thing in terms of the rtnetlink functionality.  This prevents syzkaller
from reporting spurious errors from its tests, where OOM often occurs
and module is automatically loaded.

Let's handle the errors by rtnl_register_many().

Fixes: 03c0566542f4 ("mpls: Netlink commands to add, remove, and dump routes")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mpls/af_mpls.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 0e6c94a8c2bc6..4f6836677e40b 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -2730,6 +2730,15 @@ static struct rtnl_af_ops mpls_af_ops __read_mostly = {
 	.get_stats_af_size = mpls_get_stats_af_size,
 };
 
+static const struct rtnl_msg_handler mpls_rtnl_msg_handlers[] __initdata_or_module = {
+	{THIS_MODULE, PF_MPLS, RTM_NEWROUTE, mpls_rtm_newroute, NULL, 0},
+	{THIS_MODULE, PF_MPLS, RTM_DELROUTE, mpls_rtm_delroute, NULL, 0},
+	{THIS_MODULE, PF_MPLS, RTM_GETROUTE, mpls_getroute, mpls_dump_routes, 0},
+	{THIS_MODULE, PF_MPLS, RTM_GETNETCONF,
+	 mpls_netconf_get_devconf, mpls_netconf_dump_devconf,
+	 RTNL_FLAG_DUMP_UNLOCKED},
+};
+
 static int __init mpls_init(void)
 {
 	int err;
@@ -2748,24 +2757,25 @@ static int __init mpls_init(void)
 
 	rtnl_af_register(&mpls_af_ops);
 
-	rtnl_register_module(THIS_MODULE, PF_MPLS, RTM_NEWROUTE,
-			     mpls_rtm_newroute, NULL, 0);
-	rtnl_register_module(THIS_MODULE, PF_MPLS, RTM_DELROUTE,
-			     mpls_rtm_delroute, NULL, 0);
-	rtnl_register_module(THIS_MODULE, PF_MPLS, RTM_GETROUTE,
-			     mpls_getroute, mpls_dump_routes, 0);
-	rtnl_register_module(THIS_MODULE, PF_MPLS, RTM_GETNETCONF,
-			     mpls_netconf_get_devconf,
-			     mpls_netconf_dump_devconf,
-			     RTNL_FLAG_DUMP_UNLOCKED);
-	err = ipgre_tunnel_encap_add_mpls_ops();
+	err = rtnl_register_many(mpls_rtnl_msg_handlers);
 	if (err)
+		goto out_unregister_rtnl_af;
+
+	err = ipgre_tunnel_encap_add_mpls_ops();
+	if (err) {
 		pr_err("Can't add mpls over gre tunnel ops\n");
+		goto out_unregister_rtnl;
+	}
 
 	err = 0;
 out:
 	return err;
 
+out_unregister_rtnl:
+	rtnl_unregister_many(mpls_rtnl_msg_handlers);
+out_unregister_rtnl_af:
+	rtnl_af_unregister(&mpls_af_ops);
+	dev_remove_pack(&mpls_packet_type);
 out_unregister_pernet:
 	unregister_pernet_subsys(&mpls_net_ops);
 	goto out;
-- 
2.43.0



