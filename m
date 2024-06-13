Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC01F145B19;
	Thu, 13 Jun 2024 11:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279522; cv=none; b=TVMrKelzSVENaF6uMGb6PV8Qga9F8u2agP+YJ25yrzhSn2CNf2FZ0mcgXImTJsfL8QIaPaSMICAS3kEZaPwpsikCNuhEhIQZYh7qnIPl9i6KIzUuRa6+rXAmjVePcy/fA5R/Bk7gkyFuesDuWaiTK8SokvBPETlZYPCJkrRKCIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279522; c=relaxed/simple;
	bh=g0TyOnr/+GThwomu5KH1gVAavWrle+dDeNSAWLoXpkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmI+Ji/niJM+5ft79dyzLVWxnHkMX3o/bM23nIaEgKM/HwDXv7d3nviZEs4d8ejjbGGXNTSL7PTlEuYUYPxY/CJOeYHib6tkXrzPmeeikh5ln/QqGt3Q2lbdUEi+P4xc402wUuPpHNjQpDKB8hiQLs+535N/4vAF0oZrdkHIEq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UBPjeB1+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UBPjeB1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A37C2BBFC;
	Thu, 13 Jun 2024 11:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279522;
	bh=g0TyOnr/+GThwomu5KH1gVAavWrle+dDeNSAWLoXpkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UBPjeB1+2+j40eyukBSg6nDial5gdlLGNTCuOArvDVhK5hFa37+P1p4Gkx+kttYQf
	 eYECdoFP+r8QlEt9DGxCOYBq+TSylrli+YGaIpC5Nrv8kGwkG1dZv2a6NGXELyA2Ot
	 7usFdFocIUJ9B2Op7HOPf/npxPXB/uHWYCtHxuLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Battersby <tonyb@cybernetics.com>,
	Simon Horman <horms@kernel.org>,
	Jay Vosburgh <jay.vosburgh@canonical.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.9 105/157] bonding: fix oops during rmmod
Date: Thu, 13 Jun 2024 13:33:50 +0200
Message-ID: <20240613113231.482066497@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Battersby <tonyb@cybernetics.com>

commit a45835a0bb6ef7d5ddbc0714dd760de979cb6ece upstream.

"rmmod bonding" causes an oops ever since commit cc317ea3d927 ("bonding:
remove redundant NULL check in debugfs function").  Here are the relevant
functions being called:

bonding_exit()
  bond_destroy_debugfs()
    debugfs_remove_recursive(bonding_debug_root);
    bonding_debug_root = NULL; <--------- SET TO NULL HERE
  bond_netlink_fini()
    rtnl_link_unregister()
      __rtnl_link_unregister()
        unregister_netdevice_many_notify()
          bond_uninit()
            bond_debug_unregister()
              (commit removed check for bonding_debug_root == NULL)
              debugfs_remove()
              simple_recursive_removal()
                down_write() -> OOPS

However, reverting the bad commit does not solve the problem completely
because the original code contains a race that could cause the same
oops, although it was much less likely to be triggered unintentionally:

CPU1
  rmmod bonding
    bonding_exit()
      bond_destroy_debugfs()
        debugfs_remove_recursive(bonding_debug_root);

CPU2
  echo -bond0 > /sys/class/net/bonding_masters
    bond_uninit()
      bond_debug_unregister()
        if (!bonding_debug_root)

CPU1
        bonding_debug_root = NULL;

So do NOT revert the bad commit (since the removed checks were racy
anyway), and instead change the order of actions taken during module
removal.  The same oops can also happen if there is an error during
module init, so apply the same fix there.

Fixes: cc317ea3d927 ("bonding: remove redundant NULL check in debugfs function")
Cc: stable@vger.kernel.org
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Link: https://lore.kernel.org/r/641f914f-3216-4eeb-87dd-91b78aa97773@cybernetics.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -6477,16 +6477,16 @@ static int __init bonding_init(void)
 	if (res)
 		goto out;
 
+	bond_create_debugfs();
+
 	res = register_pernet_subsys(&bond_net_ops);
 	if (res)
-		goto out;
+		goto err_net_ops;
 
 	res = bond_netlink_init();
 	if (res)
 		goto err_link;
 
-	bond_create_debugfs();
-
 	for (i = 0; i < max_bonds; i++) {
 		res = bond_create(&init_net, NULL);
 		if (res)
@@ -6501,10 +6501,11 @@ static int __init bonding_init(void)
 out:
 	return res;
 err:
-	bond_destroy_debugfs();
 	bond_netlink_fini();
 err_link:
 	unregister_pernet_subsys(&bond_net_ops);
+err_net_ops:
+	bond_destroy_debugfs();
 	goto out;
 
 }
@@ -6513,11 +6514,11 @@ static void __exit bonding_exit(void)
 {
 	unregister_netdevice_notifier(&bond_netdev_notifier);
 
-	bond_destroy_debugfs();
-
 	bond_netlink_fini();
 	unregister_pernet_subsys(&bond_net_ops);
 
+	bond_destroy_debugfs();
+
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	/* Make sure we don't have an imbalance on our netpoll blocking */
 	WARN_ON(atomic_read(&netpoll_block_tx));


