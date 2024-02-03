Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FB44C3B3;
	Sat,  3 Feb 2024 04:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933778; cv=none; b=HWr93oc/+uQE7UHq7y6EZPn0q6IotQF4+yQGe7ojvudSaqKszeG34D/w8nA87tRcWRs6b67dZ+rxOG23GYGLFKICs5H9tDjbSV15lNbwpmfWXdRLG9xgKeEeKv2DrqSC2KiSk9QSpvEiCdpHBbTeZR25i2hpsZj+BUVGuTDYfxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933778; c=relaxed/simple;
	bh=mg23ImoLiQK9aF4lsuWFfLRt+Lx7t7Oh1kSFzQZhkvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYBjiSceTIXHwmhtFw15uOwpop3VP9chiSenF9JFWFbvStZbahWQVD4DeCnw7g3v/sWvi0GAV6uU4yX73U7aK5Wlggh8RWg6xpk3XkaqyPGwsMTsYZLkRZoJ5UEJbCLA0nvK+6XajenNzTYaITY/FCIT+/Ul2rksv4cXQ2avfwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xnZy+lfZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xnZy+lfZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B7CC433C7;
	Sat,  3 Feb 2024 04:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933778;
	bh=mg23ImoLiQK9aF4lsuWFfLRt+Lx7t7Oh1kSFzQZhkvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xnZy+lfZsJWeasKmXlPpvLh88rXisKn/CRidtwCNSdJmGquzCkCvuS0dyJgVfyisp
	 5v30Igv5C/2f3opE4LLQQ6ldSIHCF61yBWH95mrFKxm1DOWaUS/XKvKNdQMpJYiUh7
	 DhZhkXFQM70c4kfhCXKuBYY+bsopv9RJeE6mBkRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jay Vosburgh <jay.vosburgh@canonical.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 082/353] bonding: return -ENOMEM instead of BUG in alb_upper_dev_walk
Date: Fri,  2 Feb 2024 20:03:20 -0800
Message-ID: <20240203035406.400459177@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index dc2c7b979656..7edf0fd58c34 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -985,7 +985,8 @@ static int alb_upper_dev_walk(struct net_device *upper,
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
index 8e6cc0e133b7..9c1652886f4e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2973,8 +2973,11 @@ struct bond_vlan_tag *bond_verify_device_path(struct net_device *start_dev,
 
 	if (start_dev == end_dev) {
 		tags = kcalloc(level + 1, sizeof(*tags), GFP_ATOMIC);
-		if (!tags)
+		if (!tags) {
+			net_err_ratelimited("%s: %s: Failed to allocate tags\n",
+					    __func__, start_dev->name);
 			return ERR_PTR(-ENOMEM);
+		}
 		tags[level].vlan_proto = BOND_VLAN_PROTO_NONE;
 		return tags;
 	}
-- 
2.43.0



