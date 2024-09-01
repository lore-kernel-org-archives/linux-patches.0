Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F6A17E46E;
	Sun,  1 Sep 2024 16:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208295; cv=none; b=PGt/oV5vW0nO+1r6slrlXq5wxCAKtFLBkqPtb4vUgpIDUjqVdarJT98Yi3wccZEIdXHAHpNww6PIj1k2W+8pa4pHk5e59R/5Pmz7qaT45ZXlPzdVX65kWNR+ijCc3bJmz6t359d9jkLWcSFvoADgAKhe7Q4fUJcX0JjHwwXjtSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208295; c=relaxed/simple;
	bh=ZrL01JAaNK34MabyuG7lSZmNRriIEVwUnpRPFfWctro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XIz3ozCTX41eSCIci9Cq4UWWJYBsTny87+T14GY3sbqY8VXhw9FuLgsCtxAO1PlLKwJT52YmulHDB7kBrh6GryKf8KhgvfA2PejZPdyCB4KfyvnKLRxFQ2ATP4rUB8mIVDe1huz8zKyQCNqCt978wTCryI0jKOqesosLdRgyBhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=alhsuLKB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="alhsuLKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E99C4CEC3;
	Sun,  1 Sep 2024 16:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208295;
	bh=ZrL01JAaNK34MabyuG7lSZmNRriIEVwUnpRPFfWctro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=alhsuLKBLhjtivQulKbRa2XlndiYYy48jTM60H1Eu6fCLj6yuhT4o3uI4uf2KVZ4O
	 KqM5yrrQ3Mr+cmgEPT9czn/628y6PSSPmyk7EitstrLo4fin29BAiew7gV4ADZbmIx
	 x0fldF3JvWp1mQyA7A8wKGBRGVoblKKqOv/eKk1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 039/149] drm/amdgpu/swsmu: always force a state reprogram on init
Date: Sun,  1 Sep 2024 18:15:50 +0200
Message-ID: <20240901160818.932574756@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit d420c857d85777663e8d16adfc24463f5d5c2dbc upstream.

Always reprogram the hardware state on init.  This ensures
the PMFW state is explicitly programmed and we are not relying
on the default PMFW state.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3131
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c50fe289ed7207f71df3b5f1720512a9620e84fb)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -2215,8 +2215,9 @@ static int smu_bump_power_profile_mode(s
 }
 
 static int smu_adjust_power_state_dynamic(struct smu_context *smu,
-				   enum amd_dpm_forced_level level,
-				   bool skip_display_settings)
+					  enum amd_dpm_forced_level level,
+					  bool skip_display_settings,
+					  bool force_update)
 {
 	int ret = 0;
 	int index = 0;
@@ -2245,7 +2246,7 @@ static int smu_adjust_power_state_dynami
 		}
 	}
 
-	if (smu_dpm_ctx->dpm_level != level) {
+	if (force_update || smu_dpm_ctx->dpm_level != level) {
 		ret = smu_asic_set_performance_level(smu, level);
 		if (ret) {
 			dev_err(smu->adev->dev, "Failed to set performance level!");
@@ -2261,7 +2262,7 @@ static int smu_adjust_power_state_dynami
 		index = index > 0 && index <= WORKLOAD_POLICY_MAX ? index - 1 : 0;
 		workload[0] = smu->workload_setting[index];
 
-		if (smu->power_profile_mode != workload[0])
+		if (force_update || smu->power_profile_mode != workload[0])
 			smu_bump_power_profile_mode(smu, workload, 0);
 	}
 
@@ -2282,11 +2283,13 @@ static int smu_handle_task(struct smu_co
 		ret = smu_pre_display_config_changed(smu);
 		if (ret)
 			return ret;
-		ret = smu_adjust_power_state_dynamic(smu, level, false);
+		ret = smu_adjust_power_state_dynamic(smu, level, false, false);
 		break;
 	case AMD_PP_TASK_COMPLETE_INIT:
+		ret = smu_adjust_power_state_dynamic(smu, level, true, true);
+		break;
 	case AMD_PP_TASK_READJUST_POWER_STATE:
-		ret = smu_adjust_power_state_dynamic(smu, level, true);
+		ret = smu_adjust_power_state_dynamic(smu, level, true, false);
 		break;
 	default:
 		break;


