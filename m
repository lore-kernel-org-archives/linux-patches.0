Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EA947D930;
	Thu, 20 Aug 2026 16:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243933; cv=none; b=W5r782EwOWWfIK+XaDI37bKtYlBIj0K6Shh/02UNN0HvN+MtJ6UDS8Swe4Nj3AhHuRlHHoE7DA+HQ3DSFd+MnK2M2heG7/FAaBWvaxLL3VEwm1tFazGx+aF/8o6hxyA0bXezEjeyQ+ro7ZNnfuh8fiRtX2WHrFlyqVDWa3IbWqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243933; c=relaxed/simple;
	bh=4hvouhmuY53YNtGr77y9dBmawyRtYV3L+jUDIqZd9ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0+B1zjVOh3Xlq7It0ruMqYeCm6sxaluKPgfKOphulHbFhKw2gGmU8fr8wgEs0lzFiy2XP/rgJYXcrBH2ls7zyqQ7HsGS7z2a6YJ26X6cKDosrNObTiImuq8A9H7RXtaX2FVjp2m8zp6TY8itZLX0GnUdMb2hBPVwVRrJT2lsI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x7VYblGl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x7VYblGl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F94B1F00A3F;
	Thu, 20 Aug 2026 16:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243931;
	bh=gFybE8hlr8kjJ56qGh9NjemE/DTf5jSrV6eFWBGt4Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x7VYblGlfApu72KhmRI2533NihNIPN7bx8f84scbbUAPYW2XBpKMJEGE5TxE7DdgW
	 +vvvPHTBHMXsY3r+shNrbqriemGwvytzHlQh46+ZHLDFtoNIu/3hrHftUffjgUgfYN
	 qtnlbJW05lq1Bwfca3j68neVMtTSlS4PnpD7Ss5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Chintan Vankar <c-vankar@ti.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 266/272] net: ethernet: ti: am65-cpsw-nuss: Fix port_id extraction from SRC TAG
Date: Thu, 20 Aug 2026 16:57:30 +0200
Message-ID: <20260820145239.615375897@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit 36a05d2820077bb3955acb8111e1041d39148037 ]

On the packet reception path, the ID of the MAC Port on which the packet
was received, is embedded in the RX DMA Descriptor's metadata. The ID is
extracted using the helper function cppi5_desc_get_tags_ids() which fills
in the 16-bit Source Tag into the 'port_id' variable. However, it is only
the lower 8-bits of the 16-bit Source Tag that represent the MAC Port ID,
while the upper 8-bits are Hardware-Reserved and carry an arbitrary value.
With the existing logic, sporadic kernel crash is observed due to the
subsequent driver code accessing out-of-bound memory because of an invalid
port_id.

Hence, fix the port_id extraction logic to use only the lower 8-bits of the
Source Tag as the MAC Port ID.

Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Reviewed-by: Chintan Vankar <c-vankar@ti.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260807111738.2055900-1-s-vadapalli@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 7c2202225475e..719465373395c 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -809,6 +809,8 @@ static int am65_cpsw_nuss_rx_packets(struct am65_cpsw_common *common,
 	k3_udma_glue_rx_cppi5_to_dma_addr(rx_chn->rx_chn, &buf_dma);
 	pkt_len = cppi5_hdesc_get_pktlen(desc_rx);
 	cppi5_desc_get_tags_ids(&desc_rx->hdr, &port_id, NULL);
+	/* Port ID is contained in the lower 8-bits of the 16-bit Source Tag */
+	port_id &= 0xFF;
 	dev_dbg(dev, "%s rx port_id:%d\n", __func__, port_id);
 	port = am65_common_get_port(common, port_id);
 	ndev = port->ndev;
-- 
2.53.0



