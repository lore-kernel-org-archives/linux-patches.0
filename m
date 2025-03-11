Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8EF25F78D;
	Tue, 11 Mar 2025 15:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707622; cv=none; b=I2El+a0D6qSK+aBeKeyCiYVTa4U/eKRbdnGU5v6VlM/E0U2tzhC0aZXNFCjl0hjUWdAcX9uoCJ+eteOQFoUGhtwNtavdDsVrZ9r54RxeBZVmK1/vN4VO8eVK2fACZQBYzJ7wFS0dW1c69TVShW9N76XFnEMrlp1jBqglFJbsO8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707622; c=relaxed/simple;
	bh=nowvR8z9b2cFXPbv49uUcxPzoqj0rXJT+zUTelPvP4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jI4mp0DSA5zmycXr4J7BLfrMoU9p+n+ON/dlW80/RFAuHRGRkI0qhBcV/a/4nhEGyQtIqsmyju7DZeJf+uTD+xugIG1I0mVMxomyLg3DjtP/Giwb7rhATpi6eB1FNuj5WTazWF4TzDHHXRUQmymr4e9tFd4+gEZedUBgj/H9qkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IefOVrF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IefOVrF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65656C4CEE9;
	Tue, 11 Mar 2025 15:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707621;
	bh=nowvR8z9b2cFXPbv49uUcxPzoqj0rXJT+zUTelPvP4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IefOVrF548pGg6A8MzH8MBpWykVD1+Qz4rtlC54Zaw3L5iqtqPp5cwDF9WXesbo/y
	 SthBgT7KG+VFP/j5bKL69CgclMNJmz+MINZdEeQGxxw+z87WnaHGWE4Z9aIUbtV1BP
	 vx0Gq08CM/nq+63B2agzcJxjy2Wh+NXxuWQLVTzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+91161fe81857b396c8a0@syzkaller.appspotmail.com,
	Oscar Maes <oscmaes92@gmail.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 420/462] vlan: enforce underlying device type
Date: Tue, 11 Mar 2025 16:01:26 +0100
Message-ID: <20250311145814.927998772@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oscar Maes <oscmaes92@gmail.com>

[ Upstream commit b33a534610067ade2bdaf2052900aaad99701353 ]

Currently, VLAN devices can be created on top of non-ethernet devices.

Besides the fact that it doesn't make much sense, this also causes a
bug which leaks the address of a kernel function to usermode.

When creating a VLAN device, we initialize GARP (garp_init_applicant)
and MRP (mrp_init_applicant) for the underlying device.

As part of the initialization process, we add the multicast address of
each applicant to the underlying device, by calling dev_mc_add.

__dev_mc_add uses dev->addr_len to determine the length of the new
multicast address.

This causes an out-of-bounds read if dev->addr_len is greater than 6,
since the multicast addresses provided by GARP and MRP are only 6
bytes long.

This behaviour can be reproduced using the following commands:

ip tunnel add gretest mode ip6gre local ::1 remote ::2 dev lo
ip l set up dev gretest
ip link add link gretest name vlantest type vlan id 100

Then, the following command will display the address of garp_pdu_rcv:

ip maddr show | grep 01:80:c2:00:00:21

Fix the bug by enforcing the type of the underlying device during VLAN
device initialization.

Fixes: 22bedad3ce11 ("net: convert multicast list to list_head")
Reported-by: syzbot+91161fe81857b396c8a0@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/000000000000ca9a81061a01ec20@google.com/
Signed-off-by: Oscar Maes <oscmaes92@gmail.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://patch.msgid.link/20250303155619.8918-1-oscmaes92@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/8021q/vlan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 64a94c9812da1..b45b9c9b12684 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -128,7 +128,8 @@ int vlan_check_real_dev(struct net_device *real_dev,
 {
 	const char *name = real_dev->name;
 
-	if (real_dev->features & NETIF_F_VLAN_CHALLENGED) {
+	if (real_dev->features & NETIF_F_VLAN_CHALLENGED ||
+	    real_dev->type != ARPHRD_ETHER) {
 		pr_info("VLANs not supported on %s\n", name);
 		NL_SET_ERR_MSG_MOD(extack, "VLANs not supported on device");
 		return -EOPNOTSUPP;
-- 
2.39.5



