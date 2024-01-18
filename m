Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567791B96D;
	Thu, 18 Jan 2024 10:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575377; cv=none; b=QfRELG4Z+PWJrPOz6BUXoOorDYbSn9pcPYGJdjH682xyyEyeXoT9Ddya0mpYL/FSaz/0aKXIyjW5Vw3OO6pZ7ivFKACf/40X7+EyaxysZJm4stzfGAUaZUlj9j4DY7qYXUeMB4Oeyl4DyQEg3zZaaSIkaCmt0hLMDKBfIMxpCFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575377; c=relaxed/simple;
	bh=h+c6TqKzNVW5yF545rJbQwd5cWl+bk9tVSDGlcoCgow=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=k9vr/gxzLEMKAAzh/WG9uK0D8kXKL3I3Iq90p//c09wjeVauQ3AyxeVD7yQRoL6dUxWQVmjlDgcVhDKpSzkteeyBOESv0sJTW9hox3n0jjQIUURUSLWpYZCbZMdPlW+JvqkCj23KkSfDdwbKdVEkxutccyxu9Zheoensn08sG/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rNXSK31v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rNXSK31v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD16BC433F1;
	Thu, 18 Jan 2024 10:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575377;
	bh=h+c6TqKzNVW5yF545rJbQwd5cWl+bk9tVSDGlcoCgow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rNXSK31vmqDysYu7IppFMkoqNOGX3iRr7wLHYcN29ZHpb+jxr/J7BoJ6r1Hnm8UVq
	 nRcxrvwbmzCMd9vElLDH/kGFOt/a7dyWEZ3vSOTnoF5FN8sYRJfaqtjUWPm2d8ssN/
	 slguDcq3ufH+WrnOEAm+gqvXSubiJsT+047hAjQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Sam Lantinga <slouken@libsdl.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/150] HID: nintendo: Prevent divide-by-zero on code
Date: Thu, 18 Jan 2024 11:48:52 +0100
Message-ID: <20240118104325.143680466@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guilherme G. Piccoli <gpiccoli@igalia.com>

[ Upstream commit 6eb04ca8c52e3f8c8ea7102ade81d642eee87f4a ]

It was reported [0] that adding a generic joycon to the system caused
a kernel crash on Steam Deck, with the below panic spew:

divide error: 0000 [#1] PREEMPT SMP NOPTI
[...]
Hardware name: Valve Jupiter/Jupiter, BIOS F7A0119 10/24/2023
RIP: 0010:nintendo_hid_event+0x340/0xcc1 [hid_nintendo]
[...]
Call Trace:
 [...]
 ? exc_divide_error+0x38/0x50
 ? nintendo_hid_event+0x340/0xcc1 [hid_nintendo]
 ? asm_exc_divide_error+0x1a/0x20
 ? nintendo_hid_event+0x307/0xcc1 [hid_nintendo]
 hid_input_report+0x143/0x160
 hidp_session_run+0x1ce/0x700 [hidp]

Since it's a divide-by-0 error, by tracking the code for potential
denominator issues, we've spotted 2 places in which this could happen;
so let's guard against the possibility and log in the kernel if the
condition happens. This is specially useful since some data that
fills some denominators are read from the joycon HW in some cases,
increasing the potential for flaws.

[0] https://github.com/ValveSoftware/SteamOS/issues/1070

Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Tested-by: Sam Lantinga <slouken@libsdl.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-nintendo.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-nintendo.c b/drivers/hid/hid-nintendo.c
index 7644edee996a..4850e915a57d 100644
--- a/drivers/hid/hid-nintendo.c
+++ b/drivers/hid/hid-nintendo.c
@@ -896,14 +896,27 @@ static int joycon_request_calibration(struct joycon_ctlr *ctlr)
  */
 static void joycon_calc_imu_cal_divisors(struct joycon_ctlr *ctlr)
 {
-	int i;
+	int i, divz = 0;
 
 	for (i = 0; i < 3; i++) {
 		ctlr->imu_cal_accel_divisor[i] = ctlr->accel_cal.scale[i] -
 						ctlr->accel_cal.offset[i];
 		ctlr->imu_cal_gyro_divisor[i] = ctlr->gyro_cal.scale[i] -
 						ctlr->gyro_cal.offset[i];
+
+		if (ctlr->imu_cal_accel_divisor[i] == 0) {
+			ctlr->imu_cal_accel_divisor[i] = 1;
+			divz++;
+		}
+
+		if (ctlr->imu_cal_gyro_divisor[i] == 0) {
+			ctlr->imu_cal_gyro_divisor[i] = 1;
+			divz++;
+		}
 	}
+
+	if (divz)
+		hid_warn(ctlr->hdev, "inaccurate IMU divisors (%d)\n", divz);
 }
 
 static const s16 DFLT_ACCEL_OFFSET /*= 0*/;
@@ -1132,16 +1145,16 @@ static void joycon_parse_imu_report(struct joycon_ctlr *ctlr,
 		    JC_IMU_SAMPLES_PER_DELTA_AVG) {
 			ctlr->imu_avg_delta_ms = ctlr->imu_delta_samples_sum /
 						 ctlr->imu_delta_samples_count;
-			/* don't ever want divide by zero shenanigans */
-			if (ctlr->imu_avg_delta_ms == 0) {
-				ctlr->imu_avg_delta_ms = 1;
-				hid_warn(ctlr->hdev,
-					 "calculated avg imu delta of 0\n");
-			}
 			ctlr->imu_delta_samples_count = 0;
 			ctlr->imu_delta_samples_sum = 0;
 		}
 
+		/* don't ever want divide by zero shenanigans */
+		if (ctlr->imu_avg_delta_ms == 0) {
+			ctlr->imu_avg_delta_ms = 1;
+			hid_warn(ctlr->hdev, "calculated avg imu delta of 0\n");
+		}
+
 		/* useful for debugging IMU sample rate */
 		hid_dbg(ctlr->hdev,
 			"imu_report: ms=%u last_ms=%u delta=%u avg_delta=%u\n",
-- 
2.43.0



