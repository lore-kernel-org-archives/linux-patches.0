Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F98E50257D;
	Thu, 17 Sep 2026 17:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664961; cv=none; b=Du2C6h01SqHp2oYKZFL3VOa660kWc1ooYMZtfT26eT8pE0TsM7KlDLgOXBUxo8p1kA1JeEVUxRFIF8Bei05T+uTevzesqUVc6e2QUNxeyFaqcqnb3/k5f86NNkAHHmdZYUImy5/NFJe+aOxp1GgbAxXcTCVARCcfF34EXz+TasY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664961; c=relaxed/simple;
	bh=AQl7ZxD7q8us8BLw8dRejRdmFAD3Dp46qFWvNNs5q+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCP3Nu0TLtnl6EhvZmP0qln5w7+MPYn65eczAtLEaS2JKpDM/NpYa6ylzUYp5QGCkG/cbGhtaigqQVFOCHPv5lPzALav+phWpWSqFL2sxWB52J1ayWbYkYWyUvOVJPD0+p8EHwesI4KmHoW68JHZarwHkGY5AUOgpQM2s5xh2UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NnkIcTjt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NnkIcTjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF0E1F000FF;
	Thu, 17 Sep 2026 17:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664960;
	bh=WofmMJ4Wh2FSu3qXiKALH8fiIG3ZHNgMW5bpVve0B1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NnkIcTjtDNnTWg8oHtbtzEwQIlTwdG1baEVD8C6M4dpUrSg9b45iLd+egHK8iEYfA
	 sbGpGOKl+o8WiGEIZwwqS4dODCfz6zvS6BrzLi8RLmUvJJmxliWGREhlaVeocWgE7K
	 VbZhivwq4XKi0qsIN9SYxguD1MESfb2J0xcw8/yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minhong He <heminhong@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0545/1250] phonet: check register_netdevice_notifier() error in phonet_device_init()
Date: Thu, 17 Sep 2026 16:05:40 +0100
Message-ID: <20260917151606.708957595@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ec9363c337a9f..4bf8f63d45a9a 100644
--- a/net/phonet/pn_dev.c
+++ b/net/phonet/pn_dev.c
@@ -350,16 +350,34 @@ static struct pernet_operations phonet_net_ops = {
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
 
@@ -367,8 +385,8 @@ void phonet_device_exit(void)
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



