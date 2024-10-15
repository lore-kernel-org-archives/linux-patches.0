Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2881B2184;
	Tue, 15 Oct 2024 13:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998562; cv=none; b=rjx6w7ZFQ47YlB1ogJkGjoGjPLwc57onHYCZTENLxORYrVBaPJFMWeFDQoMX//T5TNbtqTl+UaeuUo0jBcUWZ3+10dZlVofpf59JEhIgYGFBELH2WQa/SpZQuQpOzdYuP7m3qjKgjGtlsqELBZY/X34cKXl9HAohtGmtpMgCkqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998562; c=relaxed/simple;
	bh=VYvIX6HyzVuVYhee0aANETOocpjacypjMPT2ek1xBng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iuOQjXylEWxv9QXKbFbh+4ntBQyc9ove1ZXt9E/F0/QHGY5YXpVx1YUYL8TW53L7skJm8y9LjJfscKI+/QBMQKJK/xo1WSg3+wcf1U+5X/o5dDltMr7dS3slAfcG2rsx7v7/1lONTCwKUwllQa9/p3PVt4KuC4sHJRUVx7jgYeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uu75l9uK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uu75l9uK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F366C4CEC6;
	Tue, 15 Oct 2024 13:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998562;
	bh=VYvIX6HyzVuVYhee0aANETOocpjacypjMPT2ek1xBng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uu75l9uKxBwc8yQj2T8+yK0MSWENd6nmUL7RVjcSNrR8Daawfnp7tEHxlNeHq6Gdv
	 gs3lZAZC0ZlFO+gzypngnvt0d1gu/adWBuiTagTjKjTk0Hlt7mknteCfrks57az0Uk
	 f8jhWl443CKPzEyA6zoZ44KNkiyKAvUbpX1BQWU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Makarov <am@3a-alliance.com>,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 514/518] net: seg6: fix seg6_lookup_any_nexthop() to handle VRFs using flowi_l3mdev
Date: Tue, 15 Oct 2024 14:46:58 +0200
Message-ID: <20241015123936.828081231@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -163,6 +163,7 @@ seg6_lookup_any_nexthop(struct sk_buff *
 	struct flowi6 fl6;
 	int dev_flags = 0;
 
+	memset(&fl6, 0, sizeof(fl6));
 	fl6.flowi6_iif = skb->dev->ifindex;
 	fl6.daddr = nhaddr ? *nhaddr : hdr->daddr;
 	fl6.saddr = hdr->saddr;


