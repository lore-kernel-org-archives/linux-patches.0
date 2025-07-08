Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE3814A60D;
	Tue,  8 Jul 2025 16:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993495; cv=none; b=mIdcsVkGVcP7GiliygxVSoLeki/8adpb3Bl4nb+wHTSFKnn1l6seKvorUsm8DkkGehTTkZQ5RpQdbGJ0niQ1/OvuzKKOFJD8JEeJMWZDFTG2E3P9XbSozJUz5/oBt/FygfCyVvCrBrDZkqu40WUnmwuXFtKbh3drKZZSbp6VA2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993495; c=relaxed/simple;
	bh=4FR/gePfQWm8g0cWTmcPtXjRzRZ4xPjT8lxSWny80z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+hkCrM2xhTqVewxM62s8MDDB1HGgRP5qXHIMwqaF6tZexL1WX2oBCWj/C0KYSVZn+NrkELNDbcfOaJsn7v6jRth4O3Wms8+C1DN/2dZ+oUdvFHbai8147921uZ4R+36awuFJTi5jEd2a7tZgavzUOvByuJwlTWZVrMgDfFu/f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ie7Jq4QF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ie7Jq4QF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5377FC4CEED;
	Tue,  8 Jul 2025 16:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993495;
	bh=4FR/gePfQWm8g0cWTmcPtXjRzRZ4xPjT8lxSWny80z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ie7Jq4QFzHZFV2S/HrM/sxxJM0wAZVG6cfWO1tOusJ80l+rl5plt+hwj7E4iUTF8B
	 UUQiA2QqAcu/1HzY9I5TBZ6osFHtybQK+syRbP6br8u0oID7FHc3OzS2DW63Xk56Sm
	 en86BuJQSp92PdV1GtxJUvr5paUh9dw8CD/lPaNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 093/178] idpf: return 0 size for RSS key if not supported
Date: Tue,  8 Jul 2025 18:22:10 +0200
Message-ID: <20250708162239.086361477@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[ Upstream commit f77bf1ebf8ff6301ccdbc346f7b52db928f9cbf8 ]

Returning -EOPNOTSUPP from function returning u32 is leading to
cast and invalid size value as a result.

-EOPNOTSUPP as a size probably will lead to allocation fail.

Command: ethtool -x eth0
It is visible on all devices that don't have RSS caps set.

[  136.615917] Call Trace:
[  136.615921]  <TASK>
[  136.615927]  ? __warn+0x89/0x130
[  136.615942]  ? __alloc_frozen_pages_noprof+0x322/0x330
[  136.615953]  ? report_bug+0x164/0x190
[  136.615968]  ? handle_bug+0x58/0x90
[  136.615979]  ? exc_invalid_op+0x17/0x70
[  136.615987]  ? asm_exc_invalid_op+0x1a/0x20
[  136.616001]  ? rss_prepare_get.constprop.0+0xb9/0x170
[  136.616016]  ? __alloc_frozen_pages_noprof+0x322/0x330
[  136.616028]  __alloc_pages_noprof+0xe/0x20
[  136.616038]  ___kmalloc_large_node+0x80/0x110
[  136.616072]  __kmalloc_large_node_noprof+0x1d/0xa0
[  136.616081]  __kmalloc_noprof+0x32c/0x4c0
[  136.616098]  ? rss_prepare_get.constprop.0+0xb9/0x170
[  136.616105]  rss_prepare_get.constprop.0+0xb9/0x170
[  136.616114]  ethnl_default_doit+0x107/0x3d0
[  136.616131]  genl_family_rcv_msg_doit+0x100/0x160
[  136.616147]  genl_rcv_msg+0x1b8/0x2c0
[  136.616156]  ? __pfx_ethnl_default_doit+0x10/0x10
[  136.616168]  ? __pfx_genl_rcv_msg+0x10/0x10
[  136.616176]  netlink_rcv_skb+0x58/0x110
[  136.616186]  genl_rcv+0x28/0x40
[  136.616195]  netlink_unicast+0x19b/0x290
[  136.616206]  netlink_sendmsg+0x222/0x490
[  136.616215]  __sys_sendto+0x1fd/0x210
[  136.616233]  __x64_sys_sendto+0x24/0x30
[  136.616242]  do_syscall_64+0x82/0x160
[  136.616252]  ? __sys_recvmsg+0x83/0xe0
[  136.616265]  ? syscall_exit_to_user_mode+0x10/0x210
[  136.616275]  ? do_syscall_64+0x8e/0x160
[  136.616282]  ? __count_memcg_events+0xa1/0x130
[  136.616295]  ? count_memcg_events.constprop.0+0x1a/0x30
[  136.616306]  ? handle_mm_fault+0xae/0x2d0
[  136.616319]  ? do_user_addr_fault+0x379/0x670
[  136.616328]  ? clear_bhb_loop+0x45/0xa0
[  136.616340]  ? clear_bhb_loop+0x45/0xa0
[  136.616349]  ? clear_bhb_loop+0x45/0xa0
[  136.616359]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  136.616369] RIP: 0033:0x7fd30ba7b047
[  136.616376] Code: 0c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b8 0f 1f 00 f3 0f 1e fa 80 3d bd d5 0c 00 00 41 89 ca 74 10 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 71 c3 55 48 83 ec 30 44 89 4c 24 2c 4c 89 44
[  136.616381] RSP: 002b:00007ffde1796d68 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
[  136.616388] RAX: ffffffffffffffda RBX: 000055d7bd89f2a0 RCX: 00007fd30ba7b047
[  136.616392] RDX: 0000000000000028 RSI: 000055d7bd89f3b0 RDI: 0000000000000003
[  136.616396] RBP: 00007ffde1796e10 R08: 00007fd30bb4e200 R09: 000000000000000c
[  136.616399] R10: 0000000000000000 R11: 0000000000000202 R12: 000055d7bd89f340
[  136.616403] R13: 000055d7bd89f3b0 R14: 000055d78943f200 R15: 0000000000000000

Fixes: 02cbfba1add5 ("idpf: add ethtool callbacks")
Reviewed-by: Ahmed Zaki <ahmed.zaki@intel.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_ethtool.c b/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
index 59b1a1a099967..f72420cf68216 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
@@ -46,7 +46,7 @@ static u32 idpf_get_rxfh_key_size(struct net_device *netdev)
 	struct idpf_vport_user_config_data *user_config;
 
 	if (!idpf_is_cap_ena_all(np->adapter, IDPF_RSS_CAPS, IDPF_CAP_RSS))
-		return -EOPNOTSUPP;
+		return 0;
 
 	user_config = &np->adapter->vport_config[np->vport_idx]->user_config;
 
@@ -65,7 +65,7 @@ static u32 idpf_get_rxfh_indir_size(struct net_device *netdev)
 	struct idpf_vport_user_config_data *user_config;
 
 	if (!idpf_is_cap_ena_all(np->adapter, IDPF_RSS_CAPS, IDPF_CAP_RSS))
-		return -EOPNOTSUPP;
+		return 0;
 
 	user_config = &np->adapter->vport_config[np->vport_idx]->user_config;
 
-- 
2.39.5



