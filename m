Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8943644AF;
	Tue, 12 May 2026 18:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609726; cv=none; b=sFj5DizSqIenhLylN/BWiHIXCQRmVhWwstKFGjwWmB1YlyXUvln6UXqH4Q/N56CxRoWFBPkLWM4oxxMLPF9iibcsowv82uskaJDGF6dOiECN2m6TXRA9KrcZhvpgib5ZQVjqWFrJogY578prSXfBxtg7evGC13tOJj9oT1axnt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609726; c=relaxed/simple;
	bh=cgdnS2/iR5/1T6UYOglTO6H4G5wlrJ3kh+NEyjv66ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QE0XHNns23bB0gLWXnFcmUzxmQjBRmYcimAUt6MD6MKVVffvWXzNRmY+DPSa3yFdvN6YXoE8fkz4tDC0tkjfbqjicPXfbAsiUXyNga8NvVgIUQ8pdcttIxwu16+p5xYPHAqGibDl2wUkOn31pdIJNPWtpVeIT+v0dyeq7Au2qpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sy5F1lmD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sy5F1lmD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C840C2BCB0;
	Tue, 12 May 2026 18:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609725;
	bh=cgdnS2/iR5/1T6UYOglTO6H4G5wlrJ3kh+NEyjv66ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sy5F1lmDZAKKglPlgQw/97TwxKGRSsLfGig4/RaIOp+L1O0J9mxSlMagB4bTODY2G
	 nb5850mjzBrO2U56zXWKbQjnajPI+9AOFKndAbfZTc7+OnyTru7nx6AMhlyoKooRrX
	 M++GgVcbLx8gtn60GlWJhyjokKik0NHFM8ZJYBPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 292/307] octeon_ep_vf: add NULL check for napi_build_skb()
Date: Tue, 12 May 2026 19:41:27 +0200
Message-ID: <20260512173946.288313772@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

[ Upstream commit dd66b42854705e4e4ee7f14d260f86c578bed3e3 ]

napi_build_skb() can return NULL on allocation failure. In
__octep_vf_oq_process_rx(), the result is used directly without a NULL
check in both the single-buffer and multi-fragment paths, leading to a
NULL pointer dereference.

Add NULL checks after both napi_build_skb() calls, properly advancing
descriptors and consuming remaining fragments on failure.

Fixes: 1cd3b407977c ("octeon_ep_vf: add Tx/Rx processing and interrupt support")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Link: https://patch.msgid.link/20260409184009.930359-3-devnexen@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ inlined missing octep_vf_oq_next_idx() helper as read_idx++ with wraparound ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_rx.c |   36 +++++++++++++++-
 1 file changed, 34 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_rx.c
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_rx.c
@@ -409,10 +409,17 @@ static int __octep_vf_oq_process_rx(stru
 			data_offset = OCTEP_VF_OQ_RESP_HW_SIZE;
 			rx_ol_flags = 0;
 		}
-		rx_bytes += buff_info->len;
-
 		if (buff_info->len <= oq->max_single_buffer_size) {
 			skb = napi_build_skb((void *)resp_hw, PAGE_SIZE);
+			if (!skb) {
+				oq->stats->alloc_failures++;
+				desc_used++;
+				read_idx++;
+				if (read_idx == oq->max_count)
+					read_idx = 0;
+				continue;
+			}
+			rx_bytes += buff_info->len;
 			skb_reserve(skb, data_offset);
 			skb_put(skb, buff_info->len);
 			read_idx++;
@@ -424,6 +431,31 @@ static int __octep_vf_oq_process_rx(stru
 			u16 data_len;
 
 			skb = napi_build_skb((void *)resp_hw, PAGE_SIZE);
+			if (!skb) {
+				oq->stats->alloc_failures++;
+				desc_used++;
+				read_idx++;
+				if (read_idx == oq->max_count)
+					read_idx = 0;
+				data_len = buff_info->len - oq->max_single_buffer_size;
+				while (data_len) {
+					dma_unmap_page(oq->dev, oq->desc_ring[read_idx].buffer_ptr,
+						       PAGE_SIZE, DMA_FROM_DEVICE);
+					buff_info = (struct octep_vf_rx_buffer *)
+						    &oq->buff_info[read_idx];
+					buff_info->page = NULL;
+					if (data_len < oq->buffer_size)
+						data_len = 0;
+					else
+						data_len -= oq->buffer_size;
+					desc_used++;
+					read_idx++;
+					if (read_idx == oq->max_count)
+						read_idx = 0;
+				}
+				continue;
+			}
+			rx_bytes += buff_info->len;
 			skb_reserve(skb, data_offset);
 			/* Head fragment includes response header(s);
 			 * subsequent fragments contains only data.


