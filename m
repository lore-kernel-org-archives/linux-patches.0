Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B32817B503;
	Wed,  3 Jul 2024 11:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006001; cv=none; b=FEjhotAK97ZZUY03kqjQqw/59xssPFAtZAxO7KlGLmO6rk+ePBwNIMwm6JUQS6HwUaSWSW0s/ZUct9hPOCNugG7MI8mq9PleRiiEjL+qnQSwOemPw0gpr2DgV1Ey6ZLG/XxBOKyGVkFso7J1+VRrKXwxoNtT1I8do5yn+PfSh4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006001; c=relaxed/simple;
	bh=xiQbJ2VgtzUmmMJ5Wau66+j7klSVQZ51qIR/x94mRbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHzjYA+Brla6IzOBS+sNeyy0y9udL8ru13W82PThAoKLJeYhZXsLcSRepZqdcS55ieGRkXyifu6Yjb/zwh1kQBmHgGvmRM7n1ZezA1gQaQMqnxRit76TgydltRTUfOfgFGxjJ9kTP4zlxd5Grq9qpJoKB3rkjgmJKDf+DysS9Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VRJvJwFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VRJvJwFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856B4C32781;
	Wed,  3 Jul 2024 11:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006000;
	bh=xiQbJ2VgtzUmmMJ5Wau66+j7klSVQZ51qIR/x94mRbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VRJvJwFU8Mjevw3BF6JVkblDIsKmTAERX4eQxZsTDCCWb9sT2pXDndEGO6UclqlGf
	 pyB3l8QHa3sFBT3XhiIOsHczMcIzK6nB+5K4RqiLmRsqG869+aCHeq3vhkWWvj11Ol
	 +/FQ5kn2ThU6ONDJ2qlnOB91XpJywKqR8faV2TsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 267/356] drm/amdgpu: fix UBSAN warning in kv_dpm.c
Date: Wed,  3 Jul 2024 12:40:03 +0200
Message-ID: <20240703102923.217881584@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit f0d576f840153392d04b2d52cf3adab8f62e8cb6 ]

Adds bounds check for sumo_vid_mapping_entry.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3392
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/kv_dpm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/kv_dpm.c b/drivers/gpu/drm/amd/pm/powerplay/kv_dpm.c
index b56854c03ead6..4291bf09fc7b4 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/kv_dpm.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/kv_dpm.c
@@ -163,6 +163,8 @@ static void sumo_construct_vid_mapping_table(struct amdgpu_device *adev,
 
 	for (i = 0; i < SUMO_MAX_HARDWARE_POWERLEVELS; i++) {
 		if (table[i].ulSupportedSCLK != 0) {
+			if (table[i].usVoltageIndex >= SUMO_MAX_NUMBER_VOLTAGES)
+				continue;
 			vid_mapping_table->entries[table[i].usVoltageIndex].vid_7bit =
 				table[i].usVoltageID;
 			vid_mapping_table->entries[table[i].usVoltageIndex].vid_2bit =
-- 
2.43.0



