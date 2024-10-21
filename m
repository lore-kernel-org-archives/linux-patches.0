Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4718B1F4FAA;
	Mon, 21 Oct 2024 10:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507370; cv=none; b=N8scPeYGo23OHLcY38CpSkTACBLLCdIWPw7s9qK0wzcli5d82oeTdW9hXxBly0+RypIFmtVQZd8e3DEdKMIBOPErJboDEs1AuDyT8pCzYXzjfPdjizvMz+Vjlfd0rieu4+Ocz7YBYCw+8JDSDeb5nWw6AciVFFc/TgFMv20BYTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507370; c=relaxed/simple;
	bh=IhFjP0FbeIC5SUkpBeJCegfjPgrFRTRvouy2YT2AHZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Orb8mLdYgbZAjeBf72IwpiMfc/OaKVClD00S7dOP+kpk+4mo/IR9TCyVKKa4dM5V11KgMtR6VEfulZKnPKsOunAjLvGcWM4TE5X/PvXL8BMrz/9d9nnOF7Byj+RzD6e3uL/Du/oyzjkwwG7OVxwIlxApXmFvN4BT2Hkq9O58mBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KoMXlImZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KoMXlImZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1B0C4CEC3;
	Mon, 21 Oct 2024 10:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507370;
	bh=IhFjP0FbeIC5SUkpBeJCegfjPgrFRTRvouy2YT2AHZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KoMXlImZE50slv//dUIPlM4ap4iJoaBvZkTw2LpzR4UCTqoDC8qgzhvk8fBayrDX7
	 V0G62ZNG6WH4pyzmyVWKnZUvfuDc8bxZl95W6CvB+xPicYt7so9vONxxEprf/L9yMj
	 mhzDogJLtG33Hmpr1WoJ/+MWNS/rQAZco6qbz1Vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 53/91] drm/amdgpu/swsmu: Only force workload setup on init
Date: Mon, 21 Oct 2024 12:25:07 +0200
Message-ID: <20241021102251.889622678@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit cb07c8338fc2b9d5f949a19d4a07ee4d5ecf8793 upstream.

Needed to set the workload type at init time so that
we can apply the navi3x margin optimization.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3618
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3131
Fixes: c50fe289ed72 ("drm/amdgpu/swsmu: always force a state reprogram on init")
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 580ad7cbd4b7be8d2cb5ab5c1fca6bb76045eb0e)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1831,7 +1831,7 @@ static int smu_bump_power_profile_mode(s
 static int smu_adjust_power_state_dynamic(struct smu_context *smu,
 					  enum amd_dpm_forced_level level,
 					  bool skip_display_settings,
-					  bool force_update)
+					  bool init)
 {
 	int ret = 0;
 	int index = 0;
@@ -1860,7 +1860,7 @@ static int smu_adjust_power_state_dynami
 		}
 	}
 
-	if (force_update || smu_dpm_ctx->dpm_level != level) {
+	if (smu_dpm_ctx->dpm_level != level) {
 		ret = smu_asic_set_performance_level(smu, level);
 		if (ret) {
 			dev_err(smu->adev->dev, "Failed to set performance level!");
@@ -1877,7 +1877,7 @@ static int smu_adjust_power_state_dynami
 		index = index > 0 && index <= WORKLOAD_POLICY_MAX ? index - 1 : 0;
 		workload[0] = smu->workload_setting[index];
 
-		if (force_update || smu->power_profile_mode != workload[0])
+		if (init || smu->power_profile_mode != workload[0])
 			smu_bump_power_profile_mode(smu, workload, 0);
 	}
 


