Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6AC335BA5;
	Mon, 18 Aug 2025 13:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523973; cv=none; b=bRj7ciipq9vLQLnM1rtYeSNdtURy48Ip9Ex0e9N41JdyzzwVv3nQeKvmZVV/X6BlZe3WxmP2rPvCMTpsJGeCiRXYGwJVLyQFd/D71i7imE6rv3ArauFC0SdZ6OiZPLA+7e0Ab+dYcSpQkKYQDzpMJohoY3qsT2vDDE5XNMhWeWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523973; c=relaxed/simple;
	bh=dnAuLyMONAZTZDthxZiNs+J1hDwkbUPG99XeuYSknrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UuMQQUDYZ5uL2/tOYHr7FyN37jt3/V7rBW/AqX/wjgza3N9gLHqaYFMh2F0zdjabAR2RURzU038QHnQfAwrOmM0g67G3oYU9UCqBRA0Kzr8NdAUD7GcBR/657D/UZx5UA6+LO0UWKMsvAcQLlY/K5su8BCh7soBa88EarPZ0JoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GfyOBN8Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GfyOBN8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF853C4CEEB;
	Mon, 18 Aug 2025 13:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523973;
	bh=dnAuLyMONAZTZDthxZiNs+J1hDwkbUPG99XeuYSknrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GfyOBN8QBcdEILNk8EffMV7++HDxSDNxgNdNuRzIpja4N0Bn31pSweH0L46gUBbdF
	 vgj+Ly5d/fIWsw05iumFYMLPTQ7HGi6i3l9pBm4cN5Q7PYdkngPfQHUp2tJCcQA08x
	 Ld2LU8w0nMo3IpPbIqTNUnW+JSTXZjvzhAE74X7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 297/515] drm/amd/display: Stop storing failures into adev->dm.cached_state
Date: Mon, 18 Aug 2025 14:44:43 +0200
Message-ID: <20250818124509.855904138@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index f6d71bf7c89c..9c01496ba590 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2998,6 +2998,19 @@ static void hpd_rx_irq_work_suspend(struct amdgpu_display_manager *dm)
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
@@ -3006,11 +3019,8 @@ static int dm_prepare_suspend(struct amdgpu_ip_block *ip_block)
 		return 0;
 
 	WARN_ON(adev->dm.cached_state);
-	adev->dm.cached_state = drm_atomic_helper_suspend(adev_to_drm(adev));
-	if (IS_ERR(adev->dm.cached_state))
-		return PTR_ERR(adev->dm.cached_state);
 
-	return 0;
+	return dm_cache_state(adev);
 }
 
 static int dm_suspend(struct amdgpu_ip_block *ip_block)
@@ -3044,9 +3054,10 @@ static int dm_suspend(struct amdgpu_ip_block *ip_block)
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



