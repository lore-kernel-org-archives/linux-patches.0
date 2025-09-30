Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B54D1F152D;
	Tue, 30 Sep 2025 15:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244667; cv=none; b=I9cuA7Qf2guplrjL+OEmxQUE1GB4Gqqebfdr4eQsIW4WjAXey6HIrrCssMNGw23klRbSpxPA8fmMyhL411nyYPzUCdPaVQRlwB2jwtYfkU9ucsrCzsHGDcV3elTDQbis2ov/S1V459RQp//Uv7iFd6P4mFOjK/xVwYnyXMzNzMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244667; c=relaxed/simple;
	bh=ZWyy0SxSaOPgW0G9mK1qAFIDoyTXHwF7raUGF6K2Rl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FburXO8M8DU5t6SQu9UrRm2KL/DuAOrTbAYw2iUL5DE23LhQMppLtrPWRPDYgGumwUIRGyvByLfJ2xg9TMwurCtTC81biSRr5Nt9BC4T6JdJlWTLiU2oj9zHBNd0PZooq/6ufvn43m8iZKpdx09anROGO7L70mKczFUhc9li8R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OmyQ1OYK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OmyQ1OYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DF0C4CEF0;
	Tue, 30 Sep 2025 15:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244666;
	bh=ZWyy0SxSaOPgW0G9mK1qAFIDoyTXHwF7raUGF6K2Rl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OmyQ1OYKsVnOPMjB7RhG9E6SxrYjbuGKwaAK+XAbxcqZjCqxONtcWhlTVgrODbygv
	 kWovBKZnntwAY1ZHQmqBW+wr8/gNFO31Tz+ydRN57DTdmXLIn2CIDPc0u723q81eNg
	 ADRKc8mSSS6MAI2p6jLDhTSdHgK/AFJEZ1dcQmCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6596516dd2b635ba2350@syzkaller.appspotmail.com,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 077/143] nexthop: Forbid FDB status change while nexthop is in a group
Date: Tue, 30 Sep 2025 16:46:41 +0200
Message-ID: <20250930143834.309043923@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 390b3a300d7872cef9588f003b204398be69ce08 ]

The kernel forbids the creation of non-FDB nexthop groups with FDB
nexthops:

 # ip nexthop add id 1 via 192.0.2.1 fdb
 # ip nexthop add id 2 group 1
 Error: Non FDB nexthop group cannot have fdb nexthops.

And vice versa:

 # ip nexthop add id 3 via 192.0.2.2 dev dummy1
 # ip nexthop add id 4 group 3 fdb
 Error: FDB nexthop group can only have fdb nexthops.

However, as long as no routes are pointing to a non-FDB nexthop group,
the kernel allows changing the type of a nexthop from FDB to non-FDB and
vice versa:

 # ip nexthop add id 5 via 192.0.2.2 dev dummy1
 # ip nexthop add id 6 group 5
 # ip nexthop replace id 5 via 192.0.2.2 fdb
 # echo $?
 0

This configuration is invalid and can result in a NPD [1] since FDB
nexthops are not associated with a nexthop device:

 # ip route add 198.51.100.1/32 nhid 6
 # ping 198.51.100.1

Fix by preventing nexthop FDB status change while the nexthop is in a
group:

 # ip nexthop add id 7 via 192.0.2.2 dev dummy1
 # ip nexthop add id 8 group 7
 # ip nexthop replace id 7 via 192.0.2.2 fdb
 Error: Cannot change nexthop FDB status while in a group.

[1]
BUG: kernel NULL pointer dereference, address: 00000000000003c0
[...]
Oops: Oops: 0000 [#1] SMP
CPU: 6 UID: 0 PID: 367 Comm: ping Not tainted 6.17.0-rc6-virtme-gb65678cacc03 #1 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-4.fc41 04/01/2014
RIP: 0010:fib_lookup_good_nhc+0x1e/0x80
[...]
Call Trace:
 <TASK>
 fib_table_lookup+0x541/0x650
 ip_route_output_key_hash_rcu+0x2ea/0x970
 ip_route_output_key_hash+0x55/0x80
 __ip4_datagram_connect+0x250/0x330
 udp_connect+0x2b/0x60
 __sys_connect+0x9c/0xd0
 __x64_sys_connect+0x18/0x20
 do_syscall_64+0xa4/0x2a0
 entry_SYSCALL_64_after_hwframe+0x4b/0x53

Fixes: 38428d68719c ("nexthop: support for fdb ecmp nexthops")
Reported-by: syzbot+6596516dd2b635ba2350@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/68c9a4d2.050a0220.3c6139.0e63.GAE@google.com/
Tested-by: syzbot+6596516dd2b635ba2350@syzkaller.appspotmail.com
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250921150824.149157-2-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/nexthop.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 4397e89d3123a..423f876d14c6a 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -2400,6 +2400,13 @@ static int replace_nexthop_single(struct net *net, struct nexthop *old,
 		return -EINVAL;
 	}
 
+	if (!list_empty(&old->grp_list) &&
+	    rtnl_dereference(new->nh_info)->fdb_nh !=
+	    rtnl_dereference(old->nh_info)->fdb_nh) {
+		NL_SET_ERR_MSG(extack, "Cannot change nexthop FDB status while in a group");
+		return -EINVAL;
+	}
+
 	err = call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, new, extack);
 	if (err)
 		return err;
-- 
2.51.0



