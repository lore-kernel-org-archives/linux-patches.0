Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1632EF29C;
	Thu,  3 Jul 2025 14:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554283; cv=none; b=Cpui7sTnBkI5BalE7W3zy0seCG9UszzTklpC3PHKRIxzjAajSjhoZzS6oeWASchZsUVLX2Fh4H2J7UzPKXXkriQ82LlJh8WfgM4ps7PiZoTtYXTSyflPv+u5Q/ZT3MDTGbNeaBDYNobTVt49zVUmMmccXuynhXP+njJEO3XpLh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554283; c=relaxed/simple;
	bh=ZL5YP6zVy7mjdEZaD0++D44nhG1pQjqbDcFqKAb0JfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MiBhR/oSx+zfROjNhIY/D1F02WgZ3bpadSpq1Y4zR+kKjWkzu7Sy/pyOIXsN/QEiiIZ/RKjI7NOpETBMJjjDwhshEiy966UyBWoO9pAZSra0L63R43tivO8/gL+TMWpf1mM56JHz45mlEuCAMoxr8wvpw4EFho9VqHnmVhocbaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WKBAGNhb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WKBAGNhb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D538C4CEED;
	Thu,  3 Jul 2025 14:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554283;
	bh=ZL5YP6zVy7mjdEZaD0++D44nhG1pQjqbDcFqKAb0JfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKBAGNhbBG2e03AgqsPxiwm42ASAVXNBt39MLvQ6o7swockUyJlmd1pqq9Di3i6ba
	 Vm71KGGpOLU9VEEtzOfHW5IbEBrhx4GVI1FRbHojfEHqnkTCoWIeDE0and25+9DTep
	 bZkD5Yr/qE5K9YWEpk9schkUQfV9jjE5dJ050LE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Simon Horman <horms@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 138/218] net: libwx: fix the creation of page_pool
Date: Thu,  3 Jul 2025 16:41:26 +0200
Message-ID: <20250703144001.648362582@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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
@@ -2425,7 +2425,7 @@ static int wx_alloc_page_pool(struct wx_
 	struct page_pool_params pp_params = {
 		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
 		.order = 0,
-		.pool_size = rx_ring->size,
+		.pool_size = rx_ring->count,
 		.nid = dev_to_node(rx_ring->dev),
 		.dev = rx_ring->dev,
 		.dma_dir = DMA_FROM_DEVICE,


