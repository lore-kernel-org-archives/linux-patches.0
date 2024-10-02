Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B941D042F;
	Wed,  2 Oct 2024 13:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876739; cv=none; b=VZpM4v0DacoKSVw1Q4aOeUVgbNJu+Pn/O7wfclj9zyFD1wYi745W1jNMCvgTqI7FyMuiXdHvLyb0aOSiBFEAJuX21oA3WX28mEQlBS+fDYUtyRqw49S2PLtzJ4EcBwfvsefCF1i6xeyeO2sGgcEKO2Uz0xjukGmtob+ktm13QTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876739; c=relaxed/simple;
	bh=IRSms0ift0oF6x1KQt30ANa2WTO+HbpcPBmC+AQHx54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpoG9oz4C0uIS2+xSZqNRq4eyOGHW51MLLVRyFfegm1s0RoacCQY9WMWIq27ht0Q3ZCO1gbiQNPv2z6UFtMdFzLjJAFoVtf4MeAh+79SeiMQ3/WPkyImkC/C4D7Ak+/9o2QD5RkVs6k+uW6VQBs3pbOZWLU3peZsoO/eqllKpMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8jIlKb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8jIlKb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C5F6C4CEC2;
	Wed,  2 Oct 2024 13:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876738;
	bh=IRSms0ift0oF6x1KQt30ANa2WTO+HbpcPBmC+AQHx54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8jIlKb6yMDxqeolqX3DFCF6VZNF8vr+hOLV3t0DNNQwd7NBjqOIu+d4WmUYYPkD7
	 vbrKFWKKsRNVUTA/5CmvBli14xsDDqG5F2OMjcv4/Fby1wBpkCjmrHeVxzdoRVHMW0
	 9TS7RqyffNYqVF6qj9wip1QOmXtxVqyC3HIoeTyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 546/695] drm/amd/pm: update workload mask after the setting
Date: Wed,  2 Oct 2024 14:59:04 +0200
Message-ID: <20241002125844.297230542@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kenneth Feng <kenneth.feng@amd.com>

commit d7d2688bf4ea58734d73e18edcbf4684b1496d30 upstream.

update workload mask after the setting.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3625
Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c |    6 +++++-
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c |    3 +++
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c |    6 +++++-
 3 files changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -2569,10 +2569,14 @@ static int smu_v13_0_0_set_power_profile
 		}
 	}
 
-	return smu_cmn_send_smc_msg_with_param(smu,
+	ret = smu_cmn_send_smc_msg_with_param(smu,
 					       SMU_MSG_SetWorkloadMask,
 					       workload_mask,
 					       NULL);
+	if (!ret)
+		smu->workload_mask = workload_mask;
+
+	return ret;
 }
 
 static bool smu_v13_0_0_is_mode1_reset_supported(struct smu_context *smu)
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -2501,8 +2501,11 @@ static int smu_v13_0_7_set_power_profile
 		return -EINVAL;
 	ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_SetWorkloadMask,
 				    1 << workload_type, NULL);
+
 	if (ret)
 		dev_err(smu->adev->dev, "[%s] Failed to set work load mask!", __func__);
+	else
+		smu->workload_mask = (1 << workload_type);
 
 	return ret;
 }
--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
@@ -1570,10 +1570,14 @@ static int smu_v14_0_2_set_power_profile
 	if (workload_type < 0)
 		return -EINVAL;
 
-	return smu_cmn_send_smc_msg_with_param(smu,
+	ret = smu_cmn_send_smc_msg_with_param(smu,
 					       SMU_MSG_SetWorkloadMask,
 					       1 << workload_type,
 					       NULL);
+	if (!ret)
+		smu->workload_mask = 1 << workload_type;
+
+	return ret;
 }
 
 static int smu_v14_0_2_baco_enter(struct smu_context *smu)


