Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD5726AF2;
	Mon, 27 May 2024 19:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836886; cv=none; b=QwoJHlhQNHs8OclLvzy4mjIz9wKeP9+U8CIdOedlYFddoTkOef06MZptlpy4oWf4LjD9+DFBD77wDH/Y4FypmLye/LkCbGhcP+XdBEN+3T0qoJYggiAyoLOsqBcp0Y8sbcvrcJvuXV6i29QSSAyctCQFY7Em3pyUnsHqbvRcdfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836886; c=relaxed/simple;
	bh=ww7BLCoLjHWLi2VfuN1Rw2smkcWnrM+TxW73uNIf+bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UcGDF/Ot103GlYvxYOTDyK3Ng8UZ9CdfM8idHooxpEHiZavA7BvN+vvLTDAO9FO/wrsRqk/FkjEK+RpTOeDs8XlC2iuR1+pfHNAdd833re5zDXZxUjrnfupbB0aVvZiWVWVklo4yGEbkN+G4C9CsuP+MyXqIsJyjxe5eF+uD6yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WOhQtwoi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WOhQtwoi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A3EC2BBFC;
	Mon, 27 May 2024 19:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836885;
	bh=ww7BLCoLjHWLi2VfuN1Rw2smkcWnrM+TxW73uNIf+bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WOhQtwoiFOFnUPl2igWHpYhSE6vMfpQ37xLEmk733IssydP/1vbua/wYhfnkXO3RN
	 rfuGwxy04ZOW3w129VoWwCgi5n4OGC03oCvy4+iM9wr5DJWAMP64RZ01iMzCEJUFq1
	 LeDqdUIYMcz/hWpTm2kfuX+C17YeyYNO6xwe6IqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 224/427] HID: amd_sfh: Handle "no sensors" in PM operations
Date: Mon, 27 May 2024 20:54:31 +0200
Message-ID: <20240527185623.430814145@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 5b24d5f63701a..c2f9fc1f20a24 100644
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



