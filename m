Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABF512CD96;
	Tue, 30 Apr 2024 11:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475265; cv=none; b=PxjgYHGLtIvF+vRyhDQYLnfI5jV+62JO2+0I/0xLZiBWMquMgun99BljObb8akJ7SEclsEJ7BCU3YB/QeMb7Z53Ubhb0nGIcliQMeb1qGNQACEI2psUEV7f3NWUR3cMxrtwqIry2q+NzwrIqjqR/XCINXC2LJ9D20EiMntHRlP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475265; c=relaxed/simple;
	bh=5MTYlhQGztHr/eoHoZEeNm/cSiRL/SIbfC0PBUV9qq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ck9H4X83QgtXW5i7/O6ri/GqLwoNjqL9X6jeDfouymF+YJ1tKn0IbvOG5Stv7JgT3K+UjqNV7Y2nmOYn2rYlkHrjwDGNrAyTMr+WOcaXPjPAHr5e+tTA38trVBpysU7xGu356JB6ZvRf+zZYMIqKDbyy0QFLa1o/ZAmo4+p1Iyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebtI52bn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebtI52bn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3C8C2BBFC;
	Tue, 30 Apr 2024 11:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475265;
	bh=5MTYlhQGztHr/eoHoZEeNm/cSiRL/SIbfC0PBUV9qq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebtI52bnoKoOlVbY+T5CyIAeNkNFrBRW97mFtbXpI9kXoaQ/UtkkO6O3Hte1O/Aio
	 nu9eZw3PcWe8Fv5Z7hIVxcEPtgbYvRflyOoAVzuo++5qjQYu9BFhnVuTkcUVoCqNFb
	 RV3p6ypZvVQgRKmdyAsITtX7Y9VrI4+/mK2c84og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	David Bauer <mail@david-bauer.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/186] vxlan: drop packets from invalid src-address
Date: Tue, 30 Apr 2024 12:38:17 +0200
Message-ID: <20240430103059.339937793@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

From: David Bauer <mail@david-bauer.net>

[ Upstream commit f58f45c1e5b92975e91754f5407250085a6ae7cf ]

The VXLAN driver currently does not check if the inner layer2
source-address is valid.

In case source-address snooping/learning is enabled, a entry in the FDB
for the invalid address is created with the layer3 address of the tunnel
endpoint.

If the frame happens to have a non-unicast address set, all this
non-unicast traffic is subsequently not flooded to the tunnel network
but sent to the learnt host in the FDB. To make matters worse, this FDB
entry does not expire.

Apply the same filtering for packets as it is done for bridges. This not
only drops these invalid packets but avoids them from being learnt into
the FDB.

Fixes: d342894c5d2f ("vxlan: virtual extensible lan")
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David Bauer <mail@david-bauer.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 99ede13124194..ecdf0276004f9 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1615,6 +1615,10 @@ static bool vxlan_set_mac(struct vxlan_dev *vxlan,
 	if (ether_addr_equal(eth_hdr(skb)->h_source, vxlan->dev->dev_addr))
 		return false;
 
+	/* Ignore packets from invalid src-address */
+	if (!is_valid_ether_addr(eth_hdr(skb)->h_source))
+		return false;
+
 	/* Get address from the outer IP header */
 	if (vxlan_get_sk_family(vs) == AF_INET) {
 		saddr.sin.sin_addr.s_addr = ip_hdr(skb)->saddr;
-- 
2.43.0



