Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2519A39733E;
	Mon, 17 Aug 2026 14:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975486; cv=none; b=eN0wdJ7vRNtZRXHmx+MAPoJPH/kV/rmYxXZBL1Kc9ujHoTtz40DJRYuybt05pxce0Wm55NxCFWK0ESlIcA9mcZ42lNvjf6CwkzfsRFEkH+s2tthERBc+OAlXGFSTRVC+K0Y0KQbNx8I/1aZ66Q4agAIzAOIhs4UH9J2TIrYjBCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975486; c=relaxed/simple;
	bh=EQvhlg/4ypCDaD7Fn3mjRADqD97GebP1j5jB5y7QORs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nyeDC91XyWR7ECGcFly4AJNv473ixwYygElvNy2TBn/wU5lHz/KsqhVwsGXGj2UXkjHxf5KppuxntzASHZV2pZwopaLFkakmB2YFoUdReZbM3cTQQj90wzJr5VV3YnCkUNaBP09wzGUdTjK6sPUbaHmW2fIk1bBTC9PvVL3zlqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LfPrVFdr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LfPrVFdr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B4A1F000E9;
	Mon, 17 Aug 2026 14:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975485;
	bh=YBwL6ap/ZyGXRa4MZ5jh+ApBip0qH6fbtjlqwAxz0hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LfPrVFdr7lGff/fkcsPjiJJHBC5Jya4dTG94RILlyClu9yTtFniM5adQXDJbHIqfO
	 Sbi4SxxlHaC/lBZ4S155cyP4IWVqljCklpOnjBmp92YSn5NxCspsIwxBq7OJH9wy//
	 S5o4KcSnXKMQQiXp4XCNj1Q9d9Jb/H6tphjRhX/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/389] mpls: fix NULL deref in mpls_valid_fib_dump_req() on CONFIG_INET=n
Date: Mon, 17 Aug 2026 15:28:03 +0200
Message-ID: <20260817132540.724757286@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 56d96fededd61192cd7cc8d2b0f36adfd59036c3 ]

On CONFIG_INET=n builds, mpls_valid_fib_dump_req() walks the parsed
attribute table itself instead of calling ip_valid_fib_dump_req(). The
RTA_OIF arm passes tb[RTA_OIF] to nla_get_u32() without checking it is
present, so an RTM_GETROUTE dump for AF_MPLS with strict checking and no
RTA_OIF hits a NULL dereference.

RTM_GETROUTE is RTNL_KIND_GET, which rtnetlink_rcv_msg() permits without
CAP_NET_ADMIN, so an unprivileged user can trigger it.

  Oops: general protection fault, probably for non-canonical address
        0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  RIP: 0010:mpls_valid_fib_dump_req (net/mpls/af_mpls.c:2189)
  Call Trace:
   mpls_dump_routes (net/mpls/af_mpls.c:2236)
   netlink_dump (net/netlink/af_netlink.c:2331)
   __netlink_dump_start (net/netlink/af_netlink.c:2446)
   rtnetlink_rcv_msg (net/core/rtnetlink.c:7033)
   netlink_rcv_skb (net/netlink/af_netlink.c:2556)
   netlink_unicast (net/netlink/af_netlink.c:1345)
   netlink_sendmsg (net/netlink/af_netlink.c:1900)
   __sock_sendmsg (net/socket.c:790)
   ____sys_sendmsg (net/socket.c:2684)
   ___sys_sendmsg (net/socket.c:2738)
   __sys_sendmsg (net/socket.c:2770)
   do_syscall_64 (arch/x86/entry/syscall_64.c:94)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

Skip unset attributes, as ip_valid_fib_dump_req() does.

Fixes: 196cfebf8972 ("net/mpls: Handle kernel side filtering of route dumps")
Assisted-by: Claude:claude-opus-4-8
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20260711114958.1009619-3-bestswngs@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mpls/af_mpls.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index fa095bc8b0c1a6..66f498667ed892 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -2144,6 +2144,9 @@ static int mpls_valid_fib_dump_req(struct net *net, const struct nlmsghdr *nlh,
 		int ifindex;
 
 		if (i == RTA_OIF) {
+			if (!tb[i])
+				continue;
+
 			ifindex = nla_get_u32(tb[i]);
 			filter->dev = __dev_get_by_index(net, ifindex);
 			if (!filter->dev)
-- 
2.53.0



