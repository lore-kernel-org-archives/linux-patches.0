Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EA0824BB;
	Wed,  7 Aug 2024 15:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043624; cv=none; b=cdrKwzzpGstguWfjUZgr82w0HJIGNv4S9+OwI28edaqjAqULYYASzebL850TCSrS2p/2oU8U5SlB/EXzejdiRN421EYoRZ+3sGaZIBfwjKI2lY81vMrn0WwBiKo8MhAnzvpOTaW7Ped9CmGwgqiRiLI3QN293YlK9zsXC0ipHPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043624; c=relaxed/simple;
	bh=OPBXGYK7HkKUUwC2ddfz4Z6eD50I2M3TMQbbInRshas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYPAM/fMb+vULeX7svbLPs2rplIOuI0wixRUzckGjaJrh6HU6TUOdk0Uf0z6AcUhvGl2LQgrcPJXJ9ZP9t6VduJ14wCrs6eCfa/fwr/XoNDAvOcnwzq8TCjz8WUVCEoQlbMZrWqcsGBlO+V8XRTb5i3BR1AaXnG2eFb58HStVTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Idsa9uxk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Idsa9uxk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345E7C32781;
	Wed,  7 Aug 2024 15:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043623;
	bh=OPBXGYK7HkKUUwC2ddfz4Z6eD50I2M3TMQbbInRshas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Idsa9uxkusM3kgoIpsctHARw/+8flZLIESB6FI/2k6DX73aFI+hJp8dW5iRIURiFq
	 T/D24L5A2mvE7yZmt6jlnlr5fUtICA/lYBJUdrlkJ8vtWa9/n5mejxqWgl3T7MhZkK
	 OIboCjAxMwksmOEZ8Z6GyQ6Hxmv/gN52FbvMJ7RI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 39/86] HID: amd_sfh: Split sensor and HID initialization
Date: Wed,  7 Aug 2024 17:00:18 +0200
Message-ID: <20240807150040.529429170@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit 5ca505c6b0259606361d8f95b0811b783d4e78f7 ]

Sensors are enabled independently of HID device initialization. Sensor
initialization should be kept separate in this case, while HID devices
should be initialized according to the sensor state. Hence split sensor
initialization and HID initialization into separate blocks.

Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Stable-dep-of: 8031b001da70 ("HID: amd_sfh: Move sensor discovery before HID device initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_client.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_client.c b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
index 34eb419b225ed..6e65379b10d53 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_client.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
@@ -214,7 +214,7 @@ int amd_sfh_hid_client_init(struct amd_mp2_dev *privdata)
 	struct device *dev;
 	u32 feature_report_size;
 	u32 input_report_size;
-	int rc, i, status;
+	int rc, i;
 	u8 cl_idx;
 
 	req_list = &cl_data->req_list;
@@ -285,12 +285,15 @@ int amd_sfh_hid_client_init(struct amd_mp2_dev *privdata)
 		if (rc)
 			goto cleanup;
 		mp2_ops->start(privdata, info);
-		status = amd_sfh_wait_for_response
-				(privdata, cl_data->sensor_idx[i], SENSOR_ENABLED);
-		if (status == SENSOR_ENABLED) {
+		cl_data->sensor_sts[i] = amd_sfh_wait_for_response
+						(privdata, cl_data->sensor_idx[i], SENSOR_ENABLED);
+	}
+
+	for (i = 0; i < cl_data->num_hid_devices; i++) {
+		cl_data->cur_hid_dev = i;
+		if (cl_data->sensor_sts[i] == SENSOR_ENABLED) {
 			cl_data->is_any_sensor_enabled = true;
-			cl_data->sensor_sts[i] = SENSOR_ENABLED;
-			rc = amdtp_hid_probe(cl_data->cur_hid_dev, cl_data);
+			rc = amdtp_hid_probe(i, cl_data);
 			if (rc)
 				goto cleanup;
 		} else {
@@ -304,6 +307,7 @@ int amd_sfh_hid_client_init(struct amd_mp2_dev *privdata)
 			cl_data->sensor_idx[i], get_sensor_name(cl_data->sensor_idx[i]),
 			cl_data->sensor_sts[i]);
 	}
+
 	if (!cl_data->is_any_sensor_enabled ||
 	   (mp2_ops->discovery_status && mp2_ops->discovery_status(privdata) == 0)) {
 		dev_warn(dev, "Failed to discover, sensors not enabled is %d\n", cl_data->is_any_sensor_enabled);
-- 
2.43.0



