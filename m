Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836A613DBB7;
	Tue, 23 Jan 2024 01:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971992; cv=none; b=fHK/q9DRiBNPMO9faTrHcH72Lrw4sU6P1B+K90i4oSiQj3SJwOcJ0QtDyngwazzhIKyQYtR19ZgZAQxFE3XK4XuRLpBWcmwGyLzSc0pRD/s91cfBdV/4U54nSxjDhOFu61j4YTlEaW8GMXC+NP7oZ0jXJV304q8WR9rko/dOHMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971992; c=relaxed/simple;
	bh=3r/VwjX90zSYCIe5IgSBj5eCWTyCzoEpkj4p9Uh125M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6IiV0WamhtDFzhNNJi/2emaY6CFQu/DlQJOzk4pwZ3PxeXuVLmnWyqNMUqLFFO9DBOFiJLh+XtCaXCxzc1W7JcWRx/1mgoZu1nJopls0M2V069VX+xKfUodNJRSbtIVSsWoa0Dthj/3B7XGvRG/lxKRJFjr4zgeYq2mPWi0HR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yT6LE96Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yT6LE96Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB5FC433C7;
	Tue, 23 Jan 2024 01:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971992;
	bh=3r/VwjX90zSYCIe5IgSBj5eCWTyCzoEpkj4p9Uh125M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yT6LE96QoE51tfAYzrwgk/jn9eU7FdcHtwXKlumxBGV87qumRp4lGDNoPJhogH8SM
	 0dhsVKXYeTCF3ymFuCcuiUiPcy54Svcc1R9z/oJ0ZPSwQX1n/DOabWnvNDdvAIDbp+
	 jybDalgwLzMwpWMVhSYUlm+nmGqPUuulZkbKu3wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuah Khan <shuah@kernel.org>,
	Amit Cohen <amcohen@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 284/286] selftests: mlxsw: qos_pfc: Adjust the test to support 8 lanes
Date: Mon, 22 Jan 2024 15:59:50 -0800
Message-ID: <20240122235742.984457633@linuxfoundation.org>
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

From: Amit Cohen <amcohen@nvidia.com>

[ Upstream commit b34f4de6d30cbaa8fed905a5080b6eace8c84dc7 ]

'qos_pfc' test checks PFC behavior. The idea is to limit the traffic
using a shaper somewhere in the flow of the packets. In this area, the
buffer is smaller than the buffer at the beginning of the flow, so it fills
up until there is no more space left. The test configures there PFC
which is supposed to notice that the headroom is filling up and send PFC
Xoff to indicate the transmitter to stop sending traffic for the priorities
sharing this PG.

The Xon/Xoff threshold is auto-configured and always equal to
2*(MTU rounded up to cell size). Even after sending the PFC Xoff packet,
traffic will keep arriving until the transmitter receives and processes
the PFC packet. This amount of traffic is known as the PFC delay allowance.

Currently the buffer for the delay traffic is configured as 100KB. The
MTU in the test is 10KB, therefore the threshold for Xoff is about 20KB.
This allows 80KB extra to be stored in this buffer.

8-lane ports use two buffers among which the configured buffer is split,
the Xoff threshold then applies to each buffer in parallel.

The test does not take into account the behavior of 8-lane ports, when the
ports are configured to 400Gbps with 8 lanes or 800Gbps with 8 lanes,
packets are dropped and the test fails.

Check if the relevant ports use 8 lanes, in such case double the size of
the buffer, as the headroom is split half-half.

Cc: Shuah Khan <shuah@kernel.org>
Fixes: bfa804784e32 ("selftests: mlxsw: Add a PFC test")
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/23ff11b7dff031eb04a41c0f5254a2b636cd8ebb.1705502064.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/drivers/net/mlxsw/qos_pfc.sh     | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh
index 5d5622fc2758..56761de1ca3b 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh
@@ -121,6 +121,9 @@ h2_destroy()
 
 switch_create()
 {
+	local lanes_swp4
+	local pg1_size
+
 	# pools
 	# -----
 
@@ -230,7 +233,20 @@ switch_create()
 	dcb pfc set dev $swp4 prio-pfc all:off 1:on
 	# PG0 will get autoconfigured to Xoff, give PG1 arbitrarily 100K, which
 	# is (-2*MTU) about 80K of delay provision.
-	dcb buffer set dev $swp4 buffer-size all:0 1:$_100KB
+	pg1_size=$_100KB
+
+	setup_wait_dev_with_timeout $swp4
+
+	lanes_swp4=$(ethtool $swp4 | grep 'Lanes:')
+	lanes_swp4=${lanes_swp4#*"Lanes: "}
+
+	# 8-lane ports use two buffers among which the configured buffer
+	# is split, so double the size to get twice (20K + 80K).
+	if [[ $lanes_swp4 -eq 8 ]]; then
+		pg1_size=$((pg1_size * 2))
+	fi
+
+	dcb buffer set dev $swp4 buffer-size all:0 1:$pg1_size
 
 	# bridges
 	# -------
-- 
2.43.0



