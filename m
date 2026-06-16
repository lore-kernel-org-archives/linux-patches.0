Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639BE3A3E78;
	Tue, 16 Jun 2026 17:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631262; cv=none; b=uJjYnWIhSdhVCuv7sVTi+CTPxuswWagiy3dVGrM7GW5eZzn9K1t1PAwfZLADIGtZiJhhwglCrMvYxxaXosoPghSiKpw9t4mAHOZPETpcBpz78sXbKKg6c4cSj+pateuRv4rUq8K1ddEd73jRLDWFy8KJrMGIjxJL5FOxW8iOROc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631262; c=relaxed/simple;
	bh=v6cBPOvQK5jQt4e+Jagy6EUMQ7fkFapoABTw4ZF0YAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGHA/U71LAy4m774UzSZ8a/9ckJJ5ApLS2hHPgUuSHDT3xT/opIGrkQbZ5D6IOcmI8JPc+BtBTyNN/ky9i684v+If5KiD4V3R7uhLibzocKQX3NyzEW5KN3lvbXMQF88fXPjizRrQwyMxPsEJGKZmOva7Xh6reLU6PLj+uN8peo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YcV72xx0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YcV72xx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6698A1F000E9;
	Tue, 16 Jun 2026 17:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631261;
	bh=Fp9h+OyYmjGCQ41VXzU0OaZdnS5RvngGIi+iKP5ZEGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YcV72xx0RJE5PIt+soLtBtwBtcmyiDI/tuvz+L14dRWPpbjokvJcWH4FLayeCwEB+
	 9V3+o5PDdUnZ1ODpj3UBHOPXYEjiVA6P3wK76wEebyysCcShvH0uAE2Ll1MjiDP+6B
	 aluexORuzeQjIQZ2+5siHrNzUEhKIUgjTJofZ94o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5a287bcdc08104bc3132@syzkaller.appspotmail.com,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Rajani Kantha <681739313@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 188/522] bpf/bonding: reject vlan+srcmac xmit_hash_policy change when XDP is loaded
Date: Tue, 16 Jun 2026 20:25:35 +0530
Message-ID: <20260616145134.908960480@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@shopee.com>

[ Upstream commit 479d589b40b836442bbdadc3fdb37f001bb67f26 ]

bond_option_mode_set() already rejects mode changes that would make a
loaded XDP program incompatible via bond_xdp_check().  However,
bond_option_xmit_hash_policy_set() has no such guard.

For 802.3ad and balance-xor modes, bond_xdp_check() returns false when
xmit_hash_policy is vlan+srcmac, because the 802.1q payload is usually
absent due to hardware offload.  This means a user can:

1. Attach a native XDP program to a bond in 802.3ad/balance-xor mode
   with a compatible xmit_hash_policy (e.g. layer2+3).
2. Change xmit_hash_policy to vlan+srcmac while XDP remains loaded.

This leaves bond->xdp_prog set but bond_xdp_check() now returning false
for the same device.  When the bond is later destroyed, dev_xdp_uninstall()
calls bond_xdp_set(dev, NULL, NULL) to remove the program, which hits
the bond_xdp_check() guard and returns -EOPNOTSUPP, triggering:

WARN_ON(dev_xdp_install(dev, mode, bpf_op, NULL, 0, NULL))

Fix this by rejecting xmit_hash_policy changes to vlan+srcmac when an
XDP program is loaded on a bond in 802.3ad or balance-xor mode.

commit 39a0876d595b ("net, bonding: Disallow vlan+srcmac with XDP")
introduced bond_xdp_check() which returns false for 802.3ad/balance-xor
modes when xmit_hash_policy is vlan+srcmac.  The check was wired into
bond_xdp_set() to reject XDP attachment with an incompatible policy, but
the symmetric path -- preventing xmit_hash_policy from being changed to an
incompatible value after XDP is already loaded -- was left unguarded in
bond_option_xmit_hash_policy_set().

Note:
commit 094ee6017ea0 ("bonding: check xdp prog when set bond mode")
later added a similar guard to bond_option_mode_set(), but
bond_option_xmit_hash_policy_set() remained unprotected.

Reported-by: syzbot+5a287bcdc08104bc3132@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6995aff6.050a0220.2eeac1.014e.GAE@google.com/T/
Fixes: 39a0876d595b ("net, bonding: Disallow vlan+srcmac with XDP")
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Link: https://patch.msgid.link/20260226080306.98766-2-jiayuan.chen@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Rajani Kantha <681739313@139.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c    | 9 +++++++--
 drivers/net/bonding/bond_options.c | 2 ++
 include/net/bonding.h              | 1 +
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 0e078252b52a98..f2e97f640467de 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -322,7 +322,7 @@ bool bond_sk_check(struct bonding *bond)
 	}
 }
 
-bool bond_xdp_check(struct bonding *bond, int mode)
+bool __bond_xdp_check(int mode, int xmit_policy)
 {
 	switch (mode) {
 	case BOND_MODE_ROUNDROBIN:
@@ -333,7 +333,7 @@ bool bond_xdp_check(struct bonding *bond, int mode)
 		/* vlan+srcmac is not supported with XDP as in most cases the 802.1q
 		 * payload is not in the packet due to hardware offload.
 		 */
-		if (bond->params.xmit_policy != BOND_XMIT_POLICY_VLAN_SRCMAC)
+		if (xmit_policy != BOND_XMIT_POLICY_VLAN_SRCMAC)
 			return true;
 		fallthrough;
 	default:
@@ -341,6 +341,11 @@ bool bond_xdp_check(struct bonding *bond, int mode)
 	}
 }
 
+bool bond_xdp_check(struct bonding *bond, int mode)
+{
+	return __bond_xdp_check(mode, bond->params.xmit_policy);
+}
+
 /*---------------------------------- VLAN -----------------------------------*/
 
 /* In the following 2 functions, bond_vlan_rx_add_vid and bond_vlan_rx_kill_vid,
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 40731d180bb505..3d15b340b5c939 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -1590,6 +1590,8 @@ static int bond_option_fail_over_mac_set(struct bonding *bond,
 static int bond_option_xmit_hash_policy_set(struct bonding *bond,
 					    const struct bond_opt_value *newval)
 {
+	if (bond->xdp_prog && !__bond_xdp_check(BOND_MODE(bond), newval->value))
+		return -EOPNOTSUPP;
 	netdev_dbg(bond->dev, "Setting xmit hash policy to %s (%llu)\n",
 		   newval->string, newval->value);
 	bond->params.xmit_policy = newval->value;
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 06a048d716b19f..f2dee8cefa1963 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -704,6 +704,7 @@ void bond_debug_register(struct bonding *bond);
 void bond_debug_unregister(struct bonding *bond);
 void bond_debug_reregister(struct bonding *bond);
 const char *bond_mode_name(int mode);
+bool __bond_xdp_check(int mode, int xmit_policy);
 bool bond_xdp_check(struct bonding *bond, int mode);
 void bond_setup(struct net_device *bond_dev);
 unsigned int bond_get_num_tx_queues(void);
-- 
2.53.0



