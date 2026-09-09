Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3D6579818;
	Wed,  9 Sep 2026 14:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963050; cv=none; b=LM4pnisDFUqZbEYaGwMCmWMG2rmWU+HE8uPCEmfQzN3YRzH/n0Z4xwF6HzVcF8HShlCWw1E1KHp4eIvnGv17ypAhwGmO5TolKYAwMagrI3x5l1669gYDejlDiouAgsIWiKImoOHXWK+oScgUUucyvbEwsWAS/R4Hti8/DHXoHuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963050; c=relaxed/simple;
	bh=iRoEMUr6yF6JTdWKLdhex0H8/gBY/I3a2TuBZJxYYG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LL5JPAUbYhda60WUpvcoi/NPYMtdPyeRor/MgncBRGxB9fxZzFKCWCS5DLrIwmapGMa7Y9dzltpv9X0mYDQXsP2UsqFQeDVFhWFvURrPR1VcaQxcgiMoW6G3fSu0/eCk0TS3GHyzvzl7cmKHsBnolDgH6qoPIhCchB8WQkkAqyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRrRd4l1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRrRd4l1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C293D1F00A3A;
	Wed,  9 Sep 2026 14:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963049;
	bh=EiMziSFcszUky3+BCX+wDChWT708d6go3iXnkbRoocQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QRrRd4l1SiMVD1nJ764rLohPJJ1BLEjjzd24WSlpsZDoykuruCYIR5YH+BYJh1/vy
	 nMc8oEKegbVH+Z5ioiwTQOWUSxEjV1fSHJp1XSdl3566T8bUycu48QhPLX+UZacV/k
	 PBffbA5jIzNPFXDJ5/vzEmUP2eZfZ4okpAGmRhcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 502/556] drm/amdgpu: delay ttm buffer func enablement on xgmi
Date: Wed,  9 Sep 2026 15:43:02 +0200
Message-ID: <20260909134248.132391470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>

commit c675dea86a000e9550077c5bca97c6431786d1b7 upstream.

When amdgpu_init_minimal_xgmi is used, SDMA engines init
is delayed so amdgpu_ttm_enable_buffer_funcs must be
called later.

Without this, the check for num_buffer_funcs_scheds will
fail and using ttm buffer funcs later will fail.

Given that amdgpu_ttm_enable_buffer_funcs is a no-op if
amdgpu_in_reset() returns true, the call has to occur
after the reset lock is dropped.

Cc: stable@vger.kernel.org
Fixes: e4029f7a9474 ("drm/amdgpu: only use working sdma schedulers for ttm")
Signed-off-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    8 +++++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c   |    3 +++
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2537,7 +2537,11 @@ static int amdgpu_device_ip_init(struct
 	if (r)
 		goto init_failed;
 
-	amdgpu_ttm_enable_buffer_funcs(adev);
+	/* If SDMA is not brought up during hwini, the ttm buffer funcs enablement
+	 * is delayed after reset-on-init completes.
+	 */
+	if (amdgpu_ip_member_of_hwini(adev, AMD_IP_BLOCK_TYPE_SDMA))
+		amdgpu_ttm_enable_buffer_funcs(adev);
 
 	/* Don't init kfd if whole hive need to be reset during init */
 	if (adev->init_lvl->level != AMDGPU_INIT_LEVEL_MINIMAL_XGMI) {
@@ -5321,8 +5325,6 @@ int amdgpu_device_reinit_after_reset(str
 				if (r)
 					goto out;
 
-				amdgpu_ttm_enable_buffer_funcs(tmp_adev);
-
 				r = amdgpu_device_ip_resume_phase3(tmp_adev);
 				if (r)
 					goto out;
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
@@ -1659,6 +1659,9 @@ static void amdgpu_xgmi_reset_on_init_wo
 	amdgpu_device_unlock_reset_domain(tmp_adev->reset_domain);
 
 	list_for_each_entry(tmp_adev, &hive->device_list, gmc.xgmi.head) {
+		/* Enable ttm buffers funcs after the reset lock has been dropped. */
+		amdgpu_ttm_enable_buffer_funcs(tmp_adev);
+
 		r = amdgpu_ras_init_badpage_info(tmp_adev);
 		if (r && r != -EHWPOISON)
 			dev_err(tmp_adev->dev,


