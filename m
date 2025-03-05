Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DAA24C07D;
	Wed,  5 Mar 2025 17:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197442; cv=none; b=Be3bVjdBSFc1BwMUrTyAR5eT8fVy4pGLCNq2rxh/DQiuywF0oabhZMGpxzapLunVlJhoa3d/Dyb+vnKdr1BgA08Cp1A7ASVWrUwTQm0R8asBoSZEFdaeaUJ97tpWj2UTcbJockc45aiY5NeSUu/e2ImLtdmw3TdrBeNRMI5+d58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197442; c=relaxed/simple;
	bh=jnph49W75XbROrdH5bRw1G2RRq68DQm5Ei2IttGo+gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPGdNwy4/QQvpy2tJLbkA6Sj042mTRSvn4lziBBzYSCLaikC5dEqJCEnW+rVxPRcxUiddLlOafr639S0oAxPrM6f/Ya80DrCavvGNTPVVLT0fb2dE3i+7Su/+tJbXDTwmeAKIYsRgGkz9W14mM1Ri8fmbi3d3rnoeHF4bemV93A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eoLUJK0B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eoLUJK0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A22C4CED1;
	Wed,  5 Mar 2025 17:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197441;
	bh=jnph49W75XbROrdH5bRw1G2RRq68DQm5Ei2IttGo+gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eoLUJK0BdysFLM0SYi1+veOlFw2GBJfCw7pQmykRHst1zpbJGF5nqHRVM4ZOlMHmJ
	 Ghb/DDIYEUbcmGUsx++5/A1M1sjicHR6SGXLyEjT40xtJp+qpLVPElDJAxrUOSxdsO
	 T1kqjMd3gVaswln8rxmLLfLuJz5hQ5TzfqYi5Y+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Wei Fang <wei.fang@nxp.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 157/176] net: enetc: fix the off-by-one issue in enetc_map_tx_buffs()
Date: Wed,  5 Mar 2025 18:48:46 +0100
Message-ID: <20250305174511.744472590@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

commit 39ab773e4c120f7f98d759415ccc2aca706bbc10 upstream.

When a DMA mapping error occurs while processing skb frags, it will free
one more tx_swbd than expected, so fix this off-by-one issue.

Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
Cc: stable@vger.kernel.org
Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Suggested-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Link: https://patch.msgid.link/20250224111251.1061098-2-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -123,6 +123,24 @@ static int enetc_ptp_parse(struct sk_buf
 	return 0;
 }
 
+/**
+ * enetc_unwind_tx_frame() - Unwind the DMA mappings of a multi-buffer Tx frame
+ * @tx_ring: Pointer to the Tx ring on which the buffer descriptors are located
+ * @count: Number of Tx buffer descriptors which need to be unmapped
+ * @i: Index of the last successfully mapped Tx buffer descriptor
+ */
+static void enetc_unwind_tx_frame(struct enetc_bdr *tx_ring, int count, int i)
+{
+	while (count--) {
+		struct enetc_tx_swbd *tx_swbd = &tx_ring->tx_swbd[i];
+
+		enetc_free_tx_frame(tx_ring, tx_swbd);
+		if (i == 0)
+			i = tx_ring->bd_count;
+		i--;
+	}
+}
+
 static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb)
 {
 	bool do_vlan, do_onestep_tstamp = false, do_twostep_tstamp = false;
@@ -306,13 +324,7 @@ static int enetc_map_tx_buffs(struct ene
 dma_err:
 	dev_err(tx_ring->dev, "DMA map error");
 
-	do {
-		tx_swbd = &tx_ring->tx_swbd[i];
-		enetc_free_tx_frame(tx_ring, tx_swbd);
-		if (i == 0)
-			i = tx_ring->bd_count;
-		i--;
-	} while (count--);
+	enetc_unwind_tx_frame(tx_ring, count, i);
 
 	return 0;
 }


