Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4701C2913;
	Thu, 13 Jun 2024 12:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282705; cv=none; b=Gu+bMG7C9CFVVPgZhnthYKdsswYmFN++m5aBwyBg8MBCY3DFQu6b1u+iaZ2Dq19K46v12CvZKPfPL8dRzQgKNk6imOPprc7eLAurGQZ6pWa3magxMYIA4JPxCgi49rJBmvjdEIzO29gKLaNg6ws2ZtzkLZISqSzbh5h5znyiOWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282705; c=relaxed/simple;
	bh=EBq/oktIFYdkztackG4aX44k0w4YEEmPxqYDOPabLjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQAJhsCvESo9AKUUjkengwVsdNtFsoIShBysRW0HetM/v95gGhHzc7tdJzCNZXQbpu3DBiHhmLy5D1KB5MVpBIw8QiZp8Au8UMr14p8TJIj/0JyqLap5gUA7pVZyuh2QeZyW43+jHDNSdjf8mOQzh3lmAr4dadcFRe1G8XpyCJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P72fRtWB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P72fRtWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FE0C2BBFC;
	Thu, 13 Jun 2024 12:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282705;
	bh=EBq/oktIFYdkztackG4aX44k0w4YEEmPxqYDOPabLjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P72fRtWB+v+bTxZEmCmqHIaklBNyPLKucgWfrLahyEcRAULFyjhUiQRhApleEY+dm
	 ed+Zygi38VZYh0vNWBLXdPHwPDuzwlY+Lk3WVsOCUYcgaB1ym8DBmm2sjdY4qCTuMv
	 wo2BmMATNWD3b8nX1tatbM+IHSb4Pi5kHVLhn+ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Simon Horman <simon.horman@corigine.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 350/402] net: dsa: tag_sja1105: always prefer source port information from INCL_SRCPT
Date: Thu, 13 Jun 2024 13:35:07 +0200
Message-ID: <20240613113315.789863693@linuxfoundation.org>
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

commit c1ae02d876898b1b8ca1e12c6f84d7b406263800 upstream.

Currently the sja1105 tagging protocol prefers using the source port
information from the VLAN header if that is available, falling back to
the INCL_SRCPT option if it isn't. The VLAN header is available for all
frames except for META frames initiated by the switch (containing RX
timestamps), and thus, the "if (is_link_local)" branch is practically
dead.

The tag_8021q source port identification has become more loose
("imprecise") and will report a plausible rather than exact bridge port,
when under a bridge (be it VLAN-aware or VLAN-unaware). But link-local
traffic always needs to know the precise source port. With incorrect
source port reporting, for example PTP traffic over 2 bridged ports will
all be seen on sockets opened on the first such port, which is incorrect.

Now that the tagging protocol has been changed to make link-local frames
always contain source port information, we can reverse the order of the
checks so that we always give precedence to that information (which is
always precise) in lieu of the tag_8021q VID which is only precise for a
standalone port.

Fixes: d7f9787a763f ("net: dsa: tag_8021q: add support for imprecise RX based on the VBID")
Fixes: 91495f21fcec ("net: dsa: tag_8021q: replace the SVL bridging with VLAN-unaware IVL bridging")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ Replaced the 2 original Fixes: tags with the correct one.
  Respun the change around the lack of a "vbid", corresponding to DSA
  FDB isolation, which appeared only in v5.18. ]
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/tag_sja1105.c |   34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -489,10 +489,7 @@ static struct sk_buff *sja1105_rcv(struc
 	is_link_local = sja1105_is_link_local(skb);
 	is_meta = sja1105_is_meta_frame(skb);
 
-	if (sja1105_skb_has_tag_8021q(skb)) {
-		/* Normal traffic path. */
-		sja1105_vlan_rcv(skb, &source_port, &switch_id, &vid);
-	} else if (is_link_local) {
+	if (is_link_local) {
 		/* Management traffic path. Switch embeds the switch ID and
 		 * port ID into bytes of the destination MAC, courtesy of
 		 * the incl_srcpt options.
@@ -506,14 +503,35 @@ static struct sk_buff *sja1105_rcv(struc
 		sja1105_meta_unpack(skb, &meta);
 		source_port = meta.source_port;
 		switch_id = meta.switch_id;
-	} else {
+	}
+
+	/* Normal data plane traffic and link-local frames are tagged with
+	 * a tag_8021q VLAN which we have to strip
+	 */
+	if (sja1105_skb_has_tag_8021q(skb)) {
+		int tmp_source_port = -1, tmp_switch_id = -1;
+
+		sja1105_vlan_rcv(skb, &tmp_source_port, &tmp_switch_id, &vid);
+		/* Preserve the source information from the INCL_SRCPT option,
+		 * if available. This allows us to not overwrite a valid source
+		 * port and switch ID with zeroes when receiving link-local
+		 * frames from a VLAN-aware bridged port (non-zero vid).
+		 */
+		if (source_port == -1)
+			source_port = tmp_source_port;
+		if (switch_id == -1)
+			switch_id = tmp_switch_id;
+	} else if (source_port == -1 && switch_id == -1) {
+		/* Packets with no source information have no chance of
+		 * getting accepted, drop them straight away.
+		 */
 		return NULL;
 	}
 
-	if (source_port == -1 || switch_id == -1)
-		skb->dev = dsa_find_designated_bridge_port_by_vid(netdev, vid);
-	else
+	if (source_port != -1 && switch_id != -1)
 		skb->dev = dsa_master_find_slave(netdev, switch_id, source_port);
+	else
+		skb->dev = dsa_find_designated_bridge_port_by_vid(netdev, vid);
 	if (!skb->dev) {
 		netdev_warn(netdev, "Couldn't decode source port\n");
 		return NULL;


