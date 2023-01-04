Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3EFAD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90288C433EF;
	Wed,  4 Jan 2023 16:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849666;
	bh=A1uw5Hxj7vIDBREgQvE/zNZFncoElsjiK6WCBNxgwko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hyYxDiL0lU7pcrx8+l4ewFVjzUJlU5dZI77serJ74WqucOaTzWxNHqUFkuiVam/5E
	 eGXrBq1Fh2U3nIdXoWrbWxVsE6vvvKvhApr/e3OMzAXsUh4ZpD3fpjm+RLokwp/jBO
	 X9/K3z5pTtccFKoVd2NwOiuHNIfS9i/YaO1YvUyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Quan <evan.quan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 177/177] drm/amd/pm: correct the fan speed retrieving in PWM for some SMU13 asics
Date: Wed,  4 Jan 2023 17:07:48 +0100
Message-Id: <20230104160513.051677410@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Evan Quan <evan.quan@amd.com>

commit e73fc71e8f015d61f3adca7659cb209fd5117aa5 upstream.

For SMU 13.0.0 and 13.0.7, the output from PMFW is in percent. Driver
need to convert that into correct PMW(255) based.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0, 6.1
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c |   17 ++++++++++++++---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c |   17 ++++++++++++++---
 2 files changed, 28 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -1417,12 +1417,23 @@ out:
 static int smu_v13_0_0_get_fan_speed_pwm(struct smu_context *smu,
 					 uint32_t *speed)
 {
+	int ret;
+
 	if (!speed)
 		return -EINVAL;
 
-	return smu_v13_0_0_get_smu_metrics_data(smu,
-						METRICS_CURR_FANPWM,
-						speed);
+	ret = smu_v13_0_0_get_smu_metrics_data(smu,
+					       METRICS_CURR_FANPWM,
+					       speed);
+	if (ret) {
+		dev_err(smu->adev->dev, "Failed to get fan speed(PWM)!");
+		return ret;
+	}
+
+	/* Convert the PMFW output which is in percent to pwm(255) based */
+	*speed = MIN(*speed * 255 / 100, 255);
+
+	return 0;
 }
 
 static int smu_v13_0_0_get_fan_speed_rpm(struct smu_context *smu,
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -1361,12 +1361,23 @@ static int smu_v13_0_7_populate_umd_stat
 static int smu_v13_0_7_get_fan_speed_pwm(struct smu_context *smu,
 					 uint32_t *speed)
 {
+	int ret;
+
 	if (!speed)
 		return -EINVAL;
 
-	return smu_v13_0_7_get_smu_metrics_data(smu,
-						METRICS_CURR_FANPWM,
-						speed);
+	ret = smu_v13_0_7_get_smu_metrics_data(smu,
+					       METRICS_CURR_FANPWM,
+					       speed);
+	if (ret) {
+		dev_err(smu->adev->dev, "Failed to get fan speed(PWM)!");
+		return ret;
+	}
+
+	/* Convert the PMFW output which is in percent to pwm(255) based */
+	*speed = MIN(*speed * 255 / 100, 255);
+
+	return 0;
 }
 
 static int smu_v13_0_7_get_fan_speed_rpm(struct smu_context *smu,


