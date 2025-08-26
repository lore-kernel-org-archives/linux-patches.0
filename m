Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771D931CA7C;
	Tue, 26 Aug 2025 11:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207938; cv=none; b=qcc/JmETajITbZ+H7fTBiOXwYdC/zBBbDpHiHlmKbnJkTuLAZj4+cNJ1hHek7Xk+dBsO3pBzR9YgmOidvcIO6ttmzm3xY8UxXwT8iOw/jHJ366cyNEBQR/K9o4YqY1zN2bq48lOymJKy6n20hmW1O+hM+xvsDbcMNy5q9j/etUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207938; c=relaxed/simple;
	bh=1cjDSwzjFgB6GrTVO81zcAGRbVyFcN2p814TZ3tHrH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0+5HYeHK0w4ZAyvipY4hQhtvW+EMJ/OCEyz66zxSDnh5JYxyz2bc4ZJb+kWPizqexBhLAlDjXppDyRJt414zp7rK7k5p0/pJOGpxDJ0Ua+9pEe05Odw+LYSAUji7Rqt3fF9PP2ECzZVMzefvIjHJgmj9zMC0pXNj6kw6lX50xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ankJnx1/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ankJnx1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DF0C4CEF1;
	Tue, 26 Aug 2025 11:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207938;
	bh=1cjDSwzjFgB6GrTVO81zcAGRbVyFcN2p814TZ3tHrH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ankJnx1/+NGRr2OOv69xfZzOmoJ7ovxJ8D00f9VRhCZm1WeMCi5Q1GF6KpmtE9U3B
	 zq33sFvMBoW6mKSPEjTOPwmYAG//p5vvFTQWosrISEWN6LBVkIiLUDyALGyQPdSJIi
	 GGZRjAqqj+jPKGkyofIzl1TiU8G/ea2ej7U9Iev4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 375/457] Bluetooth: hci_core: Fix using {cis,bis}_capable for current settings
Date: Tue, 26 Aug 2025 13:10:59 +0200
Message-ID: <20250826110946.564167582@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 709788b154caf042874d765628ffa860f0bb0d1e ]

{cis,bis}_capable only indicates the controller supports the feature
since it doesn't check that LE is enabled so it shall not be used for
current setting, instead this introduces {cis,bis}_enabled macros that
can be used to indicate that these features are currently enabled.

Fixes: 26afbd826ee3 ("Bluetooth: Add initial implementation of CIS connections")
Fixes: eca0ae4aea66 ("Bluetooth: Add initial implementation of BIS connections")
Fixes: ae7533613133 ("Bluetooth: Check for ISO support in controller")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/bluetooth.h |  4 ++--
 include/net/bluetooth/hci_core.h  | 13 ++++++++++++-
 net/bluetooth/hci_sync.c          |  4 ++--
 net/bluetooth/iso.c               | 14 +++++++-------
 net/bluetooth/mgmt.c              | 10 +++++-----
 5 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
index 114299bd8b98..b847cdd2c9d3 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -638,7 +638,7 @@ static inline void sco_exit(void)
 #if IS_ENABLED(CONFIG_BT_LE)
 int iso_init(void);
 int iso_exit(void);
-bool iso_enabled(void);
+bool iso_inited(void);
 #else
 static inline int iso_init(void)
 {
@@ -650,7 +650,7 @@ static inline int iso_exit(void)
 	return 0;
 }
 
-static inline bool iso_enabled(void)
+static inline bool iso_inited(void)
 {
 	return false;
 }
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index f22881bf1b39..e77cb840deee 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1932,6 +1932,8 @@ void hci_conn_del_sysfs(struct hci_conn *conn);
 				!hci_dev_test_flag(dev, HCI_RPA_EXPIRED))
 #define adv_rpa_valid(adv)     (bacmp(&adv->random_addr, BDADDR_ANY) && \
 				!adv->rpa_expired)
+#define le_enabled(dev)        (lmp_le_capable(dev) && \
+				hci_dev_test_flag(dev, HCI_LE_ENABLED))
 
 #define scan_1m(dev) (((dev)->le_tx_def_phys & HCI_LE_SET_PHY_1M) || \
 		      ((dev)->le_rx_def_phys & HCI_LE_SET_PHY_1M))
@@ -1998,14 +2000,23 @@ void hci_conn_del_sysfs(struct hci_conn *conn);
 
 /* CIS Master/Slave and BIS support */
 #define iso_capable(dev) (cis_capable(dev) || bis_capable(dev))
+#define iso_enabled(dev) (le_enabled(dev) && iso_capable(dev))
 #define cis_capable(dev) \
 	(cis_central_capable(dev) || cis_peripheral_capable(dev))
+#define cis_enabled(dev) (le_enabled(dev) && cis_capable(dev))
 #define cis_central_capable(dev) \
 	((dev)->le_features[3] & HCI_LE_CIS_CENTRAL)
+#define cis_central_enabled(dev) \
+	(le_enabled(dev) && cis_central_capable(dev))
 #define cis_peripheral_capable(dev) \
 	((dev)->le_features[3] & HCI_LE_CIS_PERIPHERAL)
+#define cis_peripheral_enabled(dev) \
+	(le_enabled(dev) && cis_peripheral_capable(dev))
 #define bis_capable(dev) ((dev)->le_features[3] & HCI_LE_ISO_BROADCASTER)
-#define sync_recv_capable(dev) ((dev)->le_features[3] & HCI_LE_ISO_SYNC_RECEIVER)
+#define bis_enabled(dev) (le_enabled(dev) && bis_capable(dev))
+#define sync_recv_capable(dev) \
+	((dev)->le_features[3] & HCI_LE_ISO_SYNC_RECEIVER)
+#define sync_recv_enabled(dev) (le_enabled(dev) && sync_recv_capable(dev))
 
 #define mws_transport_config_capable(dev) (((dev)->commands[30] & 0x08) && \
 	(!hci_test_quirk((dev), HCI_QUIRK_BROKEN_MWS_TRANSPORT_CONFIG)))
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 6c3218bac116..892eca21c6c4 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4531,14 +4531,14 @@ static int hci_le_set_host_feature_sync(struct hci_dev *hdev)
 {
 	struct hci_cp_le_set_host_feature cp;
 
-	if (!cis_capable(hdev))
+	if (!iso_capable(hdev))
 		return 0;
 
 	memset(&cp, 0, sizeof(cp));
 
 	/* Connected Isochronous Channels (Host Support) */
 	cp.bit_number = 32;
-	cp.bit_value = 1;
+	cp.bit_value = iso_enabled(hdev) ? 0x01 : 0x00;
 
 	return __hci_cmd_sync_status(hdev, HCI_OP_LE_SET_HOST_FEATURE,
 				     sizeof(cp), &cp, HCI_CMD_TIMEOUT);
diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 3c2c98eecc62..f6fad466d16d 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -2455,11 +2455,11 @@ static const struct net_proto_family iso_sock_family_ops = {
 	.create	= iso_sock_create,
 };
 
-static bool iso_inited;
+static bool inited;
 
-bool iso_enabled(void)
+bool iso_inited(void)
 {
-	return iso_inited;
+	return inited;
 }
 
 int iso_init(void)
@@ -2468,7 +2468,7 @@ int iso_init(void)
 
 	BUILD_BUG_ON(sizeof(struct sockaddr_iso) > sizeof(struct sockaddr));
 
-	if (iso_inited)
+	if (inited)
 		return -EALREADY;
 
 	err = proto_register(&iso_proto, 0);
@@ -2496,7 +2496,7 @@ int iso_init(void)
 		iso_debugfs = debugfs_create_file("iso", 0444, bt_debugfs,
 						  NULL, &iso_debugfs_fops);
 
-	iso_inited = true;
+	inited = true;
 
 	return 0;
 
@@ -2507,7 +2507,7 @@ int iso_init(void)
 
 int iso_exit(void)
 {
-	if (!iso_inited)
+	if (!inited)
 		return -EALREADY;
 
 	bt_procfs_cleanup(&init_net, "iso");
@@ -2521,7 +2521,7 @@ int iso_exit(void)
 
 	proto_unregister(&iso_proto);
 
-	iso_inited = false;
+	inited = false;
 
 	return 0;
 }
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 63dba0503653..7a75309e6fd4 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -922,16 +922,16 @@ static u32 get_current_settings(struct hci_dev *hdev)
 	if (hci_dev_test_flag(hdev, HCI_WIDEBAND_SPEECH_ENABLED))
 		settings |= MGMT_SETTING_WIDEBAND_SPEECH;
 
-	if (cis_central_capable(hdev))
+	if (cis_central_enabled(hdev))
 		settings |= MGMT_SETTING_CIS_CENTRAL;
 
-	if (cis_peripheral_capable(hdev))
+	if (cis_peripheral_enabled(hdev))
 		settings |= MGMT_SETTING_CIS_PERIPHERAL;
 
-	if (bis_capable(hdev))
+	if (bis_enabled(hdev))
 		settings |= MGMT_SETTING_ISO_BROADCASTER;
 
-	if (sync_recv_capable(hdev))
+	if (sync_recv_enabled(hdev))
 		settings |= MGMT_SETTING_ISO_SYNC_RECEIVER;
 
 	if (ll_privacy_capable(hdev))
@@ -4512,7 +4512,7 @@ static int read_exp_features_info(struct sock *sk, struct hci_dev *hdev,
 	}
 
 	if (IS_ENABLED(CONFIG_BT_LE)) {
-		flags = iso_enabled() ? BIT(0) : 0;
+		flags = iso_inited() ? BIT(0) : 0;
 		memcpy(rp->features[idx].uuid, iso_socket_uuid, 16);
 		rp->features[idx].flags = cpu_to_le32(flags);
 		idx++;
-- 
2.50.1



