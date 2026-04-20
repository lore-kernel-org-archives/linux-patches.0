Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABE83C0624;
	Mon, 20 Apr 2026 13:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691622; cv=none; b=S4yCiRi006aXCX9Ih7Cfv2UF1So/pL5+FgDJ0lJgb51yoDpVqb88sziLNviSpoD76kt3O1a/ZY9spueB+n2E/6/AyVmBgSxX8BwiN6HVDZqO9WQuB5P24Y/vzmeQ/0x+k2KHQ6uyZMPI/pxyQ/eWt1nzOalYLGqsku5LDQidemY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691622; c=relaxed/simple;
	bh=2HFDKDa+QYlTQ7jECX761lpR0rAZxZkBIpMTXWaLxk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjG10gtFWSiljityG3g4MJtfFuFuyZ1wsrGlDpp3nbfCjxJBLGPjd/6eYC5z9RiX2nV3zUpmbPtQoypJ55hv80zysjrveGVb8kK5h2g0NAdUqAuFWzuRMPy2GkDgDs81L0I8CEsFRStHHQoRGugCxdQeyp7FZhQB7W/UIm95JLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jjR1yiFQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jjR1yiFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D019C2BCB7;
	Mon, 20 Apr 2026 13:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691622;
	bh=2HFDKDa+QYlTQ7jECX761lpR0rAZxZkBIpMTXWaLxk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jjR1yiFQmvgvbl0MaX6FNOeY5wctDyVfhMdSyIirW6I859uV+uFivP6rsbcMLpbBJ
	 eMmrtnwo/O+wkJ/1LyGgGtJQdnwnEWR7lUHlMkLQDxcPqLpJ4uflgJaKXNa2xrze3H
	 Vq8JqB3PP0Nf1XroKgBLpHBVilumLijzKt8Jd6iOb2U3CmelzIuTyN571mgWe9Ef48
	 UrrhN2Tk2sO9pSbA515cdthqO2u8U7t93o+skRJ6ibVvX9fkdYtT1iTbRhIcFciDOW
	 VqD0oCAmwKy9yYATxq/9wVLqqMN/ZM2co2sGW3E8cA5yQe2iaJ2DU3TvsVTNkV/FrG
	 EcCepRH6Cf5RA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel Golle <daniel@makrotopia.org>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	shuah@kernel.org,
	razor@blackwall.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] selftests: net: bridge_vlan_mcast: wait for h1 before querier check
Date: Mon, 20 Apr 2026 09:18:51 -0400
Message-ID: <20260420132314.1023554-137-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

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

