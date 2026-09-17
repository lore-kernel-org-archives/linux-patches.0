Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5909D2C1788;
	Thu, 17 Sep 2026 15:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660493; cv=none; b=fqSevCod9pQnJJejG8YdHGbmcwXGsi0MixJqNWJiHac6htETyt3GgRJTU4uQ6NwcO7c6qOxyq1UdsPBOvewOpD9vzgkK4+On2tWWMLjlY3FVCu6fnoGEoS+YaTYs6ElNnM5vKIpb8eiD2vzWMFrUSuLLVWKlupEGQYPEnVnO3F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660493; c=relaxed/simple;
	bh=RABZM4GEZjoKhnZbc29gNzHi9n7PG4uozv0LOaFji9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtReRyQe7enYU+Pxey1o4f+tW8g/bKV92t52Im9ix5YuB3SP6YFJkZUR8BKk8xtDWHTlQ1qECN2tJ+ckJanB1j2qu+zLpZ75T0CbHcymwBJpaqgweI+2Patn3mZfDuXIpKHLGJpaQuDT09HyMEsj5LFC9kA10a6/RTTP4aBC2qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTZSnaz6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTZSnaz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBEE1F000FF;
	Thu, 17 Sep 2026 15:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660492;
	bh=+EVcc7xjUpI+7uO+G45c2SZwajczRyjTnAJtC1ZMgQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hTZSnaz6XFgA/kBVaKc0mG5+rC+TI9K4HLPNO4UxDTqb49IPnIUa3xEeuz27KKJlz
	 wfVAerUBVEVQuKLTlg2B5lFOg/b0StL/94SaFduQV4F0qW3YJ/8/V3LaibVHHspu2h
	 FCfEbupReXAHJ8xVZUvJdROYadQiIyZoIqvaA85U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Joe Damato <joe@dama.to>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.2 609/733] bnxt_en: Propagate TPA buffer allocation failures in bnxt_queue_mem_alloc()
Date: Thu, 17 Sep 2026 16:15:17 +0100
Message-ID: <20260917151407.669087985@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Damato <joe@dama.to>

commit b814dfbfeb0a68c9a52073f2caa05a2d5247a329 upstream.

bnxt_alloc_one_tpa_info_data() returns -ENOMEM as soon as one allocation
fails. This leaves the remaining rxr->rx_tpa[] entries zeroed.

bnxt_queue_mem_alloc() discards that return value, so the partially
initialized ring is installed by bnxt_queue_start().

Since the agg_id is picked by the hardware and bnxt_alloc_agg_idx maps
it to a SW index in rxr->rx_tpa[], it is possible that an uninitialized
slot can be chosen which would hand a zero DMA address to the device.

Fix this by checking the return value of bnxt_alloc_one_tpa_info_data
and unwinding, freeing the ring buffers.

Fixes: bd649c5cc958 ("bnxt_en: handle tpa_info in queue API implementation")
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260828190900.1767611-1-joe%40dama.to
Cc: stable@vger.kernel.org
Signed-off-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260902015652.2421609-4-joe@dama.to
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -16347,11 +16347,16 @@ static int bnxt_queue_mem_alloc(struct n
 	bnxt_alloc_one_rx_ring_skb(bp, clone, idx);
 	if (bp->flags & BNXT_FLAG_AGG_RINGS)
 		bnxt_alloc_one_rx_ring_netmem(bp, clone, idx);
-	if (bp->flags & BNXT_FLAG_TPA)
-		bnxt_alloc_one_tpa_info_data(bp, clone);
+	if (bp->flags & BNXT_FLAG_TPA) {
+		rc = bnxt_alloc_one_tpa_info_data(bp, clone);
+		if (rc)
+			goto err_free_rx_ring_skbs;
+	}
 
 	return 0;
 
+err_free_rx_ring_skbs:
+	bnxt_free_one_rx_ring_skbs(bp, clone);
 err_free_tpa_info:
 	bnxt_free_one_tpa_info(bp, clone);
 err_free_rx_agg_ring:


