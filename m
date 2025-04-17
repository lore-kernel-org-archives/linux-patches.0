Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97931DE3A8;
	Thu, 17 Apr 2025 18:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913372; cv=none; b=BZi1Xt5fvGkQccM+0baRDEcSHjod//ZJRN1FVEIKeohGLLIqJYUmk2/qO8fIezLHGMvOtrZRcJXqx0jTV64n46zFVMwSXQrDrA4CTHNTzh7Qg2Zkd8RhGl2lWUXCJxusPUsUlLVCQTyEN4KQpPTwL08bkP0uHjyU+17ZG/ubp58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913372; c=relaxed/simple;
	bh=Fz21OXs7qgx2Efx6FoGLasL+wCjNGTSlS2lsRFOY7+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vo4xykY1YOu7SpxnE3DQdWK5fXkaozIpI7avn9LpEBSqw2Uw7MAOwIrYYOZk3YJb0bI69giXSq5iWwSca5xfe1dPsP32bW+rCe8vGsBzBHLgLvgD6q9HBnlHIynGqIANnZmIvslRp2xIB+njuElFl19tZnC8a0eP3h4ghB0AczQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLmaRsDZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLmaRsDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB1DC4CEE4;
	Thu, 17 Apr 2025 18:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913372;
	bh=Fz21OXs7qgx2Efx6FoGLasL+wCjNGTSlS2lsRFOY7+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLmaRsDZe22p0u1oJn8w9Qw0MJ+0WiTpjQR+Zh/8zA1qQiARaRmCC6C7xd8Z4tfdV
	 RXLw7n3kemy4p4NdnumZRRQjSFfyBEn+R1u1/aSmH8Nx5ZQQoEVdeDif9sNYfl9HXc
	 bXC09XaEYCSRtN6xkmW0cK5uhTBe+LJKGppbrnjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <jdamato@fastly.com>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.14 317/449] igc: Fix XSK queue NAPI ID mapping
Date: Thu, 17 Apr 2025 19:50:05 +0200
Message-ID: <20250417175130.874073676@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Damato <jdamato@fastly.com>

commit dddeeaa16ce9d163ccf3b681715512d338afa541 upstream.

In commit b65969856d4f ("igc: Link queues to NAPI instances"), the XSK
queues were incorrectly unmapped from their NAPI instances. After
discussion on the mailing list and the introduction of a test to codify
the expected behavior, we can see that the unmapping causes the
check_xsk test to fail:

NETIF=enp86s0 ./tools/testing/selftests/drivers/net/queues.py

[...]
  # Check|     ksft_eq(q.get('xsk', None), {},
  # Check failed None != {} xsk attr on queue we configured
  not ok 4 queues.check_xsk

After this commit, the test passes:

  ok 4 queues.check_xsk

Note that the test itself is only in net-next, so I tested this change
by applying it to my local net-next tree, booting, and running the test.

Cc: stable@vger.kernel.org
Fixes: b65969856d4f ("igc: Link queues to NAPI instances")
Signed-off-by: Joe Damato <jdamato@fastly.com>
Reviewed-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Tested-by: Mor Bar-Gabay <morx.bar.gabay@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igc/igc.h      |    2 --
 drivers/net/ethernet/intel/igc/igc_main.c |    4 ++--
 drivers/net/ethernet/intel/igc/igc_xdp.c  |    2 --
 3 files changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -337,8 +337,6 @@ struct igc_adapter {
 	struct igc_led_classdev *leds;
 };
 
-void igc_set_queue_napi(struct igc_adapter *adapter, int q_idx,
-			struct napi_struct *napi);
 void igc_up(struct igc_adapter *adapter);
 void igc_down(struct igc_adapter *adapter);
 int igc_open(struct net_device *netdev);
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5021,8 +5021,8 @@ static int igc_sw_init(struct igc_adapte
 	return 0;
 }
 
-void igc_set_queue_napi(struct igc_adapter *adapter, int vector,
-			struct napi_struct *napi)
+static void igc_set_queue_napi(struct igc_adapter *adapter, int vector,
+			       struct napi_struct *napi)
 {
 	struct igc_q_vector *q_vector = adapter->q_vector[vector];
 
--- a/drivers/net/ethernet/intel/igc/igc_xdp.c
+++ b/drivers/net/ethernet/intel/igc/igc_xdp.c
@@ -86,7 +86,6 @@ static int igc_xdp_enable_pool(struct ig
 		napi_disable(napi);
 	}
 
-	igc_set_queue_napi(adapter, queue_id, NULL);
 	set_bit(IGC_RING_FLAG_AF_XDP_ZC, &rx_ring->flags);
 	set_bit(IGC_RING_FLAG_AF_XDP_ZC, &tx_ring->flags);
 
@@ -136,7 +135,6 @@ static int igc_xdp_disable_pool(struct i
 	xsk_pool_dma_unmap(pool, IGC_RX_DMA_ATTR);
 	clear_bit(IGC_RING_FLAG_AF_XDP_ZC, &rx_ring->flags);
 	clear_bit(IGC_RING_FLAG_AF_XDP_ZC, &tx_ring->flags);
-	igc_set_queue_napi(adapter, queue_id, napi);
 
 	if (needs_reset) {
 		napi_enable(napi);


