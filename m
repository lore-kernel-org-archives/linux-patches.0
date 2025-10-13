Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F4B3081CE;
	Mon, 13 Oct 2025 15:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369919; cv=none; b=kTqGRoAdZgICc0U47KC/5imHsHS7aTQ4KCrR0MvO1oU5w16134aU/fyb36Q9W31GR324mlpSRhmV2wRrSRLp4Topnb8lvScks9ZGrNE8rDGpsqzeXYc7S7Y5b8nwNdMSZLfuU3AbtsB6At31LAjnVZJFH0bgDyn9Yhys7JKgc2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369919; c=relaxed/simple;
	bh=xNKK/Apk4ujHUGrZuIlz5zypqCOqOGmHxqY9OmjQeTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhnJYtxn3xwMIUETSXQa+7nb7fMMKn4fbbgoXDk2QXAn9+qbs6q/4o/frM6mSukxXvSkbNdpkg3If3Y9rgxjuYcrPSyWkym9MjrmnTFCyPKFV3Imnu8SSo5nLZ+BzP/D68+mZbHV2m0zKj10Xo0sFsJt7UNt5MrjvTXi+/3RZ8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pjsvCzIA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pjsvCzIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C18C4CEE7;
	Mon, 13 Oct 2025 15:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369919;
	bh=xNKK/Apk4ujHUGrZuIlz5zypqCOqOGmHxqY9OmjQeTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pjsvCzIAPLMvDdhm/osvZ5xM87XNV8BFqP9z57qFmQ5hFKVZAdb399/NTxCkYgnB2
	 z+PU5/eCZcev35SFRIIKHa4MPMsQy5xifS5AAbiCvlnYEqaK+IiVopbuGz3MkyaYvi
	 rrfGjVKWUA4PVfZrgrqPPfXNKQ5+6YXHo7cLSzlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 381/563] smc: Use __sk_dst_get() and dst_dev_rcu() in smc_vlan_by_tcpsk().
Date: Mon, 13 Oct 2025 16:44:02 +0200
Message-ID: <20251013144425.075823983@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 0b0e4d51c6554e5ecc3f8cc73c2eaf12da21249a ]

smc_vlan_by_tcpsk() fetches sk_dst_get(sk)->dev before RTNL and
passes it to netdev_walk_all_lower_dev(), which is illegal.

Also, smc_vlan_by_tcpsk_walk() does not require RTNL at all.

Let's use __sk_dst_get(), dst_dev_rcu(), and
netdev_walk_all_lower_dev_rcu().

Note that the returned value of smc_vlan_by_tcpsk() is not used
in the caller.

Fixes: 0cfdd8f92cac ("smc: connection and link group creation")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250916214758.650211-5-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_core.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 262746e304dda..2a559a98541c7 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1883,35 +1883,32 @@ static int smc_vlan_by_tcpsk_walk(struct net_device *lower_dev,
 /* Determine vlan of internal TCP socket. */
 int smc_vlan_by_tcpsk(struct socket *clcsock, struct smc_init_info *ini)
 {
-	struct dst_entry *dst = sk_dst_get(clcsock->sk);
 	struct netdev_nested_priv priv;
 	struct net_device *ndev;
+	struct dst_entry *dst;
 	int rc = 0;
 
 	ini->vlan_id = 0;
-	if (!dst) {
-		rc = -ENOTCONN;
-		goto out;
-	}
-	if (!dst->dev) {
+
+	rcu_read_lock();
+
+	dst = __sk_dst_get(clcsock->sk);
+	ndev = dst ? dst_dev_rcu(dst) : NULL;
+	if (!ndev) {
 		rc = -ENODEV;
-		goto out_rel;
+		goto out;
 	}
 
-	ndev = dst->dev;
 	if (is_vlan_dev(ndev)) {
 		ini->vlan_id = vlan_dev_vlan_id(ndev);
-		goto out_rel;
+		goto out;
 	}
 
 	priv.data = (void *)&ini->vlan_id;
-	rtnl_lock();
-	netdev_walk_all_lower_dev(ndev, smc_vlan_by_tcpsk_walk, &priv);
-	rtnl_unlock();
-
-out_rel:
-	dst_release(dst);
+	netdev_walk_all_lower_dev_rcu(ndev, smc_vlan_by_tcpsk_walk, &priv);
 out:
+	rcu_read_unlock();
+
 	return rc;
 }
 
-- 
2.51.0



