Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9222F1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D5DC433EF;
	Wed, 28 Dec 2022 15:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241647;
	bh=PpfDcUChdczWqCkpHadSl7VJy3AjayjgqxcU11WcKCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJvdUpSc4OHQAXg0LYZlO/q7iVlLsh1B3PIrw8EE1sBSESgjdBRsg8/QfNW9FzRl0
	 TpaEE2Fed9pYRWB8EaqlZRkc4Vphwu7RL9ublk5gQzsvqbq7U5pPrdioe48BKIoSSl
	 1clg7hZMlSyYqEOY5eEd2KfasrnxneRRGlWLQ1Ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0311/1073] wifi: iwlwifi: mei: dont send SAP commands if AMT is disabled
Date: Wed, 28 Dec 2022 15:31:39 +0100
Message-Id: <20221228144336.452893652@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 95170a46b7dddbc3ac31b20ef2e8fa9d556d783d ]

We should not send any SAP command to CSME if AMT is disabled.

Reported-by: Toke Høiland-Jørgensen <toke@toke.dk>
Fixes: 2da4366f9e2c ("iwlwifi: mei: add the driver to allow cooperation with CSME")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20221030191011.ea222d41c781.Ifc90ddc3e35187683ff7f59371d792b61c8854c8@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mei/main.c | 85 ++++++++++---------
 1 file changed, 44 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mei/main.c b/drivers/net/wireless/intel/iwlwifi/mei/main.c
index 90646c54a3c5..64a637ef199c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mei/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/mei/main.c
@@ -596,8 +596,6 @@ iwl_mei_handle_rx_start_ok(struct mei_cl_device *cldev,
 			   const struct iwl_sap_me_msg_start_ok *rsp,
 			   ssize_t len)
 {
-	struct iwl_mei *mei = mei_cldev_get_drvdata(cldev);
-
 	if (len != sizeof(*rsp)) {
 		dev_err(&cldev->dev,
 			"got invalid SAP_ME_MSG_START_OK from CSME firmware\n");
@@ -616,13 +614,10 @@ iwl_mei_handle_rx_start_ok(struct mei_cl_device *cldev,
 
 	mutex_lock(&iwl_mei_mutex);
 	set_bit(IWL_MEI_STATUS_SAP_CONNECTED, &iwl_mei_status);
-	/* wifi driver has registered already */
-	if (iwl_mei_cache.ops) {
-		iwl_mei_send_sap_msg(mei->cldev,
-				     SAP_MSG_NOTIF_WIFIDR_UP);
-		iwl_mei_cache.ops->sap_connected(iwl_mei_cache.priv);
-	}
-
+	/*
+	 * We'll receive AMT_STATE SAP message in a bit and
+	 * that will continue the flow
+	 */
 	mutex_unlock(&iwl_mei_mutex);
 }
 
@@ -715,6 +710,13 @@ static void iwl_mei_set_init_conf(struct iwl_mei *mei)
 		.val = cpu_to_le32(iwl_mei_cache.rf_kill),
 	};
 
+	/* wifi driver has registered already */
+	if (iwl_mei_cache.ops) {
+		iwl_mei_send_sap_msg(mei->cldev,
+				     SAP_MSG_NOTIF_WIFIDR_UP);
+		iwl_mei_cache.ops->sap_connected(iwl_mei_cache.priv);
+	}
+
 	iwl_mei_send_sap_msg(mei->cldev, SAP_MSG_NOTIF_WHO_OWNS_NIC);
 
 	if (iwl_mei_cache.conn_info) {
@@ -1420,10 +1422,7 @@ void iwl_mei_host_associated(const struct iwl_mei_conn_info *conn_info,
 
 	mei = mei_cldev_get_drvdata(iwl_mei_global_cldev);
 
-	if (!mei)
-		goto out;
-
-	if (!mei->amt_enabled)
+	if (!mei && !mei->amt_enabled)
 		goto out;
 
 	iwl_mei_send_sap_msg_payload(mei->cldev, &msg.hdr);
@@ -1452,7 +1451,7 @@ void iwl_mei_host_disassociated(void)
 
 	mei = mei_cldev_get_drvdata(iwl_mei_global_cldev);
 
-	if (!mei)
+	if (!mei && !mei->amt_enabled)
 		goto out;
 
 	iwl_mei_send_sap_msg_payload(mei->cldev, &msg.hdr);
@@ -1488,7 +1487,7 @@ void iwl_mei_set_rfkill_state(bool hw_rfkill, bool sw_rfkill)
 
 	mei = mei_cldev_get_drvdata(iwl_mei_global_cldev);
 
-	if (!mei)
+	if (!mei && !mei->amt_enabled)
 		goto out;
 
 	iwl_mei_send_sap_msg_payload(mei->cldev, &msg.hdr);
@@ -1517,7 +1516,7 @@ void iwl_mei_set_nic_info(const u8 *mac_address, const u8 *nvm_address)
 
 	mei = mei_cldev_get_drvdata(iwl_mei_global_cldev);
 
-	if (!mei)
+	if (!mei && !mei->amt_enabled)
 		goto out;
 
 	iwl_mei_send_sap_msg_payload(mei->cldev, &msg.hdr);
@@ -1545,7 +1544,7 @@ void iwl_mei_set_country_code(u16 mcc)
 
 	mei = mei_cldev_get_drvdata(iwl_mei_global_cldev);
 
-	if (!mei)
+	if (!mei && !mei->amt_enabled)
 		goto out;
 
 	iwl_mei_send_sap_msg_payload(mei->cldev, &msg.hdr);
@@ -1571,7 +1570,7 @@ void iwl_mei_set_power_limit(const __le16 *power_limit)
 
 	mei = mei_cldev_get_drvdata(iwl_mei_global_cldev);
 
-	if (!mei)
+	if (!mei && !mei->amt_enabled)
 		goto out;
 
 	memcpy(msg.sar_chain_info_table, power_limit, sizeof(msg.sar_chain_info_table));
@@ -1678,9 +1677,10 @@ int iwl_mei_register(void *priv, const struct iwl_mei_ops *ops)
 
 		/* we have already a SAP connection */
 		if (iwl_mei_is_connected()) {
-			iwl_mei_send_sap_msg(mei->cldev,
-					     SAP_MSG_NOTIF_WIFIDR_UP);
-			ops->rfkill(priv, mei->link_prot_state);
+			if (mei->amt_enabled)
+				iwl_mei_send_sap_msg(mei->cldev,
+						     SAP_MSG_NOTIF_WIFIDR_UP);
+			ops->rfkill(priv, mei->link_prot_state, false);
 		}
 	}
 	ret = 0;
@@ -1931,29 +1931,32 @@ static void iwl_mei_remove(struct mei_cl_device *cldev)
 
 	mutex_lock(&iwl_mei_mutex);
 
-	/*
-	 * Tell CSME that we are going down so that it won't access the
-	 * memory anymore, make sure this message goes through immediately.
-	 */
-	mei->csa_throttled = false;
-	iwl_mei_send_sap_msg(mei->cldev,
-			     SAP_MSG_NOTIF_HOST_GOES_DOWN);
+	if (mei->amt_enabled) {
+		/*
+		 * Tell CSME that we are going down so that it won't access the
+		 * memory anymore, make sure this message goes through immediately.
+		 */
+		mei->csa_throttled = false;
+		iwl_mei_send_sap_msg(mei->cldev,
+				     SAP_MSG_NOTIF_HOST_GOES_DOWN);
 
-	for (i = 0; i < SEND_SAP_MAX_WAIT_ITERATION; i++) {
-		if (!iwl_mei_host_to_me_data_pending(mei))
-			break;
+		for (i = 0; i < SEND_SAP_MAX_WAIT_ITERATION; i++) {
+			if (!iwl_mei_host_to_me_data_pending(mei))
+				break;
 
-		msleep(5);
-	}
+			msleep(20);
+		}
 
-	/*
-	 * If we couldn't make sure that CSME saw the HOST_GOES_DOWN message,
-	 * it means that it will probably keep reading memory that we are going
-	 * to unmap and free, expect IOMMU error messages.
-	 */
-	if (i == SEND_SAP_MAX_WAIT_ITERATION)
-		dev_err(&mei->cldev->dev,
-			"Couldn't get ACK from CSME on HOST_GOES_DOWN message\n");
+		/*
+		 * If we couldn't make sure that CSME saw the HOST_GOES_DOWN
+		 * message, it means that it will probably keep reading memory
+		 * that we are going to unmap and free, expect IOMMU error
+		 * messages.
+		 */
+		if (i == SEND_SAP_MAX_WAIT_ITERATION)
+			dev_err(&mei->cldev->dev,
+				"Couldn't get ACK from CSME on HOST_GOES_DOWN message\n");
+	}
 
 	mutex_unlock(&iwl_mei_mutex);
 
-- 
2.35.1



