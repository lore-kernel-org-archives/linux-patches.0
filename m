Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B1C384;
	Thu, 13 Jun 2024 12:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282849; cv=none; b=a2YvUo5e+BKPT24ELJclPjbOr1iDj8mPQ295wDfnuHO8EmUlXYq6f0H297281jWpecmHVkCnaniUT77hcRAB1rfJ5t39tfKP6gXoyWcAvAAuqePgPOBWaeiqGFk/1hkXA8gjS2HjVRQtUGjy1zdtkeLQvQcJLQkJbiGZM7ESsAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282849; c=relaxed/simple;
	bh=i8+OKxgzSor74MFINiJQFDHRfmDhBI3RQP1TwXOAiFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWhAoIJslkzfiaC8t0QNe9kwaLSS0UuPjgjv2wKG4gNeXxkaSiPlTu2V2cJQ+moOq53F1fKc0vgIOvzFufozkX+zL7+fncke0Pwzo+7ixDHxIvRR9O0LDBlmYzks+Ez5CyyrcmHuSSwQ13Y3iVub9qVy55AnTBEld3YglINtkz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZjp4poG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZjp4poG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95362C2BBFC;
	Thu, 13 Jun 2024 12:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282849;
	bh=i8+OKxgzSor74MFINiJQFDHRfmDhBI3RQP1TwXOAiFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZjp4poGpbI54D9b5nMVD+I5GlV6xjlxpH0AG3PLLPOBRvXG2TDBKLcXi5iYNC7oA
	 USWzW6xcjly7RZlkVDXq2KXK7ULO6gHvZ5uUPgMh8wSLhJoPXPIejY2BnB4wNsYijP
	 Lo4l8BRYftLOXtVKF6RtqcTYSnw4jHhtGU85dn0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	David Bauer <mail@david-bauer.net>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 14/85] vxlan: Fix regression when dropping packets due to invalid src addresses
Date: Thu, 13 Jun 2024 13:35:12 +0200
Message-ID: <20240613113214.694732528@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

commit 1cd4bc987abb2823836cbb8f887026011ccddc8a upstream.

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
[ Backport note: vxlan snooping/learning not supported in 6.8 or older,
  so commit is simply a revert. ]
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan/vxlan_core.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1662,10 +1662,6 @@ static bool vxlan_set_mac(struct vxlan_d
 	if (ether_addr_equal(eth_hdr(skb)->h_source, vxlan->dev->dev_addr))
 		return false;
 
-	/* Ignore packets from invalid src-address */
-	if (!is_valid_ether_addr(eth_hdr(skb)->h_source))
-		return false;
-
 	/* Get address from the outer IP header */
 	if (vxlan_get_sk_family(vs) == AF_INET) {
 		saddr.sin.sin_addr.s_addr = ip_hdr(skb)->saddr;


