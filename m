Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134736FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F81C433C8;
	Sun, 17 Sep 2023 20:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981633;
	bh=W+no1Kn/rOq2myDNYLUrnOBz3xAB+subx0v1n7O0FEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dqejJUHS0QSTEOacmeqcRabxyZybFrYaMBX4689bh42U1c0JIGC58xgHx1aEIaIz/
	 JcqDEFv9Yirna193PVEex4YXsLGwAAekB0yjAvXDLgg8Pm9NDKo0ztjsj0GihKHo+i
	 Svj5SvYhsz1imivpv5zOv5XnbQJMgCRcB0EJwSkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 123/219] net: dsa: sja1105: complete tc-cbs offload support on SJA1110
Date: Sun, 17 Sep 2023 21:14:10 +0200
Message-ID: <20230917191045.422989628@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 180a7419fe4adc8d9c8e0ef0fd17bcdd0cf78acd ]

The blamed commit left this delta behind:

  struct sja1105_cbs_entry {
 -	u64 port;
 -	u64 prio;
 +	u64 port; /* Not used for SJA1110 */
 +	u64 prio; /* Not used for SJA1110 */
  	u64 credit_hi;
  	u64 credit_lo;
  	u64 send_slope;
  	u64 idle_slope;
  };

but did not actually implement tc-cbs offload fully for the new switch.
The offload is accepted, but it doesn't work.

The difference compared to earlier switch generations is that now, the
table of CBS shapers is sparse, because there are many more shapers, so
the mapping between a {port, prio} and a table index is static, rather
than requiring us to store the port and prio into the sja1105_cbs_entry.

So, the problem is that the code programs the CBS shaper parameters at a
dynamic table index which is incorrect.

All that needs to be done for SJA1110 CBS shapers to work is to bypass
the logic which allocates shapers in a dense manner, as for SJA1105, and
use the fixed mapping instead.

Fixes: 3e77e59bf8cf ("net: dsa: sja1105: add support for the SJA1110 switch family")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105.h      |  2 ++
 drivers/net/dsa/sja1105/sja1105_main.c | 13 +++++++++++++
 drivers/net/dsa/sja1105/sja1105_spi.c  |  4 ++++
 3 files changed, 19 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index fb3cd4c78faa8..a831bb0a52074 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -132,6 +132,8 @@ struct sja1105_info {
 	int max_frame_mem;
 	int num_ports;
 	bool multiple_cascade_ports;
+	/* Every {port, TXQ} has its own CBS shaper */
+	bool fixed_cbs_mapping;
 	enum dsa_tag_protocol tag_proto;
 	const struct sja1105_dynamic_table_ops *dyn_ops;
 	const struct sja1105_table_ops *static_ops;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 9dd5cdcda2843..ff94c5996fafb 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2122,12 +2122,22 @@ static void sja1105_bridge_leave(struct dsa_switch *ds, int port,
 }
 
 #define BYTES_PER_KBIT (1000LL / 8)
+/* Port 0 (the uC port) does not have CBS shapers */
+#define SJA1110_FIXED_CBS(port, prio) ((((port) - 1) * SJA1105_NUM_TC) + (prio))
 
 static int sja1105_find_cbs_shaper(struct sja1105_private *priv,
 				   int port, int prio)
 {
 	int i;
 
+	if (priv->info->fixed_cbs_mapping) {
+		i = SJA1110_FIXED_CBS(port, prio);
+		if (i >= 0 && i < priv->info->num_cbs_shapers)
+			return i;
+
+		return -1;
+	}
+
 	for (i = 0; i < priv->info->num_cbs_shapers; i++)
 		if (priv->cbs[i].port == port && priv->cbs[i].prio == prio)
 			return i;
@@ -2139,6 +2149,9 @@ static int sja1105_find_unused_cbs_shaper(struct sja1105_private *priv)
 {
 	int i;
 
+	if (priv->info->fixed_cbs_mapping)
+		return -1;
+
 	for (i = 0; i < priv->info->num_cbs_shapers; i++)
 		if (!priv->cbs[i].idle_slope && !priv->cbs[i].send_slope)
 			return i;
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index d3c9ad6d39d46..e6b61aef4127c 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -781,6 +781,7 @@ const struct sja1105_info sja1110a_info = {
 	.tag_proto		= DSA_TAG_PROTO_SJA1110,
 	.can_limit_mcast_flood	= true,
 	.multiple_cascade_ports	= true,
+	.fixed_cbs_mapping	= true,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.max_frame_mem		= SJA1110_MAX_FRAME_MEMORY,
@@ -831,6 +832,7 @@ const struct sja1105_info sja1110b_info = {
 	.tag_proto		= DSA_TAG_PROTO_SJA1110,
 	.can_limit_mcast_flood	= true,
 	.multiple_cascade_ports	= true,
+	.fixed_cbs_mapping	= true,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.max_frame_mem		= SJA1110_MAX_FRAME_MEMORY,
@@ -881,6 +883,7 @@ const struct sja1105_info sja1110c_info = {
 	.tag_proto		= DSA_TAG_PROTO_SJA1110,
 	.can_limit_mcast_flood	= true,
 	.multiple_cascade_ports	= true,
+	.fixed_cbs_mapping	= true,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.max_frame_mem		= SJA1110_MAX_FRAME_MEMORY,
@@ -931,6 +934,7 @@ const struct sja1105_info sja1110d_info = {
 	.tag_proto		= DSA_TAG_PROTO_SJA1110,
 	.can_limit_mcast_flood	= true,
 	.multiple_cascade_ports	= true,
+	.fixed_cbs_mapping	= true,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.max_frame_mem		= SJA1110_MAX_FRAME_MEMORY,
-- 
2.40.1



