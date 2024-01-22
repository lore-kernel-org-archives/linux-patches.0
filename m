Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5395013DBB7;
	Tue, 23 Jan 2024 01:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971990; cv=none; b=Amg5vVh0c8R44eH1HULLsGsTNMBhtBoxiDNAFzHr7zdbCSYpKmTmLUv7CfTZT1jkqXew+2qmGV8p5MjZNQw9QGgl7zKpsid7sGnhQUSRXIofGYLDsqu6kdAhTA5CtrcDKicdVGzDSyM/cswq5V2ljys4R/qyxsUCi3lt7V2ERPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971990; c=relaxed/simple;
	bh=pad0kKlZpHtnVm3ErMmz0hmNi2+DKs/wuMgmw/WK/tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GiONP0DBc43CQtXdxu6YwKsR73+o6mA81mqKSKAKEo+KvG+nhCDmnRIUhm7OUKWR0bp2fqfn9Nb1XS2DNmu0EufLl3jHHky7bd9t6Z2Std4SyIxl3AqD6qEKLTViN6FkeWpcK+e68tTmNRwVQTywDfErjH8yNiVmgcyw8w5l/5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZSfmP/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZSfmP/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E1EC43394;
	Tue, 23 Jan 2024 01:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971990;
	bh=pad0kKlZpHtnVm3ErMmz0hmNi2+DKs/wuMgmw/WK/tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mZSfmP/L+GvB9NJKhPugIe379mz8jeb86SCPTchpDZvtA80q5N4sa6qNhaAHA915U
	 ylxlytLh13U/ObHHKtu4t72tLN96cvxzw8Q7FOntP5iT3s575JuPxkl8ABcA85gF3K
	 Tj+Pc+uwl3TfNgN4rGt/jL+Q6FwgGf9pFiavFw40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 283/286] selftests: mlxsw: qos_pfc: Convert to iproute2 dcb
Date: Mon, 22 Jan 2024 15:59:49 -0800
Message-ID: <20240122235742.951214549@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit b0bab2298ec9b3a837f8ef4a0cae4b42a4d03365 ]

There is a dedicated tool for configuration of DCB in iproute2 now. Use it
in the selftest instead of mlnx_qos.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: b34f4de6d30c ("selftests: mlxsw: qos_pfc: Adjust the test to support 8 lanes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/drivers/net/mlxsw/qos_pfc.sh    | 24 +++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh
index 5c7700212f75..5d5622fc2758 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh
@@ -171,7 +171,7 @@ switch_create()
 	# assignment.
 	tc qdisc replace dev $swp1 root handle 1: \
 	   ets bands 8 strict 8 priomap 7 6
-	__mlnx_qos -i $swp1 --prio2buffer=0,1,0,0,0,0,0,0 >/dev/null
+	dcb buffer set dev $swp1 prio-buffer all:0 1:1
 
 	# $swp2
 	# -----
@@ -209,8 +209,8 @@ switch_create()
 	# the lossless prio into a buffer of its own. Don't bother with buffer
 	# sizes though, there is not going to be any pressure in the "backward"
 	# direction.
-	__mlnx_qos -i $swp3 --prio2buffer=0,1,0,0,0,0,0,0 >/dev/null
-	__mlnx_qos -i $swp3 --pfc=0,1,0,0,0,0,0,0 >/dev/null
+	dcb buffer set dev $swp3 prio-buffer all:0 1:1
+	dcb pfc set dev $swp3 prio-pfc all:off 1:on
 
 	# $swp4
 	# -----
@@ -226,11 +226,11 @@ switch_create()
 	# Configure qdisc so that we can hand-tune headroom.
 	tc qdisc replace dev $swp4 root handle 1: \
 	   ets bands 8 strict 8 priomap 7 6
-	__mlnx_qos -i $swp4 --prio2buffer=0,1,0,0,0,0,0,0 >/dev/null
-	__mlnx_qos -i $swp4 --pfc=0,1,0,0,0,0,0,0 >/dev/null
+	dcb buffer set dev $swp4 prio-buffer all:0 1:1
+	dcb pfc set dev $swp4 prio-pfc all:off 1:on
 	# PG0 will get autoconfigured to Xoff, give PG1 arbitrarily 100K, which
 	# is (-2*MTU) about 80K of delay provision.
-	__mlnx_qos -i $swp4 --buffer_size=0,$_100KB,0,0,0,0,0,0 >/dev/null
+	dcb buffer set dev $swp4 buffer-size all:0 1:$_100KB
 
 	# bridges
 	# -------
@@ -273,9 +273,9 @@ switch_destroy()
 	# $swp4
 	# -----
 
-	__mlnx_qos -i $swp4 --buffer_size=0,0,0,0,0,0,0,0 >/dev/null
-	__mlnx_qos -i $swp4 --pfc=0,0,0,0,0,0,0,0 >/dev/null
-	__mlnx_qos -i $swp4 --prio2buffer=0,0,0,0,0,0,0,0 >/dev/null
+	dcb buffer set dev $swp4 buffer-size all:0
+	dcb pfc set dev $swp4 prio-pfc all:off
+	dcb buffer set dev $swp4 prio-buffer all:0
 	tc qdisc del dev $swp4 root
 
 	devlink_tc_bind_pool_th_restore $swp4 1 ingress
@@ -288,8 +288,8 @@ switch_destroy()
 	# $swp3
 	# -----
 
-	__mlnx_qos -i $swp3 --pfc=0,0,0,0,0,0,0,0 >/dev/null
-	__mlnx_qos -i $swp3 --prio2buffer=0,0,0,0,0,0,0,0 >/dev/null
+	dcb pfc set dev $swp3 prio-pfc all:off
+	dcb buffer set dev $swp3 prio-buffer all:0
 	tc qdisc del dev $swp3 root
 
 	devlink_tc_bind_pool_th_restore $swp3 1 egress
@@ -315,7 +315,7 @@ switch_destroy()
 	# $swp1
 	# -----
 
-	__mlnx_qos -i $swp1 --prio2buffer=0,0,0,0,0,0,0,0 >/dev/null
+	dcb buffer set dev $swp1 prio-buffer all:0
 	tc qdisc del dev $swp1 root
 
 	devlink_tc_bind_pool_th_restore $swp1 1 ingress
-- 
2.43.0



