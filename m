Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8178F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:52:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F03CC433C8;
	Sun, 16 Jul 2023 20:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540759;
	bh=+oiNfMe20yn5AQbcMXrRJa2L2IPU8mEqSlpz6Sv9gu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v13fQ53Lq77kBoJ4GIueetqJ68GGCQ8pN3DzfDKlW74HFasJUNwzua+DjC3t+N6Bd
	 He3wZH0hmFYVrxjlzKaeickjD2EwxehcwN85hufHcmc7L2JDwTzU5RVwhIHhn/vMwd
	 JUF9bGTf3JP/iEByPuPzzs8VxFgSLJaOGbW86SN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Simon Horman <simon.horman@corigine.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 478/591] net: dsa: sja1105: always enable the INCL_SRCPT option
Date: Sun, 16 Jul 2023 21:50:17 +0200
Message-ID: <20230716194936.268112781@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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

[ Upstream commit b4638af8885af93cd70351081da1909c59342440 ]

Link-local traffic on bridged SJA1105 ports is sometimes tagged by the
hardware with source port information (when the port is under a VLAN
aware bridge).

The tag_8021q source port identification has become more loose
("imprecise") and will report a plausible rather than exact bridge port,
when under a bridge (be it VLAN-aware or VLAN-unaware). But link-local
traffic always needs to know the precise source port.

Modify the driver logic (and therefore: the tagging protocol itself) to
always include the source port information with link-local packets,
regardless of whether the port is standalone, under a VLAN-aware or
VLAN-unaware bridge. This makes it possible for the tagging driver to
give priority to that information over the tag_8021q VLAN header.

The big drawback with INCL_SRCPT is that it makes it impossible to
distinguish between an original MAC DA of 01:80:C2:XX:YY:ZZ and
01:80:C2:AA:BB:ZZ, because the tagger just patches MAC DA bytes 3 and 4
with zeroes. Only if PTP RX timestamping is enabled, the switch will
generate a META follow-up frame containing the RX timestamp and the
original bytes 3 and 4 of the MAC DA. Those will be used to patch up the
original packet. Nonetheless, in the absence of PTP RX timestamping, we
have to live with this limitation, since it is more important to have
the more precise source port information for link-local traffic.

Fixes: d7f9787a763f ("net: dsa: tag_8021q: add support for imprecise RX based on the VBID")
Fixes: 91495f21fcec ("net: dsa: tag_8021q: replace the SVL bridging with VLAN-unaware IVL bridging")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b70dcf32a26dc..8bd61f2ebb2ad 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -866,11 +866,11 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		.hostprio = 7,
 		.mac_fltres1 = SJA1105_LINKLOCAL_FILTER_A,
 		.mac_flt1    = SJA1105_LINKLOCAL_FILTER_A_MASK,
-		.incl_srcpt1 = false,
+		.incl_srcpt1 = true,
 		.send_meta1  = false,
 		.mac_fltres0 = SJA1105_LINKLOCAL_FILTER_B,
 		.mac_flt0    = SJA1105_LINKLOCAL_FILTER_B_MASK,
-		.incl_srcpt0 = false,
+		.incl_srcpt0 = true,
 		.send_meta0  = false,
 		/* Default to an invalid value */
 		.mirr_port = priv->ds->num_ports,
@@ -2407,11 +2407,6 @@ int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
 	general_params->tpid = tpid;
 	/* EtherType used to identify outer tagged (S-tag) VLAN traffic */
 	general_params->tpid2 = tpid2;
-	/* When VLAN filtering is on, we need to at least be able to
-	 * decode management traffic through the "backup plan".
-	 */
-	general_params->incl_srcpt1 = enabled;
-	general_params->incl_srcpt0 = enabled;
 
 	for (port = 0; port < ds->num_ports; port++) {
 		if (dsa_is_unused_port(ds, port))
-- 
2.39.2



