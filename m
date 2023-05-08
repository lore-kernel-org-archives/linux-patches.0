Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2376E168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF0AC433A0;
	Mon,  8 May 2023 11:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544582;
	bh=0EtESPJ9ns3FZ29SfoOrK+BwKaLqd1DG0mtlEAfj15s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EQ1NH1Ve1oLttepzVobtnx1mb+3Qzsa+Q3aeJsX6xugq75I+TzcvWyCQqwsCzSYwo
	 gaLzsmlhQztJ6O3Olcc6B63u+eJaEBU5mMsmtQij4sh7i6q/wzVGx1LqgANJMRdoUI
	 k68At3Uh3EGZnOi4RbU8qUe1Hqy1A9ro02QwffwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Simon Horman <simon.horman@corigine.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 457/694] net: libwx: fix memory leak in wx_setup_rx_resources
Date: Mon,  8 May 2023 11:44:52 +0200
Message-Id: <20230508094448.456184109@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit e315e7b83a22043bffee450437d7089ef373cbf6 ]

When wx_alloc_page_pool() failed in wx_setup_rx_resources(), it doesn't
release DMA buffer. Add dma_free_coherent() in the error path to release
the DMA buffer.

Fixes: 850b971110b2 ("net: libwx: Allocate Rx and Tx resources")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230418065450.2268522-1-shaozhengchao@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index eb89a274083e7..1e8d8b7b0c62e 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -1798,10 +1798,13 @@ static int wx_setup_rx_resources(struct wx_ring *rx_ring)
 	ret = wx_alloc_page_pool(rx_ring);
 	if (ret < 0) {
 		dev_err(rx_ring->dev, "Page pool creation failed: %d\n", ret);
-		goto err;
+		goto err_desc;
 	}
 
 	return 0;
+
+err_desc:
+	dma_free_coherent(dev, rx_ring->size, rx_ring->desc, rx_ring->dma);
 err:
 	kvfree(rx_ring->rx_buffer_info);
 	rx_ring->rx_buffer_info = NULL;
-- 
2.39.2



