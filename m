Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888D937A858;
	Thu, 20 Aug 2026 16:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244649; cv=none; b=QR5VCQt//bOCDBq8Su6vQr+apsm54QEkzGDfVtdZlwMY8d9TRZ1/secDihqXh1wUeiA3pDuLqTa+4ZpziKA6J+S0/lqJLbd9BztBVwHgRtUnXzhGY0AqcRQn7u92gRXRHWcpRf5j3Kd3Y9vIkEgxsCa4/8GLwGuCnZ+PPre6BVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244649; c=relaxed/simple;
	bh=2uBKJUi5D+HArbT8t07SHxHQzGSPBFwrPhzB912NPWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdyD8uNLX4HnY1iyumJvfWlaBg2VDCjXbx1A4DGILQeHf5byT6Cl7tIVxdd7Oiqv21SO4HHQa3rRSMF6nkl8iazJVq6wFesoYP9bXJd2/Q0TaL4oKshx3j9XQKc9j+fhLQ50AqDpEirz1X6sqa2joGsA1rtNmwW41FvAxN5KkKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFQ/hnQ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFQ/hnQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29F41F00ACA;
	Thu, 20 Aug 2026 16:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244648;
	bh=imfaHHyTMY13Q+duJC4Jyam2jlW4gu/ePDc8GfnFNA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xFQ/hnQ2dzchTwuwuSTnWHr8T2Hg1AnN4n5V4AB1OjNYZ9MdZkOmsikntKl3AdykQ
	 yQE8l/r/Vw8GL6j2EAyKc+sxclKc8EewFeU72U94HL8v0ZZEu06XqvxJ+aPpGwmmcE
	 8McR7gwXj6+tNBZQw1ghX98D/TJKX+ZYQdLAZkmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Chintan Vankar <c-vankar@ti.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 228/235] net: ethernet: ti: am65-cpsw-nuss: Fix port_id extraction from SRC TAG
Date: Thu, 20 Aug 2026 16:57:44 +0200
Message-ID: <20260820145223.532421199@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3fb87601b329c..7128d43ead502 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -779,6 +779,8 @@ static int am65_cpsw_nuss_rx_packets(struct am65_cpsw_common *common,
 	cppi5_hdesc_get_obuf(desc_rx, &buf_dma, &buf_dma_len);
 	pkt_len = cppi5_hdesc_get_pktlen(desc_rx);
 	cppi5_desc_get_tags_ids(&desc_rx->hdr, &port_id, NULL);
+	/* Port ID is contained in the lower 8-bits of the 16-bit Source Tag */
+	port_id &= 0xFF;
 	dev_dbg(dev, "%s rx port_id:%d\n", __func__, port_id);
 	port = am65_common_get_port(common, port_id);
 	ndev = port->ndev;
-- 
2.53.0



