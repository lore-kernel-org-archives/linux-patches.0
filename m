Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220864C901F;
	Mon, 20 Apr 2026 13:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691996; cv=none; b=CLxGxG+9q88snmFsPMY2FD0F0Tr33NlV4cTIltzDvYjz1CwbSsGkT9zD1HXjsFYsWrijw/N5E7axeKDqUAP4SbIXyyJz0O9vLmuX+PirQn8hVNWfGTMwgCnzuTPUQNrNes3PUlrZx2mmIyNqXxoNXzyF3YfMonO6xr9CyG8DDFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691996; c=relaxed/simple;
	bh=8IuyPOdlgEEHqblmwh+5zj4LIO3kR3cdpVBKlbJTs9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EkbKze04OqXyTcXob1Jgq8ynHZB2qADBrmRz20Cy+f1hYlhxecXDfTi/T0/+oamV5J8Ro8C9cyn4imEkiNII3+I6my9qnWIAHE8XbF38rR/rO7/ye2QZ/8SwJaQa7ZBR/L0zPqTPG0ZyXhDkjmehSUlpFrvCGrqUBpicTGn4S2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NVyXIYdB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NVyXIYdB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7243BC19425;
	Mon, 20 Apr 2026 13:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691995;
	bh=8IuyPOdlgEEHqblmwh+5zj4LIO3kR3cdpVBKlbJTs9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NVyXIYdBhwaMtVH/RSJVuzCL1HP6I7ftf4G9+xxqvwrI/fAK0xl+qTqHZsdLhaXkX
	 i60zE7PSSmQRqEznTv2sU/rzGx2H9w8FCU+Crnsju/w6TTp9FbyRYY/TdivGtV8Crg
	 43Ci8rcFdfpD2x5L5ovPRf3q0er947MPNpvN4I050QbR/uIcmBDbAZBu7iQmQiIvVK
	 p8rMXWEYaGMhvyyAh4cVkLf4r4oc2nLuCbEHY+5vlpeDwfaG+BukgDfyvkE+fsrc+I
	 6ABU9cFaJDcuXv4wiKl12LkqZwMx4NeZ/tMbSSI2SDN5CXBcXmvQlAw4pLM5HWVteK
	 WFk9PoCQ55lCQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	magnus.karlsson@intel.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	ast@kernel.org,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] xsk: validate MTU against usable frame size on bind
Date: Mon, 20 Apr 2026 09:21:46 -0400
Message-ID: <20260420132314.1023554-312-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 36ee60b569ba0dfb6f961333b90d19ab5b323fa9 ]

AF_XDP bind currently accepts zero-copy pool configurations without
verifying that the device MTU fits into the usable frame space provided
by the UMEM chunk.

This becomes a problem since we started to respect tailroom which is
subtracted from chunk_size (among with headroom). 2k chunk size might
not provide enough space for standard 1500 MTU, so let us catch such
settings at bind time. Furthermore, validate whether underlying HW will
be able to satisfy configured MTU wrt XSK's frame size multiplied by
supported Rx buffer chain length (that is exposed via
net_device::xdp_zc_max_segs).

Fixes: 24ea50127ecf ("xsk: support mbuf on ZC RX")
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://patch.msgid.link/20260402154958.562179-5-maciej.fijalkowski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 net/xdp/xsk_buff_pool.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 677c7d00f8c32..a129ce6f1c25f 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -10,6 +10,8 @@
 #include "xdp_umem.h"
 #include "xsk.h"
 
+#define ETH_PAD_LEN (ETH_HLEN + 2 * VLAN_HLEN  + ETH_FCS_LEN)
+
 void xp_add_xsk(struct xsk_buff_pool *pool, struct xdp_sock *xs)
 {
 	unsigned long flags;
@@ -165,8 +167,12 @@ static void xp_disable_drv_zc(struct xsk_buff_pool *pool)
 int xp_assign_dev(struct xsk_buff_pool *pool,
 		  struct net_device *netdev, u16 queue_id, u16 flags)
 {
+	u32 needed = netdev->mtu + ETH_PAD_LEN;
+	u32 segs = netdev->xdp_zc_max_segs;
+	bool mbuf = flags & XDP_USE_SG;
 	bool force_zc, force_copy;
 	struct netdev_bpf bpf;
+	u32 frame_size;
 	int err = 0;
 
 	ASSERT_RTNL();
@@ -186,7 +192,7 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 	if (err)
 		return err;
 
-	if (flags & XDP_USE_SG)
+	if (mbuf)
 		pool->umem->flags |= XDP_UMEM_SG_FLAG;
 
 	if (flags & XDP_USE_NEED_WAKEUP)
@@ -208,8 +214,24 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 		goto err_unreg_pool;
 	}
 
-	if (netdev->xdp_zc_max_segs == 1 && (flags & XDP_USE_SG)) {
-		err = -EOPNOTSUPP;
+	if (mbuf) {
+		if (segs == 1) {
+			err = -EOPNOTSUPP;
+			goto err_unreg_pool;
+		}
+	} else {
+		segs = 1;
+	}
+
+	/* open-code xsk_pool_get_rx_frame_size() as pool->dev is not
+	 * set yet at this point; we are before getting down to driver
+	 */
+	frame_size = __xsk_pool_get_rx_frame_size(pool) -
+		     xsk_pool_get_tailroom(mbuf);
+	frame_size = ALIGN_DOWN(frame_size, 128);
+
+	if (needed > frame_size * segs) {
+		err = -EINVAL;
 		goto err_unreg_pool;
 	}
 
-- 
2.53.0

