Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDB619A288;
	Fri, 24 Apr 2026 13:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037808; cv=none; b=KNXDBtukKPcFCUR0u5ruEu6ZkdnqU1/cAl4GR19HuPQsU9IJvfGIDmkPeeU5Zetc3ncBP5CCUjjx4MEBGViOtOwAHzGwC02pHKyEzfWm7v/yYmkyplZl8XQDvY2yDNqr6Iqmf8c+7qnkln9N+yN2ScVKIinV0KCeowY60QO1WZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037808; c=relaxed/simple;
	bh=zZT70ns9srFHfs4i3iDsIHdG2BU0CJxczAzZ3ANpcd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VNUJBp+x+pivrDYe3MA8/dysdEeW9Cskkl6+GLRX/Nwsbab/Dpo0kifzw2OBJRQdcGrbM2d996U9Di7JBFHS11iGsi7hyUJF/uqteM3ggfueFkmxAHO3p8nG8y4ibjSLP2ySI0XpMRekqcy8JpMf9heYjh7mi1IqH5SPDAKDx6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yyOq29fU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yyOq29fU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20EB5C19425;
	Fri, 24 Apr 2026 13:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037808;
	bh=zZT70ns9srFHfs4i3iDsIHdG2BU0CJxczAzZ3ANpcd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yyOq29fUveAmPrbaSSJk9KQ95Z4VtLTrP5ZkxtuhjLIcZcK6+luUqObl7o4BBwIJ2
	 fFjvLk7EJmbt4lJd2rn02Avuaw28eJVa6r4CeDUHK/tIlL5mtFtaD++BhED8F1TRLB
	 w1U/w8taIKcGn7MlNA4R7dYx0xRHTBlh6jXqC/PA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/166] selftests: net: bridge_vlan_mcast: wait for h1 before querier check
Date: Fri, 24 Apr 2026 15:29:24 +0200
Message-ID: <20260424132543.299699564@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



