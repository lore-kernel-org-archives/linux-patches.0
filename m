Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18DF1ABCB8;
	Thu,  6 Jun 2024 14:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683286; cv=none; b=ddvJiaRsDBGMJDS3kc/lmlsgl3OXqTlpx0jiFN8b9avh/A4aYCvoYwSSHResRj+ROG9VtL04NL6rpQcHTaEUQLw5OZOvep6ms3f9vjX3GTrV3qpDhw/dH2xHnWHL5juJNeghnlXrHWNn7p6EJMHNZLCXBCrHpxA9b+n2OCtIvKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683286; c=relaxed/simple;
	bh=Oz9SwYWEaL9PyJX9kCK3Sx8PBnPK2n6iznyJmmP8C9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XE1vtyNa6yZskKPiTcj2klykx8CvKmb8Y7/jaZnpweU4ntugOBbkW7LTXJzB4TTLrZD6gCv/NJCJdVsBhVdgI38PHkT5GwdeAOuFUUtBF3XivqNtSvb2bWn4D9lr5xtrpn2DtVeq8p4aVjiQYhFqMvVLSk0G4BQ67atcFKyD7d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RB4I+2k7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RB4I+2k7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E064C2BD10;
	Thu,  6 Jun 2024 14:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683286;
	bh=Oz9SwYWEaL9PyJX9kCK3Sx8PBnPK2n6iznyJmmP8C9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RB4I+2k7zp7JFgt1YB/8cKebmlb7+TImS1p+/GLbCsfL8uX7Jv6bivdmKchtGBpvw
	 KVnplVDQiRqkPzTD9hvqoZzXHZTlj4SjENgRuhe9KnfpDkZe5F6uX79rNZuUhs6/NN
	 +d/aCqtc/kOkx8aAmy4YDbtH0D1cevKoC/D+lLus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 163/473] HID: amd_sfh: Handle "no sensors" in PM operations
Date: Thu,  6 Jun 2024 16:01:32 +0200
Message-ID: <20240606131705.336348325@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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
index bb8bd7892b674..eda888f75f165 100644
--- a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
+++ b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
@@ -222,6 +222,11 @@ static void amd_sfh_resume(struct amd_mp2_dev *mp2)
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
@@ -247,6 +252,11 @@ static void amd_sfh_suspend(struct amd_mp2_dev *mp2)
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



