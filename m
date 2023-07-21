Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0151F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3203FC433C8;
	Fri, 21 Jul 2023 16:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955987;
	bh=N7opixyqbVsy3FDh/oxoCuuVY/2WOjnKgbDVr222iQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Hlg8H4uN7T0QYzDOQmMFWmeQzNNCAbAzCIvLAoqXEaB5gBECX4N6FBLa5tl9O8Xe
	 pi02SOYCDO9wLShFvjBqtCx93hiirclim+W2PUK0/3B4QkWvPenAGfZVfoO/jYadXt
	 3yFlrFQ53slajQGB5tqNQnmrx+0fzBkCU1cuLTWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Kauer <florian.kauer@linutronix.de>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 077/292] igc: Fix inserting of empty frame for launchtime
Date: Fri, 21 Jul 2023 18:03:06 +0200
Message-ID: <20230721160532.114558644@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Kauer <florian.kauer@linutronix.de>

[ Upstream commit 0bcc62858d6ba62cbade957d69745e6adeed5f3d ]

The insertion of an empty frame was introduced with
commit db0b124f02ba ("igc: Enhance Qbv scheduling by using first flag bit")
in order to ensure that the current cycle has at least one packet if
there is some packet to be scheduled for the next cycle.

However, the current implementation does not properly check if
a packet is already scheduled for the current cycle. Currently,
an empty packet is always inserted if and only if
txtime >= end_of_cycle && txtime > last_tx_cycle
but since last_tx_cycle is always either the end of the current
cycle (end_of_cycle) or the end of a previous cycle, the
second part (txtime > last_tx_cycle) is always true unless
txtime == last_tx_cycle.

What actually needs to be checked here is if the last_tx_cycle
was already written within the current cycle, so an empty frame
should only be inserted if and only if
txtime >= end_of_cycle && end_of_cycle > last_tx_cycle.

This patch does not only avoid an unnecessary insertion, but it
can actually be harmful to insert an empty packet if packets
are already scheduled in the current cycle, because it can lead
to a situation where the empty packet is actually processed
as the first packet in the upcoming cycle shifting the packet
with the first_flag even one cycle into the future, finally leading
to a TX hang.

The TX hang can be reproduced on a i225 with:

    sudo tc qdisc replace dev enp1s0 parent root handle 100 taprio \
	    num_tc 1 \
	    map 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 \
	    queues 1@0 \
	    base-time 0 \
	    sched-entry S 01 300000 \
	    flags 0x1 \
	    txtime-delay 500000 \
	    clockid CLOCK_TAI
    sudo tc qdisc replace dev enp1s0 parent 100:1 etf \
	    clockid CLOCK_TAI \
	    delta 500000 \
	    offload \
	    skip_sock_check

and traffic generator

    sudo trafgen -i traffic.cfg -o enp1s0 --cpp -n0 -q -t1400ns

with traffic.cfg

    #define ETH_P_IP        0x0800

    {
      /* Ethernet Header */
      0x30, 0x1f, 0x9a, 0xd0, 0xf0, 0x0e,  # MAC Dest - adapt as needed
      0x24, 0x5e, 0xbe, 0x57, 0x2e, 0x36,  # MAC Src  - adapt as needed
      const16(ETH_P_IP),

      /* IPv4 Header */
      0b01000101, 0,   # IPv4 version, IHL, TOS
      const16(1028),   # IPv4 total length (UDP length + 20 bytes (IP header))
      const16(2),      # IPv4 ident
      0b01000000, 0,   # IPv4 flags, fragmentation off
      64,              # IPv4 TTL
      17,              # Protocol UDP
      csumip(14, 33),  # IPv4 checksum

      /* UDP Header */
      10,  0, 48, 1,   # IP Src - adapt as needed
      10,  0, 48, 10,  # IP Dest - adapt as needed
      const16(5555),   # UDP Src Port
      const16(6666),   # UDP Dest Port
      const16(1008),   # UDP length (UDP header 8 bytes + payload length)
      csumudp(14, 34), # UDP checksum

      /* Payload */
      fill('W', 1000),
    }

and the observed message with that is for example

 igc 0000:01:00.0 enp1s0: Detected Tx Unit Hang
   Tx Queue             <0>
   TDH                  <32>
   TDT                  <3c>
   next_to_use          <3c>
   next_to_clean        <32>
 buffer_info[next_to_clean]
   time_stamp           <ffff26a8>
   next_to_watch        <00000000632a1828>
   jiffies              <ffff27f8>
   desc.status          <1048000>

Fixes: db0b124f02ba ("igc: Enhance Qbv scheduling by using first flag bit")
Signed-off-by: Florian Kauer <florian.kauer@linutronix.de>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 96a2f6e6f6b8a..44aa4342cbbb5 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1029,7 +1029,7 @@ static __le32 igc_tx_launchtime(struct igc_ring *ring, ktime_t txtime,
 			*first_flag = true;
 			ring->last_ff_cycle = baset_est;
 
-			if (ktime_compare(txtime, ring->last_tx_cycle) > 0)
+			if (ktime_compare(end_of_cycle, ring->last_tx_cycle) > 0)
 				*insert_empty = true;
 		}
 	}
-- 
2.39.2



