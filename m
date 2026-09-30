Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1656A51FCA3;
	Wed, 30 Sep 2026 16:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784797; cv=none; b=lKTRdDff25YktC3dLAyXiYxneVz/byMX67CC+wk6yqxw+hhUzu7/GtoqZ0iHpyD7CjHgU+PXhSYmhc/F7RFeK9/ZkqFUoM1hPrKoEixjGw/ozoPy7Qe92b9p4SoAxFEwSRBQ8UKXaG/wnU9U0xa2O8o4EWqVrxo4vLsNmJj3kns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784797; c=relaxed/simple;
	bh=wZLIWzCSNML3ZDdfxSHGu3mYt3nf+toyLDCepfBzswI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFUpIgaozDiuIX7eq41PoceAKkDRolZMMM4Rz+6vm4f3W3TUgbLFwXMgsUzt7lUvmGGsmmvj7z/MO2ZpzGJam2YzPcDUMeHgjq84loIRkwmJIPeOdkfRJ9Ot/wqo66hkvAGOT1p4WNCIdxU3jbNKMhx9CDamNdimKE+RN3BosmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=orZaGQgL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="orZaGQgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C311F00898;
	Wed, 30 Sep 2026 16:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784790;
	bh=lusvd2PZyMhvnlWdYMdg39ha7ADqJvmWPOmXaEEegyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=orZaGQgLzkvYWlG+MNAvQque/p4Dtpr84u6U+mSYWEKkXh2v0lg2dxBB/nCGQDrH2
	 tHTRV/D/3LwMfb7fZElZVX7Pms9V54R01X25Ke389ZeISWLQMCwBZKRa0v9PJ3OZUk
	 EdlUXo5sbHDBVz+R7pK6/9jAP/GAWCapXl78pTU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minhong He <heminhong@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 280/982] phonet: check register_netdevice_notifier() error in phonet_device_init()
Date: Wed, 30 Sep 2026 17:16:56 +0200
Message-ID: <20260930152422.811406371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Minhong He <heminhong@kylinos.cn>

[ Upstream commit d1ff66b66151c14b084e88040512a064b1c1e493 ]

phonet_device_init() registers a netdevice notifier before calling
phonet_netlink_register(), but does not check whether notifier
registration succeeded. On failure, netlink setup still proceeds and
init may return success without the notifier in place.

Also, the existing phonet_netlink_register() failure path called
phonet_device_exit(), which runs rtnl_unregister_all() even though
rtnl_register_many() already unwound any partial registration. Calling
the full exit helper on a partial init is not correct.

Check each registration error, including proc_create_net(), and unwind
only the steps that have succeeded so far, in reverse order.

Signed-off-by: Minhong He <heminhong@kylinos.cn>
Link: https://patch.msgid.link/20260721093956.162617-1-heminhong@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/phonet/pn_dev.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/net/phonet/pn_dev.c b/net/phonet/pn_dev.c
index 3f020c362d6cd..260131669ed73 100644
--- a/net/phonet/pn_dev.c
+++ b/net/phonet/pn_dev.c
@@ -336,16 +336,34 @@ static struct pernet_operations phonet_net_ops = {
 /* Initialize Phonet devices list */
 int __init phonet_device_init(void)
 {
-	int err = register_pernet_subsys(&phonet_net_ops);
+	int err;
+
+	err = register_pernet_subsys(&phonet_net_ops);
 	if (err)
 		return err;
 
-	proc_create_net("pnresource", 0, init_net.proc_net, &pn_res_seq_ops,
-			sizeof(struct seq_net_private));
-	register_netdevice_notifier(&phonet_device_notifier);
+	if (!proc_create_net("pnresource", 0, init_net.proc_net,
+			     &pn_res_seq_ops, sizeof(struct seq_net_private))) {
+		err = -ENOMEM;
+		goto err_pernet;
+	}
+
+	err = register_netdevice_notifier(&phonet_device_notifier);
+	if (err)
+		goto err_proc;
+
 	err = phonet_netlink_register();
 	if (err)
-		phonet_device_exit();
+		goto err_notifier;
+
+	return 0;
+
+err_notifier:
+	unregister_netdevice_notifier(&phonet_device_notifier);
+err_proc:
+	remove_proc_entry("pnresource", init_net.proc_net);
+err_pernet:
+	unregister_pernet_subsys(&phonet_net_ops);
 	return err;
 }
 
@@ -353,8 +371,8 @@ void phonet_device_exit(void)
 {
 	rtnl_unregister_all(PF_PHONET);
 	unregister_netdevice_notifier(&phonet_device_notifier);
-	unregister_pernet_subsys(&phonet_net_ops);
 	remove_proc_entry("pnresource", init_net.proc_net);
+	unregister_pernet_subsys(&phonet_net_ops);
 }
 
 int phonet_route_add(struct net_device *dev, u8 daddr)
-- 
2.53.0



