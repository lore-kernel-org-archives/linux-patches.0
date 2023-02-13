Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9884B8F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E39C433EF;
	Mon, 13 Feb 2023 14:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300088;
	bh=w6C0jnu8POwOL7zyGT45D1QOUyS1SmMVfAIYq7oxF68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSXiEAuVOztahORg8O4jV2Up4HV6VliZziF1+rIaDuoePEO3AmIXo2BlnVhRxP+80
	 TAcXQwUNqTw/qBYhXzNZ6Li21rf+BakY2RL/OTuJYUoznePHRUk2VvrXLNy111JgBf
	 PyHb88OV8EOXg/Unz1Vfs3oBCo3OXd1G2r3u1wM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Simon Horman <simon.horman@corigine.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/114] net: mscc: ocelot: fix all IPv6 getting trapped to CPU when PTP timestamping is used
Date: Mon, 13 Feb 2023 15:48:14 +0100
Message-Id: <20230213144745.277679385@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 2fcde9fe258ec8b88d41def38e43ca4da32c0a9a ]

While running this selftest which usually passes:

~/selftests/drivers/net/dsa# ./local_termination.sh eno0 swp0
TEST: swp0: Unicast IPv4 to primary MAC address                     [ OK ]
TEST: swp0: Unicast IPv4 to macvlan MAC address                     [ OK ]
TEST: swp0: Unicast IPv4 to unknown MAC address                     [ OK ]
TEST: swp0: Unicast IPv4 to unknown MAC address, promisc            [ OK ]
TEST: swp0: Unicast IPv4 to unknown MAC address, allmulti           [ OK ]
TEST: swp0: Multicast IPv4 to joined group                          [ OK ]
TEST: swp0: Multicast IPv4 to unknown group                         [ OK ]
TEST: swp0: Multicast IPv4 to unknown group, promisc                [ OK ]
TEST: swp0: Multicast IPv4 to unknown group, allmulti               [ OK ]
TEST: swp0: Multicast IPv6 to joined group                          [ OK ]
TEST: swp0: Multicast IPv6 to unknown group                         [ OK ]
TEST: swp0: Multicast IPv6 to unknown group, promisc                [ OK ]
TEST: swp0: Multicast IPv6 to unknown group, allmulti               [ OK ]

if I start PTP timestamping then run it again (debug prints added by me),
the unknown IPv6 MC traffic is seen by the CPU port even when it should
have been dropped:

~/selftests/drivers/net/dsa# ptp4l -i swp0 -2 -P -m
ptp4l[225.410]: selected /dev/ptp1 as PTP clock
[  225.445746] mscc_felix 0000:00:00.5: ocelot_l2_ptp_trap_add: port 0 adding L2 PTP trap
[  225.453815] mscc_felix 0000:00:00.5: ocelot_ipv4_ptp_trap_add: port 0 adding IPv4 PTP event trap
[  225.462703] mscc_felix 0000:00:00.5: ocelot_ipv4_ptp_trap_add: port 0 adding IPv4 PTP general trap
[  225.471768] mscc_felix 0000:00:00.5: ocelot_ipv6_ptp_trap_add: port 0 adding IPv6 PTP event trap
[  225.480651] mscc_felix 0000:00:00.5: ocelot_ipv6_ptp_trap_add: port 0 adding IPv6 PTP general trap
ptp4l[225.488]: port 1: INITIALIZING to LISTENING on INIT_COMPLETE
ptp4l[225.488]: port 0: INITIALIZING to LISTENING on INIT_COMPLETE
^C
~/selftests/drivers/net/dsa# ./local_termination.sh eno0 swp0
TEST: swp0: Unicast IPv4 to primary MAC address                     [ OK ]
TEST: swp0: Unicast IPv4 to macvlan MAC address                     [ OK ]
TEST: swp0: Unicast IPv4 to unknown MAC address                     [ OK ]
TEST: swp0: Unicast IPv4 to unknown MAC address, promisc            [ OK ]
TEST: swp0: Unicast IPv4 to unknown MAC address, allmulti           [ OK ]
TEST: swp0: Multicast IPv4 to joined group                          [ OK ]
TEST: swp0: Multicast IPv4 to unknown group                         [ OK ]
TEST: swp0: Multicast IPv4 to unknown group, promisc                [ OK ]
TEST: swp0: Multicast IPv4 to unknown group, allmulti               [ OK ]
TEST: swp0: Multicast IPv6 to joined group                          [ OK ]
TEST: swp0: Multicast IPv6 to unknown group                         [FAIL]
        reception succeeded, but should have failed
TEST: swp0: Multicast IPv6 to unknown group, promisc                [ OK ]
TEST: swp0: Multicast IPv6 to unknown group, allmulti               [ OK ]

The PGID_MCIPV6 is configured correctly to not flood to the CPU,
I checked that.

Furthermore, when I disable back PTP RX timestamping (ptp4l doesn't do
that when it exists), packets are RX filtered again as they should be:

~/selftests/drivers/net/dsa# hwstamp_ctl -i swp0 -r 0
[  218.202854] mscc_felix 0000:00:00.5: ocelot_l2_ptp_trap_del: port 0 removing L2 PTP trap
[  218.212656] mscc_felix 0000:00:00.5: ocelot_ipv4_ptp_trap_del: port 0 removing IPv4 PTP event trap
[  218.222975] mscc_felix 0000:00:00.5: ocelot_ipv4_ptp_trap_del: port 0 removing IPv4 PTP general trap
[  218.233133] mscc_felix 0000:00:00.5: ocelot_ipv6_ptp_trap_del: port 0 removing IPv6 PTP event trap
[  218.242251] mscc_felix 0000:00:00.5: ocelot_ipv6_ptp_trap_del: port 0 removing IPv6 PTP general trap
current settings:
tx_type 1
rx_filter 12
new settings:
tx_type 1
rx_filter 0
~/selftests/drivers/net/dsa# ./local_termination.sh eno0 swp0
TEST: swp0: Unicast IPv4 to primary MAC address                     [ OK ]
TEST: swp0: Unicast IPv4 to macvlan MAC address                     [ OK ]
TEST: swp0: Unicast IPv4 to unknown MAC address                     [ OK ]
TEST: swp0: Unicast IPv4 to unknown MAC address, promisc            [ OK ]
TEST: swp0: Unicast IPv4 to unknown MAC address, allmulti           [ OK ]
TEST: swp0: Multicast IPv4 to joined group                          [ OK ]
TEST: swp0: Multicast IPv4 to unknown group                         [ OK ]
TEST: swp0: Multicast IPv4 to unknown group, promisc                [ OK ]
TEST: swp0: Multicast IPv4 to unknown group, allmulti               [ OK ]
TEST: swp0: Multicast IPv6 to joined group                          [ OK ]
TEST: swp0: Multicast IPv6 to unknown group                         [ OK ]
TEST: swp0: Multicast IPv6 to unknown group, promisc                [ OK ]
TEST: swp0: Multicast IPv6 to unknown group, allmulti               [ OK ]

So it's clear that something in the PTP RX trapping logic went wrong.

Looking a bit at the code, I can see that there are 4 typos, which
populate "ipv4" VCAP IS2 key filter fields for IPv6 keys.

VCAP IS2 keys of type OCELOT_VCAP_KEY_IPV4 and OCELOT_VCAP_KEY_IPV6 are
handled by is2_entry_set(). OCELOT_VCAP_KEY_IPV4 looks at
&filter->key.ipv4, and OCELOT_VCAP_KEY_IPV6 at &filter->key.ipv6.
Simply put, when we populate the wrong key field, &filter->key.ipv6
fields "proto.mask" and "proto.value" remain all zeroes (or "don't care").
So is2_entry_set() will enter the "else" of this "if" condition:

	if (msk == 0xff && (val == IPPROTO_TCP || val == IPPROTO_UDP))

and proceed to ignore the "proto" field. The resulting rule will match
on all IPv6 traffic, trapping it to the CPU.

This is the reason why the local_termination.sh selftest sees it,
because control traps are stronger than the PGID_MCIPV6 used for
flooding (from the forwarding data path).

But the problem is in fact much deeper. We trap all IPv6 traffic to the
CPU, but if we're bridged, we set skb->offload_fwd_mark = 1, so software
forwarding will not take place and IPv6 traffic will never reach its
destination.

The fix is simple - correct the typos.

I was intentionally inaccurate in the commit message about the breakage
occurring when any PTP timestamping is enabled. In fact it only happens
when L4 timestamping is requested (HWTSTAMP_FILTER_PTP_V2_EVENT or
HWTSTAMP_FILTER_PTP_V2_L4_EVENT). But ptp4l requests a larger RX
timestamping filter than it needs for "-2": HWTSTAMP_FILTER_PTP_V2_EVENT.
I wanted people skimming through git logs to not think that the bug
doesn't affect them because they only use ptp4l in L2 mode.

Fixes: 96ca08c05838 ("net: mscc: ocelot: set up traps for PTP packets")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230207183117.1745754-1-vladimir.oltean@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_ptp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ptp.c b/drivers/net/ethernet/mscc/ocelot_ptp.c
index 1a82f10c88539..2180ae94c7447 100644
--- a/drivers/net/ethernet/mscc/ocelot_ptp.c
+++ b/drivers/net/ethernet/mscc/ocelot_ptp.c
@@ -335,8 +335,8 @@ static void
 ocelot_populate_ipv6_ptp_event_trap_key(struct ocelot_vcap_filter *trap)
 {
 	trap->key_type = OCELOT_VCAP_KEY_IPV6;
-	trap->key.ipv4.proto.value[0] = IPPROTO_UDP;
-	trap->key.ipv4.proto.mask[0] = 0xff;
+	trap->key.ipv6.proto.value[0] = IPPROTO_UDP;
+	trap->key.ipv6.proto.mask[0] = 0xff;
 	trap->key.ipv6.dport.value = PTP_EV_PORT;
 	trap->key.ipv6.dport.mask = 0xffff;
 }
@@ -355,8 +355,8 @@ static void
 ocelot_populate_ipv6_ptp_general_trap_key(struct ocelot_vcap_filter *trap)
 {
 	trap->key_type = OCELOT_VCAP_KEY_IPV6;
-	trap->key.ipv4.proto.value[0] = IPPROTO_UDP;
-	trap->key.ipv4.proto.mask[0] = 0xff;
+	trap->key.ipv6.proto.value[0] = IPPROTO_UDP;
+	trap->key.ipv6.proto.mask[0] = 0xff;
 	trap->key.ipv6.dport.value = PTP_GEN_PORT;
 	trap->key.ipv6.dport.mask = 0xffff;
 }
-- 
2.39.0



