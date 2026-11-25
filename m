Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622115;
	b=WAlnLEUqwzg+BkWscrx4NSROwdWHNObKkCXGluDvZtsvphwOrkI/Ax6CcjYWeQyHR4nf
	 g2iD/cv61Q8yoz0slxbNrLt3U/xv0wA1EBseszZsHffYuRXDANFHEqCulvBzZmyv74WWo
	 R8VVzaltdnfrAEt7sQxWiEyC5FBWhbeKwq1woMwm8hOk16CtPCogpJ0awFatIEkmOYQQd
	 3cYHw+afuXrjmRhlpfGCvQr6z6x2wafOa+1qgfLn7h495yl5zM6PRripWM0Ic5KpWDgGG
	 7ZPKv2Z94pnZQcvMdPoC4APGZRi2srS9lQqxXA5V/8289Gjv17UQ9ND3+hb31+sEk/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=PozJ/9qegF6DQQ9HSdFR7ZCEI11djyhysRM4Z6I6BME=;
	b=4EhUd6WhL78QvMpZs05QWus+3iVL4yRivvu4jc1UISPj2BvTQrP7OETINKnxjP/EcAuL
	 SUqxNkckgmQHrxpLYMF6D9scHUWoiVufLz4HxsG3oAq2JTpcEaG1g18wjbBzB0YwO6ut7
	 V2SbQ7WTw0DWw/7TtXKU7WVoRNk9x5Uu5H1drbZBN9ZwwxG+/cByttpype/h44GA+zw+T
	 3ElIsWy2eGprQeRlZ4xkBgk+NVBVt72KKDCgeQWQu7Qn7cOFBLfWBUoH6WlUPw10DsbVz
	 spzoDINpRGy0Pcb4q9wOOo3E//ySOm6WAuw5O89FKqIGx7in2RelsYlMRk6X8gNylsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cwuU0wNH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17E1606A321;
	Wed, 25 Nov 2026 15:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cwuU0wNH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FC41F000D3;
	Wed, 25 Nov 2026 15:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622115;
	bh=PozJ/9qegF6DQQ9HSdFR7ZCEI11djyhysRM4Z6I6BME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cwuU0wNH26i184Y18gbqZrh8Zo9gnzCwZ6YGBRFJZI6mNfB+rTiw87Nh375MbMVqd
	 pgR9V08ZyJxKcqErzAPolbzej9yYrkeua5uUx01M8twTwhh26bDCrvha+qVZuR6BPI
	 n1XrIfjop5MAIIgNByjaSEZU4F4ZU/vSptY6QAgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 399/990] ice: xsk: free stashed Rx frame when cleaning the ring
Date: Wed, 25 Nov 2026 15:29:26 +0100
Message-ID: <20261125143831.446499959@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit d5e7a86b7cd6c38a628635baace7eb2fdce14a43 ]

ice_clean_rx_irq_zc() stashes a partially received multi-buffer frame
in rx_ring->xsk, with its frags on pool->xskb_list. next_to_clean is
already past its buffers, so ice_xsk_clean_rx_ring(), which walks
next_to_clean..next_to_use, misses the frame, and ice_vsi_cfg_rxq()
later clears the pointer via ring->xdp.data.

The buffers are lost to user space and, as the pool outlives the ring
across ifdown/ifup or a reset, the stale frags are taken as frags of
the next frame. Before commit 93f53db9f9dc ("ice: switch to Page
Pool"), the frame was tracked by rx_ring->first_desc and leaked the
same way.

Free the stashed frame when cleaning the ring.

Fixes: 1bbc04de607b ("ice: xsk: add RX multi-buffer support")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Link: https://patch.msgid.link/20261102124950.958345-9-maciej.fijalkowski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 2009744a9f6a4..9840522d65dac 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -913,6 +913,11 @@ void ice_xsk_clean_rx_ring(struct ice_rx_ring *rx_ring)
 	if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
 		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
 
+	if (rx_ring->xsk) {
+		xsk_buff_free(&rx_ring->xsk->base);
+		rx_ring->xsk = NULL;
+	}
+
 	while (ntc != ntu) {
 		struct xdp_buff *xdp = *ice_xdp_buf(rx_ring, ntc);
 
-- 
2.53.0



