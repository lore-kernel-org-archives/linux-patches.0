Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562204CB5B;
	Sun,  7 Jun 2026 10:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827673; cv=none; b=p0Gt+hDx0YUUnAG/iEBsmVXxl/kCmibkhMBbRVul7sO/qPJcKkGMG1F1U6CbEIg6Bn8TIxH6fNrk7dSrKBJqOCfy5EW8x7sSoLqzd3DN8i8t3EVZrhGp16ww01+QqK6KY5LsBjqS5kkgv7yNi2ljsILuWwBcpq8kzPVPWeKgU8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827673; c=relaxed/simple;
	bh=7FaXTwVxzqQ5mP9Gwp6j+6ThkUxh2JTpv/R4E23Z7K0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QdzqSPYMRY1QDOkk+Rodz+g4618+8V6P6iJBCodJOn8rZg9lcbvuJbH3vMAfsRPFzs/isoTy1FosPma+9zOD2vxn7cTdr1xk0ZHGpVG7ns3AbLDmIe6rx2D2laSkT+zcx0YntV8NzMpzxNQU1C8TZ9c0OOId7H03zySC98KT984=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eO5jWUKT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eO5jWUKT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF441F00893;
	Sun,  7 Jun 2026 10:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827671;
	bh=juhwrVi0IDL0+y2R5QtPK/qEmJXjEAfU4/5j3KzBy0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eO5jWUKTMQEn9TlSfL9HRFgYHo5Fwi30+tEmPUr+U9SuS4IqudR1lJTymPtPC2emq
	 daR9TABXSXusEjNb4wrGlOaB4QdPafSugW6Qc1V+soZctFnIZdah/AW1D0kWzCTQMS
	 Gune3sG9EmYalEdnSfFlUDLtdUXqgX9tgzcKzfmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Adams <linux@cmadams.net>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 113/332] Revert "ipv6: preserve insertion order for same-scope addresses"
Date: Sun,  7 Jun 2026 11:58:02 +0200
Message-ID: <20260607095732.264833069@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 072aa0f5c3d8f11f3159037418ec45edce7440b8 ]

Chris Adams reported that preserving insertion order for same-scope
addresses is causing SSH connections to be dropped after stopping a VM
while running NetworkManager.

NetworkManager caches the IPv6 address configuration, when a RA arrives,
it determines the list of addresses to configure and checks if the
addresses are already in the right order in the kernel. If they aren't,
NetworkManager removes and re-adds them to achieve the desired order.

As the order changes, NetworkManager is confused and reconfigures the
addresses on every update. In addition, this would also affect to cloud
tooling that relies on IPv6 addresses order to identify primary and
secondaries addresses.

This reverts commit cb3de96eea66f5e4a580086c6a1be46e765f97f4.

Fixes: cb3de96eea66 ("ipv6: preserve insertion order for same-scope addresses")
Reported-by: Chris Adams <linux@cmadams.net>
Closes: https://lore.kernel.org/netdev/20260521135310.GC977@cmadams.net/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Link: https://patch.msgid.link/20260529112357.5079-1-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c                  | 2 +-
 tools/testing/selftests/net/ioam6.sh | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index dd0b4d80e0f84d..e5276be71062a3 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1012,7 +1012,7 @@ ipv6_link_dev_addr(struct inet6_dev *idev, struct inet6_ifaddr *ifp)
 	list_for_each(p, &idev->addr_list) {
 		struct inet6_ifaddr *ifa
 			= list_entry(p, struct inet6_ifaddr, if_list);
-		if (ifp_scope > ipv6_addr_src_scope(&ifa->addr))
+		if (ifp_scope >= ipv6_addr_src_scope(&ifa->addr))
 			break;
 	}
 
diff --git a/tools/testing/selftests/net/ioam6.sh b/tools/testing/selftests/net/ioam6.sh
index b2b99889942f75..845c26dd01a932 100755
--- a/tools/testing/selftests/net/ioam6.sh
+++ b/tools/testing/selftests/net/ioam6.sh
@@ -273,8 +273,8 @@ setup()
   ip -netns $ioam_node_beta link set ioam-veth-betaR name veth1 &>/dev/null
   ip -netns $ioam_node_gamma link set ioam-veth-gamma name veth0 &>/dev/null
 
-  ip -netns $ioam_node_alpha addr add 2001:db8:1::2/64 dev veth0 &>/dev/null
   ip -netns $ioam_node_alpha addr add 2001:db8:1::50/64 dev veth0 &>/dev/null
+  ip -netns $ioam_node_alpha addr add 2001:db8:1::2/64 dev veth0 &>/dev/null
   ip -netns $ioam_node_alpha link set veth0 up &>/dev/null
   ip -netns $ioam_node_alpha link set lo up &>/dev/null
   ip -netns $ioam_node_alpha route add 2001:db8:2::/64 \
-- 
2.53.0



