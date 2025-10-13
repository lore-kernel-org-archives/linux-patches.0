Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535A5309DC1;
	Mon, 13 Oct 2025 15:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367650; cv=none; b=pAxjtTvnWcOizvR0MPHooUQt/wkzvyGdanqbuB+ftHqSa1tJQ5X5OSXR2AGhSnCHHTj2ld8QwzwYfVDVvBrOP1N1EMCobIg0KQTJ1w28TVF4ehVvNdGnYe3Kbce7jvtgiu+91P1/Z2m2dJUylsFjyyAl0XYKhev4eo3ex/U34q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367650; c=relaxed/simple;
	bh=ijKNbPL20XxfzBjP5Bc37Fy3sBPu5ZsKn1g0SbUVhAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WxaG0Sm61yXYi2RGpMVaktMguyg9O5tpWLTFvO2saJOWD+YEKYTR+PZuARXCyo/Am3jUwwIudAtLV8m3krBygI9J5oFxFLzYLHaOUlenrSc5AKlUBYuOccVOoO0Yw1r6NRzxW0IyucyvyFZy+DtpQh/yxMnEh9N4lLLsEX2y4yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WIxz/6Wz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WIxz/6Wz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB974C4CEE7;
	Mon, 13 Oct 2025 15:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367650;
	bh=ijKNbPL20XxfzBjP5Bc37Fy3sBPu5ZsKn1g0SbUVhAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WIxz/6WzdEKPh+BJOjs7LeiDtASN+nr87bJHcyKmMwtY7N6c5Mu5XA+kZScu5YKkc
	 Sc+J9N4SJuZghAFBjajpaZ2HaLbCAdrKaKJ0p5bzIV2tcaEzA0+5pGhZeTn/1g9q/9
	 7dMe347Me+bvEkSqE+EbgVsMaDAOKSf5+YV571lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/196] drm/amdgpu: Power up UVD 3 for FW validation (v2)
Date: Mon, 13 Oct 2025 16:44:36 +0200
Message-ID: <20251013144318.392745047@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit c661219cd7be75bb5599b525f16a455a058eb516 ]

Unlike later versions, UVD 3 has firmware validation.
For this to work, the UVD should be powered up correctly.

When DPM is enabled and the display clock is off,
the SMU may choose a power state which doesn't power
the UVD, which can result in failure to initialize UVD.

v2:
Add code comments to explain about the UVD power state
and how UVD clock is turned on/off.

Fixes: b38f3e80ecec ("drm amdgpu: SI UVD v3_1 (v2)")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c | 29 +++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c b/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c
index 5534c769b6550..1e0189f90fd6a 100644
--- a/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c
@@ -625,7 +625,22 @@ static void uvd_v3_1_enable_mgcg(struct amdgpu_device *adev,
  *
  * @handle: handle used to pass amdgpu_device pointer
  *
- * Initialize the hardware, boot up the VCPU and do some testing
+ * Initialize the hardware, boot up the VCPU and do some testing.
+ *
+ * On SI, the UVD is meant to be used in a specific power state,
+ * or alternatively the driver can manually enable its clock.
+ * In amdgpu we use the dedicated UVD power state when DPM is enabled.
+ * Calling amdgpu_dpm_enable_uvd makes DPM select the UVD power state
+ * for the SMU and afterwards enables the UVD clock.
+ * This is automatically done by amdgpu_uvd_ring_begin_use when work
+ * is submitted to the UVD ring. Here, we have to call it manually
+ * in order to power up UVD before firmware validation.
+ *
+ * Note that we must not disable the UVD clock here, as that would
+ * cause the ring test to fail. However, UVD is powered off
+ * automatically after the ring test: amdgpu_uvd_ring_end_use calls
+ * the UVD idle work handler which will disable the UVD clock when
+ * all fences are signalled.
  */
 static int uvd_v3_1_hw_init(void *handle)
 {
@@ -635,6 +650,15 @@ static int uvd_v3_1_hw_init(void *handle)
 	int r;
 
 	uvd_v3_1_mc_resume(adev);
+	uvd_v3_1_enable_mgcg(adev, true);
+
+	/* Make sure UVD is powered during FW validation.
+	 * It's going to be automatically powered off after the ring test.
+	 */
+	if (adev->pm.dpm_enabled)
+		amdgpu_dpm_enable_uvd(adev, true);
+	else
+		amdgpu_asic_set_uvd_clocks(adev, 53300, 40000);
 
 	r = uvd_v3_1_fw_validate(adev);
 	if (r) {
@@ -642,9 +666,6 @@ static int uvd_v3_1_hw_init(void *handle)
 		return r;
 	}
 
-	uvd_v3_1_enable_mgcg(adev, true);
-	amdgpu_asic_set_uvd_clocks(adev, 53300, 40000);
-
 	uvd_v3_1_start(adev);
 
 	r = amdgpu_ring_test_helper(ring);
-- 
2.51.0



