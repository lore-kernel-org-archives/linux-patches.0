Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145CE4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:26:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D8A3C433EF;
	Wed, 15 Mar 2023 12:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883213;
	bh=6tUjH8bWN0jkW+H2oNmGniF5MDJP2jgc/3922VpjwpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pDnb6maL7jEXA0cn+X9zk71nuGd9abGCYXnTl6Rq64ie2e1abOTNdP7XD8gWehAzO
	 vdMnA1NXRkvGVyE1Nol8LLN25ZT5bf1GfcTbwtFpRDJ/rd8fWpw9q8mzVHbEkU5Cvf
	 cZpQr5k9gC/vm/D4zhjixOBAxnWrYK6qdBURfZZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 058/145] ice: copy last block omitted in ice_get_module_eeprom()
Date: Wed, 15 Mar 2023 13:12:04 +0100
Message-Id: <20230315115740.948873173@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Petr Oros <poros@redhat.com>

[ Upstream commit 84cba1840e68430325ac133a11be06bfb2f7acd8 ]

ice_get_module_eeprom() is broken since commit e9c9692c8a81 ("ice:
Reimplement module reads used by ethtool") In this refactor,
ice_get_module_eeprom() reads the eeprom in blocks of size 8.
But the condition that should protect the buffer overflow
ignores the last block. The last block always contains zeros.

Bug uncovered by ethtool upstream commit 9538f384b535
("netlink: eeprom: Defer page requests to individual parsers")
After this commit, ethtool reads a block with length = 1;
to read the SFF-8024 identifier value.

unpatched driver:
$ ethtool -m enp65s0f0np0 offset 0x90 length 8
Offset          Values
------          ------
0x0090:         00 00 00 00 00 00 00 00
$ ethtool -m enp65s0f0np0 offset 0x90 length 12
Offset          Values
------          ------
0x0090:         00 00 01 a0 4d 65 6c 6c 00 00 00 00
$

$ ethtool -m enp65s0f0np0
Offset          Values
------          ------
0x0000:         11 06 06 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0010:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0020:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0030:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0040:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0050:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0060:         00 00 00 00 00 00 00 00 00 00 00 00 00 01 08 00
0x0070:         00 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00

patched driver:
$ ethtool -m enp65s0f0np0 offset 0x90 length 8
Offset          Values
------          ------
0x0090:         00 00 01 a0 4d 65 6c 6c
$ ethtool -m enp65s0f0np0 offset 0x90 length 12
Offset          Values
------          ------
0x0090:         00 00 01 a0 4d 65 6c 6c 61 6e 6f 78
$ ethtool -m enp65s0f0np0
    Identifier                                : 0x11 (QSFP28)
    Extended identifier                       : 0x00
    Extended identifier description           : 1.5W max. Power consumption
    Extended identifier description           : No CDR in TX, No CDR in RX
    Extended identifier description           : High Power Class (> 3.5 W) not enabled
    Connector                                 : 0x23 (No separable connector)
    Transceiver codes                         : 0x88 0x00 0x00 0x00 0x00 0x00 0x00 0x00
    Transceiver type                          : 40G Ethernet: 40G Base-CR4
    Transceiver type                          : 25G Ethernet: 25G Base-CR CA-N
    Encoding                                  : 0x05 (64B/66B)
    BR, Nominal                               : 25500Mbps
    Rate identifier                           : 0x00
    Length (SMF,km)                           : 0km
    Length (OM3 50um)                         : 0m
    Length (OM2 50um)                         : 0m
    Length (OM1 62.5um)                       : 0m
    Length (Copper or Active cable)           : 1m
    Transmitter technology                    : 0xa0 (Copper cable unequalized)
    Attenuation at 2.5GHz                     : 4db
    Attenuation at 5.0GHz                     : 5db
    Attenuation at 7.0GHz                     : 7db
    Attenuation at 12.9GHz                    : 10db
    ........
    ....

Fixes: e9c9692c8a81 ("ice: Reimplement module reads used by ethtool")
Signed-off-by: Petr Oros <poros@redhat.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 24001035910e0..60f73e775beeb 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3998,6 +3998,8 @@ ice_get_module_eeprom(struct net_device *netdev,
 		 * SFP modules only ever use page 0.
 		 */
 		if (page == 0 || !(data[0x2] & 0x4)) {
+			u32 copy_len;
+
 			/* If i2c bus is busy due to slow page change or
 			 * link management access, call can fail. This is normal.
 			 * So we retry this a few times.
@@ -4021,8 +4023,8 @@ ice_get_module_eeprom(struct net_device *netdev,
 			}
 
 			/* Make sure we have enough room for the new block */
-			if ((i + SFF_READ_BLOCK_SIZE) < ee->len)
-				memcpy(data + i, value, SFF_READ_BLOCK_SIZE);
+			copy_len = min_t(u32, SFF_READ_BLOCK_SIZE, ee->len - i);
+			memcpy(data + i, value, copy_len);
 		}
 	}
 	return 0;
-- 
2.39.2



