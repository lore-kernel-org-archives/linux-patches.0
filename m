Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2313A1A0BFD;
	Sun,  7 Sep 2025 20:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277192; cv=none; b=TI7WtdeWSJuhzUX23l7bacQhUHRT35nM0065fv0Kh5txr0kgK/d++d5V6V78J+nqaNkg5Yd+w+mBCOPS/QNsmYMIy7o1huAOfSwNOqpXHUVmASdc+ZXxebBFM6we3yjWuaiSkGCXvsGUZmwQaBoJ38i9M70uWhbkfisJ1y7VoNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277192; c=relaxed/simple;
	bh=4bU5VCykL30PXe6z/tyek9ya3PxZmFUkofrSDMXJvIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dBGDljq5iFZpVmtUzRI8Pj2gp7MGbGIBs6M2tMEIYE8g0utpn9ys7i9DH1cZGKhz3951x/VafebZA+jGlx8aMz6Yb9ftmtCGG5HFta8RaTTGo/YVyEUY6qTW+W/gcwLZH/YUOHGSL0pj9/tbygzWFjeClkiWzpdsd0vBeCiUoiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XyQ09Uav; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XyQ09Uav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991A4C4CEF0;
	Sun,  7 Sep 2025 20:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277192;
	bh=4bU5VCykL30PXe6z/tyek9ya3PxZmFUkofrSDMXJvIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyQ09UavnN3Sp/2t1SiB6GESiuTYpk1egf3YQcmS9yBC81TWQfWeXyGyIk271cxNU
	 Dh55/RJP8I9pNHHYSEO4UIFigPh85ffMCfmt9wNOHE+UBIzLD1JqN8OkQc9ClxHSZr
	 qjliE8/tUsls3yorH5hP1sLo+ss3V8jXQovhxclg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	oushixiong <oushixiong1025@163.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 113/175] drm/amdgpu: drop hw access in non-DC audio fini
Date: Sun,  7 Sep 2025 21:58:28 +0200
Message-ID: <20250907195617.531680346@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 71403f58b4bb6c13b71c05505593a355f697fd94 upstream.

We already disable the audio pins in hw_fini so
there is no need to do it again in sw_fini.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4481
Cc: oushixiong <oushixiong1025@163.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5eeb16ca727f11278b2917fd4311a7d7efb0bbd6)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/dce_v10_0.c |    5 -----
 drivers/gpu/drm/amd/amdgpu/dce_v11_0.c |    5 -----
 drivers/gpu/drm/amd/amdgpu/dce_v6_0.c  |    5 -----
 drivers/gpu/drm/amd/amdgpu/dce_v8_0.c  |    5 -----
 4 files changed, 20 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c
@@ -1462,17 +1462,12 @@ static int dce_v10_0_audio_init(struct a
 
 static void dce_v10_0_audio_fini(struct amdgpu_device *adev)
 {
-	int i;
-
 	if (!amdgpu_audio)
 		return;
 
 	if (!adev->mode_info.audio.enabled)
 		return;
 
-	for (i = 0; i < adev->mode_info.audio.num_pins; i++)
-		dce_v10_0_audio_enable(adev, &adev->mode_info.audio.pin[i], false);
-
 	adev->mode_info.audio.enabled = false;
 }
 
--- a/drivers/gpu/drm/amd/amdgpu/dce_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v11_0.c
@@ -1511,17 +1511,12 @@ static int dce_v11_0_audio_init(struct a
 
 static void dce_v11_0_audio_fini(struct amdgpu_device *adev)
 {
-	int i;
-
 	if (!amdgpu_audio)
 		return;
 
 	if (!adev->mode_info.audio.enabled)
 		return;
 
-	for (i = 0; i < adev->mode_info.audio.num_pins; i++)
-		dce_v11_0_audio_enable(adev, &adev->mode_info.audio.pin[i], false);
-
 	adev->mode_info.audio.enabled = false;
 }
 
--- a/drivers/gpu/drm/amd/amdgpu/dce_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v6_0.c
@@ -1394,17 +1394,12 @@ static int dce_v6_0_audio_init(struct am
 
 static void dce_v6_0_audio_fini(struct amdgpu_device *adev)
 {
-	int i;
-
 	if (!amdgpu_audio)
 		return;
 
 	if (!adev->mode_info.audio.enabled)
 		return;
 
-	for (i = 0; i < adev->mode_info.audio.num_pins; i++)
-		dce_v6_0_audio_enable(adev, &adev->mode_info.audio.pin[i], false);
-
 	adev->mode_info.audio.enabled = false;
 }
 
--- a/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c
@@ -1443,17 +1443,12 @@ static int dce_v8_0_audio_init(struct am
 
 static void dce_v8_0_audio_fini(struct amdgpu_device *adev)
 {
-	int i;
-
 	if (!amdgpu_audio)
 		return;
 
 	if (!adev->mode_info.audio.enabled)
 		return;
 
-	for (i = 0; i < adev->mode_info.audio.num_pins; i++)
-		dce_v8_0_audio_enable(adev, &adev->mode_info.audio.pin[i], false);
-
 	adev->mode_info.audio.enabled = false;
 }
 


