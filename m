Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716142561D7;
	Tue, 25 Mar 2025 12:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905949; cv=none; b=EPZX2bOxv6crNrl36AlF0rUyZ7cdctL4XgydKQk9/iNROlXyv65nPTvX1NcQmCkXfpRXOWsYX1IMvFwa9xX394wDCu3DfLLiSLC/1LzGRW0WDNalTQ9KQnEPyEIr4RGQS6OpPLjedRQa4oOuTciqoL0cwjobjthEPY0XUnL80rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905949; c=relaxed/simple;
	bh=hAhwMwnsdCVZrfH9moa+9AcCYtYB/E4Q89jgtgm5geQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEnMNq2e89nRkQUH1nVxZ0JGOfZfyBsnHkZY9FmDs2lOV/TMcpaqvSPJImQ3PIIAWnypz6iBFaFbP4p+2f2MIBZMXrPzL6+1jOSbVoD1DRkAkcyecBO0ONnR6Ce/t7RcLSxtgELd8dkYdF06ExGad8GAvLMqE0mjuzkYDbGSnQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=btlDw49r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="btlDw49r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25099C4CEE4;
	Tue, 25 Mar 2025 12:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905949;
	bh=hAhwMwnsdCVZrfH9moa+9AcCYtYB/E4Q89jgtgm5geQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=btlDw49rG84bEpjLGaHjIgFtvyDdZIohqWLNoEzvHRcFKvYkuLJ3lN0uX6N4ot/3L
	 XV3VIG9cEkMb7YG3VXc2SNpAbZEqW5A39bn3WG+hD/SB+wM4DrzeVRkx55vA+CnO5B
	 Ib1CgMEje7i0ao/oOLHOjAdsbwyiQVTxmcE32S2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 051/119] Revert "gre: Fix IPv6 link-local address generation."
Date: Tue, 25 Mar 2025 08:21:49 -0400
Message-ID: <20250325122150.359490006@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit fc486c2d060f67d672ddad81724f7c8a4d329570 ]

This reverts commit 183185a18ff96751db52a46ccf93fff3a1f42815.

This patch broke net/forwarding/ip6gre_custom_multipath_hash.sh in some
circumstances (https://lore.kernel.org/netdev/Z9RIyKZDNoka53EO@mini-arch/).
Let's revert it while the problem is being investigated.

Fixes: 183185a18ff9 ("gre: Fix IPv6 link-local address generation.")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Link: https://patch.msgid.link/8b1ce738eb15dd841aab9ef888640cab4f6ccfea.1742418408.git.gnault@redhat.com
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index bdf39388e514b..0e765466d7f79 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3237,13 +3237,16 @@ static void add_v4_addrs(struct inet6_dev *idev)
 	struct in6_addr addr;
 	struct net_device *dev;
 	struct net *net = dev_net(idev->dev);
-	int scope, plen;
+	int scope, plen, offset = 0;
 	u32 pflags = 0;
 
 	ASSERT_RTNL();
 
 	memset(&addr, 0, sizeof(struct in6_addr));
-	memcpy(&addr.s6_addr32[3], idev->dev->dev_addr, 4);
+	/* in case of IP6GRE the dev_addr is an IPv6 and therefore we use only the last 4 bytes */
+	if (idev->dev->addr_len == sizeof(struct in6_addr))
+		offset = sizeof(struct in6_addr) - 4;
+	memcpy(&addr.s6_addr32[3], idev->dev->dev_addr + offset, 4);
 
 	if (!(idev->dev->flags & IFF_POINTOPOINT) && idev->dev->type == ARPHRD_SIT) {
 		scope = IPV6_ADDR_COMPATv4;
@@ -3554,13 +3557,7 @@ static void addrconf_gre_config(struct net_device *dev)
 		return;
 	}
 
-	/* Generate the IPv6 link-local address using addrconf_addr_gen(),
-	 * unless we have an IPv4 GRE device not bound to an IP address and
-	 * which is in EUI64 mode (as __ipv6_isatap_ifid() would fail in this
-	 * case). Such devices fall back to add_v4_addrs() instead.
-	 */
-	if (!(dev->type == ARPHRD_IPGRE && *(__be32 *)dev->dev_addr == 0 &&
-	      idev->cnf.addr_gen_mode == IN6_ADDR_GEN_MODE_EUI64)) {
+	if (dev->type == ARPHRD_ETHER) {
 		addrconf_addr_gen(idev, true);
 		return;
 	}
-- 
2.39.5



