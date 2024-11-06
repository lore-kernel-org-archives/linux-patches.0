Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0307198E96;
	Wed,  6 Nov 2024 12:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896340; cv=none; b=nPYgD1tUTeq7ep88yOCBEimjkWKNhYM4fLQSHRG9Xraihd3bYWe+kjpYvmeqM4U/DRlAlZ2a2YeRZ6V6KfQwuuLU/5X3txbEvTYGfvoKHgp11N5CnGIy2KULNAC1Dwgj+yUHsZkM4NTfG+K9ojTcMETV5nDCBiB/fT3hD5q+dZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896340; c=relaxed/simple;
	bh=kq1sPvId3MyhGDR6H5BFJuuZdZ2OIoLcUER/F/HVWlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQO3JQECUrUJu4WNC1uBkq1ngiDzMIYjBVtX5XRopBKEjH5XgzWX6CWlPlXlylpdpMeCUYBU4F6KszBEG4fFj5yQ3R+CeWzqQqGykDUxR9eOWVRCbGnYXCAo7eN1r/KuXzB4yA6xeEg509PBnfiDlezo6S+ytY4M4jW1CVDq3b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9IBvlun; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9IBvlun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48096C4CECD;
	Wed,  6 Nov 2024 12:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896340;
	bh=kq1sPvId3MyhGDR6H5BFJuuZdZ2OIoLcUER/F/HVWlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P9IBvlunJKRGGHnMf6WgXIhkMhvT52vupFGNnLKoPppZJoka7msTb8jxJoqLkujF2
	 wgKjKgEbnVcn5CtBtAFF1U/zeSvpCso37fd6mtqxQRkfp5McoRhNvBUUPT1iuWov/U
	 rZ/BNRybH/stGHX8STvM2/5F2z8Us/b39q2PSWPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 170/245] drm/amdgpu/smu13: fix profile reporting
Date: Wed,  6 Nov 2024 13:03:43 +0100
Message-ID: <20241106120323.425244269@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 935abb86a95def8c20dbb184ce30051db168e541 ]

The following 3 commits landed in parallel:
commit d7d2688bf4ea ("drm/amd/pm: update workload mask after the setting")
commit 7a1613e47e65 ("drm/amdgpu/smu13: always apply the powersave optimization")
commit 7c210ca5a2d7 ("drm/amdgpu: handle default profile on on devices without fullscreen 3D")
While everything is set correctly, this caused the profile to be
reported incorrectly because both the powersave and fullscreen3d bits
were set in the mask and when the driver prints the profile, it looks
for the first bit set.

Fixes: d7d2688bf4ea ("drm/amd/pm: update workload mask after the setting")
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ecfe9b237687a55d596fff0650ccc8cc455edd3f)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index cb923e33fd6fc..d53e162dcd8de 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -2485,7 +2485,7 @@ static int smu_v13_0_0_set_power_profile_mode(struct smu_context *smu,
 	DpmActivityMonitorCoeffInt_t *activity_monitor =
 		&(activity_monitor_external.DpmActivityMonitorCoeffInt);
 	int workload_type, ret = 0;
-	u32 workload_mask;
+	u32 workload_mask, selected_workload_mask;
 
 	smu->power_profile_mode = input[size];
 
@@ -2552,7 +2552,7 @@ static int smu_v13_0_0_set_power_profile_mode(struct smu_context *smu,
 	if (workload_type < 0)
 		return -EINVAL;
 
-	workload_mask = 1 << workload_type;
+	selected_workload_mask = workload_mask = 1 << workload_type;
 
 	/* Add optimizations for SMU13.0.0/10.  Reuse the power saving profile */
 	if ((amdgpu_ip_version(smu->adev, MP1_HWIP, 0) == IP_VERSION(13, 0, 0) &&
@@ -2572,7 +2572,7 @@ static int smu_v13_0_0_set_power_profile_mode(struct smu_context *smu,
 					       workload_mask,
 					       NULL);
 	if (!ret)
-		smu->workload_mask = workload_mask;
+		smu->workload_mask = selected_workload_mask;
 
 	return ret;
 }
-- 
2.43.0



