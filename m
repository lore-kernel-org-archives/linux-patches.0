Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BE71419B5;
	Wed, 19 Jun 2024 13:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803545; cv=none; b=D+nDOB+vpP0mt7RtkIV/fPXYz5ZwnCkPYDwJIi0j1bKn5xsG52vbj7VclVHv5I9qI16rRzqW4IXWdA7aTqZee2JM+Izo+x8TDDCbmZgTw6ab18pL1uQM+PW/BKW9InVR+r0sfAXqxouIFD7z2UFa3QDl71iSPqaL8SzPQkAHuNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803545; c=relaxed/simple;
	bh=EJXPawyfOvp9J8H1ts7hFXD7FB9+G32rGVcBodRSOQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qXtm4dQz27Nllo4dIS8+B1rBGg9MQkMaed/2i0P5gWQKiiuLhgb7QBDcxMrRAfECVXXYjbC7g7c5UCXTm9nbemc5GgIc09eU5zf0rle4bHduoBtPkTbFzH4OQXe8ABfC7yGstQhNLwPW+D9+XZOJsMzMjTwWuT2/LoIriSa1YzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pVKFSswK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pVKFSswK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3E7C32786;
	Wed, 19 Jun 2024 13:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803545;
	bh=EJXPawyfOvp9J8H1ts7hFXD7FB9+G32rGVcBodRSOQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pVKFSswKlfPhgUwlpJaaOD85VMYH5FZJwoBsp/Jfy9eLHylSHIgb1XUb4NataSN84
	 IfVSb6SpmpTEsNA398WhjZoI/EQ7aDjI1jUCajL/JnEsb/adO+e8ql5N+3jJDjj3PQ
	 MVyejA22QNiaOibNpcRTWfYLrA5anbWyIBP1X2JQ=
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
Subject: [PATCH 6.1 021/217] vxlan: Fix regression when dropping packets due to invalid src addresses
Date: Wed, 19 Jun 2024 14:54:24 +0200
Message-ID: <20240619125557.463354682@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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
index a7ae68f490c4c..61224a5a877cb 100644
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



