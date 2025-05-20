Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9E92522BD;
	Tue, 20 May 2025 14:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750622; cv=none; b=qKlOURFfU1vkIa4OVSzcBYPqMlspZcwvGafyvBMn1kdJT7SI8xDZzNefnpa3fr0jjsBGir8CWHzE052af6lcWzJnT1cAnkZohFRUW9uB9Iy9qjkWOPYMKUFvVYTHEHCK0JNcI4bNeo5szORbM3utphn9bAwoVf/SFqtt2GY4Y7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750622; c=relaxed/simple;
	bh=naq4yp2DIlAvBSD73+JCm+TQS/npBrWO27I4qmN8CNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V21rTnCY6QiFViSRgPoq2LOSOpmf7RWn9RYUr3a2AYMYvwVounjOlbwzBSXbuOu7aRB3KH2muVO8ydu1N6GPL3dGfW3DYl9G0WsFHWnqgnZpCA0LbT/RX70aXcG51FLEgLTQQFVUpo0Ki+hJa4cb3QOnchmJRvraiY9rPA6jmho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E/Rcv3D4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E/Rcv3D4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE02C4CEE9;
	Tue, 20 May 2025 14:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750622;
	bh=naq4yp2DIlAvBSD73+JCm+TQS/npBrWO27I4qmN8CNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E/Rcv3D466+7iHaiA12bTKz/uXltzuvttvrjx62Gu566viZ4Wdq+XvDdGizqzQmQS
	 3IxI6ZigQy7T7HD3IwtQ0/x5p4Syg7aS2ev04hKoQIC6ta3IMTEzyUezJJA98TmLTr
	 3Lhl72xJEt6LoKZ9/ynpozdxqBOm2H2ZjuL6jsqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yijun Shen <Yijun.Shen@dell.com>,
	Yijun Shen <Yijun_Shen@Dell.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.14 068/145] HID: amd_sfh: Fix SRA sensor when its the only sensor
Date: Tue, 20 May 2025 15:50:38 +0200
Message-ID: <20250520125813.244232396@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit 0cc2effbc8f522af6b9d871cd27678e6aed9d56c upstream.

On systems that only have an SRA sensor connected to SFH the sensor
doesn't get enabled due to a bad optimization condition of breaking
the sensor walk loop.

This optimization is unnecessary in the first place because if there
is only one device then the loop only runs once. Drop the condition
and explicitly mark sensor as enabled.

Reported-by: Yijun Shen <Yijun.Shen@dell.com>
Tested-By: Yijun Shen <Yijun_Shen@Dell.com>
Fixes: d1c444b47100d ("HID: amd_sfh: Add support to export device operating states")
Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
+++ b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
@@ -134,9 +134,6 @@ static int amd_sfh1_1_hid_client_init(st
 	for (i = 0; i < cl_data->num_hid_devices; i++) {
 		cl_data->sensor_sts[i] = SENSOR_DISABLED;
 
-		if (cl_data->num_hid_devices == 1 && cl_data->sensor_idx[0] == SRA_IDX)
-			break;
-
 		if (cl_data->sensor_idx[i] == SRA_IDX) {
 			info.sensor_idx = cl_data->sensor_idx[i];
 			writel(0, privdata->mmio + amd_get_p2c_val(privdata, 0));
@@ -145,8 +142,10 @@ static int amd_sfh1_1_hid_client_init(st
 				(privdata, cl_data->sensor_idx[i], ENABLE_SENSOR);
 
 			cl_data->sensor_sts[i] = (status == 0) ? SENSOR_ENABLED : SENSOR_DISABLED;
-			if (cl_data->sensor_sts[i] == SENSOR_ENABLED)
+			if (cl_data->sensor_sts[i] == SENSOR_ENABLED) {
+				cl_data->is_any_sensor_enabled = true;
 				privdata->dev_en.is_sra_present = true;
+			}
 			continue;
 		}
 


