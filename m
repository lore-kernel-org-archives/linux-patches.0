Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B48E158D9B;
	Mon, 29 Jan 2024 17:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548175; cv=none; b=sx7Iwv71+vOCS9pFOjPbrSXJPFoc396vdME+rlaUaBIP4jZvpuPrwt1cf8HU4b2ImmgQUmJomJiibF7w11IBth6V1ObGNDardGBkk9uzrnLftHBq7NtcVfgZQB/nX+wbScjHTD/mHVxUQyqGFwlFRiVdObpZAZOg62sFH0aePl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548175; c=relaxed/simple;
	bh=Y8uaWd5KDFgCNryUAKg6gftn6GbnCVA8xkjN2BV3xbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VaItT0cK6NUdngIXq2kPfwfYTC2yO2I75LSST9ohHg4YWpgLsPs+0F9JnfRe1ehmBk1wTwJWhUWm/TL9X56+n5r4v5wJAzI5S7/Sp3U32kQH6vcVtIns7XIiUImclnJrh4x1vzMkQ4c09ZcFsFiZK4dVA6z70VgkSJTmjg0SPIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqsHLwrW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqsHLwrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04228C43390;
	Mon, 29 Jan 2024 17:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548175;
	bh=Y8uaWd5KDFgCNryUAKg6gftn6GbnCVA8xkjN2BV3xbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqsHLwrWgOGm9Z1Ty5b66lzCBJlUDcAYqLa5dm17UBymw0Os7KkNeBfqRatrFlHFF
	 2NU0/Ejnkl/BTGVMD2eKQWZn8Oud1qqyuNRG2k5SE2V0t34lC+WxEcE6yREI1g6VXX
	 sPcj88tbtiVwSgkON1lA4w6uHOQ7oBbFTTe5utP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 220/346] tsnep: Remove FCS for XDP data path
Date: Mon, 29 Jan 2024 09:04:11 -0800
Message-ID: <20240129170022.857200159@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

[ Upstream commit 50bad6f797d4d501c5ef416a6f92e1912ab5aa8b ]

The RX data buffer includes the FCS. The FCS is already stripped for the
normal data path. But for the XDP data path the FCS is included and
acts like additional/useless data.

Remove the FCS from the RX data buffer also for XDP.

Fixes: 65b28c810035 ("tsnep: Add XDP RX support")
Fixes: 3fc2333933fd ("tsnep: Add XDP socket zero-copy RX support")
Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index df40c720e7b2..456e0336f3f6 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1485,7 +1485,7 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 
 			xdp_prepare_buff(&xdp, page_address(entry->page),
 					 XDP_PACKET_HEADROOM + TSNEP_RX_INLINE_METADATA_SIZE,
-					 length, false);
+					 length - ETH_FCS_LEN, false);
 
 			consume = tsnep_xdp_run_prog(rx, prog, &xdp,
 						     &xdp_status, tx_nq, tx);
@@ -1568,7 +1568,7 @@ static int tsnep_rx_poll_zc(struct tsnep_rx *rx, struct napi_struct *napi,
 		prefetch(entry->xdp->data);
 		length = __le32_to_cpu(entry->desc_wb->properties) &
 			 TSNEP_DESC_LENGTH_MASK;
-		xsk_buff_set_size(entry->xdp, length);
+		xsk_buff_set_size(entry->xdp, length - ETH_FCS_LEN);
 		xsk_buff_dma_sync_for_cpu(entry->xdp, rx->xsk_pool);
 
 		/* RX metadata with timestamps is in front of actual data,
-- 
2.43.0



