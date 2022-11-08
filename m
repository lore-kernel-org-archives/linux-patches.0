Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DAD15CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C9CC433D6;
	Tue,  8 Nov 2022 14:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916650;
	bh=7ZJ3R4L+X6VQRbiVUvy3GpUBgwHzXrDrbK3snEFGfns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zNFRDTP1Plw7X1E+HtT3N59NILxAywr6h4zutvNpNH54sVUnBRLigm3IyOQkvIoqs
	 rEQfmUVfGa775dAquAmkurtr+URbfjhcMruFeCuZ0si+DvwuxppZ3QNe+0nCY9T9l+
	 RH/tFrRPpPlujk1D0F6zLdw1UHxxXRC/zVpkwmbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 060/197] bridge: Fix flushing of dynamic FDB entries
Date: Tue,  8 Nov 2022 14:38:18 +0100
Message-Id: <20221108133357.562387198@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 628ac04a75ed5ff13647e725f40192da22ef2be8 ]

The following commands should result in all the dynamic FDB entries
being flushed, but instead all the non-local (non-permanent) entries are
flushed:

 # bridge fdb add 00:aa:bb:cc:dd:ee dev dummy1 master static
 # bridge fdb add 00:11:22:33:44:55 dev dummy1 master dynamic
 # ip link set dev br0 type bridge fdb_flush
 # bridge fdb show brport dummy1
 00:00:00:00:00:01 master br0 permanent
 33:33:00:00:00:01 self permanent
 01:00:5e:00:00:01 self permanent

This is because br_fdb_flush() works with FDB flags and not the
corresponding enumerator values. Fix by passing the FDB flag instead.

After the fix:

 # bridge fdb add 00:aa:bb:cc:dd:ee dev dummy1 master static
 # bridge fdb add 00:11:22:33:44:55 dev dummy1 master dynamic
 # ip link set dev br0 type bridge fdb_flush
 # bridge fdb show brport dummy1
 00:aa:bb:cc:dd:ee master br0 static
 00:00:00:00:00:01 master br0 permanent
 33:33:00:00:00:01 self permanent
 01:00:5e:00:00:01 self permanent

Fixes: 1f78ee14eeac ("net: bridge: fdb: add support for fine-grained flushing")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20221101185753.2120691-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_netlink.c  | 2 +-
 net/bridge/br_sysfs_br.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 5aeb3646e74c..d087fd4c784a 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1332,7 +1332,7 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
 
 	if (data[IFLA_BR_FDB_FLUSH]) {
 		struct net_bridge_fdb_flush_desc desc = {
-			.flags_mask = BR_FDB_STATIC
+			.flags_mask = BIT(BR_FDB_STATIC)
 		};
 
 		br_fdb_flush(br, &desc);
diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index 612e367fff20..ea733542244c 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -345,7 +345,7 @@ static int set_flush(struct net_bridge *br, unsigned long val,
 		     struct netlink_ext_ack *extack)
 {
 	struct net_bridge_fdb_flush_desc desc = {
-		.flags_mask = BR_FDB_STATIC
+		.flags_mask = BIT(BR_FDB_STATIC)
 	};
 
 	br_fdb_flush(br, &desc);
-- 
2.35.1



