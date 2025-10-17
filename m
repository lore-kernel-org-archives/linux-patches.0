Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3FF330B1C;
	Fri, 17 Oct 2025 15:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716061; cv=none; b=Z4Gbnoz68mN/gH1FXH62Uek0zUWcu4P8opJDwX5NSiNHyergIuCgXAqVZa2fymkae9R7DfLcepaD/eFwclsHoGIPafORN81UUJYZ2WHeHOvb3huX2uwvnACWMnmNCE9XGue7gHyGE5yNhvalWycomPQv65aR0/LTFb0j822VX2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716061; c=relaxed/simple;
	bh=UxNSqUCemrbACV6NrfVKozlYt13z6JT6FE0FP/vnaNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VL4nPmHkmgFCbkhGzR3qCq9EhJlcXGNAwghR9/K3WwdPJ8E+Jb/fiY6MqXC/r0RBFaZ+0oJbROzG41lCPGvAbD0zKu5YgSi7m5WlE5fS0Y34J/gaKkCDdaJvXADLDl4EZlEBUPsLD4kMhYNGacVjA0kwS3uDwoEF6IX08GDiAMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AmoYnINK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AmoYnINK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657B6C4CEE7;
	Fri, 17 Oct 2025 15:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716060;
	bh=UxNSqUCemrbACV6NrfVKozlYt13z6JT6FE0FP/vnaNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AmoYnINK4C6oYJNpUH0a+27Agn8SqmP7FrZ/3fFlQBmHFRG+hOErzhj+2O2pOobF1
	 oIoxmTlQPgS4QBBCv0s8wnGucP5wN+rW6hGGfjYycajgIrHLH+9jbONBFE3yXVOCdM
	 No22eGlYYk9hI6xsyvO7Gw8qdyhb3zoz3K0oootc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/276] drm/amdgpu: Power up UVD 3 for FW validation (v2)
Date: Fri, 17 Oct 2025 16:52:32 +0200
Message-ID: <20251017145144.643282829@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0fef925b66024..e458e0d5801b0 100644
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



