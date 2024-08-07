Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D664B3EA9A;
	Wed,  7 Aug 2024 15:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042901; cv=none; b=hLzspfrsTS9CkZSVpKqYhBATpKruuPefak+yOzZJtmA6X6sBrPzRy7yLKnV75qy+Ru6qge3e39n6kkO4qMth0e/P3YEgwCyUpLXrvIVpnxR/WfvOcyGQbywHJA0GP3VnKkns1b4nSeqOV+BGHsCWa8zKJqXt9iZLGnDS19B8p0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042901; c=relaxed/simple;
	bh=MD4k+ef0I7vrq6SMjERLZREP6zZQkymbyRo267X4udI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZaNN8kQZDqDU0QRm/9drHAdK+IuEBnfJ3h3ebfCwd8y707yuSpWeUZicVqMGRV4MqRQ9wH493gqgRIkAfr4/UUpKzfkKoYQWYPdNWsbnKXl58I3IuZjus9Oe+h3R7uqpQvvR3OkqZoaV9KjxDNwkxOVPHreOcWse3i/R/VCYtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gSIF25zR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gSIF25zR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EDA9C4AF0B;
	Wed,  7 Aug 2024 15:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042901;
	bh=MD4k+ef0I7vrq6SMjERLZREP6zZQkymbyRo267X4udI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gSIF25zRBusQJ084U35yaPke/QIu6Z1zwUrEmlkjQ7XVtjUU3R1i+z0RZ2THpz8ip
	 cX7HZUiNNANghCq1/LW4MOO2arYT0oTXOUBNMRUEpAnxKyiLSU/Mbg5VRdc7smBHm8
	 uQ85Vihi/7/lw5RdgcTeC2KMJuYfuoH/0Ew2vUpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurinko <petrvelicka@tuta.io>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 018/123] HID: amd_sfh: Move sensor discovery before HID device initialization
Date: Wed,  7 Aug 2024 16:58:57 +0200
Message-ID: <20240807150021.406940403@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index bdb578e0899f5..4b59687ff5d82 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_client.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
@@ -288,12 +288,22 @@ int amd_sfh_hid_client_init(struct amd_mp2_dev *privdata)
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
@@ -305,12 +315,6 @@ int amd_sfh_hid_client_init(struct amd_mp2_dev *privdata)
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



