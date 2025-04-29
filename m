Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37DB2522A1;
	Tue, 29 Apr 2025 17:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946241; cv=none; b=dcu9xGwYi7KsJLEljIEIVGuK3QjLT2Qoee/XQudWo/bC5rvQA8/H65hdrs66T+t7VKsBNiyXd2bgMhjGxVMLuC6Fn5GDceUnL3JP0s401KVDvxgSg/+vG0lCZr5/K1Vr3muvFunczcE+CvIdRMISrZPw/ztW6BDSzEkVvG7j0uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946241; c=relaxed/simple;
	bh=IJptYgRhMSUZxNwGECoFJjf4EhmkdsNIfJd0jQkgfyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5GmY5Nb0Mf9VpYxzai2DgvPYj4yrpPEey2phCOe3QJZBSvPIz0Z6WGjWPuZz4OhlC+RiZE96cRdUDfn/vHPgfY2JebMviKapSoQL5GiHqRiYR0e3l5F6ISh0cdHW0h8K0BPSpCcnIDAC8HWnvrLrrEsAtw3tGJt2vbz2Y56fCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6Ml7Q/j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6Ml7Q/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1143C4CEE3;
	Tue, 29 Apr 2025 17:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946240;
	bh=IJptYgRhMSUZxNwGECoFJjf4EhmkdsNIfJd0jQkgfyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W6Ml7Q/jZi0tnDd9OsAep3WemNrJtC0Lqyru1LmyzWLxdQJTtxPgRMnQgysb74JjS
	 ryuDZkPw5Q6hXoiruLop4OUdCNSYRXHDlI+RbVJBGUMWNg3zBuTLrenXpTBSdCbe24
	 A8wZFHsy2pgzNzjsSPsuX0ClXPQV4YhMJ1Qu2s+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 201/311] usb: typec: ucsi: ccg: move command quirks to ucsi_ccg_sync_control()
Date: Tue, 29 Apr 2025 18:40:38 +0200
Message-ID: <20250429161129.247433244@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 7f82635494ef3391ff6b542249793c7febf99c3f ]

It is easier to keep all command-specific quirks in a single place. Move
them to ucsi_ccg_sync_control() as the code now allows us to return
modified messages data.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250120-ucsi-merge-commands-v2-2-462a1ec22ecc@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi_ccg.c | 62 +++++++++++++++----------------
 1 file changed, 29 insertions(+), 33 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi_ccg.c b/drivers/usb/typec/ucsi/ucsi_ccg.c
index 43a8a67159d84..c1d776c82fc2e 100644
--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -222,7 +222,6 @@ struct ucsi_ccg {
 	u16 fw_build;
 	struct work_struct pm_work;
 
-	u64 last_cmd_sent;
 	bool has_multiple_dp;
 	struct ucsi_ccg_altmode orig[UCSI_MAX_ALTMODES];
 	struct ucsi_ccg_altmode updated[UCSI_MAX_ALTMODES];
@@ -538,9 +537,10 @@ static void ucsi_ccg_update_set_new_cam_cmd(struct ucsi_ccg *uc,
  * first and then vdo=0x3
  */
 static void ucsi_ccg_nvidia_altmode(struct ucsi_ccg *uc,
-				    struct ucsi_altmode *alt)
+				    struct ucsi_altmode *alt,
+				    u64 command)
 {
-	switch (UCSI_ALTMODE_OFFSET(uc->last_cmd_sent)) {
+	switch (UCSI_ALTMODE_OFFSET(command)) {
 	case NVIDIA_FTB_DP_OFFSET:
 		if (alt[0].mid == USB_TYPEC_NVIDIA_VLINK_DBG_VDO)
 			alt[0].mid = USB_TYPEC_NVIDIA_VLINK_DP_VDO |
@@ -578,37 +578,11 @@ static int ucsi_ccg_read_cci(struct ucsi *ucsi, u32 *cci)
 static int ucsi_ccg_read_message_in(struct ucsi *ucsi, void *val, size_t val_len)
 {
 	struct ucsi_ccg *uc = ucsi_get_drvdata(ucsi);
-	struct ucsi_capability *cap;
-	struct ucsi_altmode *alt;
 
 	spin_lock(&uc->op_lock);
 	memcpy(val, uc->op_data.message_in, val_len);
 	spin_unlock(&uc->op_lock);
 
-	switch (UCSI_COMMAND(uc->last_cmd_sent)) {
-	case UCSI_GET_CURRENT_CAM:
-		if (uc->has_multiple_dp)
-			ucsi_ccg_update_get_current_cam_cmd(uc, (u8 *)val);
-		break;
-	case UCSI_GET_ALTERNATE_MODES:
-		if (UCSI_ALTMODE_RECIPIENT(uc->last_cmd_sent) ==
-		    UCSI_RECIPIENT_SOP) {
-			alt = val;
-			if (alt[0].svid == USB_TYPEC_NVIDIA_VLINK_SID)
-				ucsi_ccg_nvidia_altmode(uc, alt);
-		}
-		break;
-	case UCSI_GET_CAPABILITY:
-		if (uc->fw_build == CCG_FW_BUILD_NVIDIA_TEGRA) {
-			cap = val;
-			cap->features &= ~UCSI_CAP_ALT_MODE_DETAILS;
-		}
-		break;
-	default:
-		break;
-	}
-	uc->last_cmd_sent = 0;
-
 	return 0;
 }
 
@@ -639,11 +613,9 @@ static int ucsi_ccg_sync_control(struct ucsi *ucsi, u64 command, u32 *cci,
 	mutex_lock(&uc->lock);
 	pm_runtime_get_sync(uc->dev);
 
-	uc->last_cmd_sent = command;
-
-	if (UCSI_COMMAND(uc->last_cmd_sent) == UCSI_SET_NEW_CAM &&
+	if (UCSI_COMMAND(command) == UCSI_SET_NEW_CAM &&
 	    uc->has_multiple_dp) {
-		con_index = (uc->last_cmd_sent >> 16) &
+		con_index = (command >> 16) &
 			UCSI_CMD_CONNECTOR_MASK;
 		if (con_index == 0) {
 			ret = -EINVAL;
@@ -655,6 +627,30 @@ static int ucsi_ccg_sync_control(struct ucsi *ucsi, u64 command, u32 *cci,
 
 	ret = ucsi_sync_control_common(ucsi, command, cci, data, size);
 
+	switch (UCSI_COMMAND(command)) {
+	case UCSI_GET_CURRENT_CAM:
+		if (uc->has_multiple_dp)
+			ucsi_ccg_update_get_current_cam_cmd(uc, (u8 *)data);
+		break;
+	case UCSI_GET_ALTERNATE_MODES:
+		if (UCSI_ALTMODE_RECIPIENT(command) == UCSI_RECIPIENT_SOP) {
+			struct ucsi_altmode *alt = data;
+
+			if (alt[0].svid == USB_TYPEC_NVIDIA_VLINK_SID)
+				ucsi_ccg_nvidia_altmode(uc, alt, command);
+		}
+		break;
+	case UCSI_GET_CAPABILITY:
+		if (uc->fw_build == CCG_FW_BUILD_NVIDIA_TEGRA) {
+			struct ucsi_capability *cap = data;
+
+			cap->features &= ~UCSI_CAP_ALT_MODE_DETAILS;
+		}
+		break;
+	default:
+		break;
+	}
+
 err_put:
 	pm_runtime_put_sync(uc->dev);
 	mutex_unlock(&uc->lock);
-- 
2.39.5



