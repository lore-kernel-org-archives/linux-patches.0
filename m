Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2201F34B1A6;
	Tue, 21 Jul 2026 21:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670353; cv=none; b=civ1+S4EWbP2EtL9w9S/oU58xi8Y1fViCOHbwvvH0XotRnGqCVM73BsfDx8I6gCwSqoi1xd7rX/WMIIaI/aDvTfzR9ImxL26ebfiiOqcz03cfWChViU/VTO0rBKgA3ETJfgzeFK/d37ZHptr+c7h5RXvvHwR9dFAc3776a4haiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670353; c=relaxed/simple;
	bh=EhicGewuLOWHCiI244Sjeg1NTsNbmQ6Hhrn9922CnbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8Cfqa/Oa6xv09oU9+QZ+wlWs0jRgtEoZiKoBvGsCWnOT5dwXkYdZuejGE4DtINisDN8/prTlyB/ojiMHtwyT6jjIk6MXEZRIQN26vxNtIutZK7IzFoAH/IaIBzGAMYPLYmVi4ML/LYy8V5cdsx8IhSSU/VoQeQV8CGVdj7ddt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CtmZkTbO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CtmZkTbO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871241F000E9;
	Tue, 21 Jul 2026 21:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670352;
	bh=dgpmCyeHn3dBQAfRc2fLDVvqAH4o3TQclQ55LufX3oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CtmZkTbO7XoH7reX2aO5vO8N7rO56VRUl5/DpElpl3vtQHJBMPG6cQz2vlLt4mDuN
	 SufKjnsvyQgVqYyrAQ6KCi4+SGW/wlgC7xKa05se3NF/bfeR+N4cUN6ZNn/dcpoLbn
	 DeNLWWGUZzjQqi/haKg8JKMj6JWsSS9YjitT6m7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	David Thompson <davthompson@nvidia.com>,
	Thangaraj Samynathan <Thangaraj.s@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 0901/1067] net: lan743x: Initialize eth_syslock spinlock before use
Date: Tue, 21 Jul 2026 17:25:02 +0200
Message-ID: <20260721152444.689764217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3293,8 +3293,8 @@ static int lan743x_hardware_init(struct
 		adapter->max_tx_channels = PCI11X1X_MAX_TX_CHANNELS;
 		adapter->used_tx_channels = PCI11X1X_USED_TX_CHANNELS;
 		adapter->max_vector_count = PCI11X1X_MAX_VECTOR_COUNT;
-		pci11x1x_strap_get_status(adapter);
 		spin_lock_init(&adapter->eth_syslock_spinlock);
+		pci11x1x_strap_get_status(adapter);
 		mutex_init(&adapter->sgmii_rw_lock);
 		pci11x1x_set_rfe_rd_fifo_threshold(adapter);
 		sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);


