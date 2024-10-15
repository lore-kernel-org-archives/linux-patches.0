Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC2A1EF92E;
	Tue, 15 Oct 2024 12:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994410; cv=none; b=icDbtcwX4X5THjMfrw2ots4zbz/J5zFJPT/C4aZl6ft8LUIgC3pQtRpc9mahKavFJo97lpDp9r4fyKNMwEga74j6u1WB7IwK5rzs5Grwk8pS3lDy2JehTUoNPpMTlBrydtb0E+uGAVp3TfJ7InDZmZ42Wn2sKPX1P/9DzJayTIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994410; c=relaxed/simple;
	bh=uhEVQ0Gca4Y7m13BdxXhe6R2hIxeDeOzPLQSyM27CaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3295qHrCo+TDKVsWsPKB3bTrs1aCLMpq7ptJHJ5VYln/H3OwffPkIxoDGxp3nrFF8/q8Zc33p/9czA7N0GrQ7NyRlrb8OK5ZIAUBe4siVwZCXYz0bnhnavZvXDLZr66tFBkPoMeibjQhhwSgrIKT1hiSMW/OzU15WNTXwfr6S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HfXqWhp/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HfXqWhp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC067C4CEC6;
	Tue, 15 Oct 2024 12:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994410;
	bh=uhEVQ0Gca4Y7m13BdxXhe6R2hIxeDeOzPLQSyM27CaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HfXqWhp/5LZV7Fd6cuqs1U3FnREw00LCntMLGUpI3UAOR9tNBwFQ3jE9Fa/GT/NKm
	 WfSipT9dMUfK81M9D9ibnWMWmWnIVPfhdHTC+10tL3JE1qyC/O5mjF8F18Q5naWCMv
	 gWU5WEKoyFdxQCnjQuvOT1VWYoqm6ia78f/ClGfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Makarov <am@3a-alliance.com>,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 685/691] net: seg6: fix seg6_lookup_any_nexthop() to handle VRFs using flowi_l3mdev
Date: Tue, 15 Oct 2024 13:30:33 +0200
Message-ID: <20241015112507.509049542@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Andrea Mayer <andrea.mayer@uniroma2.it>

commit a3bd2102e464202b58d57390a538d96f57ffc361 upstream.

Commit 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif
reset for port devices") adds a new entry (flowi_l3mdev) in the common
flow struct used for indicating the l3mdev index for later rule and
table matching.
The l3mdev_update_flow() has been adapted to properly set the
flowi_l3mdev based on the flowi_oif/flowi_iif. In fact, when a valid
flowi_iif is supplied to the l3mdev_update_flow(), this function can
update the flowi_l3mdev entry only if it has not yet been set (i.e., the
flowi_l3mdev entry is equal to 0).

The SRv6 End.DT6 behavior in VRF mode leverages a VRF device in order to
force the routing lookup into the associated routing table. This routing
operation is performed by seg6_lookup_any_nextop() preparing a flowi6
data structure used by ip6_route_input_lookup() which, in turn,
(indirectly) invokes l3mdev_update_flow().

However, seg6_lookup_any_nexthop() does not initialize the new
flowi_l3mdev entry which is filled with random garbage data. This
prevents l3mdev_update_flow() from properly updating the flowi_l3mdev
with the VRF index, and thus SRv6 End.DT6 (VRF mode)/DT46 behaviors are
broken.

This patch correctly initializes the flowi6 instance allocated and used
by seg6_lookup_any_nexhtop(). Specifically, the entire flowi6 instance
is wiped out: in case new entries are added to flowi/flowi6 (as happened
with the flowi_l3mdev entry), we should no longer have incorrectly
initialized values. As a result of this operation, the value of
flowi_l3mdev is also set to 0.

The proposed fix can be tested easily. Starting from the commit
referenced in the Fixes, selftests [1],[2] indicate that the SRv6
End.DT6 (VRF mode)/DT46 behaviors no longer work correctly. By applying
this patch, those behaviors are back to work properly again.

[1] - tools/testing/selftests/net/srv6_end_dt46_l3vpn_test.sh
[2] - tools/testing/selftests/net/srv6_end_dt6_l3vpn_test.sh

Fixes: 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif reset for port devices")
Reported-by: Anton Makarov <am@3a-alliance.com>
Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20220608091917.20345-1-andrea.mayer@uniroma2.it
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/seg6_local.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -217,6 +217,7 @@ seg6_lookup_any_nexthop(struct sk_buff *
 	struct flowi6 fl6;
 	int dev_flags = 0;
 
+	memset(&fl6, 0, sizeof(fl6));
 	fl6.flowi6_iif = skb->dev->ifindex;
 	fl6.daddr = nhaddr ? *nhaddr : hdr->daddr;
 	fl6.saddr = hdr->saddr;


