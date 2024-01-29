Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAB2755EF;
	Mon, 29 Jan 2024 17:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548594; cv=none; b=CAqqS1boLOimWOCVfGXNeOv7JUbRADtPZ8WuoJBR55AVRejhSJXlRHxpESDtazxK0uBOQw0vKO8qOwoScDEXSMDtDJFWIErsrLNZskYpnB9tUEcWHJHZ6VP8paCjDskuhQQS/soAyH2LH0qgBMsmXTklNAWpSamEwsw+kOG4Ah4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548594; c=relaxed/simple;
	bh=OPZNytY/7balN7G3JGLIDwRy1ALIsRTuZ/JXcbsPA/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRpOIm7IV+cYwNnSSHuQHcwvk0zomKn7ZouR6q34uXE6H+UTdDwKYilIyJRfCYAl2bCvaVh3i57RDN/K17AARX2Kc4cPfwOxfQiBFRNlyKGdzPPXA2owHZabI7UX369HC5t8SNwnuNGYZM3vapL0NWm1w1P55YS+oCwfeX5ctkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7cjzf+R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7cjzf+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F5FC43390;
	Mon, 29 Jan 2024 17:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548593;
	bh=OPZNytY/7balN7G3JGLIDwRy1ALIsRTuZ/JXcbsPA/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7cjzf+RO8e0rJI7454iWRNwQCtyTzYsT7T68uzx8GauZc4Vx6Ops6YSjRlWM7TEB
	 VXUgB+9hoL//sdQTKOWlbxBAz7BVehLRDIHuswmHL9lqKJFebrv8aWp0NW6wbg98b9
	 Cv30aTSAfFNrUUdDp3eEgMELrhMF9T9Yx2yCbfoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 228/331] tsnep: Remove FCS for XDP data path
Date: Mon, 29 Jan 2024 09:04:52 -0800
Message-ID: <20240129170021.553359401@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 38da2d6c250e..9fea97671f4b 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1434,7 +1434,7 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 
 			xdp_prepare_buff(&xdp, page_address(entry->page),
 					 XDP_PACKET_HEADROOM + TSNEP_RX_INLINE_METADATA_SIZE,
-					 length, false);
+					 length - ETH_FCS_LEN, false);
 
 			consume = tsnep_xdp_run_prog(rx, prog, &xdp,
 						     &xdp_status, tx_nq, tx);
@@ -1517,7 +1517,7 @@ static int tsnep_rx_poll_zc(struct tsnep_rx *rx, struct napi_struct *napi,
 		prefetch(entry->xdp->data);
 		length = __le32_to_cpu(entry->desc_wb->properties) &
 			 TSNEP_DESC_LENGTH_MASK;
-		xsk_buff_set_size(entry->xdp, length);
+		xsk_buff_set_size(entry->xdp, length - ETH_FCS_LEN);
 		xsk_buff_dma_sync_for_cpu(entry->xdp, rx->xsk_pool);
 
 		/* RX metadata with timestamps is in front of actual data,
-- 
2.43.0



