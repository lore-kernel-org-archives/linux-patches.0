Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A432133E36A;
	Wed,  3 Dec 2025 16:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779890; cv=none; b=ogXg6Apws1a/VO5anIIihbhvC9MSIBpgVPWSSyST2eVyooTGuo70r0hr3MHVi1tFkn6vgQGWhRdcOzIX/Y6CoRNkfKYovZRIuMRsROwmtj+UxI5agnyUmUR/IdvNVRRI2iSzHCEabnJGIKK7+medNeADlElGxOtf347yfUnWHaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779890; c=relaxed/simple;
	bh=50cD7qf9JBW4982RXJ1A96YPfJLeNuC6eJ9Cd/CVz38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YDhNSbL6Xc1vRDYmRNXyCAzItLyB2LWCvkcaS4uVjmJ6T2yzOl1KhobZKZUknnJyuyuPGo5b75EuMHS1p4KJKlUv2JqvSt3bt93+M9ik4vuZkV2WM3eXWZ4NznN9RhyZ616iGycmRlyWzl7uCuWDeIjcMmIrCXYMLqZsLLw83oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nu3jjwvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nu3jjwvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0ECC4CEF5;
	Wed,  3 Dec 2025 16:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779890;
	bh=50cD7qf9JBW4982RXJ1A96YPfJLeNuC6eJ9Cd/CVz38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nu3jjwvEjYCJPZmWKnbYy/tQNIwUhoCGF/0ZDzsXcRvc2g9EoLeKielNRjrUWLSam
	 2ES02usONKbok3cNy9464sMRijTnuEuP46UG0H8+6+M4PqfM68nKo7BB9yjTXtv45K
	 KLFVrlem49Mao3GLIv0Rzvafxj1U9YjjYC+HQVBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 350/568] net: fec: correct rx_bytes statistic for the case SHIFT16 is set
Date: Wed,  3 Dec 2025 16:25:52 +0100
Message-ID: <20251203152453.524421768@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit ad17e7e92a7c52ce70bb764813fcf99464f96903 ]

Two additional bytes in front of each frame received into the RX FIFO if
SHIFT16 is set, so we need to subtract the extra two bytes from pkt_len
to correct the statistic of rx_bytes.

Fixes: 3ac72b7b63d5 ("net: fec: align IP header in hardware")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20251106021421.2096585-1-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index ca271d7a388b4..c8f897afb30a6 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1681,6 +1681,8 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		ndev->stats.rx_packets++;
 		pkt_len = fec16_to_cpu(bdp->cbd_datlen);
 		ndev->stats.rx_bytes += pkt_len;
+		if (fep->quirks & FEC_QUIRK_HAS_RACC)
+			ndev->stats.rx_bytes -= 2;
 
 		index = fec_enet_get_bd_index(bdp, &rxq->bd);
 		page = rxq->rx_skb_info[index].page;
-- 
2.51.0



