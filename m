Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B170A4854EE;
	Mon, 31 Aug 2026 14:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184986; cv=none; b=YxH2gakd8BAV7kJYDG/qhZ4R5R4zWo/UROyHBgbUnJUhZ8Y8ZXnpnLVgSc27Ka8ICFyho+LICaQuB0DufvbmAw7fEj8+cj/xszYJi2eKGEBmvDi/YkxgLqPYaV9QwX8wR161uGz+whvkIOCzTn52eVzTspFG4aIUqs8yNi+MCTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184986; c=relaxed/simple;
	bh=WgI97qG/4aAe6QnS2SjqS4jof0VVm+VE8fNWOEg1ygU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ih2HRc/YETldyKAElPsCaeqGx2MGbK41SdlQfsaD2TTAqaMdeUVBjJokLwPnQ9yqNaLzckE+1bRukft6HVyb6R64ti9a1ZmqKJ3LPeh4myI6ho5748XE6Gs/4642H9e7Ok9QKUVxx9rXe2S00qPAT7tCPO5jC+9wSUCTuyEu7yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hfHSH5uH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hfHSH5uH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177261F00A3D;
	Mon, 31 Aug 2026 14:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184984;
	bh=P9tsM3r8KVbBHVmasyECK0ie2e1oMEBrpjALWusjAYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hfHSH5uHZCl20wgUA80IhvKXYcIdwZLfxRmZViqtg0nDKvhiEm/EDH4CYcBxpX8t1
	 PUNlADPh/0lySphHpICLSKFEFCBOeWZI/uxL4kptNIzerc4GxH7APwMSz7Lrk/HcD/
	 IEf9Ex6EW2mEdMU+yVAGRXaiK1a+iy3jIZxkCjr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 14/69] smc: Use __sk_dst_get() and dst_dev_rcu() in smc_vlan_by_tcpsk().
Date: Mon, 31 Aug 2026 15:34:47 +0200
Message-ID: <20260831133359.195944015@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 37614dcf19194..f6119f29b44ce 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1612,35 +1612,32 @@ static int smc_vlan_by_tcpsk_walk(struct net_device *lower_dev,
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
2.53.0



