Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AA020ED;
	Thu, 13 Jun 2024 12:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282672; cv=none; b=qfuvIBYG5dzMB2WOwvBksybyD3Gx3k5OF3i9gynJMKnbgvkEyLxKb0xiD1+WAWFAOUoeU/vpcOhbc/KB6k8/NrEZs05Vvlx6ZOigTs0ApInZri1+FLEJd3hRLM3fNXUkcbk/RmYoBCZIglBp3qhY9jJPupEAzSkT03GzogjuHnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282672; c=relaxed/simple;
	bh=BPVJrwyw/yHIVGL76E4HqJHi63pZYrILmjPrjPfiMu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xi2LAloBkKXZfR+I7mxFMtVG00P6pOdVZ8TgWmiWFUxo99sxmbA8kYUw5W+uBR1PD8YiPmSxbENazy6NFW7qMTcYAuHGbeXNeb5WqVizpJlRMmqINFjMF63NX6Hjb2RXtd7WrqjcSrDMS2Cmu5JHhNq1lGPsDo1IsQLvxMvt6Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RHvMoKkr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHvMoKkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BC4C2BBFC;
	Thu, 13 Jun 2024 12:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282672;
	bh=BPVJrwyw/yHIVGL76E4HqJHi63pZYrILmjPrjPfiMu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RHvMoKkrWZREKj/wpTSHYZV7QYMGWBfcwsmB5AM4s5F5QhWaLJ9/0b8k6zi29lw5b
	 vxAxL6JSir9hkCORKkCxPNXIFxtMXkNu8zdqWfeo3ZszXtTNHgBM0lZWsA3744BNMy
	 rEajLnOldp1wHovrvs+qRGcrzIl1hue+0w6pQ+T4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Simon Horman <simon.horman@corigine.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 349/402] net: dsa: sja1105: always enable the INCL_SRCPT option
Date: Thu, 13 Jun 2024 13:35:06 +0200
Message-ID: <20240613113315.748575534@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit b4638af8885af93cd70351081da1909c59342440 upstream.

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
Stable-dep-of: c1ae02d87689 ("net: dsa: tag_sja1105: always prefer source port information from INCL_SRCPT")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -853,11 +853,11 @@ static int sja1105_init_general_params(s
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
@@ -2346,11 +2346,6 @@ int sja1105_vlan_filtering(struct dsa_sw
 	general_params->tpid = tpid;
 	/* EtherType used to identify outer tagged (S-tag) VLAN traffic */
 	general_params->tpid2 = tpid2;
-	/* When VLAN filtering is on, we need to at least be able to
-	 * decode management traffic through the "backup plan".
-	 */
-	general_params->incl_srcpt1 = enabled;
-	general_params->incl_srcpt0 = enabled;
 
 	/* VLAN filtering => independent VLAN learning.
 	 * No VLAN filtering (or best effort) => shared VLAN learning.


