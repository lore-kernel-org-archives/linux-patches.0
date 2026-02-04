Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4B219E96D;
	Wed,  4 Feb 2026 15:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219091; cv=none; b=pfjJJZzClFZvH0xxvu+w2GatYcGAnwygtZqxtQYViVz9HlSlT2hh8rpST/Gtn7nMUfl2O8Y9j+h4NYjz6Gj0LdHOPugxQae+HotCMjuQo0EuckcLnqIULjmES9Qck3frxqyU6In1EzkUhnGLA8bhqPTnoar7L4wTTAVQ4DucTOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219091; c=relaxed/simple;
	bh=L9YCclQGQmuLi2eND9meB35oRSCLXh9bd4iPVwpTrls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WuE34ZutcakfX4eArnn4tNuHVc+E4HKcmzTnUO23mUmj6OyjSfdVdT9QXe67miRCOQ1a1pcXDoFHVRSLC4kq+WM43xQ0jlyXRWIvvgruj93ysXmvMw0wUAqIa6zIFwQ3S1rwy0ZUCN8D6qbn7tPPAQtnupGuNuZ85DD+hG95WGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNVjGdzW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNVjGdzW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4C3C4CEF7;
	Wed,  4 Feb 2026 15:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219090;
	bh=L9YCclQGQmuLi2eND9meB35oRSCLXh9bd4iPVwpTrls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WNVjGdzWJOpu9Bvg6aBqPMacsox/wOitBNW03VtLheSEoIbVRCkakNXO319n++lB0
	 z9LE4+0T8vm8ji+JFoMZ0OSqPh7Whsn71Ob0hPF9Pl8UDueE84HmITm8XTYSKinyxY
	 9WJI6cXgb6MN1oECbUx1YpN3xuphPck4XJtDuqaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <enjuk@amazon.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 021/122] ixgbe: fix memory leaks in the ixgbe_recovery_probe() path
Date: Wed,  4 Feb 2026 15:40:03 +0100
Message-ID: <20260204143852.628766341@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kohei Enju <enjuk@amazon.com>

[ Upstream commit 638344712aefeba97b6e0d90f560815fd88abd0f ]

When ixgbe_recovery_probe() is invoked and this function fails,
allocated resources in advance are not completely freed, because
ixgbe_probe() returns ixgbe_recovery_probe() directly and
ixgbe_recovery_probe() only frees partial resources, resulting in memory
leaks including:
- adapter->io_addr
- adapter->jump_tables[0]
- adapter->mac_table
- adapter->rss_key
- adapter->af_xdp_zc_qps

The leaked MMIO region can be observed in /proc/vmallocinfo, and the
remaining leaks are reported by kmemleak.

Don't return ixgbe_recovery_probe() directly, and instead let
ixgbe_probe() to clean up resources on failures.

Fixes: 29cb3b8d95c7 ("ixgbe: add E610 implementation of FW recovery mode")
Signed-off-by: Kohei Enju <enjuk@amazon.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 20 ++++++++-----------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 3190ce7e44c74..ee1007e9b6355 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -11468,14 +11468,12 @@ static void ixgbe_set_fw_version(struct ixgbe_adapter *adapter)
  */
 static int ixgbe_recovery_probe(struct ixgbe_adapter *adapter)
 {
-	struct net_device *netdev = adapter->netdev;
 	struct pci_dev *pdev = adapter->pdev;
 	struct ixgbe_hw *hw = &adapter->hw;
-	bool disable_dev;
 	int err = -EIO;
 
 	if (hw->mac.type != ixgbe_mac_e610)
-		goto clean_up_probe;
+		return err;
 
 	ixgbe_get_hw_control(adapter);
 	mutex_init(&hw->aci.lock);
@@ -11507,13 +11505,6 @@ static int ixgbe_recovery_probe(struct ixgbe_adapter *adapter)
 shutdown_aci:
 	mutex_destroy(&adapter->hw.aci.lock);
 	ixgbe_release_hw_control(adapter);
-clean_up_probe:
-	disable_dev = !test_and_set_bit(__IXGBE_DISABLED, &adapter->state);
-	free_netdev(netdev);
-	devlink_free(adapter->devlink);
-	pci_release_mem_regions(pdev);
-	if (disable_dev)
-		pci_disable_device(pdev);
 	return err;
 }
 
@@ -11655,8 +11646,13 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_sw_init;
 
-	if (ixgbe_check_fw_error(adapter))
-		return ixgbe_recovery_probe(adapter);
+	if (ixgbe_check_fw_error(adapter)) {
+		err = ixgbe_recovery_probe(adapter);
+		if (err)
+			goto err_sw_init;
+
+		return 0;
+	}
 
 	if (adapter->hw.mac.type == ixgbe_mac_e610) {
 		err = ixgbe_get_caps(&adapter->hw);
-- 
2.51.0



