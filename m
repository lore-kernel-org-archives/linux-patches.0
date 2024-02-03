Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63CFFC03;
	Sat,  3 Feb 2024 04:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933470; cv=none; b=e5UjO+lxgvlFRs+tnTjGEC3OcY2SdxqSXx7o9EuEqaNW5pkZYW7cWAREC4+NEsB8ZdqGdb4slSdBropENIerD9uz271aBheSyHrxwN14vLiL+IXamVZLQTxELcIX78yCm48fI6v8RBvAjJorUZmGl44pVl0ezqe7liNBRhCScPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933470; c=relaxed/simple;
	bh=iTlTRGyyK0EfaeBLWaCHxVM9ry3rRMfdjxfgT1MRZsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLD7xiuAxiH5JlnN99lyhHD8wwBl4270U8sdrcEdRuuZZuQoRxC/YgK7PLBFL332mSSJIOfLBbiSkTDIJkvliKUVGSOK40PATWpdDbxjRj0McRgSpmicMRaAxBgGop+Iy4R/pQOtQ1FJ0OfhGd003ip5/24KFFJI9YD/0Mqk6So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EjRekyc9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EjRekyc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E74AC43390;
	Sat,  3 Feb 2024 04:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933470;
	bh=iTlTRGyyK0EfaeBLWaCHxVM9ry3rRMfdjxfgT1MRZsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjRekyc9zWFaStWChxRqrSHF52NZrsCmBWX9QT8kPG1XrCNkVoIP7R6awL4ybplHb
	 090LerrOve5JHAdaenAISeWi8sWaUbddJQUe/ULK/sBsBBxmnegHLHNPqWHKjbZbFn
	 51efaJQ65I04s7iP7df40fOzlF3p60Znkfo/rd+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Poirier <bpoirier@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 212/219] selftests: bonding: Check initial state
Date: Fri,  2 Feb 2024 20:06:25 -0800
Message-ID: <20240203035346.570450237@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 16c7fb858ac1..696ef9bf3afc 100644
--- a/tools/testing/selftests/drivers/net/bonding/lag_lib.sh
+++ b/tools/testing/selftests/drivers/net/bonding/lag_lib.sh
@@ -46,6 +46,17 @@ test_LAG_cleanup()
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



