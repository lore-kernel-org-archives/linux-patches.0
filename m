Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A716184A27;
	Wed,  7 Aug 2024 15:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043626; cv=none; b=Zx00pLgVXwAB7Oe2ynKfaDc2Gts7UEt5jFC0FYQZJWv8wh3ejZrae5HjCejV1Su1YW+/DeUzHMLUOwEXtmt2J8EO7yI+vbJfy1lU44JI2KCxSncFAedktg3nqRX8Q+q28Nv8ehJk/78p8QzsoP58QJGmXaMp3qdcIHGIEYDDK/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043626; c=relaxed/simple;
	bh=C6L/smlR3srmvju6xsfRp1JLDHm8dWWgnTwNZrDjlKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOj9nIKsmW5nuAkbYnwxGZ6f1bytemNCu/4K5Nb8ejju1yGgS410d8KhKpQ5B+4pvR5CCfmmkgM2VbfZxfYj0tyozXzbVhvc/oc8BYoCBT2dtTIhQy71x2qfseuLCyUYYnrv5CPs9EE3eivFXlRpjB9t3smqufIzajm/JejW1x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RUp4Jnch; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RUp4Jnch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096DEC32781;
	Wed,  7 Aug 2024 15:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043626;
	bh=C6L/smlR3srmvju6xsfRp1JLDHm8dWWgnTwNZrDjlKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RUp4Jnchonl1FAxBjeZmxG9c9ZphpVU2b85sAGCRMgCaNxtbNT+gnI9E75kkWsGN6
	 aZ7bLpxUeUN51ppl4IeUQg2FGeZbcTWbJZx2pEAgyF58XbsYW7p2kOwhaPld5NRMpP
	 cfJdfAGRHk/3VqjzIZZ2eVR71wiqknLfcr5Z7v3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurinko <petrvelicka@tuta.io>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 40/86] HID: amd_sfh: Move sensor discovery before HID device initialization
Date: Wed,  7 Aug 2024 17:00:19 +0200
Message-ID: <20240807150040.563556340@linuxfoundation.org>
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

[ Upstream commit 8031b001da700474c11d28629581480b12a0d8d4 ]

Sensors discovery is independent of HID device initialization. If sensor
discovery fails after HID initialization, then the HID device needs to be
deinitialized. Therefore, sensors discovery should be moved before HID
device initialization.

Fixes: 7bcfdab3f0c6 ("HID: amd_sfh: if no sensors are enabled, clean up")
Tested-by: Aurinko <petrvelicka@tuta.io>
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Link: https://patch.msgid.link/20240718111616.3012155-1-Basavaraj.Natikar@amd.com
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_client.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_client.c b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
index 6e65379b10d53..4343fef7dd83e 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_client.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
@@ -287,12 +287,22 @@ int amd_sfh_hid_client_init(struct amd_mp2_dev *privdata)
 		mp2_ops->start(privdata, info);
 		cl_data->sensor_sts[i] = amd_sfh_wait_for_response
 						(privdata, cl_data->sensor_idx[i], SENSOR_ENABLED);
+
+		if (cl_data->sensor_sts[i] == SENSOR_ENABLED)
+			cl_data->is_any_sensor_enabled = true;
+	}
+
+	if (!cl_data->is_any_sensor_enabled ||
+	    (mp2_ops->discovery_status && mp2_ops->discovery_status(privdata) == 0)) {
+		dev_warn(dev, "Failed to discover, sensors not enabled is %d\n",
+			 cl_data->is_any_sensor_enabled);
+		rc = -EOPNOTSUPP;
+		goto cleanup;
 	}
 
 	for (i = 0; i < cl_data->num_hid_devices; i++) {
 		cl_data->cur_hid_dev = i;
 		if (cl_data->sensor_sts[i] == SENSOR_ENABLED) {
-			cl_data->is_any_sensor_enabled = true;
 			rc = amdtp_hid_probe(i, cl_data);
 			if (rc)
 				goto cleanup;
@@ -308,12 +318,6 @@ int amd_sfh_hid_client_init(struct amd_mp2_dev *privdata)
 			cl_data->sensor_sts[i]);
 	}
 
-	if (!cl_data->is_any_sensor_enabled ||
-	   (mp2_ops->discovery_status && mp2_ops->discovery_status(privdata) == 0)) {
-		dev_warn(dev, "Failed to discover, sensors not enabled is %d\n", cl_data->is_any_sensor_enabled);
-		rc = -EOPNOTSUPP;
-		goto cleanup;
-	}
 	schedule_delayed_work(&cl_data->work_buffer, msecs_to_jiffies(AMD_SFH_IDLE_LOOP));
 	return 0;
 
-- 
2.43.0



