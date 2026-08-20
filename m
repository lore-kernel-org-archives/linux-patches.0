Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E8D47F2CE;
	Thu, 20 Aug 2026 17:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247752; cv=none; b=pM8f3WRW2XWhN8x7tMGJQRaIg1L+3eR/XtMxwVLu0fsB4e8rPmkGbZLngApwT/VyL6rVH1vT5t3Ck1eE4pehiXKujoQabcjVTeP0eR4DkZByGOAmLql5NDVbL/NxV9KrX3P0MJ1+s0EPA06AQdXgW2oC/kTX822LC6Q+Rkp0GuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247752; c=relaxed/simple;
	bh=DoAUkueYofsKY+ZHKqT7bswWp9j860Ag8em49RIG9/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLo/xS5Rmr16gmVtMABQgqb/x6L2+WCcVbpcmGjCeunK8RVEarvLhWJ4b3n4lyUYrgqMXgNHTyaTwx9XtPetHMt3ylHbxzLzHW8gFxw08cK8ON/8ZXrRBzduHZ8GU2ZJs1CUEQBGqh2vmZUgtOty2nCxqkN3txF6NU/MrweoBc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pBBI4lhZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pBBI4lhZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CED01F000E9;
	Thu, 20 Aug 2026 17:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247750;
	bh=EHwtUNzNjwe4t7yY3HsJilyFYldnGxNnS82NzA7akbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pBBI4lhZQN+hv+pghPrU+XAHLyalQx1Ynf6BiAFab/rtZzmWqQZfzOiB8CBIp8Ubt
	 C+tIDzlFootsMa5R73OZrMUeVUibV5NddxQd/+R2lvxlvv6v1zOwti4lvFAMNQJ5gI
	 EIHX+3CVhq3XNV1EnVvSKynbZ2ZXvuLSt8rkbHTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/166] vxlan: Do not alloc tstats manually
Date: Thu, 20 Aug 2026 16:56:18 +0200
Message-ID: <20260820145214.745934889@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit e28c5efc31397af17bc5a7d55b963f59bcde0166 ]

With commit 34d21de99cea9 ("net: Move {l,t,d}stats allocation to core and
convert veth & vrf"), stats allocation could be done on net core
instead of in this driver.

With this new approach, the driver doesn't have to bother with error
handling (allocation failure checking, making sure free happens in the
right spot, etc). This is core responsibility now.

Remove the allocation in the vxlan driver and leverage the network
core allocation instead.

Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>
Link: https://lore.kernel.org/r/20240311112437.3813987-1-leitao@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b9553558b48d ("vxlan: use pskb_network_may_pull() for transmit path header pulls")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan/vxlan_core.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2990,15 +2990,9 @@ static int vxlan_init(struct net_device
 			return err;
 	}
 
-	dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
-	if (!dev->tstats) {
-		err = -ENOMEM;
-		goto err_vnigroup_uninit;
-	}
-
 	err = gro_cells_init(&vxlan->gro_cells, dev);
 	if (err)
-		goto err_free_percpu;
+		goto err_vnigroup_uninit;
 
 	err = vxlan_mdb_init(vxlan);
 	if (err)
@@ -3009,8 +3003,6 @@ static int vxlan_init(struct net_device
 
 err_gro_cells_destroy:
 	gro_cells_destroy(&vxlan->gro_cells);
-err_free_percpu:
-	free_percpu(dev->tstats);
 err_vnigroup_uninit:
 	if (vxlan->cfg.flags & VXLAN_F_VNIFILTER)
 		vxlan_vnigroup_uninit(vxlan);
@@ -3041,8 +3033,6 @@ static void vxlan_uninit(struct net_devi
 	gro_cells_destroy(&vxlan->gro_cells);
 
 	vxlan_fdb_delete_default(vxlan, vxlan->cfg.vni);
-
-	free_percpu(dev->tstats);
 }
 
 /* Start ageing timer and join group when device is brought up */
@@ -3269,6 +3259,7 @@ static void vxlan_setup(struct net_devic
 	dev->min_mtu = ETH_MIN_MTU;
 	dev->max_mtu = ETH_MAX_MTU;
 
+	dev->pcpu_stat_type = NETDEV_PCPU_STAT_TSTATS;
 	INIT_LIST_HEAD(&vxlan->next);
 
 	timer_setup(&vxlan->age_timer, vxlan_cleanup, TIMER_DEFERRABLE);


