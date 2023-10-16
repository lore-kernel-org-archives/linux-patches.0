Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AC81A29F
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uoaecZAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E015C433C8;
	Mon, 16 Oct 2023 08:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446771;
	bh=pi/kT2+V3TZuZ1rqlA4qI+Q0FwaVgsNfl/2Pfpdm3Ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uoaecZAzoxdwjYpgKzk9bu66AVl81T6weoywctKmayXWgZn7bMCmkehjllnzqL08B
	 KsCovkijaMxacOWVRJlrMzMX2/CU18oahoAxbfHmspaLtquTEBWEEOJuqP/fqOIqre
	 xTZyAkE6k97BJao7Wd7ww9F+lmjCHZubdX2TVPOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Christian Marangi <ansuelsmth@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/131] net: dsa: qca8k: fix potential MDIO bus conflict when accessing internal PHYs via management frames
Date: Mon, 16 Oct 2023 10:40:25 +0200
Message-ID: <20231016084001.117589479@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 526c8ee04bdbd4d8d19a583b1f3b06700229a815 ]

Besides the QCA8337 switch the Turris 1.x device has on it's MDIO bus
also Micron ethernet PHY (dedicated to the WAN port).

We've been experiencing a strange behavior of the WAN ethernet
interface, wherein the WAN PHY started timing out the MDIO accesses, for
example when the interface was brought down and then back up.

Bisecting led to commit 2cd548566384 ("net: dsa: qca8k: add support for
phy read/write with mgmt Ethernet"), which added support to access the
QCA8337 switch's internal PHYs via management ethernet frames.

Connecting the MDIO bus pins onto an oscilloscope, I was able to see
that the MDIO bus was active whenever a request to read/write an
internal PHY register was done via an management ethernet frame.

My theory is that when the switch core always communicates with the
internal PHYs via the MDIO bus, even when externally we request the
access via ethernet. This MDIO bus is the same one via which the switch
and internal PHYs are accessible to the board, and the board may have
other devices connected on this bus. An ASCII illustration may give more
insight:

           +---------+
      +----|         |
      |    | WAN PHY |
      | +--|         |
      | |  +---------+
      | |
      | |  +----------------------------------+
      | |  | QCA8337                          |
MDC   | |  |                        +-------+ |
------o-+--|--------o------------o--|       | |
MDIO    |  |        |            |  | PHY 1 |-|--to RJ45
--------o--|---o----+---------o--+--|       | |
           |   |    |         |  |  +-------+ |
	   | +-------------+  |  o--|       | |
	   | | MDIO MDC    |  |  |  | PHY 2 |-|--to RJ45
eth1	   | |             |  o--+--|       | |
-----------|-|port0        |  |  |  +-------+ |
           | |             |  |  o--|       | |
	   | | switch core |  |  |  | PHY 3 |-|--to RJ45
           | +-------------+  o--+--|       | |
	   |                  |  |  +-------+ |
	   |                  |  o--|  ...  | |
	   +----------------------------------+

When we send a request to read an internal PHY register via an ethernet
management frame via eth1, the switch core receives the ethernet frame
on port 0 and then communicates with the internal PHY via MDIO. At this
time, other potential devices, such as the WAN PHY on Turris 1.x, cannot
use the MDIO bus, since it may cause a bus conflict.

Fix this issue by locking the MDIO bus even when we are accessing the
PHY registers via ethernet management frames.

Fixes: 2cd548566384 ("net: dsa: qca8k: add support for phy read/write with mgmt Ethernet")
Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index b3f7988668996..1e94ba1031ece 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -544,6 +544,15 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 		goto err_read_skb;
 	}
 
+	/* It seems that accessing the switch's internal PHYs via management
+	 * packets still uses the MDIO bus within the switch internally, and
+	 * these accesses can conflict with external MDIO accesses to other
+	 * devices on the MDIO bus.
+	 * We therefore need to lock the MDIO bus onto which the switch is
+	 * connected.
+	 */
+	mutex_lock(&priv->bus->mdio_lock);
+
 	/* Actually start the request:
 	 * 1. Send mdio master packet
 	 * 2. Busy Wait for mdio master command
@@ -556,6 +565,7 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	mgmt_master = priv->mgmt_master;
 	if (!mgmt_master) {
 		mutex_unlock(&mgmt_eth_data->mutex);
+		mutex_unlock(&priv->bus->mdio_lock);
 		ret = -EINVAL;
 		goto err_mgmt_master;
 	}
@@ -643,6 +653,7 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 				    QCA8K_ETHERNET_TIMEOUT);
 
 	mutex_unlock(&mgmt_eth_data->mutex);
+	mutex_unlock(&priv->bus->mdio_lock);
 
 	return ret;
 
-- 
2.40.1



