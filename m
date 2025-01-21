Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C381E9B38;
	Tue, 21 Jan 2025 17:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482064; cv=none; b=Rj/iK48WOOUp6DfqU+ef5h+r3W2xbHD7xoBiasF2wnJ/+JY9HFuWbi208BJgoSCDiyXVv0ZuiqYVesnS5UsU6V8Fzn6wtxFB02JHTe3/Q79Ig5hEvuwTEQFwOdarONn8uslambn3RpDnxmmu+xiXOug56TiVm+zf6GjXWCaq9uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482064; c=relaxed/simple;
	bh=A1LdJ6JRjWf0tGO9TZxTlBtBLtFX1qdShYcU0wIWWzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUUwJBXtpDCjoSEFNA9bXeDKY4cK/Qq5UhlNc6IJnB9DKp/+rCDppuiYhiLRdTgryhlLjCRl4jA9hABgz0oykTN/36MnYAdqXJMGXxBASYpHgYhwonUdVoFGpGKObq/RXK0B+olGpUPEGNYSu+keaG2dBvJv8nkdTNqD+ZUiRXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiV2vaIZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiV2vaIZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE62C4CEDF;
	Tue, 21 Jan 2025 17:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482064;
	bh=A1LdJ6JRjWf0tGO9TZxTlBtBLtFX1qdShYcU0wIWWzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiV2vaIZHHxwn08C9ODm+/F7m0sMzAObUP2HNW8ZEAcQ03knHglKdqtpuOT9HRInu
	 w2Dfmf9oEtnX6vu1+EMVWCPRZcVl18ztkwsoXA3ltHfZ7GscD4ymmcdFTr1TdYnqnZ
	 +YSsj8JRLe6nB5z+43PKku+GhxCMLNV3RQ/8rHCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Antoine Tenart <atenart@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 06/72] gtp: use exit_batch_rtnl() method
Date: Tue, 21 Jan 2025 18:51:32 +0100
Message-ID: <20250121174523.676678436@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9dd8f66610ce6..60c950066ec5b 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1884,23 +1884,23 @@ static int __net_init gtp_net_init(struct net *net)
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



