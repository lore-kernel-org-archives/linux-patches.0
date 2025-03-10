Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE8CBA3D;
	Mon, 10 Mar 2025 18:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630883; cv=none; b=njD4sOdJN/gEoAdFtKFwOZpVvZwX/bKPtrsNioEDblxDdDSvfFi7PWuagRiQIQzbviNHb9KiqoxpkerqGg02fCQC7qxvvAx7OuAxO/CuAh0AXL8zRr/kTsbm9UG+k3C1Ok/kMsrCnuxF5fTAgA40SUmWukFtYKAb6s7v5lh3G38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630883; c=relaxed/simple;
	bh=a0NzzosRn60cB2+PqjhE0QsRymvGSMgUkDEPNPc9DWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hf/uJfPVoX3hGD4wIFJDXF4gNNcla6xL007SRqrSU2cEsfY0ZSO9wuKMfoaLw9Ww4/pRtjdyIgNM8//BaqhvmJBP3qCdqh2Cl5ZU7pH4qqOWMHazKE+qaG9PydYUoPb2NsS5kvgwlj7IMuQhtCISJp2zSKwiVznyZQhkMkNxT2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lvQaH6Ik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lvQaH6Ik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E913C4CEE5;
	Mon, 10 Mar 2025 18:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630882;
	bh=a0NzzosRn60cB2+PqjhE0QsRymvGSMgUkDEPNPc9DWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lvQaH6IkzQhqQi9vseMan8ppR/HbCNN6uw908+Sbizaw8jg935hFGMjoorKjjuM8m
	 xEk/2ujvCL0iFoLOMvQUueyCoADErdLOEnZJcJ2t0XTF84u9iE+pOzA5TT4le0svwO
	 ZpJYVy/y5IGLSoQHUGV4F9z/wvE+ntutxvQA6m54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+91161fe81857b396c8a0@syzkaller.appspotmail.com,
	Oscar Maes <oscmaes92@gmail.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 568/620] vlan: enforce underlying device type
Date: Mon, 10 Mar 2025 18:06:54 +0100
Message-ID: <20250310170607.966075286@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index abaa5d96ded24..eba36453a51ad 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -131,7 +131,8 @@ int vlan_check_real_dev(struct net_device *real_dev,
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



