Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C348E27CCC7;
	Wed, 23 Apr 2025 14:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420213; cv=none; b=rNzB8bCs0Mgb/Ms17jf09C2CemHiC2+wNsNSdGUdhuHtMMXgdsL1sEO+Ikpy0vE9QCPxCXivAhBAvmvb78ACPeU6+QvuClqG25gGdL2OBI9fO8AQy7HavTfFQqQ2r6HDTJhRiZgjYYNpJ3ktR1c7VDxgxstKmEQhVcrlhZyo1bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420213; c=relaxed/simple;
	bh=E6oUe261y8RcZyU+Tt3DJ5xvCbNOOaDZJracfr4UvrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nopPcMXCX1o9AXbunktkBj7zW0iBClu00U+Yji2sne1h9fs5ov9t7qrsmWhdy2y/SsRHUpe/1Q1cGWzD4gZTVcouT08xcXG3Nft1pwGqk7KFitUe73FNTZp2KcBFieI+cN2ZqJB4+sDPJX91/K56s2kP7iUuXeOui0Wx/3epy/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p4FxMAm0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p4FxMAm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5715C4CEE2;
	Wed, 23 Apr 2025 14:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420213;
	bh=E6oUe261y8RcZyU+Tt3DJ5xvCbNOOaDZJracfr4UvrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p4FxMAm09ep0aI3/SAK/g+udpctQuDvMKjdiK/DacnaB5/+S4ZYc7Decrq7O1I4o1
	 KikoNxS/GrfnUDsGMPuMCFsQHzyQqkyiPVKajQxg0YpAl4Yy+NOcihXKaKznf93+En
	 fWjJawQHo4ENPWGGvSjdjO7kZ+CW042Nt70qbGj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 072/241] net: bridge: switchdev: do not notify new brentries as changed
Date: Wed, 23 Apr 2025 16:42:16 +0200
Message-ID: <20250423142623.537378780@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit eb25de13bd9cf025413a04f25e715d0e99847e30 ]

When adding a bridge vlan that is pvid or untagged after the vlan has
already been added to any other switchdev backed port, the vlan change
will be propagated as changed, since the flags change.

This causes the vlan to not be added to the hardware for DSA switches,
since the DSA handler ignores any vlans for the CPU or DSA ports that
are changed.

E.g. the following order of operations would work:

$ ip link add swbridge type bridge vlan_filtering 1 vlan_default_pvid 0
$ ip link set lan1 master swbridge
$ bridge vlan add dev swbridge vid 1 pvid untagged self
$ bridge vlan add dev lan1 vid 1 pvid untagged

but this order would break:

$ ip link add swbridge type bridge vlan_filtering 1 vlan_default_pvid 0
$ ip link set lan1 master swbridge
$ bridge vlan add dev lan1 vid 1 pvid untagged
$ bridge vlan add dev swbridge vid 1 pvid untagged self

Additionally, the vlan on the bridge itself would become undeletable:

$ bridge vlan
port              vlan-id
lan1              1 PVID Egress Untagged
swbridge          1 PVID Egress Untagged
$ bridge vlan del dev swbridge vid 1 self
$ bridge vlan
port              vlan-id
lan1              1 PVID Egress Untagged
swbridge          1 Egress Untagged

since the vlan was never added to DSA's vlan list, so deleting it will
cause an error, causing the bridge code to not remove it.

Fix this by checking if flags changed only for vlans that are already
brentry and pass changed as false for those that become brentries, as
these are a new vlan (member) from the switchdev point of view.

Since *changed is set to true for becomes_brentry = true regardless of
would_change's value, this will not change any rtnetlink notification
delivery, just the value passed on to switchdev in vlan->changed.

Fixes: 8d23a54f5bee ("net: bridge: switchdev: differentiate new VLANs from changed ones")
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20250414200020.192715-1-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_vlan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index d9a69ec9affe5..939a3aa78d5c4 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -715,8 +715,8 @@ static int br_vlan_add_existing(struct net_bridge *br,
 				u16 flags, bool *changed,
 				struct netlink_ext_ack *extack)
 {
-	bool would_change = __vlan_flags_would_change(vlan, flags);
 	bool becomes_brentry = false;
+	bool would_change = false;
 	int err;
 
 	if (!br_vlan_is_brentry(vlan)) {
@@ -725,6 +725,8 @@ static int br_vlan_add_existing(struct net_bridge *br,
 			return -EINVAL;
 
 		becomes_brentry = true;
+	} else {
+		would_change = __vlan_flags_would_change(vlan, flags);
 	}
 
 	/* Master VLANs that aren't brentries weren't notified before,
-- 
2.39.5



