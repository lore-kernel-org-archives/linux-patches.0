Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C83115C158;
	Sun,  7 Sep 2025 20:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277067; cv=none; b=UYO/jO8qqszBLhH3uZ4KbLxuLyzRPrE8ltrvDNpwgTMWgfC5+MzzpfChOeUGQelEM/yGDqPZHQ07NbgYLVURorieWQ6wR7BJg3GYbCid8xfgVFA21rzGSWelI7lpp3rfgRrM1Tj/HcGFrubwJa+g5g7uM2G8NtSlCZaaV5Hl7dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277067; c=relaxed/simple;
	bh=GkXiaD/STlOLfTcfsGT5W7OGeOLT7gZuuxm21mS/w/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gc1ZT7lVR4m73DKAGjrJ2rBkH75M+K6vvhOaDi4TwHg8OPCsluNR67aC+rzulvuWie7Rpm8GF0izIwfrxohgmGB20V1Tizy5k0X4VYPWixYCwHOT97OgK4LnGibsosl8hjbM66zrjvAYwZiIId0olIK8ao9bL2ByOROB/aeC0e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FfxG8qn2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FfxG8qn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68D6C4CEF0;
	Sun,  7 Sep 2025 20:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277067;
	bh=GkXiaD/STlOLfTcfsGT5W7OGeOLT7gZuuxm21mS/w/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FfxG8qn2dpK4SZMjnMF/ubBkcVUYb2cB+IvATC5MeOkWM/3hsthdWGjjngAsSmIyr
	 r085yFZWjKiSL5f7B1XTII6uKgpP6kNymdi2dPTHBlAXvcMQ2CR1bR/yDJyOUelfae
	 gEfVV9EBLsEOGqKu2y0mWgwt2kuGEGG+4aKA2EPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/175] vxlan: Avoid unnecessary updates to FDB used time
Date: Sun,  7 Sep 2025 21:57:48 +0200
Message-ID: <20250907195616.561987326@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 9722f834fe9a7c583591defa2cab3f652f50a5f0 ]

Now that the VXLAN driver ages out FDB entries based on their 'updated'
time we can remove unnecessary updates of the 'used' time from the Rx
path and the control path, so that the 'used' time is only updated by
the Tx path.

Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20250204145549.1216254-8-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 1f5d2fd1ca04 ("vxlan: Fix NPD in {arp,neigh}_reduce() when using nexthop objects")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index ce9c979080bb4..8853fcb7eb7f2 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1047,10 +1047,8 @@ static int vxlan_fdb_update_existing(struct vxlan_dev *vxlan,
 		notify |= rc;
 	}
 
-	if (ndm_flags & NTF_USE) {
-		WRITE_ONCE(f->used, jiffies);
+	if (ndm_flags & NTF_USE)
 		WRITE_ONCE(f->updated, jiffies);
-	}
 
 	if (notify) {
 		if (rd == NULL)
@@ -1294,7 +1292,7 @@ int __vxlan_fdb_delete(struct vxlan_dev *vxlan,
 	struct vxlan_fdb *f;
 	int err = -ENOENT;
 
-	f = vxlan_find_mac(vxlan, addr, src_vni);
+	f = __vxlan_find_mac(vxlan, addr, src_vni);
 	if (!f)
 		return err;
 
@@ -1458,7 +1456,7 @@ static enum skb_drop_reason vxlan_snoop(struct net_device *dev,
 		ifindex = src_ifindex;
 #endif
 
-	f = vxlan_find_mac(vxlan, src_mac, vni);
+	f = __vxlan_find_mac(vxlan, src_mac, vni);
 	if (likely(f)) {
 		struct vxlan_rdst *rdst = first_remote_rcu(f);
 
@@ -4718,7 +4716,7 @@ vxlan_fdb_offloaded_set(struct net_device *dev,
 
 	spin_lock_bh(&vxlan->hash_lock[hash_index]);
 
-	f = vxlan_find_mac(vxlan, fdb_info->eth_addr, fdb_info->vni);
+	f = __vxlan_find_mac(vxlan, fdb_info->eth_addr, fdb_info->vni);
 	if (!f)
 		goto out;
 
@@ -4774,7 +4772,7 @@ vxlan_fdb_external_learn_del(struct net_device *dev,
 	hash_index = fdb_head_index(vxlan, fdb_info->eth_addr, fdb_info->vni);
 	spin_lock_bh(&vxlan->hash_lock[hash_index]);
 
-	f = vxlan_find_mac(vxlan, fdb_info->eth_addr, fdb_info->vni);
+	f = __vxlan_find_mac(vxlan, fdb_info->eth_addr, fdb_info->vni);
 	if (!f)
 		err = -ENOENT;
 	else if (f->flags & NTF_EXT_LEARNED)
-- 
2.50.1



