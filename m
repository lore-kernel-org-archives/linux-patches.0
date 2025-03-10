Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD6F1C3F34;
	Mon, 10 Mar 2025 18:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630868; cv=none; b=Y00b9z6Zj63iarjDHFli+7mlXNSL78E2zbxEUfQcegikoaNptnhHB6xyKjB0H3DiooXsM5LE85JUwai41uiHfq9zGJtf1CNQnpELn29cnrDHJNnEawPJvyrczUBeQbOTr1TEXhmONwz5MHNAY568ACGWsdDmxmzuOyc6Srcu4nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630868; c=relaxed/simple;
	bh=gF/y9RF2oiyzcGStYRVWhvb2Vy27RyYS5RrAMpGdnas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VL30vF/NnvTecZ9+yJWf7LigEMq8ffhAOw1o4rjeRiOqauMnLySqBwyprToXdmnMpY+bKJRF/xODtwOj6uvCiHNAYcOEefJRj5F9LjoeGipmmmaE8xRH/+6BCirNJOK8VzGH0XbiyopoUm6qee1DVI7Gd0fR5TPUi4EQc59iAik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0y0R6Nne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0y0R6Nne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77B4C4CEE5;
	Mon, 10 Mar 2025 18:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630868;
	bh=gF/y9RF2oiyzcGStYRVWhvb2Vy27RyYS5RrAMpGdnas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0y0R6NnewgIhOyPCkucFKB2RT4ateCBV004C7cDLsLvtx6li3sPeKV/+v+P0JE4mq
	 ajIh7MCyFdfvMx5ynfY0o5UEMYjKzny8Dl641h7W8OblcIBr/gMIIieR/A31Gdc4ew
	 NVJGQbDQNp60Mt9/qfSWsfEfjQgIZlHg2lV8tmNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 521/620] net: enetc: update UDP checksum when updating originTimestamp field
Date: Mon, 10 Mar 2025 18:06:07 +0100
Message-ID: <20250310170606.118145558@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

commit bbcbc906ab7b5834c1219cd17a38d78dba904aa0 upstream.

There is an issue with one-step timestamp based on UDP/IP. The peer will
discard the sync packet because of the wrong UDP checksum. For ENETC v1,
the software needs to update the UDP checksum when updating the
originTimestamp field, so that the hardware can correctly update the UDP
checksum when updating the correction field. Otherwise, the UDP checksum
in the sync packet will be wrong.

Fixes: 7294380c5211 ("enetc: support PTP Sync packet one-step timestamping")
Cc: stable@vger.kernel.org
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250224111251.1061098-6-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c |   41 ++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -228,9 +228,11 @@ static int enetc_map_tx_buffs(struct ene
 		}
 
 		if (do_onestep_tstamp) {
-			u32 lo, hi, val;
-			u64 sec, nsec;
+			__be32 new_sec_l, new_nsec;
+			u32 lo, hi, nsec, val;
+			__be16 new_sec_h;
 			u8 *data;
+			u64 sec;
 
 			lo = enetc_rd_hot(hw, ENETC_SICTR0);
 			hi = enetc_rd_hot(hw, ENETC_SICTR1);
@@ -244,13 +246,38 @@ static int enetc_map_tx_buffs(struct ene
 			/* Update originTimestamp field of Sync packet
 			 * - 48 bits seconds field
 			 * - 32 bits nanseconds field
+			 *
+			 * In addition, the UDP checksum needs to be updated
+			 * by software after updating originTimestamp field,
+			 * otherwise the hardware will calculate the wrong
+			 * checksum when updating the correction field and
+			 * update it to the packet.
 			 */
 			data = skb_mac_header(skb);
-			*(__be16 *)(data + offset2) =
-				htons((sec >> 32) & 0xffff);
-			*(__be32 *)(data + offset2 + 2) =
-				htonl(sec & 0xffffffff);
-			*(__be32 *)(data + offset2 + 6) = htonl(nsec);
+			new_sec_h = htons((sec >> 32) & 0xffff);
+			new_sec_l = htonl(sec & 0xffffffff);
+			new_nsec = htonl(nsec);
+			if (udp) {
+				struct udphdr *uh = udp_hdr(skb);
+				__be32 old_sec_l, old_nsec;
+				__be16 old_sec_h;
+
+				old_sec_h = *(__be16 *)(data + offset2);
+				inet_proto_csum_replace2(&uh->check, skb, old_sec_h,
+							 new_sec_h, false);
+
+				old_sec_l = *(__be32 *)(data + offset2 + 2);
+				inet_proto_csum_replace4(&uh->check, skb, old_sec_l,
+							 new_sec_l, false);
+
+				old_nsec = *(__be32 *)(data + offset2 + 6);
+				inet_proto_csum_replace4(&uh->check, skb, old_nsec,
+							 new_nsec, false);
+			}
+
+			*(__be16 *)(data + offset2) = new_sec_h;
+			*(__be32 *)(data + offset2 + 2) = new_sec_l;
+			*(__be32 *)(data + offset2 + 6) = new_nsec;
 
 			/* Configure single-step register */
 			val = ENETC_PM0_SINGLE_STEP_EN;


