Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D98293C59;
	Wed, 30 Jul 2025 09:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868243; cv=none; b=A9Voa+e8cduojyhMwzCuzZyP6QRYo2+KG9OIVFtgbeRQrtEeYP2p7RolqHzHheo12gYUdDA84F/1dfLjeba0VOhcsbkQTZUUj4UllzMKbO7UjIMnKUOxjtOFNUjZItGnJ9K4Ou7KtsgmfT1PGxV+q88jigh8rV5kC8FTNl9chUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868243; c=relaxed/simple;
	bh=ojM0OT5NZJEcroSLbQCfudooPY38PLC6R3HrXY8YlLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6H1dKHJ5SuOXsCZILz2MduGb6QPFRvfgxfMPIlcQoRQgEmAnEyR+jTej6irFPajlP3gG9ybW5sK6muCA5CTXIS3cZdLgJOOCdzLKeLmUlQZuCM1Y+FgxWrkJktrVgPU7s725DI9+1SKH2wHJpBSZnPMTdHBHT6hbN76VLIjvMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5movj/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5movj/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA04CC4CEE7;
	Wed, 30 Jul 2025 09:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868242;
	bh=ojM0OT5NZJEcroSLbQCfudooPY38PLC6R3HrXY8YlLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5movj/bKAapW7q0A0bd6a1aG6kwc6DO6uzaZFrORg01e2zr2m7YPY+9l8a8zAMGn
	 RnjCG7TPDk0nBPR3tSn0eKJgbjuPdaWyd91pQyaTvBJ9kQdnpa7u2dkXRQdCe2sO7U
	 0AfwkUpS1wJZ28zy3bwXv+SU1/HvYta3cTQs+Iyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Chen <dechen@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 15/76] i40e: report VF tx_dropped with tx_errors instead of tx_discards
Date: Wed, 30 Jul 2025 11:35:08 +0200
Message-ID: <20250730093227.443694989@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dennis Chen <dechen@redhat.com>

[ Upstream commit 50b2af451597ca6eefe9d4543f8bbf8de8aa00e7 ]

Currently the tx_dropped field in VF stats is not updated correctly
when reading stats from the PF. This is because it reads from
i40e_eth_stats.tx_discards which seems to be unused for per VSI stats,
as it is not updated by i40e_update_eth_stats() and the corresponding
register, GLV_TDPC, is not implemented[1].

Use i40e_eth_stats.tx_errors instead, which is actually updated by
i40e_update_eth_stats() by reading from GLV_TEPC.

To test, create a VF and try to send bad packets through it:

$ echo 1 > /sys/class/net/enp2s0f0/device/sriov_numvfs
$ cat test.py
from scapy.all import *

vlan_pkt = Ether(dst="ff:ff:ff:ff:ff:ff") / Dot1Q(vlan=999) / IP(dst="192.168.0.1") / ICMP()
ttl_pkt = IP(dst="8.8.8.8", ttl=0) / ICMP()

print("Send packet with bad VLAN tag")
sendp(vlan_pkt, iface="enp2s0f0v0")
print("Send packet with TTL=0")
sendp(ttl_pkt, iface="enp2s0f0v0")
$ ip -s link show dev enp2s0f0
16: enp2s0f0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 3c:ec:ef:b7:e0:ac brd ff:ff:ff:ff:ff:ff
    RX:  bytes packets errors dropped  missed   mcast
             0       0      0       0       0       0
    TX:  bytes packets errors dropped carrier collsns
             0       0      0       0       0       0
    vf 0     link/ether e2:c6:fd:c1:1e:92 brd ff:ff:ff:ff:ff:ff, spoof checking on, link-state auto, trust off
    RX: bytes  packets  mcast   bcast   dropped
             0        0       0       0        0
    TX: bytes  packets   dropped
             0        0        0
$ python test.py
Send packet with bad VLAN tag
.
Sent 1 packets.
Send packet with TTL=0
.
Sent 1 packets.
$ ip -s link show dev enp2s0f0
16: enp2s0f0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 3c:ec:ef:b7:e0:ac brd ff:ff:ff:ff:ff:ff
    RX:  bytes packets errors dropped  missed   mcast
             0       0      0       0       0       0
    TX:  bytes packets errors dropped carrier collsns
             0       0      0       0       0       0
    vf 0     link/ether e2:c6:fd:c1:1e:92 brd ff:ff:ff:ff:ff:ff, spoof checking on, link-state auto, trust off
    RX: bytes  packets  mcast   bcast   dropped
             0        0       0       0        0
    TX: bytes  packets   dropped
             0        0        0

A packet with non-existent VLAN tag and a packet with TTL = 0 are sent,
but tx_dropped is not incremented.

After patch:

$ ip -s link show dev enp2s0f0
19: enp2s0f0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 3c:ec:ef:b7:e0:ac brd ff:ff:ff:ff:ff:ff
    RX:  bytes packets errors dropped  missed   mcast
             0       0      0       0       0       0
    TX:  bytes packets errors dropped carrier collsns
             0       0      0       0       0       0
    vf 0     link/ether 4a:b7:3d:37:f7:56 brd ff:ff:ff:ff:ff:ff, spoof checking on, link-state auto, trust off
    RX: bytes  packets  mcast   bcast   dropped
             0        0       0       0        0
    TX: bytes  packets   dropped
             0        0        2

Fixes: dc645daef9af5bcbd9c ("i40e: implement VF stats NDO")
Signed-off-by: Dennis Chen <dechen@redhat.com>
Link: https://www.intel.com/content/www/us/en/content-details/596333/intel-ethernet-controller-x710-tm4-at2-carlsville-datasheet.html
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 18720e9c24f73..b233ae45d89c2 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -5011,7 +5011,7 @@ int i40e_get_vf_stats(struct net_device *netdev, int vf_id,
 	vf_stats->broadcast  = stats->rx_broadcast;
 	vf_stats->multicast  = stats->rx_multicast;
 	vf_stats->rx_dropped = stats->rx_discards + stats->rx_discards_other;
-	vf_stats->tx_dropped = stats->tx_discards;
+	vf_stats->tx_dropped = stats->tx_errors;
 
 	return 0;
 }
-- 
2.39.5



