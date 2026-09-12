Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D752E32B102;
	Sat, 12 Sep 2026 15:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225876; cv=none; b=AWWkC0lH1aPdt5F7MhzWToo+xrTKWcU17KtxrYbBkSct8Wgtr37EaTQuW3RQsPJoahEaWg9O1yaGMslToYIHcG5WHP3EIO5tklf4wZRek1vVH228Ej2s4ZjsdUKqXyOkCP8mSMU2fM+rMhcFMjSitcBi/yE4QhRhDu8I+RHCpO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225876; c=relaxed/simple;
	bh=Z+VFq5an71L+pBDGmNEHHHDVXlEg03mF1QgS1KFkIII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eA1gJ5SOHFpLrdD8ZXMoULQ309tvtPP01/nT8Ij0pYDGV82bjO2WJYF0zL+EowxlbkJ6Qm3qgq1l3RrYsYq6Y22acz4Twk4bk/6AvdIHSAQJ0zYrwrejXlOWDbBF/yB3WuztxUrXXm8MIIhyTMDvesjSSEk+JiIx6qQCpqKic/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1LYHGjws; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1LYHGjws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3D61F000FF;
	Sat, 12 Sep 2026 15:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225874;
	bh=PRjRi1+uP5MxOnuCq0EEvnlgsKyrcu0dYwNN/K4kAbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1LYHGjwslraxEM7//rnQR1koSnFgzbGr9gk5qikbV4XMBAhajmbLcqte8usb+AgpA
	 4pNroaffdt531bxzw7JHLL1nKs8x2dceIPhDQoaCYGKmVRq3uZddNPBTFJf5xZV/DK
	 AJZBtBy+QwWzXmTY6FSXc7Qq/WcZKR5sKOMW2Mz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1288/1424] net: Add MDB get device operation
Date: Sat, 12 Sep 2026 09:02:00 +0200
Message-ID: <20260912065636.116537396@linuxfoundation.org>
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

[ Upstream commit 62f47bf9e2c00eea457cad8fa43c24ed0282b37a ]

Add MDB net device operation that will be invoked by rtnetlink code in
response to received RTM_GETMDB messages. Subsequent patches will
implement the operation in the bridge and VXLAN drivers.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bc2dc66a6693 ("vxlan: mdb: Fix use-after-free in vxlan_mdb_flush()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index eefbe40295b1c..2b4094ac2e3bc 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1594,6 +1594,10 @@ struct net_device_ops {
 	int			(*ndo_mdb_dump)(struct net_device *dev,
 						struct sk_buff *skb,
 						struct netlink_callback *cb);
+	int			(*ndo_mdb_get)(struct net_device *dev,
+					       struct nlattr *tb[], u32 portid,
+					       u32 seq,
+					       struct netlink_ext_ack *extack);
 	int			(*ndo_bridge_setlink)(struct net_device *dev,
 						      struct nlmsghdr *nlh,
 						      u16 flags,
-- 
2.53.0



