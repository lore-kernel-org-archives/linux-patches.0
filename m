Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BA8374C4;
	Tue,  8 Apr 2025 11:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110820; cv=none; b=lisva6GfP6Lp+ANZFEcl2deP1KWU3od5QbhcVwjFF8H1o3mcSffSWcIVAoTTBpeXg2ADaeXxYZ9l7B8R1a1euVNKebHJ6c7dDSUH8zJ3s5cxrIKYQLmPr2o22UoGUEiG+PLyDzrMYFHOZwidrw2PcMX3AnseHIeXMuTubLezVr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110820; c=relaxed/simple;
	bh=Pn3gXPOBjRPWs+XCxjWauX5kg037zZJTiBqvgclFLv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyAI+gtVZBlSkHgpJxMJu8zj3ifnGV3Dvu3Lw9PDmiqPf+xBzvWOpHJnJaAwVuVyEnq1R4JU8QBKZF6d1a4QH6fwDbJ5Ev75pniIa8S28wGty6JOg7zp7JaXiCZ9s9LXGH6Pve164vep8MczaquW4QuUPss9wVw/wKRbOc0QI6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7H8zOy6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7H8zOy6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBEE2C4CEE5;
	Tue,  8 Apr 2025 11:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110820;
	bh=Pn3gXPOBjRPWs+XCxjWauX5kg037zZJTiBqvgclFLv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7H8zOy6BcdAnYIKu6fENq8UHR44qXp96JAXyXdgSXNnOiN0XN927+f+/HLE3v68H
	 JlV25cYH+T5nXTr8M+Mr/sxcmNLrSqLyGFgqtO7eieIZYSDW9eitdh7WAMYwVD3r6X
	 kOE85fKqJ5+NURGJbw0k9seuoF3lcf9LXU9bOkVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 205/731] wifi: mwifiex: Fix RF calibration data download from file
Date: Tue,  8 Apr 2025 12:41:42 +0200
Message-ID: <20250408104919.048610445@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

From: Jeff Chen <jeff.chen_1@nxp.com>

[ Upstream commit 9868c4ce9481043d6c11f7421fe2b9637aa0feee ]

This patch resolves an issue where RF calibration data from a
file could not be downloaded to the firmware. The feature to
download calibration data from a file was broken by the commit:
d39fbc88956e.

The issue arose because the function `mwifiex_cmd_cfg_data()`
was modified in a way that prevented proper handling of
file-based calibration data. While this patch restores the ability
to download RF calibration data from a file, it may inadvertently
break the feature to download calibration data from the device
tree. This is because the function `mwifiex_dnld_dt_cfgdata()`,
which also relies on `mwifiex_cmd_cfg_data()`, is still used for
device tree-based calibration data downloads.

Fixes: d39fbc88956e ("mwifiex: remove cfg_data construction")
Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
Link: https://patch.msgid.link/20250318050739.2239376-3-jeff.chen_1@nxp.com
[add newline for shorter lines]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/fw.h      | 14 ++++++++++++++
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c | 12 ++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 4a96281792cc1..91458f3bd14a5 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -454,6 +454,11 @@ enum mwifiex_channel_flags {
 #define HostCmd_RET_BIT                       0x8000
 #define HostCmd_ACT_GEN_GET                   0x0000
 #define HostCmd_ACT_GEN_SET                   0x0001
+#define HOST_CMD_ACT_GEN_SET                  0x0001
+/* Add this non-CamelCase-style macro to comply with checkpatch requirements.
+ *  This macro will eventually replace all existing CamelCase-style macros in
+ *  the future for consistency.
+ */
 #define HostCmd_ACT_GEN_REMOVE                0x0004
 #define HostCmd_ACT_BITWISE_SET               0x0002
 #define HostCmd_ACT_BITWISE_CLR               0x0003
@@ -2352,6 +2357,14 @@ struct host_cmd_ds_add_station {
 	u8 tlv[];
 } __packed;
 
+#define MWIFIEX_CFG_TYPE_CAL 0x2
+
+struct host_cmd_ds_802_11_cfg_data {
+	__le16 action;
+	__le16 type;
+	__le16 data_len;
+} __packed;
+
 struct host_cmd_ds_command {
 	__le16 command;
 	__le16 size;
@@ -2431,6 +2444,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_pkt_aggr_ctrl pkt_aggr_ctrl;
 		struct host_cmd_ds_sta_configure sta_cfg;
 		struct host_cmd_ds_add_station sta_info;
+		struct host_cmd_ds_802_11_cfg_data cfg_data;
 	} params;
 } __packed;
 
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index c0e6ce1a82fed..c4689f5a1acc8 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -1507,6 +1507,7 @@ static int mwifiex_cmd_cfg_data(struct mwifiex_private *priv,
 	u32 len;
 	u8 *data = (u8 *)cmd + S_DS_GEN;
 	int ret;
+	struct host_cmd_ds_802_11_cfg_data *pcfg_data;
 
 	if (prop) {
 		len = prop->length;
@@ -1514,12 +1515,20 @@ static int mwifiex_cmd_cfg_data(struct mwifiex_private *priv,
 						data, len);
 		if (ret)
 			return ret;
+
+		cmd->size = cpu_to_le16(S_DS_GEN + len);
 		mwifiex_dbg(adapter, INFO,
 			    "download cfg_data from device tree: %s\n",
 			    prop->name);
 	} else if (adapter->cal_data->data && adapter->cal_data->size > 0) {
 		len = mwifiex_parse_cal_cfg((u8 *)adapter->cal_data->data,
-					    adapter->cal_data->size, data);
+					    adapter->cal_data->size,
+					    data + sizeof(*pcfg_data));
+		pcfg_data = &cmd->params.cfg_data;
+		pcfg_data->action = cpu_to_le16(HOST_CMD_ACT_GEN_SET);
+		pcfg_data->type = cpu_to_le16(MWIFIEX_CFG_TYPE_CAL);
+		pcfg_data->data_len = cpu_to_le16(len);
+		cmd->size = cpu_to_le16(S_DS_GEN + sizeof(*pcfg_data) + len);
 		mwifiex_dbg(adapter, INFO,
 			    "download cfg_data from config file\n");
 	} else {
@@ -1527,7 +1536,6 @@ static int mwifiex_cmd_cfg_data(struct mwifiex_private *priv,
 	}
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_CFG_DATA);
-	cmd->size = cpu_to_le16(S_DS_GEN + len);
 
 	return 0;
 }
-- 
2.39.5



