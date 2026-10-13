Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB07B41D11F;
	Tue, 13 Oct 2026 12:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894554; cv=none; b=gp6Ki6LiZmhmdg0aCqgLn6FhEDJqKyvWWmPgUetCL161uPgSE5CWZERecJS8HGR4Woh9XGC+/bwre/vnkcm9SPODDyZfxa7vT/BVHaJB+NXCllkXzwSXoIBD2MTX4EUOQc+Yiy8v2LmEjAbS91CfLlyuE0qIi2z91OEC7jiUSP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894554; c=relaxed/simple;
	bh=NhcttXfv2xov4zxvZQLGHFW7yH2g9x+NCQQERBBIN1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0hEcZB8mFWbqS4cikcX+rgcQw1NaCOYd7UKFmiSc0qa6DG1WgE1bO+2eFI3ZK7O6z6XW4ZCtvZE0DEg0MJnhR/n/DFDkM2RY9u7dCAaeaOZQRKT+EjEw8MLMfESlWbnyRiv1DChLNXyWSgMfRCp7XEUZkYK+w8Qh4XPB4Le5S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+ZMEbTk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+ZMEbTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063891F000FF;
	Tue, 13 Oct 2026 12:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894552;
	bh=t5ynaHY3pwzNqVr7lcNk1sDuswchZWWWJxrNhPQqTko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0+ZMEbTkXHnO5juYLYW42VXUe9RhFLdbdaA00ywEq2icPb2pVn7Yp+H3P5mMMilDf
	 1b0+r+FsWIeTa1Cu3J5joMcfeohUBFeWrPDJ15pmX3iJocvqgC1dEf/AYAToNWFB75
	 pMBQ3RyxmLVl35t1Wt9tvGt6L7ZMoZhGQsiycBB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4cc63fcfb3845e149969@syzkaller.appspotmail.com,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 599/621] net: openvswitch: validate transport header presence in set_ipv6_addr
Date: Tue, 13 Oct 2026 13:39:54 +0200
Message-ID: <20261013112935.016806848@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 3c6a4b11330fe424557538a98fca9f0a4c5bf313 ]

When executing IPv6 address rewrite actions on IPv6 fragments,
set_ipv6_addr() calls update_ipv6_checksum(). If parse_ipv6hdr()
processes a non-first IPv6 fragment, it sets key->ip.proto to
NEXTHDR_FRAGMENT and returns early without calling
skb_set_transport_header().

update_ipv6_checksum() unconditionally evaluates skb_transport_offset()
on entry before checking l4_proto.  Because skb->transport_header is
uninitialized, this triggers a warning under CONFIG_DEBUG_NET=y although
it is completely harmless.

Fix this by returning early in update_ipv6_checksum() if l4_proto is
NEXTHDR_FRAGMENT. This avoids reading the uninitialized transport offset
for fragments while preserving the debug warning for any other protocol
where the transport header is unexpectedly missing.

See the syzbot trace:

!skb_transport_header_was_set(skb)
WARNING: ./include/linux/skbuff.h:3075 at skb_transport_header include/linux/skbuff.h:3075 [inline], CPU#1: syz-executor463/5635
WARNING: ./include/linux/skbuff.h:3075 at skb_transport_offset include/linux/skbuff.h:3250 [inline], CPU#1: syz-executor463/5635
WARNING: ./include/linux/skbuff.h:3075 at update_ipv6_checksum net/openvswitch/actions.c:361 [inline], CPU#1: syz-executor463/5635
WARNING: ./include/linux/skbuff.h:3075 at set_ipv6_addr+0x462/0x660 net/openvswitch/actions.c:399, CPU#1: syz-executor463/5635
[...]
RIP: 0010:skb_transport_header include/linux/skbuff.h:3075 [inline]
RIP: 0010:skb_transport_offset include/linux/skbuff.h:3250 [inline]
RIP: 0010:update_ipv6_checksum net/openvswitch/actions.c:361 [inline]
RIP: 0010:set_ipv6_addr+0x462/0x660 net/openvswitch/actions.c:399
[...]
Call Trace:
 <TASK>
 set_ipv6 net/openvswitch/actions.c:531 [inline]
 do_execute_actions+0x557e/0x8600 net/openvswitch/actions.c:1366
 ovs_execute_actions+0xde/0x520 net/openvswitch/actions.c:1592
 ovs_packet_cmd_execute+0xb4f/0xf10 net/openvswitch/datapath.c:705
 genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
 genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2572
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
 netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1361
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec+0x14e/0x190 net/socket.c:800

Reported-by: syzbot+4cc63fcfb3845e149969@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4cc63fcfb3845e149969
Fixes: 3fdbd1ce11e5 ("openvswitch: add ipv6 'set' action")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://patch.msgid.link/20261008104135.4722-1-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/actions.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 5d6a4c6b7ea6f..9d9697cf63298 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -357,7 +357,12 @@ static void set_ip_addr(struct sk_buff *skb, struct iphdr *nh,
 static void update_ipv6_checksum(struct sk_buff *skb, u8 l4_proto,
 				 __be32 addr[4], const __be32 new_addr[4])
 {
-	int transport_len = skb->len - skb_transport_offset(skb);
+	int transport_len;
+
+	if (l4_proto == NEXTHDR_FRAGMENT)
+		return;
+
+	transport_len = skb->len - skb_transport_offset(skb);
 
 	if (l4_proto == NEXTHDR_TCP) {
 		if (likely(transport_len >= sizeof(struct tcphdr)))
-- 
2.53.0



