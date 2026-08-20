Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309BC46C84F;
	Thu, 20 Aug 2026 16:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243597; cv=none; b=KM5NnnT82zFCuacyBbeDeN5F48VYEksa0VIXO1GVnMJPJGoDmanZup/ZDB6+zBCARGaqLuxN+oXamXW7PDRJEerVBRqCqT7QN9CJr8nUphxgy6nsIzhfI5/m4K/nBDMGKwOPqy/6MEKQ3CYvfkT3nFvVePM/X9ylcvgaMYHFWYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243597; c=relaxed/simple;
	bh=aiJTdosWCurIDoIPW9vJGMIPugtorLVR/MC2TkwV5Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4g/cLXrlFLtSJHN/nxApmTPGSqJPJkA0OQ/wwrsj5ZuSkrl3A8DBjfWMKj0McLz3T2TvNfNZhtamtBfxzUujXcm6uJVcxBzAanM8xFoabex3dtpcD7C8ctXDW7qXQBS6lrnDl6A7pRQd/bcXHJVm6Ot/XpwPxmTUhfLtXBOla8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/0ksPH4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/0ksPH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6991F000E9;
	Thu, 20 Aug 2026 16:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243596;
	bh=Z6QYmLrQpLTVraq5/jhLt77IKV+sYYAc2+W/hf8HrL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t/0ksPH480n5buYmJZ40jG+umpJSqoCx4eI4kzHg129Zm8/D3iF8yjq5624fwnTyT
	 DrIk6R0pso/naG4ln6DB9CtXcyswO18nFcd/jHeSpEwL7sn58QEbaNiZrAP/lt5jgn
	 SacaEpqhidM03psrRa2qxjxO50VGAcLMaxmz7bMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Dexuan Cui <decui@microsoft.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 148/272] net: mana: Validate the packet length reported by the NIC
Date: Thu, 20 Aug 2026 16:55:32 +0200
Message-ID: <20260820145235.749398253@linuxfoundation.org>
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
@@ -1021,6 +1021,19 @@ static void mana_process_rx_cqe(struct m
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
 	new_page = alloc_page(GFP_ATOMIC);
 
 	if (new_page) {


