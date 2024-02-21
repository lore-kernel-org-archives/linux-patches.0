Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A407866C;
	Wed, 21 Feb 2024 13:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522468; cv=none; b=MbHI+XGqv6CVlMK0493NQFQYz05tDkFW2IZJWMfKtuH9eyQA1bY0SyvwViD7PMX3NH0Ta8nbqzRCKBx5b56jmCS8mTpWElTSvFG6nR6cIuEyI7KLV2uhln77X/4/rsRhHZ82qTvpgaxo75Yj1VwZfDhBpKWnGUKGWDmRyX+gqfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522468; c=relaxed/simple;
	bh=7KVzUocuuV1PUqsrV9ql0VHD2Q6VAegwm9vw4GYBb+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DoCa0F3g0o+wmYpiTCITBHr5tMvvsnNBcTas/xxIwm04NtwINV+al65W5QpYUcs8D5I9shm2roRXKYT82+c3koMKx9JtX8mp9Rr44nzsnFkQ7pzxB1Jxv91IDrhCGiwhBpwjI1/jnBfw0BXW43gGcnPKaFMgZJBMFwMQyc56+oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cLVlXNqk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cLVlXNqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891E1C433F1;
	Wed, 21 Feb 2024 13:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522468;
	bh=7KVzUocuuV1PUqsrV9ql0VHD2Q6VAegwm9vw4GYBb+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLVlXNqkYZGubdZa3Ru7lw8/I+Lc3C4ZsHy2pEOs1CjD38L6JbNHws1J+luds0ktb
	 hCEuO6UaeOWDqem0EPxdgHd9PaCs0BpO+5fgty6+YMtU1CCBXzKbO6/WM+uszsLYhK
	 HuV/iBVryuM8rzEpIIm/3HN7DmW2bpUuK1Kx2/Zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jay Vosburgh <jay.vosburgh@canonical.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 171/476] bonding: return -ENOMEM instead of BUG in alb_upper_dev_walk
Date: Wed, 21 Feb 2024 14:03:42 +0100
Message-ID: <20240221130014.242006915@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b29393831a30..7091b018078b 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -973,7 +973,8 @@ static int alb_upper_dev_walk(struct net_device *upper,
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
index 9aed194d308d..1ecd0c136fc6 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2893,8 +2893,11 @@ struct bond_vlan_tag *bond_verify_device_path(struct net_device *start_dev,
 
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



