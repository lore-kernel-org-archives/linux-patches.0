Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4048B168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:42:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D642C433D2;
	Mon,  8 May 2023 10:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542569;
	bh=S+r0qtguRFC3MYOnUV0u/jp5wGKz2OatD/jYEOi+MDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jyyLJjv8xIrtwADvfyrWGOLWRxiPVF6hTklEuYqNqmxeoPvAzhW07LFMIMGlfYrUJ
	 X+SnEAdm1NLDyziVsX5MO3cSWxSo5BQqzqRATA/IOGHrWYxD3VG3IMBlR23JKlbu/Z
	 K7M6xH0hLTzQlhl6eXCIt4YxEXJuDNICOGq3TJPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 477/663] HID: amd_sfh: Handle "no sensors" enabled for SFH1.1
Date: Mon,  8 May 2023 11:45:03 +0200
Message-Id: <20230508094443.771264894@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit 8455cbb25927013b3417ab619dced1c0e87708af ]

Based on num_hid_devices, each sensor device is initialized. If
"no sensors" is initialized, amd_sfh work initialization and scheduling
doesn’t make sense and returns EOPNOTSUPP to stop driver probe. Hence,
add a check for "no sensors" enabled to handle the special case.

Fixes: 93ce5e0231d7 ("HID: amd_sfh: Implement SFH1.1 functionality")
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
index a1d6e08fab7d4..bb8bd7892b674 100644
--- a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
+++ b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
@@ -112,6 +112,7 @@ static int amd_sfh1_1_hid_client_init(struct amd_mp2_dev *privdata)
 	cl_data->num_hid_devices = amd_sfh_get_sensor_num(privdata, &cl_data->sensor_idx[0]);
 	if (cl_data->num_hid_devices == 0)
 		return -ENODEV;
+	cl_data->is_any_sensor_enabled = false;
 
 	INIT_DELAYED_WORK(&cl_data->work, amd_sfh_work);
 	INIT_DELAYED_WORK(&cl_data->work_buffer, amd_sfh_work_buffer);
@@ -170,6 +171,7 @@ static int amd_sfh1_1_hid_client_init(struct amd_mp2_dev *privdata)
 		status = (status == 0) ? SENSOR_ENABLED : SENSOR_DISABLED;
 
 		if (status == SENSOR_ENABLED) {
+			cl_data->is_any_sensor_enabled = true;
 			cl_data->sensor_sts[i] = SENSOR_ENABLED;
 			rc = amdtp_hid_probe(i, cl_data);
 			if (rc) {
@@ -186,12 +188,21 @@ static int amd_sfh1_1_hid_client_init(struct amd_mp2_dev *privdata)
 					cl_data->sensor_sts[i]);
 				goto cleanup;
 			}
+		} else {
+			cl_data->sensor_sts[i] = SENSOR_DISABLED;
 		}
 		dev_dbg(dev, "sid 0x%x (%s) status 0x%x\n",
 			cl_data->sensor_idx[i], get_sensor_name(cl_data->sensor_idx[i]),
 			cl_data->sensor_sts[i]);
 	}
 
+	if (!cl_data->is_any_sensor_enabled) {
+		dev_warn(dev, "Failed to discover, sensors not enabled is %d\n",
+			 cl_data->is_any_sensor_enabled);
+		rc = -EOPNOTSUPP;
+		goto cleanup;
+	}
+
 	schedule_delayed_work(&cl_data->work_buffer, msecs_to_jiffies(AMD_SFH_IDLE_LOOP));
 	return 0;
 
-- 
2.39.2



