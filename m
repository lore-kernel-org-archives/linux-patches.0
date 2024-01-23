Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA68A65BA6;
	Tue, 23 Jan 2024 01:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975097; cv=none; b=VsenfYx7xpsc32q9Lwz4Kc1C9IGcY1jGkozAL5xdHaOL4fL2zfwbvXErN9Vv9dm2IlaM7yB3368UyFKsAeqOAKLuSLRIXJt1S0nwK54LCVxqeB6NcwOJgQEifVmkOeJXCYp/6uBHJiZc8qE1Xu5P+9SaFEhoZ4JO+B7JGroG+0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975097; c=relaxed/simple;
	bh=wFSxH8mcDvrRJ5+jBgAzeWciw4KbgN5lGi8GyxYUZro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJerqR212JG5JfC5oEWvEUuQwIcfrf2VR/k1h3epRueWM98cYMaeYG8jXaZ0hqDbf49nnI7n6XTqYdtN3qcn6KbwrRRwq9vDHeT8ZVZjpGi8kEk91mjVNsKgAh8ECWNxUQxrRdQB+z/b59PgrFjCYsYE9olGQYhl39hfJ/qJFWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XIgobwA7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XIgobwA7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973F8C43394;
	Tue, 23 Jan 2024 01:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975097;
	bh=wFSxH8mcDvrRJ5+jBgAzeWciw4KbgN5lGi8GyxYUZro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XIgobwA7uIC2Tq90OUuGi2uOPzrk1E4WiWAWYpgDm0INBkmplb4km/GpAmWj1UFHb
	 ReiUuSQ3AUatzs+0P5ojpMlJtvqY48/FbuWto8hLhknPyeDqm0TK6wFWPX9/8QRsD9
	 WX8QFlFIauKQgesR8tCPgJv9/yDU2DsrBA7a3Q1Y=
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
Subject: [PATCH 5.15 364/374] selftests: mlxsw: qos_pfc: Adjust the test to support 8 lanes
Date: Mon, 22 Jan 2024 16:00:20 -0800
Message-ID: <20240122235757.616884223@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



