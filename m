Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D3121D00A;
	Mon, 23 Mar 2026 13:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274212; cv=none; b=dtL2l3YrPOL+haHhGUTb+XMAxh/sOJBXBOB1flhf2sLakeHo368wGXVFvAyik6yTXqKIRUXTMTQfdUSmkPAz08EOsxpPxcf4bgLFjo9noBvTGj05uBp8cSClv3/iKFNTVfOoJRanbpCguG01IMKNxcU12i3nF9TeqtmFEfUvxFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274212; c=relaxed/simple;
	bh=fXPiHnyQgxw33bexgbslVgdpOce4MdK2Kjrx20grT6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RzF1Tof+bdCIa7PHPXoIbMlW+/OL6OUUhSEkF2BuOcSR/eZ/QpYo9PO89n9nmT2MNurUUYCtJ5eGqxIPIsKv+cyuzhlI/hkuo+153xpbev/h0122LDeUldeKAj31b2snEZMNYkWhc6hneftC8Nq9sxXKCvrspRSta58r3MOEvbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o++iwP/3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o++iwP/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90658C4CEF7;
	Mon, 23 Mar 2026 13:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274212;
	bh=fXPiHnyQgxw33bexgbslVgdpOce4MdK2Kjrx20grT6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o++iwP/3QT54ohhtApTl0Qc6AOkDxnyZmuOHj2wBjzjhwqTpjNdtJXVV5L04TS1PG
	 4YnvCjzEx5mGgU3eFPxzDQTQWfgd+P5Y9FhVscDqFDjoClMh0hl/iXnmsfb4cEF2YU
	 sSLVuRkc5jOjFnbORlcN/NqZDwuI4kHWHCKWFdsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meghana Malladi <m-malladi@ti.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 145/220] net: ti: icssg-prueth: Fix memory leak in XDP_DROP for non-zero-copy mode
Date: Mon, 23 Mar 2026 14:45:22 +0100
Message-ID: <20260323134509.176628558@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meghana Malladi <m-malladi@ti.com>

[ Upstream commit 719d3e71691db7c4f1658ba5a6d1472928121594 ]

Page recycling was removed from the XDP_DROP path in emac_run_xdp() to
avoid conflicts with AF_XDP zero-copy mode, which uses xsk_buff_free()
instead.

However, this causes a memory leak when running XDP programs that drop
packets in non-zero-copy mode (standard page pool mode). The pages are
never returned to the page pool, leading to OOM conditions.

Fix this by handling cleanup in the caller, emac_rx_packet().
When emac_run_xdp() returns ICSSG_XDP_CONSUMED for XDP_DROP, the
caller now recycles the page back to the page pool. The zero-copy
path, emac_rx_packet_zc() already handles cleanup correctly with
xsk_buff_free().

Fixes: 7a64bb388df3 ("net: ti: icssg-prueth: Add AF_XDP zero copy for RX")
Signed-off-by: Meghana Malladi <m-malladi@ti.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260311095441.1691636-1-m-malladi@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_common.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_common.c b/drivers/net/ethernet/ti/icssg/icssg_common.c
index 090aa74d3ce72..a9b5f86bc71bc 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_common.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_common.c
@@ -1075,6 +1075,11 @@ static int emac_rx_packet(struct prueth_emac *emac, u32 flow_id, u32 *xdp_state)
 		xdp_prepare_buff(&xdp, pa, PRUETH_HEADROOM, pkt_len, false);
 
 		*xdp_state = emac_run_xdp(emac, &xdp, &pkt_len);
+		if (*xdp_state == ICSSG_XDP_CONSUMED) {
+			page_pool_recycle_direct(pool, page);
+			goto requeue;
+		}
+
 		if (*xdp_state != ICSSG_XDP_PASS)
 			goto requeue;
 		headroom = xdp.data - xdp.data_hard_start;
-- 
2.51.0



