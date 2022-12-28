Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE0C1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5482FC433EF;
	Wed, 28 Dec 2022 16:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246065;
	bh=QG4DOtGBvWPfutdY4gutfUHbJvS+CD5uT6XcePVcGuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NSC3jzwmY8oLYQ297txHXMp6n7QtegWyNqdEpKho0Yee6bb5XgbxnDKHtHHdTLb5Y
	 s8Y2J6Hfo3H03kPxkVF+Gn3ALzLQ/1EKOgjMMs/tmyXH9IVkGixj3oSrOrzclA3ldY
	 7tfxn0ZUsMTYnkxP4pQ2d96WWV6Iy8q8gTSciVWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasesh Mody <rmody@marvell.com>,
	GR-Linux-NIC-Dev@marvell.com,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0975/1146] bnx2: Use kmalloc_size_roundup() to match ksize() usage
Date: Wed, 28 Dec 2022 15:41:54 +0100
Message-Id: <20221228144356.835878357@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

[ Upstream commit d6dd508080a3cdc0ab34ebf66c3734f2dff907ad ]

Round up allocations with kmalloc_size_roundup() so that build_skb()'s
use of ksize() is always accurate and no special handling of the memory
is needed by KASAN, UBSAN_BOUNDS, nor FORTIFY_SOURCE.

Cc: Rasesh Mody <rmody@marvell.com>
Cc: GR-Linux-NIC-Dev@marvell.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221022021004.gonna.489-kees@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index fec57f1982c8..dbe310144780 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -5415,8 +5415,9 @@ bnx2_set_rx_ring_size(struct bnx2 *bp, u32 size)
 
 	bp->rx_buf_use_size = rx_size;
 	/* hw alignment + build_skb() overhead*/
-	bp->rx_buf_size = SKB_DATA_ALIGN(bp->rx_buf_use_size + BNX2_RX_ALIGN) +
-		NET_SKB_PAD + SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	bp->rx_buf_size = kmalloc_size_roundup(
+		SKB_DATA_ALIGN(bp->rx_buf_use_size + BNX2_RX_ALIGN) +
+		NET_SKB_PAD + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
 	bp->rx_jumbo_thresh = rx_size - BNX2_RX_OFFSET;
 	bp->rx_ring_size = size;
 	bp->rx_max_ring = bnx2_find_max_ring(size, BNX2_MAX_RX_RINGS);
-- 
2.35.1



