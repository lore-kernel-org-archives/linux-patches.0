Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80FD2E11B6;
	Tue, 22 Jul 2025 14:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192802; cv=none; b=Dk9cJ7w1Qxv3orsbhn3uRCzolP53gbAVIFuKFjYblFNbARD8KeRiZ0TF2K+IazacB8F60RZw82zhFczkqt7NmOuZfIvu9+qFIGTP+amqkhYphkHcZQMCEVhZLG0d9XrcJBwaCXdfhztRUhXAqbT1Van3CIRLbrBeT/78pFnHf+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192802; c=relaxed/simple;
	bh=lDrCfDiv/OEa8K/TZTb1vMEoK9PYCAV4npZKh88nuy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YbdORD6rAPYy3/Gole/SWymvZd1wcUikfliFAIQerTgWH/HgcnkFXXxnc2zzuGlIinlICIjJI5iIaCS/KNu/lTvUikcHMQNdx54bRxnpcF7vT5uV16UL9LjNbJlWDp4Kn0Rjo7SQeEs2gieaYX29YP5S60lUAzoXaJNNSCPgsrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9MdlDDi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9MdlDDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B97C4CEEB;
	Tue, 22 Jul 2025 14:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192802;
	bh=lDrCfDiv/OEa8K/TZTb1vMEoK9PYCAV4npZKh88nuy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k9MdlDDii+85A2lNtBEUeqkE1YDdWWinx8HGX2xOUC459z5ezHOpOtUxlM636583o
	 DPjW+Ov3J7+h/RAKcb9CRxhNU5G0u9889Q7KQGyznwUug1xH9MKu2uJhY6JroUpjlu
	 2DQbPgQrkVE+F6WYPJzGQGSrH08FCviYMMd5/210=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 060/158] net: libwx: fix the using of Rx buffer DMA
Date: Tue, 22 Jul 2025 15:44:04 +0200
Message-ID: <20250722134342.986566113@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -305,7 +305,7 @@ static bool wx_alloc_mapped_page(struct
 		return false;
 	dma = page_pool_get_dma_addr(page);
 
-	bi->page_dma = dma;
+	bi->dma = dma;
 	bi->page = page;
 	bi->page_offset = 0;
 
@@ -342,7 +342,7 @@ void wx_alloc_rx_buffers(struct wx_ring
 						 DMA_FROM_DEVICE);
 
 		rx_desc->read.pkt_addr =
-			cpu_to_le64(bi->page_dma + bi->page_offset);
+			cpu_to_le64(bi->dma + bi->page_offset);
 
 		rx_desc++;
 		bi++;
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -874,7 +874,6 @@ struct wx_tx_buffer {
 struct wx_rx_buffer {
 	struct sk_buff *skb;
 	dma_addr_t dma;
-	dma_addr_t page_dma;
 	struct page *page;
 	unsigned int page_offset;
 };


