Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FE82517BC;
	Wed,  5 Mar 2025 18:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197800; cv=none; b=JnuL/DAh+mx8/rCh4+HQM/5rcXBFc1wOf3TPD9uN0Xl59QSc9ImXl/fDCCAmRTurlcWVP0stjB+HFmOs2Uqt1xhKHHy8E1a5IgA8bJgRGCeBElc7/zvJG+ZmyY1kijBOGHKcS800y+KjODjDuJf9zQtSHQyJ6fRFd/+1c78+e80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197800; c=relaxed/simple;
	bh=vslIVhhj7qhgiWdcUxgtc1egVx9IKl9oNsB2US4KFi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHTeY8QttJdjIOvaeUjGvLgmv8g5Oj9zTwvlq2IO9BjPbjabHGVyR0QLlHglhONUpJTqPV0DGiADql14mdA+wVY53blJQXCMZDn63g5gIUrt0p1O7+/XX6YqM/OhSy418bUgXsvitweFynedrmsUeigoEcdbYDRlFdRkkLiCu2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oWGygQ/F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oWGygQ/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF107C4CED1;
	Wed,  5 Mar 2025 18:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197800;
	bh=vslIVhhj7qhgiWdcUxgtc1egVx9IKl9oNsB2US4KFi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oWGygQ/FQ6CmX+FYACxAzY8+DAoOULuzHd+58DXdu8Wn8qJJVBg/ZKSBvEvxaRP+J
	 7H1mKxNVi5yTPRnEcnNNNJJOCvIgx5zQKFKSesmfjHTifTg86Sie3JlPEc16oKpcG+
	 vBatx5IH9UpyFkIx6jutYU/kn44fRws77b6iPLTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Wei Fang <wei.fang@nxp.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 073/142] net: enetc: fix the off-by-one issue in enetc_map_tx_buffs()
Date: Wed,  5 Mar 2025 18:48:12 +0100
Message-ID: <20250305174503.269799197@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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
@@ -145,6 +145,24 @@ static int enetc_ptp_parse(struct sk_buf
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
@@ -328,13 +346,7 @@ static int enetc_map_tx_buffs(struct ene
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


