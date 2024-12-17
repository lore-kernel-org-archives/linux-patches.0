Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0C11F7579;
	Tue, 17 Dec 2024 17:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456563; cv=none; b=lTeayimUoIgkUHJ6HmCanzdnMlCwvF2KL4lQDuQ37QKZfBcskjkngJwO8MCLRu28iUgc6DMKBtHXKi24bc6X3082Awwq+N0p6lgA7wCFp+GxjDTOHMgqlYK3BLwDjs43XxK8TDx9roW7+9K+qHprFpKHVIFYTFqJO3lXdYIKkL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456563; c=relaxed/simple;
	bh=yE/iYjhEpAL82McY1ekLBwexXhxldx141U/9XFMtj5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B7N67AQTGKGlnQC09SPnr8RNpO8ic2GHg88Ij8YC8gAvOIAKSy4hL85osjCiCPmFOqdN69VekLGHDbm7xb2YUnLtQlMbPbuhlHlj/wv//XeKtBWidGEzfJ9DRT+qrfbw26+kbGs22fTm80aREG3A47ks1pCppk1ynCFAlKDU8Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FKha7Lmv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FKha7Lmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1108C4CED3;
	Tue, 17 Dec 2024 17:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456563;
	bh=yE/iYjhEpAL82McY1ekLBwexXhxldx141U/9XFMtj5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FKha7Lmv5Hkj/5dAyolqitBAxUkc3hOZYi4Iu+a/NMsMp4Nqjq5tygpu2yI/d6Qcj
	 CYZXOeg/caXK+F+hfwGkLwcdwNjAK11/F61TEKImRtLF5Ob4KSJ7Ld+ug3GUnZRuf+
	 ins8H/rgtUKJ4GmIDPgOI9Nd9Vb2j0RUgLl8nnww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danielle Ratson <danieller@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/172] selftests: mlxsw: sharedbuffer: Ensure no extra packets are counted
Date: Tue, 17 Dec 2024 18:07:34 +0100
Message-ID: <20241217170550.364194540@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danielle Ratson <danieller@nvidia.com>

[ Upstream commit 5f2c7ab15fd806043db1a7d54b5ec36be0bd93b1 ]

The test assumes that the packet it is sending is the only packet being
passed to the device.

However, it is not the case and so other packets are filling the buffers
as well. Therefore, the test sometimes fails because it is reading a
maximum occupancy that is larger than expected.

Add egress filters on $h1 and $h2 that will guarantee the above.

Fixes: a865ad999603 ("selftests: mlxsw: Add shared buffer traffic test")
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Link: https://patch.msgid.link/64c28bc9b1cc1d78c4a73feda7cedbe9526ccf8b.1733414773.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drivers/net/mlxsw/sharedbuffer.sh         | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh b/tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh
index 21bebc5726f6..c068e6c2a580 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh
@@ -22,20 +22,34 @@ SB_ITC=0
 h1_create()
 {
 	simple_if_init $h1 192.0.1.1/24
+	tc qdisc add dev $h1 clsact
+
+	# Add egress filter on $h1 that will guarantee that the packet sent,
+	# will be the only packet being passed to the device.
+	tc filter add dev $h1 egress pref 2 handle 102 matchall action drop
 }
 
 h1_destroy()
 {
+	tc filter del dev $h1 egress pref 2 handle 102 matchall action drop
+	tc qdisc del dev $h1 clsact
 	simple_if_fini $h1 192.0.1.1/24
 }
 
 h2_create()
 {
 	simple_if_init $h2 192.0.1.2/24
+	tc qdisc add dev $h2 clsact
+
+	# Add egress filter on $h2 that will guarantee that the packet sent,
+	# will be the only packet being passed to the device.
+	tc filter add dev $h2 egress pref 1 handle 101 matchall action drop
 }
 
 h2_destroy()
 {
+	tc filter del dev $h2 egress pref 1 handle 101 matchall action drop
+	tc qdisc del dev $h2 clsact
 	simple_if_fini $h2 192.0.1.2/24
 }
 
@@ -101,6 +115,11 @@ port_pool_test()
 	local exp_max_occ=$(devlink_cell_size_get)
 	local max_occ
 
+	tc filter add dev $h1 egress protocol ip pref 1 handle 101 flower \
+		src_mac $h1mac dst_mac $h2mac \
+		src_ip 192.0.1.1 dst_ip 192.0.1.2 \
+		action pass
+
 	devlink sb occupancy clearmax $DEVLINK_DEV
 
 	$MZ $h1 -c 1 -p 10 -a $h1mac -b $h2mac -A 192.0.1.1 -B 192.0.1.2 \
@@ -117,6 +136,11 @@ port_pool_test()
 	max_occ=$(sb_occ_pool_check $cpu_dl_port $SB_POOL_EGR_CPU $exp_max_occ)
 	check_err $? "Expected ePool($SB_POOL_EGR_CPU) max occupancy to be $exp_max_occ, but got $max_occ"
 	log_test "CPU port's egress pool"
+
+	tc filter del dev $h1 egress protocol ip pref 1 handle 101 flower \
+		src_mac $h1mac dst_mac $h2mac \
+		src_ip 192.0.1.1 dst_ip 192.0.1.2 \
+		action pass
 }
 
 port_tc_ip_test()
@@ -124,6 +148,11 @@ port_tc_ip_test()
 	local exp_max_occ=$(devlink_cell_size_get)
 	local max_occ
 
+	tc filter add dev $h1 egress protocol ip pref 1 handle 101 flower \
+		src_mac $h1mac dst_mac $h2mac \
+		src_ip 192.0.1.1 dst_ip 192.0.1.2 \
+		action pass
+
 	devlink sb occupancy clearmax $DEVLINK_DEV
 
 	$MZ $h1 -c 1 -p 10 -a $h1mac -b $h2mac -A 192.0.1.1 -B 192.0.1.2 \
@@ -140,6 +169,11 @@ port_tc_ip_test()
 	max_occ=$(sb_occ_etc_check $cpu_dl_port $SB_ITC_CPU_IP $exp_max_occ)
 	check_err $? "Expected egress TC($SB_ITC_CPU_IP) max occupancy to be $exp_max_occ, but got $max_occ"
 	log_test "CPU port's egress TC - IP packet"
+
+	tc filter del dev $h1 egress protocol ip pref 1 handle 101 flower \
+		src_mac $h1mac dst_mac $h2mac \
+		src_ip 192.0.1.1 dst_ip 192.0.1.2 \
+		action pass
 }
 
 port_tc_arp_test()
@@ -147,6 +181,9 @@ port_tc_arp_test()
 	local exp_max_occ=$(devlink_cell_size_get)
 	local max_occ
 
+	tc filter add dev $h1 egress protocol arp pref 1 handle 101 flower \
+		src_mac $h1mac action pass
+
 	devlink sb occupancy clearmax $DEVLINK_DEV
 
 	$MZ $h1 -c 1 -p 10 -a $h1mac -A 192.0.1.1 -t arp -q
@@ -162,6 +199,9 @@ port_tc_arp_test()
 	max_occ=$(sb_occ_etc_check $cpu_dl_port $SB_ITC_CPU_ARP $exp_max_occ)
 	check_err $? "Expected egress TC($SB_ITC_IP2ME) max occupancy to be $exp_max_occ, but got $max_occ"
 	log_test "CPU port's egress TC - ARP packet"
+
+	tc filter del dev $h1 egress protocol arp pref 1 handle 101 flower \
+		src_mac $h1mac action pass
 }
 
 setup_prepare()
-- 
2.39.5



