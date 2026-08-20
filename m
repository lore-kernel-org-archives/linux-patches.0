Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23ED548424D;
	Thu, 20 Aug 2026 17:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248325; cv=none; b=GHYItfcDXeQhvuQ6rVgQweWUZgCR8VEnxjmCGf0B9Dfd02IkZ4D50//mAeV7MVhEnt+sV6LfUvIb75aJBmzu5Gmh503agYc4WGlg49u2z57DfeapOZ3DgA1hpxq7ayOue57JCyVfVEDnqYy0eEkKS+ZY5mjKUhUun7n61BfmtcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248325; c=relaxed/simple;
	bh=0eLAVTndPvnchLzrc1gRmEiXO/rUYkj1SVDUXYJJkmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fa638wcsQfgLS4Cs/7BKlsKy/AGbGDM4rRqnE/6DsO/IaK9VlAGJ/gUq0+jZk5m3kxf9S0n3BLmbMPPJ+URW3x5VQCSGPK56J8VnTKwplnN39IiN3bcfuypHOC/pG0xf/xZu6NY6jsdRTSJNEUjqRf9kNcyzYkA3hYjMQxQpB7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e30f7JMk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e30f7JMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA191F000E9;
	Thu, 20 Aug 2026 17:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248323;
	bh=m78MC7tTGy4PnUjG0bmdeVc8lYw4rJdPjDynHJYFbBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e30f7JMkgcx1BzTvwqPtiD3Bc46FBtZ1A9MdjCJc7Qqcq1U30kqT6bEzpv7xrMQQz
	 Xwg6kARqSZeK4FUck7gbFB5pj7zVouwiCrmkemWyYXbZrzFIarMDCNrA/HJnIg1aUw
	 c9+EBaFHEhw/RBGhx3kEh4ptxyG3JMJiLXR0c2CQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Dexuan Cui <decui@microsoft.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 149/303] net: mana: Validate the packet length reported by the NIC
Date: Thu, 20 Aug 2026 16:54:45 +0200
Message-ID: <20260820145257.764169742@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

From: Dexuan Cui <decui@microsoft.com>

[ Upstream commit 2e2a83b4998af4384e677d3b2ac08565274279bf ]

Validate the packet length reported in the RX CQE before passing it
to skb processing. The CQE is supplied by the NIC device and should
not be blindly trusted.

Cc: stable@vger.kernel.org
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Link: https://patch.msgid.link/20260702041237.617719-2-decui@microsoft.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1249,6 +1249,19 @@ static void mana_process_rx_cqe(struct m
 	rxbuf_oob = &rxq->rx_oobs[curr];
 	WARN_ON_ONCE(rxbuf_oob->wqe_inf.wqe_size_in_bu != 1);
 
+	if (unlikely(pktlen > rxq->datasize)) {
+		/* Increase it even if mana_rx_skb() isn't called. */
+		rxq->rx_cq.work_done++;
+
+		++ndev->stats.rx_dropped;
+		netdev_warn_once(ndev,
+				 "Dropped oversized RX packet: len=%u, datasize=%u\n",
+				 pktlen, rxq->datasize);
+
+		/* Reuse the RX buffer since rxbuf_oob is unchanged. */
+		goto drop;
+	}
+
 	/* Reuse XDP dropped page if available */
 	if (rxq->xdp_save_page) {
 		new_page = rxq->xdp_save_page;


