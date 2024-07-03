Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9101717279B;
	Wed,  3 Jul 2024 11:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005334; cv=none; b=GEK1fkKs/hoRGZgoQ/ld0MTtAxUyeDzWjdsc8np0gZxSRqvoLo3fARwCmesudrq7y8G6aX+PkhD1AwiRjc4Xigv8bPES60mD/KuSCriNFQWra1DXSNyIh0H+3APxgVQjTtVgGj9MkdDn98m9h9Wumy8EFytSMOlFnlo9C+pdoIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005334; c=relaxed/simple;
	bh=B3yz+xkCkVHLHoRJ1NND0BYF+LyBQ3gHV+oEslinqPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnDMtnvJmqGkzTykoj3pY2xnLn+PQzUPc/ZSXU6u5SjdW/8JZ7STLfBMd0PSXMW6dKxfCphENTw1yRjXys20YF7GG+PH422I6cTjjVvEdi3D8gvajtUjht0nk8KIs5qZYsmojBbWo0PvoPn+B1IvtJ8dSKNik31nk6efsyZr+d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0UqZXp7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0UqZXp7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79D1C2BD10;
	Wed,  3 Jul 2024 11:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005334;
	bh=B3yz+xkCkVHLHoRJ1NND0BYF+LyBQ3gHV+oEslinqPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0UqZXp7nCS91QwtEQrRcesBXmlnlI9VTTu35v5wk74HyQf/gqfkFJQPNRwm9AWy5
	 atXpWMu81pvrtZdv05yfd1PEmT2BTH5Z2LsF+CiF+3xIBjcUYvk89bJUzNbz6UDIK/
	 N7NfMcMumTeuaR7YLr+gdd67Ffn5b6RMnZ3Qykts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	David Bauer <mail@david-bauer.net>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/356] vxlan: Fix regression when dropping packets due to invalid src addresses
Date: Wed,  3 Jul 2024 12:35:52 +0200
Message-ID: <20240703102913.714501788@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 1cd4bc987abb2823836cbb8f887026011ccddc8a ]

Commit f58f45c1e5b9 ("vxlan: drop packets from invalid src-address")
has recently been added to vxlan mainly in the context of source
address snooping/learning so that when it is enabled, an entry in the
FDB is not being created for an invalid address for the corresponding
tunnel endpoint.

Before commit f58f45c1e5b9 vxlan was similarly behaving as geneve in
that it passed through whichever macs were set in the L2 header. It
turns out that this change in behavior breaks setups, for example,
Cilium with netkit in L3 mode for Pods as well as tunnel mode has been
passing before the change in f58f45c1e5b9 for both vxlan and geneve.
After mentioned change it is only passing for geneve as in case of
vxlan packets are dropped due to vxlan_set_mac() returning false as
source and destination macs are zero which for E/W traffic via tunnel
is totally fine.

Fix it by only opting into the is_valid_ether_addr() check in
vxlan_set_mac() when in fact source address snooping/learning is
actually enabled in vxlan. This is done by moving the check into
vxlan_snoop(). With this change, the Cilium connectivity test suite
passes again for both tunnel flavors.

Fixes: f58f45c1e5b9 ("vxlan: drop packets from invalid src-address")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: David Bauer <mail@david-bauer.net>
Cc: Ido Schimmel <idosch@nvidia.com>
Cc: Nikolay Aleksandrov <razor@blackwall.org>
Cc: Martin KaFai Lau <martin.lau@kernel.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: David Bauer <mail@david-bauer.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 41b1b23fdd3e9..65a2f4ab89970 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1493,6 +1493,10 @@ static bool vxlan_snoop(struct net_device *dev,
 	struct vxlan_fdb *f;
 	u32 ifindex = 0;
 
+	/* Ignore packets from invalid src-address */
+	if (!is_valid_ether_addr(src_mac))
+		return true;
+
 #if IS_ENABLED(CONFIG_IPV6)
 	if (src_ip->sa.sa_family == AF_INET6 &&
 	    (ipv6_addr_type(&src_ip->sin6.sin6_addr) & IPV6_ADDR_LINKLOCAL))
-- 
2.43.0



