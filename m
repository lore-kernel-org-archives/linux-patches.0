Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49B12ED143;
	Thu,  3 Jul 2025 15:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555143; cv=none; b=Mn0XrlJxE0M7829Nxehqjc71mMzgw4Z+a4ahjnMgxUpSeVohPHm8CWEIKt5xN5Djx/QgZo6/VqDko97A9GlUxhONb+uUAkBBM2OASqobUpr8CpwS74IMziij8165ZhALiR0iuA7Cb6XvJInY6BiqxXSSW+1fn5qpJv7WjGsJ6yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555143; c=relaxed/simple;
	bh=C8RCy3NirBWMXCAuOqR/5B69OvxMwDFfRCnrgGs0+ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCnpiQTYGQoz+sm69tlw0YsuSBEQB0pBqFCc3D3pRuWLMlThYl2dJK5twrO1EtCdHIcxnrI4Sxsn1+eYX5yC4YbVAYt5gP+Z7gMHPIW6BIfKA+h0XVqlcBP57GSxvhRqItyeQbc5ztR0oJpLYMTKqBq5Quvzrece+NiK2I+Ddbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZOilGCkf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZOilGCkf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55261C4CEE3;
	Thu,  3 Jul 2025 15:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555142;
	bh=C8RCy3NirBWMXCAuOqR/5B69OvxMwDFfRCnrgGs0+ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZOilGCkfAnt/6GwjLEc+HNLPfSd+0FWUYK2RXbE47Aoi+Xwx4q6ar126rfQhUXlz3
	 GzLNXapQ9vGrd2zzqfRqW0qsPTXQgcLLt3HsRhFka6TPna8TSCworT2g+p+ofGndH8
	 W72GPQGS29zvwUkKUzyktl+nhR7H1xpkZ8OP9jMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Simon Horman <horms@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.15 187/263] net: libwx: fix the creation of page_pool
Date: Thu,  3 Jul 2025 16:41:47 +0200
Message-ID: <20250703144011.840937566@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

commit 85720e04d9af0b77f8092b12a06661a8d459d4a0 upstream.

'rx_ring->size' means the count of ring descriptors multiplied by the
size of one descriptor. When increasing the count of ring descriptors,
it may exceed the limit of pool size.

[ 864.209610] page_pool_create_percpu() gave up with errno -7
[ 864.209613] txgbe 0000:11:00.0: Page pool creation failed: -7

Fix to set the pool_size to the count of ring descriptors.

Fixes: 850b971110b2 ("net: libwx: Allocate Rx and Tx resources")
Cc: stable@vger.kernel.org
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/434C72BFB40E350A+20250625023924.21821-1-jiawenwu@trustnetic.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -2496,7 +2496,7 @@ static int wx_alloc_page_pool(struct wx_
 	struct page_pool_params pp_params = {
 		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
 		.order = 0,
-		.pool_size = rx_ring->size,
+		.pool_size = rx_ring->count,
 		.nid = dev_to_node(rx_ring->dev),
 		.dev = rx_ring->dev,
 		.dma_dir = DMA_FROM_DEVICE,


