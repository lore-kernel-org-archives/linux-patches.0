Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F86A79DAE;
	Wed, 21 Feb 2024 14:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525229; cv=none; b=G1B0z546Sz3Pi7jWfZc73lvpWUuaS8gbVP3N13NL0X7/opr3Ae2mIzbJjD+qmTMDYsH4ZDl3r/xAHDi0YG4/rWP9ZWR/HbOayEasKvgibZoBbuTEZGG+08Ffb2ymsYViRryNAV5MhKKUhZ3Djx4ldeeGUD8LTjIL345AqKn//fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525229; c=relaxed/simple;
	bh=II05V1KZy+TlbhNqiABa0V+z+1Kf9ppYpyuxCBlHN9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MixkxKHMAiKJ0EW+JvLFXBuwL90T3g3lmb4rxz4Lo5T5EgD3xm4T0UMna+7B4tbo0nxnL5F7tV4ce8A5rT56qGWsvC/JZ9PAp1tU7ephfgxLjLrZ5DTI9BtA5S8U30D9ZdnKRZEdPWGeTfhkSIy2chJlZWYAROFSi1lvaXLkuss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=atUHs/j/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="atUHs/j/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC64C433F1;
	Wed, 21 Feb 2024 14:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525228;
	bh=II05V1KZy+TlbhNqiABa0V+z+1Kf9ppYpyuxCBlHN9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=atUHs/j/quPnL1SLFBTciimJEutZIRUVF1V+8TIdCzQBEf+7bCTln1XySwj1a8lYe
	 NuWqPFL3a6oSTBp9noCKW6dEA5unjRXqw8NjWsrfE7BGi8xmjItUuRht9QFa6s1DsT
	 yO2x/FF4GUha4UjcnhpSCyytgHqqMMN4ey9RQbxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jay Vosburgh <jay.vosburgh@canonical.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 096/267] bonding: return -ENOMEM instead of BUG in alb_upper_dev_walk
Date: Wed, 21 Feb 2024 14:07:17 +0100
Message-ID: <20240221125942.964978701@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 6df78a36bafd..342e23e56192 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -970,7 +970,8 @@ static int alb_upper_dev_walk(struct net_device *upper, void *_data)
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
index bb1c6743222e..352afabf8571 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2482,8 +2482,11 @@ struct bond_vlan_tag *bond_verify_device_path(struct net_device *start_dev,
 
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



