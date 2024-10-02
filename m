Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF571D042F;
	Wed,  2 Oct 2024 13:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876750; cv=none; b=G89RivdVFq5UzIxXwK4osPQvmdkofSRITpj1wewn2pKGe/02AHPqJniYmwkfyHKT92JFI9JyB3t667cvGZxZ5xI5DT58szoFpsShdjiUKRzbr8wokgPDFozwFQsKIwrL6XC7ThyUPUYNPbi5rHg2q2N3w/ktOT6/HuAj/urm6bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876750; c=relaxed/simple;
	bh=dlU4L09pQPfjdk25TQymzv2IgeKQOBfR3ginZk5SYEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/DOjOrzbuyCUJBg69DV8nP1cDLhisinHCb/UOonovKmiC7Lp/xm3kQnycB6aXXgo1AAyJysSAQQ8OEdweN4XMCYrh81qjbs2ODSrVnBcRg3YJTnAPnAsBz/GtJMOwacnnkRdqPCAb8GdczjVwcaV4Q6Oi9X/P/16kczGJN2D5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XwVTVhbs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XwVTVhbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A7EC4CEC2;
	Wed,  2 Oct 2024 13:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876750;
	bh=dlU4L09pQPfjdk25TQymzv2IgeKQOBfR3ginZk5SYEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XwVTVhbseJR82jC7ut8T/vzVSGoz7VmIsCJpa9Hb1KSRWJdYT8axRr63DAeEOiEr6
	 PAFFfaYAMnIT/y68gN+eIyuFVBJffZlq3xAxHYlZ1QU10AeflmCe696B7xXg9E8UtF
	 xIQMadm/bCns8Y4QuMbugjFYBSiogYbN3KBIdlIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Belanger <david.belanger@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 550/695] drm/amdgpu: Fix selfring initialization sequence on soc24
Date: Wed,  2 Oct 2024 14:59:08 +0200
Message-ID: <20241002125844.459710919@linuxfoundation.org>
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

From: David Belanger <david.belanger@amd.com>

commit 03b5038c0ad069380fab7e251d2bf3f1540d20f4 upstream.

Move enable_doorbell_selfring_aperture from common_hw_init
to common_late_init in soc24, otherwise selfring aperture is
initialized with an incorrect doorbell aperture base.

Port changes from this commit from soc21 to soc24:
commit 1c312e816c40 ("drm/amdgpu: Enable doorbell selfring after resize FB BAR")

Signed-off-by: David Belanger <david.belanger@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.11.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/soc24.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc24.c b/drivers/gpu/drm/amd/amdgpu/soc24.c
index b0c3678cfb31..fd4c3d4f8387 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc24.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc24.c
@@ -250,13 +250,6 @@ static void soc24_program_aspm(struct amdgpu_device *adev)
 		adev->nbio.funcs->program_aspm(adev);
 }
 
-static void soc24_enable_doorbell_aperture(struct amdgpu_device *adev,
-					   bool enable)
-{
-	adev->nbio.funcs->enable_doorbell_aperture(adev, enable);
-	adev->nbio.funcs->enable_doorbell_selfring_aperture(adev, enable);
-}
-
 const struct amdgpu_ip_block_version soc24_common_ip_block = {
 	.type = AMD_IP_BLOCK_TYPE_COMMON,
 	.major = 1,
@@ -454,6 +447,11 @@ static int soc24_common_late_init(void *handle)
 	if (amdgpu_sriov_vf(adev))
 		xgpu_nv_mailbox_get_irq(adev);
 
+	/* Enable selfring doorbell aperture late because doorbell BAR
+	 * aperture will change if resize BAR successfully in gmc sw_init.
+	 */
+	adev->nbio.funcs->enable_doorbell_selfring_aperture(adev, true);
+
 	return 0;
 }
 
@@ -491,7 +489,7 @@ static int soc24_common_hw_init(void *handle)
 		adev->df.funcs->hw_init(adev);
 
 	/* enable the doorbell aperture */
-	soc24_enable_doorbell_aperture(adev, true);
+	adev->nbio.funcs->enable_doorbell_aperture(adev, true);
 
 	return 0;
 }
@@ -500,8 +498,13 @@ static int soc24_common_hw_fini(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
-	/* disable the doorbell aperture */
-	soc24_enable_doorbell_aperture(adev, false);
+	/* Disable the doorbell aperture and selfring doorbell aperture
+	 * separately in hw_fini because soc21_enable_doorbell_aperture
+	 * has been removed and there is no need to delay disabling
+	 * selfring doorbell.
+	 */
+	adev->nbio.funcs->enable_doorbell_aperture(adev, false);
+	adev->nbio.funcs->enable_doorbell_selfring_aperture(adev, false);
 
 	if (amdgpu_sriov_vf(adev))
 		xgpu_nv_mailbox_put_irq(adev);
-- 
2.46.2



