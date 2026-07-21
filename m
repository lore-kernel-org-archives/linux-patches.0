Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F23246C4B6;
	Tue, 21 Jul 2026 17:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655091; cv=none; b=lB+riOvVUQf/4p0rauxJTNuzTeQYbYG6EW7EIPgySG+STbm1t8Za6ZvocBFIcpnCOqFbjdSH3tbV+KADmx16b/uaqReVcaITgZvZIU+niiB3nLC1IlnYeoBe3cyWfD5oyMnXJM33ugp5N2TLw4Oo4Qztv/RUdw7zw//wuwPyVpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655091; c=relaxed/simple;
	bh=2sFUtone0n+DfK4i8jSx6Ck36WvdokywXbfYMXcTqJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0r6G3lJGd95uVjUoPRZerrgr4KzMyhhWMCtS7zvL8E4EAXKPP7yVoAjHKs/o33Q890lGBUMFq6eEAsA7fCiO/2q4Bc+dnw2PL0fi4KCVioks9H0Jr94qdSeV1IZt5QzjGW5N294SuQbLQ5k9dpYAS4XBrjEkg8r+xsuH6oPyGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bXtr73TN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bXtr73TN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF461F000E9;
	Tue, 21 Jul 2026 17:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655090;
	bh=+VyE+zOANi19MItusZZW/CGb5ZM4vkSatG9CTLLNJVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bXtr73TNSvTMqPyD+OLFFCSps/u66Ln0gowYbTFh9/VIyXgeyZxG5RF3h3r8IjkNN
	 uuoXnrKZmlNqdArXB9WiqbGhc/kNSSlU2nTU1NQQrzSWtffJ7N0bAL2QgQ68ep7pE8
	 3MmP/ivzDPbkLaoyOFNFOo0mToFkRjdMSUYkSibA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	David Thompson <davthompson@nvidia.com>,
	Thangaraj Samynathan <Thangaraj.s@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.1 1953/2077] net: lan743x: Initialize eth_syslock spinlock before use
Date: Tue, 21 Jul 2026 17:27:06 +0200
Message-ID: <20260721152638.774762092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3542,8 +3542,8 @@ static int lan743x_hardware_init(struct
 		adapter->max_tx_channels = PCI11X1X_MAX_TX_CHANNELS;
 		adapter->used_tx_channels = PCI11X1X_USED_TX_CHANNELS;
 		adapter->max_vector_count = PCI11X1X_MAX_VECTOR_COUNT;
-		pci11x1x_strap_get_status(adapter);
 		spin_lock_init(&adapter->eth_syslock_spinlock);
+		pci11x1x_strap_get_status(adapter);
 		mutex_init(&adapter->sgmii_rw_lock);
 		pci11x1x_set_rfe_rd_fifo_threshold(adapter);
 		sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);


