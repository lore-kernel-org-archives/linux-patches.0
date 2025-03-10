Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB5F1BBBFD;
	Mon, 10 Mar 2025 18:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630749; cv=none; b=u+xFY24KLnwRh0e4yt9Q4YYpzI1zxp91MxF7R3Xpjq2hzBpPxUv4p7Y8TlCUlukuJBY68kPcTNwIGBAWuna5R7CX7hfTyMI2IpmrAWlCEkRHKTaXu4BCH2JUuBPvbgBrz2ncd9hBpzrCO8r/ry8qzBC5szPJ0LNhFw9xLE1HVe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630749; c=relaxed/simple;
	bh=9jDKiDlmmWRWWON+cxdG54kcMlQOF3ErFpj5Ik53EQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kc9So1x2jImhSPZ6H14g7gTVd0Uy+y9KEjhw5iVgNrNHzCAqDUinb2jsv0UGB+/hWGT0dkDEqeV8SuxODBi7l/Oxbkdr4BtPd32Mbvr8j2yHtNNwDCgxo/HHhD0v71DfROjxtVrAQMtstEds5NGQbLN8Wnmf+dSwgeKUPU7dpVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZavMkCZ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZavMkCZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AE8C4CEE5;
	Mon, 10 Mar 2025 18:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630749;
	bh=9jDKiDlmmWRWWON+cxdG54kcMlQOF3ErFpj5Ik53EQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZavMkCZ+6KGpXctsi6VUIaxM8TcHbkpG9ehzrq71izWMRSK8sqn/oyaKJ8uCBppij
	 FSEPA6cN+5I4V6P0jUDNX+MdlkAC7Hw8+teWhU0HJJUZmLPfukF4ZkdscBmZtQRUDU
	 /EJoCWGWnVWd+ts3i7zXGfRtITnKkcfH8UgynEGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Wei Fang <wei.fang@nxp.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 520/620] net: enetc: fix the off-by-one issue in enetc_map_tx_buffs()
Date: Mon, 10 Mar 2025 18:06:06 +0100
Message-ID: <20250310170606.080213518@linuxfoundation.org>
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
@@ -121,6 +121,24 @@ static int enetc_ptp_parse(struct sk_buf
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
@@ -303,13 +321,7 @@ static int enetc_map_tx_buffs(struct ene
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


