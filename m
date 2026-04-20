Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42FB341AD6;
	Mon, 20 Apr 2026 16:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701309; cv=none; b=bFwC/jdpTjHxrY5ROY3iuPSV8qO8KREC2FrNfsMNOFl316ahROL5dzSRq6RD2H1HzcKkZQpOjpkdsWlXTudcQWlQ4SnYTBOboImOiij/zOEMfrhzt4HiwJWMLVDo9f7TxNiPs2bj5res3LpznxmA1mEIVMZ3mIrxMXEh9Eq59b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701309; c=relaxed/simple;
	bh=UrzkdctcUfC1aMh36qIG6V6MQU4t76LAvk2CCS3zCFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ar3Ptl4aLAV2QNUQVBou41jibUttxZvJ5JDnTvEGF6J20AmKsZLBECVPumosAgSfL0ksOeqW6sUvAvrLcfV8VmYbXo9anXtriqOeyr1v6jSAhETlyA9GW1ofI8vyGisrjVjqq6ydC34rNmQCLBCLSfgenu7CF1TzJ5lRBcpWe9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ela/obcZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ela/obcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2C9C19425;
	Mon, 20 Apr 2026 16:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701309;
	bh=UrzkdctcUfC1aMh36qIG6V6MQU4t76LAvk2CCS3zCFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ela/obcZKXOiuUjjIg1hWHPGcrs0rQX2b5GXJ1oKYTVTmHvA6359fNJ4W876oy4Kw
	 NrKlO1oTDqGzjjjUH1EZhgAkvxUjShMAZ3X4Lz/YY5G+bqFVsD8h8UZt/tw/KuWNJF
	 dHaf38pFL0IhA6Z2/q8a4HkbsoR3BWrYq3B3oaxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 064/162] xsk: validate MTU against usable frame size on bind
Date: Mon, 20 Apr 2026 17:41:36 +0200
Message-ID: <20260420153929.355929735@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a9d8aa83f8000..04fe499f76782 100644
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
@@ -163,8 +165,12 @@ static void xp_disable_drv_zc(struct xsk_buff_pool *pool)
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
@@ -184,7 +190,7 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 	if (err)
 		return err;
 
-	if (flags & XDP_USE_SG)
+	if (mbuf)
 		pool->umem->flags |= XDP_UMEM_SG_FLAG;
 
 	if (flags & XDP_USE_NEED_WAKEUP)
@@ -206,8 +212,24 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
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



