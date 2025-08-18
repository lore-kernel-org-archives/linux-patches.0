Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082CF334728;
	Mon, 18 Aug 2025 14:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525645; cv=none; b=TxYMjVByG85/7CU5o7XXx5UKoKbY3sCyCUbJ6vVpxmmZsTzVYr1ibaojQPO9Gm516qm8xD2iFKqj60+Dep7Oyi10d0stEoaSHBIJ97w3rmSl+vQ6daUGKiHCIwE5HLNpSwM5klPpKmExBI26FPeqwN7/E9O6Wuifk0zaVF1omUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525645; c=relaxed/simple;
	bh=BQpt/CcAHXOIz8UMetjQBCU7y4iA+FbBfzfsZjxXKoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNtwY2MIUlWH1OMToIibl29+VzRlEpkhoBkf4HfhxD08Fe+egmmb6b6f1//fNhsbW3BX5LyrepOvhCPJMYXlvo8sWZwz3plcElT6JF5+z6A7yC0Zjy3oxb8Gaehw1AzQSEDPTVkZLscFeaZ9TP+cTIDdWGd05jtgbKyoM/GzFEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v/gtsHpj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/gtsHpj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8053DC4CEEB;
	Mon, 18 Aug 2025 14:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525644;
	bh=BQpt/CcAHXOIz8UMetjQBCU7y4iA+FbBfzfsZjxXKoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v/gtsHpjVXeBVdCL3KXvMjKbmsrfon79l6okWXEemM81+q/+83t+erXKOqwVP4oS8
	 2gbobd+tz7w/w2JRfNU/qvjV94b8HxpkC4QRXiahlc0e68rJOR2BsFHYbJurE3IEBG
	 QFtznCCWJIaBSoi7AvGBVS8/9Yvf4eCx4rfwRyHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 324/570] drm/amd/display: Stop storing failures into adev->dm.cached_state
Date: Mon, 18 Aug 2025 14:45:11 +0200
Message-ID: <20250818124518.338638023@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 709a37ab9c63297da2194dc36f604537f9d2d417 ]

If drm_atomic_helper_suspend() has failed for any reason, it's stored
in adev->dm.cached_state.  This isn't expected because the resume
(or complete()) sequence will attempt to use the stored state to
resume.

Reviewed-by: Alex Hung <alex.hung@amd.com>
Link: https://lore.kernel.org/r/20250602014432.3538345-3-superm1@kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 25 +++++++++++++------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index f58fa5da7fe5..5be8c0bf8880 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3060,6 +3060,19 @@ static void hpd_rx_irq_work_suspend(struct amdgpu_display_manager *dm)
 	}
 }
 
+static int dm_cache_state(struct amdgpu_device *adev)
+{
+	int r;
+
+	adev->dm.cached_state = drm_atomic_helper_suspend(adev_to_drm(adev));
+	if (IS_ERR(adev->dm.cached_state)) {
+		r = PTR_ERR(adev->dm.cached_state);
+		adev->dm.cached_state = NULL;
+	}
+
+	return adev->dm.cached_state ? 0 : r;
+}
+
 static int dm_prepare_suspend(struct amdgpu_ip_block *ip_block)
 {
 	struct amdgpu_device *adev = ip_block->adev;
@@ -3068,11 +3081,8 @@ static int dm_prepare_suspend(struct amdgpu_ip_block *ip_block)
 		return 0;
 
 	WARN_ON(adev->dm.cached_state);
-	adev->dm.cached_state = drm_atomic_helper_suspend(adev_to_drm(adev));
-	if (IS_ERR(adev->dm.cached_state))
-		return PTR_ERR(adev->dm.cached_state);
 
-	return 0;
+	return dm_cache_state(adev);
 }
 
 static int dm_suspend(struct amdgpu_ip_block *ip_block)
@@ -3106,9 +3116,10 @@ static int dm_suspend(struct amdgpu_ip_block *ip_block)
 	}
 
 	if (!adev->dm.cached_state) {
-		adev->dm.cached_state = drm_atomic_helper_suspend(adev_to_drm(adev));
-		if (IS_ERR(adev->dm.cached_state))
-			return PTR_ERR(adev->dm.cached_state);
+		int r = dm_cache_state(adev);
+
+		if (r)
+			return r;
 	}
 
 	s3_handle_hdmi_cec(adev_to_drm(adev), true);
-- 
2.39.5



