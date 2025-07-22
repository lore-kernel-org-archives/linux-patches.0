Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6500D2DC32B;
	Tue, 22 Jul 2025 13:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192465; cv=none; b=f8Fczq15A0rWFGl7oDu9d3Q2etKABkDfUxsbT07GSKgvzrq1/TBpsXUt2Lb4yaqVZGmpcoTQjD5yp8tqxmrsxps/+n1f6faM0ozbTUwLPCOrn4fz3h8KyrfUMx+zqarG8p4bRzMr1kVLwsKn8dCmDnn9m3+TyT1takCnod39VN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192465; c=relaxed/simple;
	bh=vs6/+OZEsUhnEk8iA30oubQtfVBT5tVhSWIqIBUrm8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3vvDMQ+iVU/xht+HLVjip249W7SeTTbC8GJ2bTdeX3kYOE8/OpVU/N7VQb9fg8ljNoVZID0y5AjvDGSt7qZnycdyyi8+Bk4ta/kFsloXTTP1fpwNezjxBnWx2RBECdb70lKajuxsvQvljpXTm1NTo0eDkp7dy92iuCjAFZD05U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nzH+X1/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nzH+X1/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E85C4CEEB;
	Tue, 22 Jul 2025 13:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192465;
	bh=vs6/+OZEsUhnEk8iA30oubQtfVBT5tVhSWIqIBUrm8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nzH+X1/ubGZcS5C7+kful0EQq9WeJB3to6PBNgnGtwO6wRj1AMxQ0KzkPbRu4eCzG
	 sQVHCo01eoTWsWSZld/ZfWHZa64TZUnd63Kwr8gfspgyNmW2PFcEuEVOYKqDDeNjNR
	 usQxPoNUL3OkwMXuy2mMypEu6iHuLsPH4fMKxoz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 040/111] net: libwx: fix the using of Rx buffer DMA
Date: Tue, 22 Jul 2025 15:44:15 +0200
Message-ID: <20250722134334.892325321@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -307,7 +307,7 @@ static bool wx_alloc_mapped_page(struct
 		return false;
 	dma = page_pool_get_dma_addr(page);
 
-	bi->page_dma = dma;
+	bi->dma = dma;
 	bi->page = page;
 	bi->page_offset = 0;
 
@@ -344,7 +344,7 @@ void wx_alloc_rx_buffers(struct wx_ring
 						 DMA_FROM_DEVICE);
 
 		rx_desc->read.pkt_addr =
-			cpu_to_le64(bi->page_dma + bi->page_offset);
+			cpu_to_le64(bi->dma + bi->page_offset);
 
 		rx_desc++;
 		bi++;
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -755,7 +755,6 @@ struct wx_tx_buffer {
 struct wx_rx_buffer {
 	struct sk_buff *skb;
 	dma_addr_t dma;
-	dma_addr_t page_dma;
 	struct page *page;
 	unsigned int page_offset;
 };


