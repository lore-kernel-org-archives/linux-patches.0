Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD3F23F413;
	Tue, 22 Jul 2025 14:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193455; cv=none; b=a0l9QWMtUT5Kj3xrGrbhaWIKBMlsoPeYB8kX9JI9wrackEmgYrvO34Rx5lghHu/v4EE4INFU6cozA/VdeId5FKrrF+AqLo1Kzr0TPNky28sNYq4O+EotxLVDrxcSYc/Fs6GD9MxEMK8ykmBLdBMQm9XM2pI1bJ52MiAMaZdy76U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193455; c=relaxed/simple;
	bh=J4SLfmTfRxvOooZwUZqtXHKzmH+TAofBeMZn6R/G5zA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXnUz94AvAHqZ6Ir4gDBONbO7d35ZxG/vGm0++SIuHwu/WepfWTNCAFkWcrAvdYJROkd/Ay3yL7cy2GOMWOvlUQa4DWdYkHQIzVk36wsfdAYWiejHIx5/hkgfqJQSIX7DQwpzSQusehT0hI1TDDRdk2EG2/WdYosqXvuT44V/qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrDMzOMp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrDMzOMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004E4C4CEEB;
	Tue, 22 Jul 2025 14:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193455;
	bh=J4SLfmTfRxvOooZwUZqtXHKzmH+TAofBeMZn6R/G5zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zrDMzOMpZJ+4mROolfoGl72b4qf+DVgEAmdykcirLXrswUlBwibkMwJry0M6T3uR4
	 5oJABEyiEuRelq8+VtV4xQoQC2ALRE1CsmtTl0oz4V3r3b6zOOZRc83N/z5mZTKnZF
	 MsMxo+yedNEpCA/5s8/RSkFnLDlGFxIQk/US95xY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.15 070/187] net: libwx: fix the using of Rx buffer DMA
Date: Tue, 22 Jul 2025 15:44:00 +0200
Message-ID: <20250722134348.346071599@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

commit 5fd77cc6bd9b368431a815a780e407b7781bcca0 upstream.

The wx_rx_buffer structure contained two DMA address fields: 'dma' and
'page_dma'. However, only 'page_dma' was actually initialized and used
to program the Rx descriptor. But 'dma' was uninitialized and used in
some paths.

This could lead to undefined behavior, including DMA errors or
use-after-free, if the uninitialized 'dma' was used. Althrough such
error has not yet occurred, it is worth fixing in the code.

Fixes: 3c47e8ae113a ("net: libwx: Support to receive packets in NAPI")
Cc: stable@vger.kernel.org
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250714024755.17512-3-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c  |    4 ++--
 drivers/net/ethernet/wangxun/libwx/wx_type.h |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -306,7 +306,7 @@ static bool wx_alloc_mapped_page(struct
 		return false;
 	dma = page_pool_get_dma_addr(page);
 
-	bi->page_dma = dma;
+	bi->dma = dma;
 	bi->page = page;
 	bi->page_offset = 0;
 
@@ -343,7 +343,7 @@ void wx_alloc_rx_buffers(struct wx_ring
 						 DMA_FROM_DEVICE);
 
 		rx_desc->read.pkt_addr =
-			cpu_to_le64(bi->page_dma + bi->page_offset);
+			cpu_to_le64(bi->dma + bi->page_offset);
 
 		rx_desc++;
 		bi++;
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -947,7 +947,6 @@ struct wx_tx_buffer {
 struct wx_rx_buffer {
 	struct sk_buff *skb;
 	dma_addr_t dma;
-	dma_addr_t page_dma;
 	struct page *page;
 	unsigned int page_offset;
 };


