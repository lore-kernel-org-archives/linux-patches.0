Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4640F46F49C;
	Tue, 21 Jul 2026 20:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664106; cv=none; b=F77eRttxVUpWNbzyZwD+nbBwdPGVWRnojrnyRxnCg1j5VdLklE9/VflzPN5sJraRCyMMi3lOAgOZNeneKt4O/K/mT3Hb33Si1sNhF2h1P4g/Eqg942lOLzY52JdP8tfenUIfzK2wxCe3Yt2HptLZIFbdP19QdRvbiLkiZhKoAxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664106; c=relaxed/simple;
	bh=Jpypk0WoO8rXDqLYlolElbVBo6dHvhEWJkADCGUB9wM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtrWKTQxaOMG9zzYBzos2BVvTgdZvy0f0b9/SESgPo0NlQ+pR8iUbNnCnPSkvAYDWplm+pJHDNxxnY0qJXwIEVjLYP8k9/jR0Y/OUjJam9zTKS6/6Nccef1kUfujW3qcduMb1dBh+gqWCKr9V/bZefXBzCUqnc0O3VzbqaVmuko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3uwfEUl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3uwfEUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28DC1F000E9;
	Tue, 21 Jul 2026 20:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664104;
	bh=7dfoj7vp2ldZD1/dV1bzTqOpOwiZUiWpSRtvg2p3BLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G3uwfEUl3loPPgj1HlANlSLG63aTS1M8GLCMgKL2HUprkdrSh1WZd+K7CI0xXaSyk
	 12Y7ny/RTS1HNUSDEX7TEC5f8wNOAPwpzybiu8MxsOd7NpBzBnmDcc3VDSRpe2LZkX
	 XnwwmCVrTlPt4Dqpzq4yJMq6iB9l6kjzVqEPe8r8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	David Thompson <davthompson@nvidia.com>,
	Thangaraj Samynathan <Thangaraj.s@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 1075/1276] net: lan743x: Initialize eth_syslock spinlock before use
Date: Tue, 21 Jul 2026 17:25:18 +0200
Message-ID: <20260721152510.043371691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Andrea Righi <arighi@nvidia.com>

commit 39139b1c1c2b614096519b526112c726adb12ff0 upstream.

lan743x_hardware_init() calls pci11x1x_strap_get_status() during the
PCI11x1x probe sequence. That helper acquires the Ethernet subsystem
hardware lock via lan743x_hs_syslock_acquire(), which relies on
adapter->eth_syslock_spinlock to serialize access.

The spinlock is currently initialized only after the strap status is
read. With CONFIG_DEBUG_SPINLOCK enabled, taking the zeroed initialized
spinlock can trip the spinlock debug check.

Fix by initializing adapter->eth_syslock_spinlock before reading the
strap status so the probe path never attempts to lock an uninitialized
spinlock.

Fixes: 46b777ad9a8c ("net: lan743x: Add support to SGMII 1G and 2.5G")
Cc: stable@vger.kernel.org # v6.0+
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Reviewed-by: David Thompson <davthompson@nvidia.com>
Reviewed-by: Thangaraj Samynathan<Thangaraj.s@microchip.com>
Link: https://patch.msgid.link/20260626163218.3591486-1-arighi@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -3506,8 +3506,8 @@ static int lan743x_hardware_init(struct
 		adapter->max_tx_channels = PCI11X1X_MAX_TX_CHANNELS;
 		adapter->used_tx_channels = PCI11X1X_USED_TX_CHANNELS;
 		adapter->max_vector_count = PCI11X1X_MAX_VECTOR_COUNT;
-		pci11x1x_strap_get_status(adapter);
 		spin_lock_init(&adapter->eth_syslock_spinlock);
+		pci11x1x_strap_get_status(adapter);
 		mutex_init(&adapter->sgmii_rw_lock);
 		pci11x1x_set_rfe_rd_fifo_threshold(adapter);
 		sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);


