Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033C75FF0E;
	Tue, 13 Feb 2024 17:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845720; cv=none; b=Hn+sTUCARJ+fI3A35sl+G9pPn0h0rWwuxvbpAiuBvImYkMratBohfbp2fH5k26Mmh5XaRgvOzav2lUbsU+e62KPxWRoVudomiwRB5zeLbCtNPntL7/lTPNAfjTVv/w0y5t58fqlHTPJpKd/Utsg58P+KuCBiYQJG+OTVRY7o8Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845720; c=relaxed/simple;
	bh=X8b0CZV+ZsVoWJHzzLVrnMfZjz4qKswL7IhlZScpOWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PemiQMfivnhz6UfIE1GShkbStlBV+ud9v8AVkfw+gtN+F4GVEaRO9mm9VHdUDQzRuJPFieHashXDlQOeBTaBeRmFSCGTAS8UTZW69dG+nFFodqf2GGQd7Mb3E8IH9FhOGV6NnQMHSBMn9zhDgmNaWn0i9dzPBxv5YQaswWUovGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mi2QupGy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mi2QupGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDEAC43390;
	Tue, 13 Feb 2024 17:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845718;
	bh=X8b0CZV+ZsVoWJHzzLVrnMfZjz4qKswL7IhlZScpOWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mi2QupGyBQOr+6JQTX2QTP6qVb1oZiUhNmI6KILwMDfYCIlbk3Jznyb63C5X8WSkm
	 +NUSrlVDhbxbU9ZzemgBOk654ybBLkQSZpYMuRe/MTjnYMfGa1BP4f4tM5U2ZhP3l6
	 WEyYFwve2keUcMxc1z1tuub0hDp4eO+72d33tQOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 039/124] tsnep: Fix mapping for zero copy XDP_TX action
Date: Tue, 13 Feb 2024 18:21:01 +0100
Message-ID: <20240213171854.873418144@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerhard Engleder <gerhard@engleder-embedded.com>

[ Upstream commit d7f5fb33cf77247b7bf9a871aaeea72ca4f51ad7 ]

For XDP_TX action xdp_buff is converted to xdp_frame. The conversion is
done by xdp_convert_buff_to_frame(). The memory type of the resulting
xdp_frame depends on the memory type of the xdp_buff. For page pool
based xdp_buff it produces xdp_frame with memory type
MEM_TYPE_PAGE_POOL. For zero copy XSK pool based xdp_buff it produces
xdp_frame with memory type MEM_TYPE_PAGE_ORDER0.

tsnep_xdp_xmit_back() is not prepared for that and uses always the page
pool buffer type TSNEP_TX_TYPE_XDP_TX. This leads to invalid mappings
and the transmission of undefined data.

Improve tsnep_xdp_xmit_back() to use the generic buffer type
TSNEP_TX_TYPE_XDP_NDO for zero copy XDP_TX.

Fixes: 3fc2333933fd ("tsnep: Add XDP socket zero-copy RX support")
Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 9aeff2b37a61..64eadd320798 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -719,17 +719,25 @@ static void tsnep_xdp_xmit_flush(struct tsnep_tx *tx)
 
 static bool tsnep_xdp_xmit_back(struct tsnep_adapter *adapter,
 				struct xdp_buff *xdp,
-				struct netdev_queue *tx_nq, struct tsnep_tx *tx)
+				struct netdev_queue *tx_nq, struct tsnep_tx *tx,
+				bool zc)
 {
 	struct xdp_frame *xdpf = xdp_convert_buff_to_frame(xdp);
 	bool xmit;
+	u32 type;
 
 	if (unlikely(!xdpf))
 		return false;
 
+	/* no page pool for zero copy */
+	if (zc)
+		type = TSNEP_TX_TYPE_XDP_NDO;
+	else
+		type = TSNEP_TX_TYPE_XDP_TX;
+
 	__netif_tx_lock(tx_nq, smp_processor_id());
 
-	xmit = tsnep_xdp_xmit_frame_ring(xdpf, tx, TSNEP_TX_TYPE_XDP_TX);
+	xmit = tsnep_xdp_xmit_frame_ring(xdpf, tx, type);
 
 	/* Avoid transmit queue timeout since we share it with the slow path */
 	if (xmit)
@@ -1273,7 +1281,7 @@ static bool tsnep_xdp_run_prog(struct tsnep_rx *rx, struct bpf_prog *prog,
 	case XDP_PASS:
 		return false;
 	case XDP_TX:
-		if (!tsnep_xdp_xmit_back(rx->adapter, xdp, tx_nq, tx))
+		if (!tsnep_xdp_xmit_back(rx->adapter, xdp, tx_nq, tx, false))
 			goto out_failure;
 		*status |= TSNEP_XDP_TX;
 		return true;
@@ -1323,7 +1331,7 @@ static bool tsnep_xdp_run_prog_zc(struct tsnep_rx *rx, struct bpf_prog *prog,
 	case XDP_PASS:
 		return false;
 	case XDP_TX:
-		if (!tsnep_xdp_xmit_back(rx->adapter, xdp, tx_nq, tx))
+		if (!tsnep_xdp_xmit_back(rx->adapter, xdp, tx_nq, tx, true))
 			goto out_failure;
 		*status |= TSNEP_XDP_TX;
 		return true;
-- 
2.43.0



