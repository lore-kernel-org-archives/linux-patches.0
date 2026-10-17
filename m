Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE184CF489;
	Sat, 17 Oct 2026 16:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254587; cv=none; b=jqn+EMOO4gQRNgY1Ab3ZFW7Yrhx10258bO6i/xP9BG9FBZp2kdDZLAZnDe557wLmDjZBwE+BjKQhZVZ0G81EVUdSci6AQEMNDngoA/MbiOaD8J0gSuu9r92KSsOPGnrxXXm+SFEcDjkqD5HwCHMjqoHYx+8ci5HvyaB5Rm3Soz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254587; c=relaxed/simple;
	bh=5LDEk3T5j4QTCCfpEPZvV1iXAbdEdPXWE6MYhocQcn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKXRQCF/RwYjD3RG46BkEKhRFOeu+wnp1UsP0+pkosf898Xp+niu9EdpB0BV31wXlAQ2gaCDs5ZtK2ywavSC8PJZ6DehBAn/wBK1lTkvNxbOArKU4S+I2woi9NpOzWjLf09B212A4STSU3jdI8RFAD6G9PzwacjVzJXjsHxRKNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6by1mhP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6by1mhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2616B1F000C4;
	Sat, 17 Oct 2026 16:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254585;
	bh=joO9rzVbf3NQy9o5HnOAwXT4DOdRqhKTnVweDHFpfYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s6by1mhPP3wv4YbQhTpfL08T51XOxhP3AbgE/jGYXalU6DVr/0fxu56n0MHn+WCvl
	 AFtO1a1ZNi1w1SqEyBIS7/Tc7LWjdEyJQr/90k+b6Zh29h6ePEJvqMerv0z9LZ5csU
	 7sSPv/LRxPiiSQ0tQnhIHVk673d7Sm69bdDhS2HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Simon Horman <horms@kernel.org>,
	Patryk Holda <patryk.holda@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 469/869] ixgbe: do not configure xps for XDP queues
Date: Sat, 17 Oct 2026 17:55:10 +0200
Message-ID: <20261017160049.153714483@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Larysa Zaremba <larysa.zaremba@intel.com>

[ Upstream commit 7bd4355272de34c2e90e34b72c5613736d03c32b ]

netif_set_xps_queue() should not be called for an XDP Tx queue, since such
queues are not netdev-exposed. On systems with number of CPUs >=64, on E610
adapter, netdev is configured with maximum number queue pairs being 63
(due to MSI-X assignment), but configuring XDP results in 64 XDP queues.

So, during XDP program load, when netif_set_xps_queue() is called for the
last XDP queue, we get a WARNING with a call trace and KASAN report
afterwards (if enabled).

[ 2012.699800] WARNING: net/core/dev.c:2854 at __netif_set_xps_queue+0x116a/0x1e40, CPU#36: xdpsock/103668
[...]
[ 2012.700029] RIP: 0010:__netif_set_xps_queue+0x116a/0x1e40
[ 2012.700035] Code: b6 34 06 48 89 f8 83 e0 07 83 c0 01 40 38 f0 7c 09 40 84 f6 0f 85 03 0a 00 00 0f b7 44 24 40 66 43 89 44 6a 18 e9 01 fb ff ff <0f> 0b e9 f2 ee ff ff 44 8b 44 24 44 45 85 c0 74 50 4d 85 e4 0f 84
[ 2012.700040] RSP: 0018:ffff8882369aeb28 EFLAGS: 00010246
[ 2012.700046] RAX: 0000000000000000 RBX: 000000000000003f RCX: 0000000000000000
[ 2012.700050] RDX: 1ffff1111da3d891 RSI: ffff888120e34250 RDI: ffff8888ed1ec488
[ 2012.700054] RBP: ffff888913281560 R08: 0000000000000000 R09: ffff8888ed1ec000
[ 2012.700058] R10: ffff8888a2e83180 R11: 0000000000000000 R12: 0000000000007fa8
[ 2012.700061] R13: 000000000000003f R14: ffff888120e34854 R15: ffff8889132817c8
[ 2012.700065] FS:  00007fc8ea9ff740(0000) GS:ffff88884cefe000(0000) knlGS:0000000000000000
[ 2012.700069] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2012.700073] CR2: 00007f81c8000020 CR3: 00000002299f8006 CR4: 00000000007726f0
[ 2012.700077] PKRU: 55555554
[ 2012.700080] Call Trace:
[ 2012.700084]  <TASK>
[ 2012.700087]  ? ktime_get+0x61/0x150
[ 2012.700097]  ? usleep_range_state+0x133/0x1b0
[ 2012.700108]  ? __pfx_usleep_range_state+0x10/0x10
[ 2012.700114]  netif_set_xps_queue+0x31/0x50
[ 2012.700119]  ixgbe_configure_tx_ring+0x472/0x920 [ixgbe]
[...]
[ 2012.700486]  ixgbe_xdp+0x38f/0x750 [ixgbe]

[...]

[ 2012.701094] BUG: KASAN: slab-out-of-bounds in __netif_set_xps_queue+0x1ac5/0x1e40
[ 2012.701100] Write of size 4 at addr ffff88888d43cff8 by task xdpsock/103668

Skip XPS configuration for XDP Tx queues.

Fixes: 33fdc82f0883 ("ixgbe: add support for XDP_TX action")
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Patryk Holda <patryk.holda@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 8b8404d8c9460..aef70cf119bb3 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -3543,7 +3543,8 @@ void ixgbe_configure_tx_ring(struct ixgbe_adapter *adapter,
 	}
 
 	/* initialize XPS */
-	if (!test_and_set_bit(__IXGBE_TX_XPS_INIT_DONE, &ring->state)) {
+	if (!ring_is_xdp(ring) &&
+	    !test_and_set_bit(__IXGBE_TX_XPS_INIT_DONE, &ring->state)) {
 		struct ixgbe_q_vector *q_vector = ring->q_vector;
 
 		if (q_vector)
-- 
2.53.0



