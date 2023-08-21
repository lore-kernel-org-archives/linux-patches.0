Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CD41171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EDD9C433C8;
	Mon, 21 Aug 2023 20:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648483;
	bh=gdMlTlce/QpDXlz4WrUfLf/KiAVwMwkr10LkZ/NTYH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dAk3OyUdLaro1b0AoTj0NdNaujrf0irrNzyxlptX4+F6Dqr28lXHw+ialPISu05DB
	 nMofojyfj5eON9XVPiNU8ObxQxEY7CYxZNXKq6ehX27eYpM0XKS9JlYQx6he48yV/l
	 uQa4XRon615EuOq5PWKBYxq2rdxFHdpfkXBQajlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Liang Chen <liangchen.linux@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 154/234] net: veth: Page pool creation error handling for existing pools only
Date: Mon, 21 Aug 2023 21:41:57 +0200
Message-ID: <20230821194135.622503945@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liang Chen <liangchen.linux@gmail.com>

[ Upstream commit 8a519a572598b7c0c07b02f69bf5b4e8dd4b2d7d ]

The failure handling procedure destroys page pools for all queues,
including those that haven't had their page pool created yet. this patch
introduces necessary adjustments to prevent potential risks and
inconsistency with the error handling behavior.

Fixes: 0ebab78cbcbf ("net: veth: add page_pool for page recycling")
Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>
Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
Link: https://lore.kernel.org/r/20230812023016.10553-1-liangchen.linux@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index dce9f9d63e04e..76019949e3fe9 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1071,8 +1071,9 @@ static int __veth_napi_enable_range(struct net_device *dev, int start, int end)
 err_xdp_ring:
 	for (i--; i >= start; i--)
 		ptr_ring_cleanup(&priv->rq[i].xdp_ring, veth_ptr_free);
+	i = end;
 err_page_pool:
-	for (i = start; i < end; i++) {
+	for (i--; i >= start; i--) {
 		page_pool_destroy(priv->rq[i].page_pool);
 		priv->rq[i].page_pool = NULL;
 	}
-- 
2.40.1



