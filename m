Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E42FC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA815C433D2;
	Mon, 15 May 2023 17:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172531;
	bh=p0SIf7BBQR9DcN0yCrZ8bZntU5YaM3v/VwKjk2oRRhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L4CZhcQZoiJSDLWaGQaWMnghASKo4OXOBJqMKnRCD1R5y7lvDHM6JbQjPBQwGSUAX
	 etC7qyTGI1lUY/nYuYmnresNGreFjf39FopLDOcBO+pX3SZ5s6PUlwBdEepBLXfiv5
	 9OVVQwcgMjdsPOvE6HUZOhhb7YP6helPvTOjBUTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <jdamato@fastly.com>,
	Sridhar Samudrala <sridhar.samudrala@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 5.10 183/381] ixgbe: Enable setting RSS table to default values
Date: Mon, 15 May 2023 18:27:14 +0200
Message-Id: <20230515161745.088588570@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Joe Damato <jdamato@fastly.com>

[ Upstream commit e85d3d55875f7a1079edfbc4e4e98d6f8aea9ac7 ]

ethtool uses `ETHTOOL_GRXRINGS` to compute how many queues are supported
by RSS. The driver should return the smaller of either:
  - The maximum number of RSS queues the device supports, OR
  - The number of RX queues configured

Prior to this change, running `ethtool -X $iface default` fails if the
number of queues configured is larger than the number supported by RSS,
even though changing the queue count correctly resets the flowhash to
use all supported queues.

Other drivers (for example, i40e) will succeed but the flow hash will
reset to support the maximum number of queues supported by RSS, even if
that amount is smaller than the configured amount.

Prior to this change:

$ sudo ethtool -L eth1 combined 20
$ sudo ethtool -x eth1
RX flow hash indirection table for eth1 with 20 RX ring(s):
    0:      0     1     2     3     4     5     6     7
    8:      8     9    10    11    12    13    14    15
   16:      0     1     2     3     4     5     6     7
   24:      8     9    10    11    12    13    14    15
   32:      0     1     2     3     4     5     6     7
...

You can see that the flowhash was correctly set to use the maximum
number of queues supported by the driver (16).

However, asking the NIC to reset to "default" fails:

$ sudo ethtool -X eth1 default
Cannot set RX flow hash configuration: Invalid argument

After this change, the flowhash can be reset to default which will use
all of the available RSS queues (16) or the configured queue count,
whichever is smaller.

Starting with eth1 which has 10 queues and a flowhash distributing to
all 10 queues:

$ sudo ethtool -x eth1
RX flow hash indirection table for eth1 with 10 RX ring(s):
    0:      0     1     2     3     4     5     6     7
    8:      8     9     0     1     2     3     4     5
   16:      6     7     8     9     0     1     2     3
...

Increasing the queue count to 48 resets the flowhash to distribute to 16
queues, as it did before this patch:

$ sudo ethtool -L eth1 combined 48
$ sudo ethtool -x eth1
RX flow hash indirection table for eth1 with 16 RX ring(s):
    0:      0     1     2     3     4     5     6     7
    8:      8     9    10    11    12    13    14    15
   16:      0     1     2     3     4     5     6     7
...

Due to the other bugfix in this series, the flowhash can be set to use
queues 0-5:

$ sudo ethtool -X eth1 equal 5
$ sudo ethtool -x eth1
RX flow hash indirection table for eth1 with 16 RX ring(s):
    0:      0     1     2     3     4     0     1     2
    8:      3     4     0     1     2     3     4     0
   16:      1     2     3     4     0     1     2     3
...

Due to this bugfix, the flowhash can be reset to default and use 16
queues:

$ sudo ethtool -X eth1 default
$ sudo ethtool -x eth1
RX flow hash indirection table for eth1 with 16 RX ring(s):
    0:      0     1     2     3     4     5     6     7
    8:      8     9    10    11    12    13    14    15
   16:      0     1     2     3     4     5     6     7
...

Fixes: 91cd94bfe4f0 ("ixgbe: add basic support for setting and getting nfc controls")
Signed-off-by: Joe Damato <jdamato@fastly.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 472ea068ea7b0..2eb1331834731 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -2641,6 +2641,14 @@ static int ixgbe_get_rss_hash_opts(struct ixgbe_adapter *adapter,
 	return 0;
 }
 
+static int ixgbe_rss_indir_tbl_max(struct ixgbe_adapter *adapter)
+{
+	if (adapter->hw.mac.type < ixgbe_mac_X550)
+		return 16;
+	else
+		return 64;
+}
+
 static int ixgbe_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
 			   u32 *rule_locs)
 {
@@ -2649,7 +2657,8 @@ static int ixgbe_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
 
 	switch (cmd->cmd) {
 	case ETHTOOL_GRXRINGS:
-		cmd->data = adapter->num_rx_queues;
+		cmd->data = min_t(int, adapter->num_rx_queues,
+				  ixgbe_rss_indir_tbl_max(adapter));
 		ret = 0;
 		break;
 	case ETHTOOL_GRXCLSRLCNT:
@@ -3051,14 +3060,6 @@ static int ixgbe_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
 	return ret;
 }
 
-static int ixgbe_rss_indir_tbl_max(struct ixgbe_adapter *adapter)
-{
-	if (adapter->hw.mac.type < ixgbe_mac_X550)
-		return 16;
-	else
-		return 64;
-}
-
 static u32 ixgbe_get_rxfh_key_size(struct net_device *netdev)
 {
 	return IXGBE_RSS_KEY_SIZE;
-- 
2.39.2



