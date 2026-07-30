Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160B844E02A;
	Thu, 30 Jul 2026 16:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428269; cv=none; b=kXHkB+8672C2KA6Mly/GG+mySwUbMJBoIpImdNAXLz1E41vgL1tzJvuqLSarZdYLpP3Q9666M0574pAm8MDnoP6HHfKd52uaaM8b9jummZxS8IygiIhHC7NZQSxHEO8RNrMQto2JSb0rSNDlL3E328dBkBUdP0luo2xnkU4wF8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428269; c=relaxed/simple;
	bh=Lc1rCj/3VsR3znzOJbnqJkDhOm1inlrBHn1rbCKvjFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Emsq5nnl9dxuwCKsknXY45K2gMSm/CFKoWZGR73ns7cmuOaWqnRUBK8LfWkdKm4EGyBoMx1OR2AUJJeKCmWxsPerDm8Aa1OQO/Z/q3kic7oBQTwBmQkhBSFyJW9d0MYKbTQdc9A7e+7LU8WoYaxJXlt6TFvwmeJUc41E39G1h9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eab2YZBx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eab2YZBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CEF1F000E9;
	Thu, 30 Jul 2026 16:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428268;
	bh=miT3r2Br5C03vl/5P8N9lZtKUfKqJaQBgXGiC50bD+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eab2YZBxxDXwf4qvKJDVxccG+eo2ih/yij6qVaCXiny4yTwWoX4QR/6EDjJ7ufjQx
	 DE2eWEr43fhoP0sKp1DvJQQ8XNFLe+PSy/oghS0E6HfFenIp5IBkgRJsVqThBS2dc9
	 obXSm6i/gWOh/xToIrSWCxrAHh3//HHmiqZWlYSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Dexuan Cui <decui@microsoft.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 460/484] net: mana: Validate the packet length reported by the NIC
Date: Thu, 30 Jul 2026 16:15:57 +0200
Message-ID: <20260730141433.478329689@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1739,6 +1739,19 @@ static void mana_process_rx_cqe(struct m
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
 	mana_refill_rx_oob(dev, rxq, rxbuf_oob, &old_buf, &old_fp);
 
 	/* Unsuccessful refill will have old_buf == NULL.


