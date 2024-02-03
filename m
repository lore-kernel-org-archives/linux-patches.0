Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB2A481BF;
	Sat,  3 Feb 2024 04:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933711; cv=none; b=A3KgKDIY9aylc9F+zV56rgYp7tTws11aQnneTTfEzvi8+GE20C9zLhUgt7nHkxNdAVaXKxW0G63jYGPC+/H3SC3cX/iKP6OLAgRo4/OLDSK3JDev8FouAneDf+t/j5CUzVT9J5Y1ikK6asS1NwdxoUqtdVvDI3u43YeWyLCy1oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933711; c=relaxed/simple;
	bh=1L8+lFg3DvgB8v4Cj1n8v0NuAvjbmXa/0uyajDOVmMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MqoBpTf2eUV6cS3GySgN/ESSi9dEVu1xPzS5Q7fJauthxWjkT1BEQmKqt0rbQjUQXyFLYwqmp0urdjttlTklntodHp/4rV1TsqMZ5Zo5VvnfZm354ADGqu0WyoBMhit9p58z3CSbEJB2U/BM15VTCnFJaSOUJkn6govllNBrhBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3LCjZRg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3LCjZRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FA9C433F1;
	Sat,  3 Feb 2024 04:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933710;
	bh=1L8+lFg3DvgB8v4Cj1n8v0NuAvjbmXa/0uyajDOVmMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O3LCjZRgR4r5tA/uIIzaD8YztkCVjjh6yVos193PIaYzonMdZmjywfn6xiqGjDcKn
	 4VH04AKlA885aQ0woY9nYpUOrCknuI5ionzvomDfoV6Wpffzf91/M4FsR6xRsU2c/O
	 jJTfxAGKQqGihiTe5t1Gh7h6Rm7NPfTYEN/i+DvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Poirier <bpoirier@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 313/322] selftests: bonding: Check initial state
Date: Fri,  2 Feb 2024 20:06:50 -0800
Message-ID: <20240203035409.145615986@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Poirier <bpoirier@nvidia.com>

[ Upstream commit 8cc063ae1b3dbe416ce62a15d49af4c2314b45fe ]

The purpose of the test_LAG_cleanup() function is to check that some
hardware addresses are removed from underlying devices after they have been
unenslaved. The test function simply checks that those addresses are not
present at the end. However, if the addresses were never added to begin
with due to some error in device setup, the test function currently passes.
This is a false positive since in that situation the test did not actually
exercise the intended functionality.

Add a check that the expected addresses are indeed present after device
setup. This makes the test function more robust.

I noticed this problem when running the team/dev_addr_lists.sh test on a
system without support for dummy and ipv6:

tools/testing/selftests/drivers/net/team# ./dev_addr_lists.sh
Error: Unknown device type.
Error: Unknown device type.
This program is not intended to be run as root.
RTNETLINK answers: Operation not supported
TEST: team cleanup mode lacp                                        [ OK ]

Fixes: bbb774d921e2 ("net: Add tests for bonding and team address list management")
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
Link: https://lore.kernel.org/r/20240131140848.360618-3-bpoirier@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/drivers/net/bonding/lag_lib.sh  | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/bonding/lag_lib.sh b/tools/testing/selftests/drivers/net/bonding/lag_lib.sh
index 2a268b17b61f..dbdd736a41d3 100644
--- a/tools/testing/selftests/drivers/net/bonding/lag_lib.sh
+++ b/tools/testing/selftests/drivers/net/bonding/lag_lib.sh
@@ -48,6 +48,17 @@ test_LAG_cleanup()
 	ip link add mv0 link "$name" up address "$ucaddr" type macvlan
 	# Used to test dev->mc handling
 	ip address add "$addr6" dev "$name"
+
+	# Check that addresses were added as expected
+	(grep_bridge_fdb "$ucaddr" bridge fdb show dev dummy1 ||
+		grep_bridge_fdb "$ucaddr" bridge fdb show dev dummy2) >/dev/null
+	check_err $? "macvlan unicast address not found on a slave"
+
+	# mcaddr is added asynchronously by addrconf_dad_work(), use busywait
+	(busywait 10000 grep_bridge_fdb "$mcaddr" bridge fdb show dev dummy1 ||
+		grep_bridge_fdb "$mcaddr" bridge fdb show dev dummy2) >/dev/null
+	check_err $? "IPv6 solicited-node multicast mac address not found on a slave"
+
 	ip link set dev "$name" down
 	ip link del "$name"
 
-- 
2.43.0



