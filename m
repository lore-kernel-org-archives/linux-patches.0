Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6B71AB6FF;
	Mon, 14 Oct 2024 14:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917128; cv=none; b=TvMT31+ZdIfvyj3rGtbyTaTJqJ7Mo1I8fSj+A6FvqxD+xcmKjZlUhFXj9acPgHloK/kQZQk9QUcDXaWho+oJq+z2LA2Y4zVwxu3migjeiigrb4Ai5TpM5/zT3Vjz7YoYToYReNHVzLJq4odwwtlOazTrNj8HiSRuafJikkgrtNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917128; c=relaxed/simple;
	bh=/XpduKXN43olrhf3HLhOdQvnYO97Bou0H+V1M1U08ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fozuxvH8hknXMl7kUNUqDHMvF9cO8vJnO5njnqOhLv3DVTtzOxNT74vFYDyLEos0H2Lv0w1jYwfF6dpccPNh1Uxn0U9EM2FmFjfza3Ocm5sTl7ZI/14EHZQnBfsAIz/lXLnDfWZRKBGYjDQk/ozqZZoRNeeFgGVWNqbNm4RUvOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uar8QJzz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uar8QJzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05CDC4CECF;
	Mon, 14 Oct 2024 14:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917128;
	bh=/XpduKXN43olrhf3HLhOdQvnYO97Bou0H+V1M1U08ZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uar8QJzzNbKA9M71HZccEtppSTZ14qroHiVQbDXbw0udm5M7VWtCaf0+FKG2xRGXJ
	 l66IOiep7a79zmtDOYDqb48m3TlEsWIUKM2d8LyWCZbqUYe/Lok2Lsfm8qSv7TcLwa
	 hoj6SKjSnWg0ku0unuIJsy5xY92skD4fHskvWLVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 159/213] mpls: Handle error of rtnl_register_module().
Date: Mon, 14 Oct 2024 16:21:05 +0200
Message-ID: <20241014141049.177358087@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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
index ba034fcd59f0d..43e8343df0db7 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -2729,6 +2729,15 @@ static struct rtnl_af_ops mpls_af_ops __read_mostly = {
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
@@ -2747,24 +2756,25 @@ static int __init mpls_init(void)
 
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



