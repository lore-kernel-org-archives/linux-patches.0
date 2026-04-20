Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E1833262B;
	Mon, 20 Apr 2026 15:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700287; cv=none; b=QiG8Tc4hm2XMIVptnUJBKvaNCL0/kYFB9w5qM4s9vai58YMD/uLiF5JWEAnNJTI3q6343m9STRosw3pxwJlWTNS5CC7pWzWTnssl5r9qc9y3eWad9MjBtQVuPkmRGS5g8Dlf5Vy3+cXXtpxYdfdCqNcRJ5rdmU8SkLFLrVBKm4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700287; c=relaxed/simple;
	bh=yfwnwF1sViNFt6Lq41xTqCDWeb/xXqdLelR11FwulfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/LMf6vTtcpirkMnY9BU8BMslk8o1ymfXtbO8n9HIgizs4275cnnrDA6r0FEjtt4Fyz15gCucPOxTOiwhxV8A1Oc4ICbKVMBdnsRV3d17YNB2UgqfU1bMFO9SoP5kZ3lSF+sTDl2lK+pRlKlMMOjvbm4iM5ymB6GDVan0Y2DsjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FyjgjsFd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FyjgjsFd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0792C19425;
	Mon, 20 Apr 2026 15:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700287;
	bh=yfwnwF1sViNFt6Lq41xTqCDWeb/xXqdLelR11FwulfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FyjgjsFd6tpSE3Chm0mBdqbq/XMT0pq51p823gg0y0/eV9FLrmwCJm2VwsfWUD+mT
	 yuGeppw5iE6HsozHXg2vqM2FAE0VGHsFtGDtiF2VXg+6P3yr6Cm4WblwCTzRvCKXQp
	 2Mbhge4H+5KqMlX01Xh5Z4tSzySWny9JSQYmineA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 114/220] selftests: net: bridge_vlan_mcast: wait for h1 before querier check
Date: Mon, 20 Apr 2026 17:40:55 +0200
Message-ID: <20260420153938.134876122@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit efaa71faf212324ecbf6d5339e9717fe53254f58 ]

The querier-interval test adds h1 (currently a slave of the VRF created
by simple_if_init) to a temporary bridge br1 acting as an outside IGMP
querier. The kernel VRF driver (drivers/net/vrf.c) calls cycle_netdev()
on every slave add and remove, toggling the interface admin-down then up.
Phylink takes the PHY down during the admin-down half of that cycle.
Since h1 and swp1 are cable-connected, swp1 also loses its link may need
several seconds to re-negotiate.

Use setup_wait_dev $h1 0 which waits for h1 to return to UP state, so the
test can rely on the link being back up at this point.

Fixes: 4d8610ee8bd77 ("selftests: net: bridge: add vlan mcast_querier_interval tests")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Link: https://patch.msgid.link/c830f130860fd2efae08bfb9e5b25fd028e58ce5.1775424423.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh b/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
index 72dfbeaf56b92..e8031f68200ad 100755
--- a/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
@@ -414,6 +414,7 @@ vlmc_querier_intvl_test()
 	bridge vlan add vid 10 dev br1 self pvid untagged
 	ip link set dev $h1 master br1
 	ip link set dev br1 up
+	setup_wait_dev $h1 0
 	bridge vlan add vid 10 dev $h1 master
 	bridge vlan global set vid 10 dev br1 mcast_snooping 1 mcast_querier 1
 	sleep 2
-- 
2.53.0



