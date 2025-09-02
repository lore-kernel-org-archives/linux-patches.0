Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2DA3093B6;
	Tue,  2 Sep 2025 13:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819920; cv=none; b=BfCHryhuJ1X0aGddLz9Cn3S8WnPlk1rgVzrq+AuVdztD5UzXhZKNRS6bL0j+0/XMPshzJBFGcpHuUnmzeSOJynmrUD/nZs3xmStqa3HLjTWxJk+XNOcvKOMRLVZ3rxI+ElN7vPsEhq4jHhRT3aAe46v1rXQrNNWUa+y/dc4oMSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819920; c=relaxed/simple;
	bh=iOtZL4yFHKr1pQy+srJ6ksRm4Zt4W0zXiMM5eMF5xMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6EtkGKnbhM1soeKc9KLrVmauZ/oOKO+NrjutNFgkpwqMOFtfHfTy/smjXaqwBdaOVDySyxdK8fLVvaEpMKJXOpnAzfkznlFy4KPZ9X2S/xuHcSM/+/Gfv1QYxRwTXxjHyPZWL7OpWAn7aEgRgwvaZlzs0fg728SNM8qyWEZyjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlnkfls7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlnkfls7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54C1C4CEED;
	Tue,  2 Sep 2025 13:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819920;
	bh=iOtZL4yFHKr1pQy+srJ6ksRm4Zt4W0zXiMM5eMF5xMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlnkfls7MvKEyGCYrDkPxzD3jzstqOSg4DdfF7A0zSI38AsGQ9Xaa8AtxHXO7RUHc
	 vRINcMUCOdt9tSXaQw00If9Dp2Mr+Q5W7ITavJbgL1rE0XvIR+1z7jjE192UQccmmU
	 XNwBy/VYYEUhtCoCDRdH20QxMhYbxI0NOi0WYAm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Grzegorz Nitka <grzegorz.nitka@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.12 37/95] ice: use fixed adapter index for E825C embedded devices
Date: Tue,  2 Sep 2025 15:20:13 +0200
Message-ID: <20250902131941.034372219@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 5c5e5b52bf05c7fe88768318c041052c5fac36b8 ]

The ice_adapter structure is used by the ice driver to connect multiple
physical functions of a device in software. It was introduced by
commit 0e2bddf9e5f9 ("ice: add ice_adapter for shared data across PFs on
the same NIC") and is primarily used for PTP support, as well as for
handling certain cross-PF synchronization.

The original design of ice_adapter used PCI address information to
determine which devices should be connected. This was extended to support
E825C devices by commit fdb7f54700b1 ("ice: Initial support for E825C
hardware in ice_adapter"), which used the device ID for E825C devices
instead of the PCI address.

Later, commit 0093cb194a75 ("ice: use DSN instead of PCI BDF for
ice_adapter index") replaced the use of Bus/Device/Function addressing with
use of the device serial number.

E825C devices may appear in "Dual NAC" configuration which has multiple
physical devices tied to the same clock source and which need to use the
same ice_adapter. Unfortunately, each "NAC" has its own NVM which has its
own unique Device Serial Number. Thus, use of the DSN for connecting
ice_adapter does not work properly. It "worked" in the pre-production
systems because the DSN was not initialized on the test NVMs and all the
NACs had the same zero'd serial number.

Since we cannot rely on the DSN, lets fall back to the logic in the
original E825C support which used the device ID. This is safe for E825C
only because of the embedded nature of the device. It isn't a discreet
adapter that can be plugged into an arbitrary system. All E825C devices on
a given system are connected to the same clock source and need to be
configured through the same PTP clock.

To make this separation clear, reserve bit 63 of the 64-bit index values as
a "fixed index" indicator. Always clear this bit when using the device
serial number as an index.

For E825C, use a fixed value defined as the 0x579C E825C backplane device
ID bitwise ORed with the fixed index indicator. This is slightly different
than the original logic of just using the device ID directly. Doing so
prevents a potential issue with systems where only one of the NACs is
connected with an external PHY over SGMII. In that case, one NAC would
have the E825C_SGMII device ID, but the other would not.

Separate the determination of the full 64-bit index from the 32-bit
reduction logic. Provide both ice_adapter_index() and a wrapping
ice_adapter_xa_index() which handles reducing the index to a long on 32-bit
systems. As before, cache the full index value in the adapter structure to
warn about collisions.

This fixes issues with E825C not initializing PTP on both NACs, due to
failure to connect the appropriate devices to the same ice_adapter.

Fixes: 0093cb194a75 ("ice: use DSN instead of PCI BDF for ice_adapter index")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_adapter.c | 49 +++++++++++++++-----
 drivers/net/ethernet/intel/ice/ice_adapter.h |  4 +-
 2 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adapter.c b/drivers/net/ethernet/intel/ice/ice_adapter.c
index 66e070095d1bb..10285995c9edd 100644
--- a/drivers/net/ethernet/intel/ice/ice_adapter.c
+++ b/drivers/net/ethernet/intel/ice/ice_adapter.c
@@ -13,16 +13,45 @@
 static DEFINE_XARRAY(ice_adapters);
 static DEFINE_MUTEX(ice_adapters_mutex);
 
-static unsigned long ice_adapter_index(u64 dsn)
+#define ICE_ADAPTER_FIXED_INDEX	BIT_ULL(63)
+
+#define ICE_ADAPTER_INDEX_E825C	\
+	(ICE_DEV_ID_E825C_BACKPLANE | ICE_ADAPTER_FIXED_INDEX)
+
+static u64 ice_adapter_index(struct pci_dev *pdev)
 {
+	switch (pdev->device) {
+	case ICE_DEV_ID_E825C_BACKPLANE:
+	case ICE_DEV_ID_E825C_QSFP:
+	case ICE_DEV_ID_E825C_SFP:
+	case ICE_DEV_ID_E825C_SGMII:
+		/* E825C devices have multiple NACs which are connected to the
+		 * same clock source, and which must share the same
+		 * ice_adapter structure. We can't use the serial number since
+		 * each NAC has its own NVM generated with its own unique
+		 * Device Serial Number. Instead, rely on the embedded nature
+		 * of the E825C devices, and use a fixed index. This relies on
+		 * the fact that all E825C physical functions in a given
+		 * system are part of the same overall device.
+		 */
+		return ICE_ADAPTER_INDEX_E825C;
+	default:
+		return pci_get_dsn(pdev) & ~ICE_ADAPTER_FIXED_INDEX;
+	}
+}
+
+static unsigned long ice_adapter_xa_index(struct pci_dev *pdev)
+{
+	u64 index = ice_adapter_index(pdev);
+
 #if BITS_PER_LONG == 64
-	return dsn;
+	return index;
 #else
-	return (u32)dsn ^ (u32)(dsn >> 32);
+	return (u32)index ^ (u32)(index >> 32);
 #endif
 }
 
-static struct ice_adapter *ice_adapter_new(u64 dsn)
+static struct ice_adapter *ice_adapter_new(struct pci_dev *pdev)
 {
 	struct ice_adapter *adapter;
 
@@ -30,7 +59,7 @@ static struct ice_adapter *ice_adapter_new(u64 dsn)
 	if (!adapter)
 		return NULL;
 
-	adapter->device_serial_number = dsn;
+	adapter->index = ice_adapter_index(pdev);
 	spin_lock_init(&adapter->ptp_gltsyn_time_lock);
 	refcount_set(&adapter->refcount, 1);
 
@@ -63,24 +92,23 @@ static void ice_adapter_free(struct ice_adapter *adapter)
  */
 struct ice_adapter *ice_adapter_get(struct pci_dev *pdev)
 {
-	u64 dsn = pci_get_dsn(pdev);
 	struct ice_adapter *adapter;
 	unsigned long index;
 	int err;
 
-	index = ice_adapter_index(dsn);
+	index = ice_adapter_xa_index(pdev);
 	scoped_guard(mutex, &ice_adapters_mutex) {
 		err = xa_insert(&ice_adapters, index, NULL, GFP_KERNEL);
 		if (err == -EBUSY) {
 			adapter = xa_load(&ice_adapters, index);
 			refcount_inc(&adapter->refcount);
-			WARN_ON_ONCE(adapter->device_serial_number != dsn);
+			WARN_ON_ONCE(adapter->index != ice_adapter_index(pdev));
 			return adapter;
 		}
 		if (err)
 			return ERR_PTR(err);
 
-		adapter = ice_adapter_new(dsn);
+		adapter = ice_adapter_new(pdev);
 		if (!adapter)
 			return ERR_PTR(-ENOMEM);
 		xa_store(&ice_adapters, index, adapter, GFP_KERNEL);
@@ -99,11 +127,10 @@ struct ice_adapter *ice_adapter_get(struct pci_dev *pdev)
  */
 void ice_adapter_put(struct pci_dev *pdev)
 {
-	u64 dsn = pci_get_dsn(pdev);
 	struct ice_adapter *adapter;
 	unsigned long index;
 
-	index = ice_adapter_index(dsn);
+	index = ice_adapter_xa_index(pdev);
 	scoped_guard(mutex, &ice_adapters_mutex) {
 		adapter = xa_load(&ice_adapters, index);
 		if (WARN_ON(!adapter))
diff --git a/drivers/net/ethernet/intel/ice/ice_adapter.h b/drivers/net/ethernet/intel/ice/ice_adapter.h
index ac15c0d2bc1a4..409467847c753 100644
--- a/drivers/net/ethernet/intel/ice/ice_adapter.h
+++ b/drivers/net/ethernet/intel/ice/ice_adapter.h
@@ -32,7 +32,7 @@ struct ice_port_list {
  * @refcount: Reference count. struct ice_pf objects hold the references.
  * @ctrl_pf: Control PF of the adapter
  * @ports: Ports list
- * @device_serial_number: DSN cached for collision detection on 32bit systems
+ * @index: 64-bit index cached for collision detection on 32bit systems
  */
 struct ice_adapter {
 	refcount_t refcount;
@@ -41,7 +41,7 @@ struct ice_adapter {
 
 	struct ice_pf *ctrl_pf;
 	struct ice_port_list ports;
-	u64 device_serial_number;
+	u64 index;
 };
 
 struct ice_adapter *ice_adapter_get(struct pci_dev *pdev);
-- 
2.50.1



