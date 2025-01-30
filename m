Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793831E522;
	Thu, 30 Jan 2025 14:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247078; cv=none; b=evq2i9QJfpo6EJjqws5Tl9Xs10mLSsX2DisAjHOY8nJwbsQVfBIm97FVYwHap7+EGHSGKXQuIxiQFBVOfHxMj4hi9BSUhkm7gEMaHQab4Pnt0PMYpbANDQ9l/Z3t8QIEElOLhQOaWusx5vzt13FlE3UgWkv5+NjZYtcRAsTWTJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247078; c=relaxed/simple;
	bh=sIqLtUP1mF7JlN6Wi/coffeysKCGrKlUSXE6Ze9uBSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVLnz+knMgQLJQ6AcKd4WvWQHYONtXlr7X4KEDVOAVl/8ELuMhzsMG3eEgstpUmhshJww89fu4pBnl14ZIWfIgqAyWKB58yfATlU/cGkLzxsiCIFJ1NBb2ervKDRUJwalknYV9FPmKuw8H1BFotu3VB78UNSP+AWMJG6vowIXgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LLBqU/NQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LLBqU/NQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6436CC4CED2;
	Thu, 30 Jan 2025 14:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247077;
	bh=sIqLtUP1mF7JlN6Wi/coffeysKCGrKlUSXE6Ze9uBSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LLBqU/NQzZP9frqQKzZcs67KYtK0piH8UdEMkMWU8Mq1LFf67tMisA/jEhkctgmCD
	 1I4G2ccFKvmbMOknLIiVt7WZ5bXJxEgrNuByZ+neCQRGbx1DIugnlgX2pKZfkMAl4O
	 dtjD5i1ZJoRPrauHK/6MqG4uFWbyJO30tthZWC68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Antoine Tenart <atenart@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/133] gtp: use exit_batch_rtnl() method
Date: Thu, 30 Jan 2025 15:01:04 +0100
Message-ID: <20250130140145.541801862@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 6eedda01b2bfdcf427b37759e053dc27232f3af1 ]

exit_batch_rtnl() is called while RTNL is held,
and devices to be unregistered can be queued in the dev_kill_list.

This saves one rtnl_lock()/rtnl_unlock() pair per netns
and one unregister_netdevice_many() call per netns.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Link: https://lore.kernel.org/r/20240206144313.2050392-8-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 46841c7053e6 ("gtp: Use for_each_netdev_rcu() in gtp_genl_dump_pdp().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 42839cb853f83..e44291e85f9fc 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1387,23 +1387,23 @@ static int __net_init gtp_net_init(struct net *net)
 	return 0;
 }
 
-static void __net_exit gtp_net_exit(struct net *net)
+static void __net_exit gtp_net_exit_batch_rtnl(struct list_head *net_list,
+					       struct list_head *dev_to_kill)
 {
-	struct gtp_net *gn = net_generic(net, gtp_net_id);
-	struct gtp_dev *gtp;
-	LIST_HEAD(list);
+	struct net *net;
 
-	rtnl_lock();
-	list_for_each_entry(gtp, &gn->gtp_dev_list, list)
-		gtp_dellink(gtp->dev, &list);
+	list_for_each_entry(net, net_list, exit_list) {
+		struct gtp_net *gn = net_generic(net, gtp_net_id);
+		struct gtp_dev *gtp;
 
-	unregister_netdevice_many(&list);
-	rtnl_unlock();
+		list_for_each_entry(gtp, &gn->gtp_dev_list, list)
+			gtp_dellink(gtp->dev, dev_to_kill);
+	}
 }
 
 static struct pernet_operations gtp_net_ops = {
 	.init	= gtp_net_init,
-	.exit	= gtp_net_exit,
+	.exit_batch_rtnl = gtp_net_exit_batch_rtnl,
 	.id	= &gtp_net_id,
 	.size	= sizeof(struct gtp_net),
 };
-- 
2.39.5



