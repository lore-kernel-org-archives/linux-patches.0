Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223A6168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C69C4339B;
	Mon,  8 May 2023 10:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542556;
	bh=RSjOxyB5EPvG1Rqoq05Wv2cmDWnbUTTmS3+tHQm/tIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUeb7jIAZIoHhs40PC3WhR4FAQ+Z/Zh2G6+g9J4dmJPW7ZCrmr/xM/RHnGoBdWEGf
	 1QORnbYHCFUDqYXrrXJZTKoHFsYl9OqVmQmEaz9WNI9sCgNmQQ0yzxYLJjc0hVutxH
	 AkfAEXOovZ+e2GpwLHRPkqzvQaL+YYaN3++HvUQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 473/663] HID: amd_sfh: Fix illuminance value
Date: Mon,  8 May 2023 11:44:59 +0200
Message-Id: <20230508094443.598821501@linuxfoundation.org>
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

[ Upstream commit a33e5e393171ae8384d3381db5cd159ba877cfcb ]

Illuminance value is actually 32 bits, but is incorrectly trancated to
16 bits. Hence convert to integer illuminace accordingly to reflect
correct values.

Fixes: 93ce5e0231d7 ("HID: amd_sfh: Implement SFH1.1 functionality")
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_desc.c      | 2 +-
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_desc.c b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_desc.c
index 0609fea581c96..6f0d332ccf51c 100644
--- a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_desc.c
+++ b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_desc.c
@@ -218,7 +218,7 @@ static u8 get_input_rep(u8 current_index, int sensor_idx, int report_id,
 			     OFFSET_SENSOR_DATA_DEFAULT;
 		memcpy_fromio(&als_data, sensoraddr, sizeof(struct sfh_als_data));
 		get_common_inputs(&als_input.common_property, report_id);
-		als_input.illuminance_value = als_data.lux;
+		als_input.illuminance_value = float_to_int(als_data.lux);
 		report_size = sizeof(als_input);
 		memcpy(input_report, &als_input, sizeof(als_input));
 		break;
diff --git a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.h b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.h
index a3e0ec289e3f9..9d31d5b510eb4 100644
--- a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.h
+++ b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.h
@@ -133,7 +133,7 @@ struct sfh_mag_data {
 
 struct sfh_als_data {
 	struct sfh_common_data commondata;
-	u16 lux;
+	u32 lux;
 };
 
 struct hpd_status {
-- 
2.39.2



