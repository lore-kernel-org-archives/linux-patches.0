Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0973038758A;
	Tue, 10 Mar 2026 11:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141232; cv=none; b=XC4XoloNt/fwgKLGpOErUPwjFc5CIyaHOVHrhtFgn3OLQ9izbXw5mSsjRqLjvbbv2VR8yIGDM129aIVXpAfyGZMl+W7l+MEjsi32I1dSWTq2eWcTgb+IbZ2Dgph/OePruJyjiHx5dJYg5TXz8JXYUhlyZrLDCi5TxD0Eh+LxPtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141232; c=relaxed/simple;
	bh=X7wfGJe2aBJra2FnK03EeNQFlzogazhoP0nUrY0XFk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aghl+O+d47sCao8faHJ3ZK1yxf1lEq/WMGB1RG+EEMFYmRM/y+rLrTheFVu3RuT0Jwf+I81zO2UVY/8WcQEnXlM2Yezpq/cMK2VcCtSHcJCqkmxMFPhuAG3kgiIdOVxcm+2Ij4I7WYfmrAE8fl+j6OLV1dCEHBtlXKI1KKCbxvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l7fbAZdM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l7fbAZdM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED311C2BC9E;
	Tue, 10 Mar 2026 11:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141231;
	bh=X7wfGJe2aBJra2FnK03EeNQFlzogazhoP0nUrY0XFk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l7fbAZdMOGfbPPZ57lYo3qsoXZ/MS7Kv+rlE6lKg2MsHTG61YS4q7GSDyri9T3vSK
	 XzeKKSwlls0hKCx27yQDpDA5TcetutHev+54u+z0dmgvIg/Q43/PFvLSOkXR2tVw8R
	 W6bg4696jVoXBRI+gu/KDxO484NBCbeYBiS5ZQe/pvhrMaJ3bgv2HdS0YAQ4bqi/a+
	 v+AcEdWYUJitLqj8ZtrNxeJ8LPuzSBCyT4b4yMxWjRSsqzmBjNO9VvP52O1bdvfLT1
	 mM6M4bCQo6Afa++ZdpjOvcGEMJ7OwJlaXp+VNmGUeJHQ8oeLiojT2cDBtSDTZ/Ojc7
	 ZqO33Pj7JFZmg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	syzbot+5a287bcdc08104bc3132@syzkaller.appspotmail.com,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 233/311] bpf/bonding: reject vlan+srcmac xmit_hash_policy change when XDP is loaded
Date: Tue, 10 Mar 2026 07:04:40 -0400
Message-ID: <45e9934871923c8fa5cffb3bb2005a22aa6735d9.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c    | 9 +++++++--
 drivers/net/bonding/bond_options.c | 2 ++
 include/net/bonding.h              | 1 +
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 4c58d1dafcacb..739e6eea6b529 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -324,7 +324,7 @@ static bool bond_sk_check(struct bonding *bond)
 	}
 }
 
-bool bond_xdp_check(struct bonding *bond, int mode)
+bool __bond_xdp_check(int mode, int xmit_policy)
 {
 	switch (mode) {
 	case BOND_MODE_ROUNDROBIN:
@@ -335,7 +335,7 @@ bool bond_xdp_check(struct bonding *bond, int mode)
 		/* vlan+srcmac is not supported with XDP as in most cases the 802.1q
 		 * payload is not in the packet due to hardware offload.
 		 */
-		if (bond->params.xmit_policy != BOND_XMIT_POLICY_VLAN_SRCMAC)
+		if (xmit_policy != BOND_XMIT_POLICY_VLAN_SRCMAC)
 			return true;
 		fallthrough;
 	default:
@@ -343,6 +343,11 @@ bool bond_xdp_check(struct bonding *bond, int mode)
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
index f1c6e9d8f6167..adc216df43459 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -1574,6 +1574,8 @@ static int bond_option_fail_over_mac_set(struct bonding *bond,
 static int bond_option_xmit_hash_policy_set(struct bonding *bond,
 					    const struct bond_opt_value *newval)
 {
+	if (bond->xdp_prog && !__bond_xdp_check(BOND_MODE(bond), newval->value))
+		return -EOPNOTSUPP;
 	netdev_dbg(bond->dev, "Setting xmit hash policy to %s (%llu)\n",
 		   newval->string, newval->value);
 	bond->params.xmit_policy = newval->value;
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 4620784035570..99c1bdadcd11a 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -698,6 +698,7 @@ void bond_debug_register(struct bonding *bond);
 void bond_debug_unregister(struct bonding *bond);
 void bond_debug_reregister(struct bonding *bond);
 const char *bond_mode_name(int mode);
+bool __bond_xdp_check(int mode, int xmit_policy);
 bool bond_xdp_check(struct bonding *bond, int mode);
 void bond_setup(struct net_device *bond_dev);
 unsigned int bond_get_num_tx_queues(void);
-- 
2.51.0

