Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6311F262BE;
	Mon, 27 May 2024 19:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838170; cv=none; b=I/3N+ca/oal684HCsupHZZ/P69hGV86yRF6VZXsVfpXWnKI1mTk7h51ga+CFYvOPkTwVY6XU24DZlur4j7XRekrBpVPVV/jzbDZ6QPadaF+WrLPYkp4TsqZTwnAPnRRNb1YNSxgJJZQKPEszBgOlXdo9nFxcGgKs2ZXOeLvMBT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838170; c=relaxed/simple;
	bh=4ze4FDo+4S8E4RrO2QizEHfsN7Xhtol9tGwQpzMQYtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJfGcCCV4BsVe9nvgLzaSySH7a+Ctyf/q2THIq6MjLloqfDv3aMQUe6f/T/sGchbU0nX5Bt1le7stvW4ti09XbGqH3Es/VFuGHPuCmvEHcrPkgH8r86+DBwsQHEDESyYeRtFMa1GlsOJawWqNmwF2x8Hml/wnu4A8qfdMy0d9hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A2Mxree9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2Mxree9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB63C2BBFC;
	Mon, 27 May 2024 19:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838170;
	bh=4ze4FDo+4S8E4RrO2QizEHfsN7Xhtol9tGwQpzMQYtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A2Mxree91OZ/XWr/8FHNZPIGsh1XhxbEvRryP1IPqblz7z87nDRV2VTl1L7P+OEJM
	 isArPGKeWJNzCfK80kQ8+hpTbbfWToq782iWEak5dU4oR3NIXZSUGKLm7ObS26/a++
	 yIJlK4pcu1WhEXCJhpYrdXHMI9hjfhd9fYdjDMio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 292/493] HID: amd_sfh: Handle "no sensors" in PM operations
Date: Mon, 27 May 2024 20:54:54 +0200
Message-ID: <20240527185639.854945457@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit 077e3e3bc84a51891e732507bbbd9acf6e0e4c8b ]

Resume or suspend each sensor device based on the num_hid_devices.
Therefore, add a check to handle the special case where no sensors are
present.

Fixes: 93ce5e0231d7 ("HID: amd_sfh: Implement SFH1.1 functionality")
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
index 9dbe6f4cb2942..c89e6a2a58736 100644
--- a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
+++ b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
@@ -227,6 +227,11 @@ static void amd_sfh_resume(struct amd_mp2_dev *mp2)
 	struct amd_mp2_sensor_info info;
 	int i, status;
 
+	if (!cl_data->is_any_sensor_enabled) {
+		amd_sfh_clear_intr(mp2);
+		return;
+	}
+
 	for (i = 0; i < cl_data->num_hid_devices; i++) {
 		if (cl_data->sensor_sts[i] == SENSOR_DISABLED) {
 			info.sensor_idx = cl_data->sensor_idx[i];
@@ -252,6 +257,11 @@ static void amd_sfh_suspend(struct amd_mp2_dev *mp2)
 	struct amdtp_cl_data *cl_data = mp2->cl_data;
 	int i, status;
 
+	if (!cl_data->is_any_sensor_enabled) {
+		amd_sfh_clear_intr(mp2);
+		return;
+	}
+
 	for (i = 0; i < cl_data->num_hid_devices; i++) {
 		if (cl_data->sensor_idx[i] != HPD_IDX &&
 		    cl_data->sensor_sts[i] == SENSOR_ENABLED) {
-- 
2.43.0



