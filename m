Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1479613A411;
	Thu, 13 Jun 2024 12:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280565; cv=none; b=phOVzlzHUHr30Z2DOiAZC41RyP+1KD19133xxlBokivsCpHMiHUZz8RgoiOjr/HBmP+YRshluh/+zD2OjOZAl3mc9SIZTnG05YfAnCRzjLcRUsmcSChq97WKoaqF4uGz0J9suEe7ICAYLDjKcs6tfJIX53ACuvFf0N1b4WyzQwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280565; c=relaxed/simple;
	bh=s57KWhdZcs4IirZbWlqLGQe2dAFKgBYh/kxnz8m8W4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQbltXdWGfATMDMILkJT42EbLWoCgailjfkmwh8GDiX5F58PppGd9uQ7MCZl9oahB3kpzPxD1XkuXjBvVs9x2sDjk0v0ugD8mGJdGahqvlUL2U27Csg7PX6CyfyVHwdZJPRMjdYn8cPVEJ8X7z2pXPdQveSHFi2DPYXAcXyx7kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IjLGXcGq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IjLGXcGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F265C2BBFC;
	Thu, 13 Jun 2024 12:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280565;
	bh=s57KWhdZcs4IirZbWlqLGQe2dAFKgBYh/kxnz8m8W4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IjLGXcGq3oMDifdKp7dgI13zBclw386tGkndGRMsMKesXDZ+iEiY7cZcCbYRQadkN
	 LmEtXyVnHNuM/gvPhMpys8TmOPDFdhXhEvQuAY1BTZKu2M91MhrdO3uB1JzD/XkkX2
	 tgx8dJCm8FjrpK51Hs2phuv921gCV4Iy/tGHGZVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Battersby <tonyb@cybernetics.com>,
	Simon Horman <horms@kernel.org>,
	Jay Vosburgh <jay.vosburgh@canonical.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 096/137] bonding: fix oops during rmmod
Date: Thu, 13 Jun 2024 13:34:36 +0200
Message-ID: <20240613113227.021485402@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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
@@ -6484,16 +6484,16 @@ static int __init bonding_init(void)
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
@@ -6508,10 +6508,11 @@ static int __init bonding_init(void)
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
@@ -6520,11 +6521,11 @@ static void __exit bonding_exit(void)
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


