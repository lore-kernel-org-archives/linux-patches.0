Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22463B6BEB;
	Tue, 21 Jul 2026 21:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667629; cv=none; b=KcOP6OGuwLDWED1tgdgHkRYeK1RyRQdnwn5hmD8kcCtEmq9Ihpf45yQnbz0KI95u+VkBbWofKgDSizK+6HazH6UVmPfgkrveow+vyGfeYIWdRdjzUX9EUs041QKpp1U38O5+qPYNWXYs+eS/Eeuq9UoA/ILgAlAZjCTFlnWNeWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667629; c=relaxed/simple;
	bh=QqD0jWQTfs2y/nBqFqSHP9QZ0xZAb7lIn9n6gg1IgXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaBF/zYK0kKyUYboYEHRSfkzJCEyckwgI9vvUMFygxyCfAjqAsf/SyZ/blWQWeX2Ek3thKSzb2gWwyLzYyiEpxdahNct1tMc2YUJ7nPlomerPdulF/2TkY85iJlBSk2RkwTJ77ZHs94065wPBqZ5nettEsDZqFQidvU5bE73rJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VrcyMaPs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VrcyMaPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184BA1F000E9;
	Tue, 21 Jul 2026 21:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667628;
	bh=k9sSrF2TMPMNvfvG38cydo1sijsdYZ3SGDqevt+0LJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VrcyMaPskVj+8V49rtKfPddxyAK+6osXJV1XHBeSYt6JzQMMDiFtgRvXxgJ986Ozz
	 kzRTKsM2jPC+CLkr532pgoQgMOo3cKGTIueVSrvk1lWywPM/YoEY+8Emb0COrlQg1k
	 MMChPhgi4oL+qgnXxLHEd93Xh0L0chK7wESbAqTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	David Thompson <davthompson@nvidia.com>,
	Thangaraj Samynathan <Thangaraj.s@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 1106/1266] net: lan743x: Initialize eth_syslock spinlock before use
Date: Tue, 21 Jul 2026 17:25:43 +0200
Message-ID: <20260721152506.551921254@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3299,8 +3299,8 @@ static int lan743x_hardware_init(struct
 		adapter->max_tx_channels = PCI11X1X_MAX_TX_CHANNELS;
 		adapter->used_tx_channels = PCI11X1X_USED_TX_CHANNELS;
 		adapter->max_vector_count = PCI11X1X_MAX_VECTOR_COUNT;
-		pci11x1x_strap_get_status(adapter);
 		spin_lock_init(&adapter->eth_syslock_spinlock);
+		pci11x1x_strap_get_status(adapter);
 		mutex_init(&adapter->sgmii_rw_lock);
 		pci11x1x_set_rfe_rd_fifo_threshold(adapter);
 		sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);


