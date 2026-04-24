Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D633563D4;
	Fri, 24 Apr 2026 13:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037839; cv=none; b=hJMXF/GTJjZTjJ+0q2uy6dWgcjKcd9ngxHy0ktO8nnqp6zXw08+UE49yd4BDPaoou1/gE7mWvowyeCWAPkrDVwRrHTUz+OfIO4u1EaveTF3MSDNIkmTV3jcP/JvM7oxzRXRm0X6+IU+nCJYFO0bbbo3fKjhsARxYQX6DDf9xceg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037839; c=relaxed/simple;
	bh=otUiT2AahbuXJo6T4aqBi3fKjRR48JOLvgFzBZ1O/Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g/VI2m0PCJfYhjDcnKMXFVzax+gqkT71ECSyPUomVluUygaML/DTynPesL0cbrt39RSItjzCcC7m6b9nSWRvEUJIfEjprkuSbdSQpHVXysiePyKq+DnCD2ysKQnTUzHmIHHQUkSZz/uXKwcr5BFh4GWdSP2HDV4HffZzQe/xVDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=viGbsqw6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="viGbsqw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0D9C2BCB5;
	Fri, 24 Apr 2026 13:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037839;
	bh=otUiT2AahbuXJo6T4aqBi3fKjRR48JOLvgFzBZ1O/Z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=viGbsqw6NnqWzzmufgOmLPMMIkYZ53Ev+7dtjcqLntjCQKiyTaCJQZ5bcHRfN3fOT
	 jHrrsBXy6HUHB1ZwiJ+d40qi+KGw6msI8rc3avUzfXqmMbYolwyP6nhP2jXY++CD8U
	 BLUuBkfXuv4AWyWp7CB7YYUz7H1o3dkP6Vjza+JU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/166] xsk: validate MTU against usable frame size on bind
Date: Fri, 24 Apr 2026 15:29:21 +0200
Message-ID: <20260424132542.652138453@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 net/xdp/xsk_buff_pool.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 52c4204bc224e..bb9dfbe419e7c 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -8,6 +8,8 @@
 #include "xdp_umem.h"
 #include "xsk.h"
 
+#define ETH_PAD_LEN (ETH_HLEN + 2 * VLAN_HLEN  + ETH_FCS_LEN)
+
 void xp_add_xsk(struct xsk_buff_pool *pool, struct xdp_sock *xs)
 {
 	unsigned long flags;
@@ -149,8 +151,12 @@ static void xp_disable_drv_zc(struct xsk_buff_pool *pool)
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
@@ -170,7 +176,7 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 	if (err)
 		return err;
 
-	if (flags & XDP_USE_SG)
+	if (mbuf)
 		pool->umem->flags |= XDP_UMEM_SG_FLAG;
 
 	if (flags & XDP_USE_NEED_WAKEUP)
@@ -192,8 +198,24 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
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



