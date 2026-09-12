Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E972F531B;
	Sat, 12 Sep 2026 15:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225890; cv=none; b=KFIklEZLiUGC9Nmq1tzyPGrzY2gR5aqzn8ozSNBzbOqaH5ECjJVaXlCiXRiysQXYq1GlKDgBKe692tonglBmdnaV6VF8oOqV966t5wDxH0O+7SFUZjgSZonXXgg9Hf29c8R/y8vxq0l3vgNLLi//Z4GYIh4xG4ezXAiXzQ52AEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225890; c=relaxed/simple;
	bh=X9Cia2OmsjEEBeAaqCWg2CB8j0DEdLCAPve1dS9XD88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2wF6j2MyM9wclV7s2zOpAy3BG+/gW85szcjtEL0npejrxE7evSlcOP4EWSzsAvvocTudZ6itHbU268CZGzkDvCJxgTq+qLeR0hJWCJphL5JA/iC05Xl4WEUFTBcQBmUIyELqZ2SCp3GqV0dEN+Jd3EIxNgA74dwMqLYDI2zrKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l3kFN7f2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l3kFN7f2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BA61F000FF;
	Sat, 12 Sep 2026 15:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225889;
	bh=08CoOlwTO+JImXi+kdBHvLswfZOMeZhBBn8pDAuq7BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l3kFN7f28za5eRH9NizqIuWIKewJl3nqh2bVW24JWZAaEhuSLY2qjpUT12mi+j0ps
	 Tlj0xO/WYQYGWOaJE3n0wQn8BazQfMbY21/sAZtO+xKncCOtxA8vzczqt1miDcke9C
	 HLUdQ/xCjBO4pnO7bBBpJFHTagDYsQ6jCQbrWzUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1291/1424] net: Add MDB bulk deletion device operation
Date: Sat, 12 Sep 2026 09:02:03 +0200
Message-ID: <20260912065636.182016741@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 1a36e0f50f963465e9b2b980d250ab38b8fcd7a3 ]

Add MDB net device operation that will be invoked by rtnetlink code in
response to received 'RTM_DELMDB' messages with the 'NLM_F_BULK' flag
set. Subsequent patches will implement the operation in the bridge and
VXLAN drivers.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bc2dc66a6693 ("vxlan: mdb: Fix use-after-free in vxlan_mdb_flush()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 2b4094ac2e3bc..b6e63bcfff30a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1307,6 +1307,9 @@ struct netdev_net_notifier {
  * int (*ndo_mdb_del)(struct net_device *dev, struct nlattr *tb[],
  *		      struct netlink_ext_ack *extack);
  *	Deletes the MDB entry from dev.
+ * int (*ndo_mdb_del_bulk)(struct net_device *dev, struct nlattr *tb[],
+ *			   struct netlink_ext_ack *extack);
+ *	Bulk deletes MDB entries from dev.
  * int (*ndo_mdb_dump)(struct net_device *dev, struct sk_buff *skb,
  *		       struct netlink_callback *cb);
  *	Dumps MDB entries from dev. The first argument (marker) in the netlink
@@ -1591,6 +1594,9 @@ struct net_device_ops {
 	int			(*ndo_mdb_del)(struct net_device *dev,
 					       struct nlattr *tb[],
 					       struct netlink_ext_ack *extack);
+	int			(*ndo_mdb_del_bulk)(struct net_device *dev,
+						    struct nlattr *tb[],
+						    struct netlink_ext_ack *extack);
 	int			(*ndo_mdb_dump)(struct net_device *dev,
 						struct sk_buff *skb,
 						struct netlink_callback *cb);
-- 
2.53.0



