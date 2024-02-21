Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC5B6A037;
	Wed, 21 Feb 2024 13:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521371; cv=none; b=nITFMSGZeFxnIF8I/Ur1nESwdyvIvJ7U4YJ5i1n1QE1858WAl8VGntd+/KDsNQgNTMaIOoHvsgCUfWzThCj6VFSH8o74yd5UzY89XVAbJwlr7frPaqSsQkY9ONiCYIzeXDkpgKy0lGU/qJWaW2np6nUMYzJMeiacQT0CnDNnekg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521371; c=relaxed/simple;
	bh=5pPnKQaXcNcoUZW2JgajkqrpHZZfWTZQgyDtnWU86ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZ3b1pxrmOCAivqOuOUukXc17DptePhNqErXfGtwJk3UduUVcgRPzetXouu1I4XvKVld0hMfrQ0NGMbzx34S5qoysXhnVINg3uHzE8oeUhHgYegnFwhn5xZgj+mbhoKfM3w9UvB0igqGbq+3pKcI2DkyIVRXoPUMx6gFvpc26zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QK3ylbT3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QK3ylbT3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246ECC43390;
	Wed, 21 Feb 2024 13:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521371;
	bh=5pPnKQaXcNcoUZW2JgajkqrpHZZfWTZQgyDtnWU86ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QK3ylbT3sQto0AV741JaIrqf0BLu9CDW7x1ntMQFTn/aH9pjQv2bWH28vyibDiaIG
	 qN8K5p1JzlPsyFzQTIybgW6PsFmTpm2HbuJzQzL1FmMZu+rXzmJNg9O39r/vS527UY
	 zAvHlh3T8AJ+ooMDro+2vO+cc1g2PYpj5buiZWTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jay Vosburgh <jay.vosburgh@canonical.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 077/202] bonding: return -ENOMEM instead of BUG in alb_upper_dev_walk
Date: Wed, 21 Feb 2024 14:06:18 +0100
Message-ID: <20240221125934.298460412@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit d6b83f1e3707c4d60acfa58afd3515e17e5d5384 ]

If failed to allocate "tags" or could not find the final upper device from
start_dev's upper list in bond_verify_device_path(), only the loopback
detection of the current upper device should be affected, and the system is
no need to be panic.
So return -ENOMEM in alb_upper_dev_walk to stop walking, print some warn
information when failed to allocate memory for vlan tags in
bond_verify_device_path.

I also think that the following function calls
netdev_walk_all_upper_dev_rcu
---->>>alb_upper_dev_walk
---------->>>bond_verify_device_path
>From this way, "end device" can eventually be obtained from "start device"
in bond_verify_device_path, IS_ERR(tags) could be instead of
IS_ERR_OR_NULL(tags) in alb_upper_dev_walk.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Link: https://lore.kernel.org/r/20231118081653.1481260-1-shaozhengchao@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_alb.c  | 3 ++-
 drivers/net/bonding/bond_main.c | 5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index e03f4883858a..5947c1305527 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -984,7 +984,8 @@ static int alb_upper_dev_walk(struct net_device *upper, void *_data)
 	if (netif_is_macvlan(upper) && !strict_match) {
 		tags = bond_verify_device_path(bond->dev, upper, 0);
 		if (IS_ERR_OR_NULL(tags))
-			BUG();
+			return -ENOMEM;
+
 		alb_send_lp_vid(slave, upper->dev_addr,
 				tags[0].vlan_proto, tags[0].vlan_id);
 		kfree(tags);
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 79b36f1c50ae..920b491bd4cd 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2460,8 +2460,11 @@ struct bond_vlan_tag *bond_verify_device_path(struct net_device *start_dev,
 
 	if (start_dev == end_dev) {
 		tags = kcalloc(level + 1, sizeof(*tags), GFP_ATOMIC);
-		if (!tags)
+		if (!tags) {
+			net_err_ratelimited("%s: %s: Failed to allocate tags\n",
+					    __func__, start_dev->name);
 			return ERR_PTR(-ENOMEM);
+		}
 		tags[level].vlan_proto = VLAN_N_VID;
 		return tags;
 	}
-- 
2.43.0



