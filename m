Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211011E1E19;
	Wed, 17 Sep 2025 12:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112841; cv=none; b=EOZeGuDqaFNxoyMIqxbv0NUy5Dq8Fy8EFBg/3ccdRWjXWmKOQFu5hmX8GhPotTfIlERk+BxDilWAoicHmPcUEGWIh+Ic2XlqaqZyquaxjXNUeYM0i8cx6di5/xGuzAfpWreroC6+TwaEbAuUgW9kPXpqfxOlp8c5NqbA/jOCC/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112841; c=relaxed/simple;
	bh=0NkWdR6poVkEyyTLtJPjja/gvh02+hR0uVrT6f99THg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mIZkhu8dLG9ch7su9MxPeW1oLGR7QidW19cjmMwTKb8EotaDDfjIefRSmtQGY1ep/s1DD5mwBzh5LVAZlyDzygj25Ljg1dzrrB70I28Bf/i5VCyntfIn0fS6OIXvjUpUl4CbAV+D6S2KI0PdOeS3IGx1M9ha7bs+GNrRADfWF94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6ODE2Gp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6ODE2Gp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902DBC4CEF0;
	Wed, 17 Sep 2025 12:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112841;
	bh=0NkWdR6poVkEyyTLtJPjja/gvh02+hR0uVrT6f99THg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s6ODE2Gp26ayRo2vPOP19VW/C5VrM/8lJbJ4FlJMH76jCb5P3+9EatvcQpkgqqU2R
	 IlvrMyzCoSuOcjhzAjiuXEzRgPdv7AMivIClZdNz0G2EzHQa7a9BJ7s2xQupdoJq7W
	 vLDGyJvnN2ioj4vTC9M6V1+8/aZzE/PlzM3Mie5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Geoffrey McRae <geoffrey.mcrae@amd.com>
Subject: [PATCH 6.16 092/189] drm/amd/display: remove oem i2c adapter on finish
Date: Wed, 17 Sep 2025 14:33:22 +0200
Message-ID: <20250917123354.102813402@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

From: Geoffrey McRae <geoffrey.mcrae@amd.com>

commit 1dfd2864a1c4909147663e5a27c055f50f7c2796 upstream.

Fixes a bug where unbinding of the GPU would leave the oem i2c adapter
registered resulting in a null pointer dereference when applications try
to access the invalid device.

Fixes: 3d5470c97314 ("drm/amd/display/dm: add support for OEM i2c bus")
Cc: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Geoffrey McRae <geoffrey.mcrae@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 89923fb7ead4fdd37b78dd49962d9bb5892403e6)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2910,6 +2910,17 @@ static int dm_oem_i2c_hw_init(struct amd
 	return 0;
 }
 
+static void dm_oem_i2c_hw_fini(struct amdgpu_device *adev)
+{
+	struct amdgpu_display_manager *dm = &adev->dm;
+
+	if (dm->oem_i2c) {
+		i2c_del_adapter(&dm->oem_i2c->base);
+		kfree(dm->oem_i2c);
+		dm->oem_i2c = NULL;
+	}
+}
+
 /**
  * dm_hw_init() - Initialize DC device
  * @ip_block: Pointer to the amdgpu_ip_block for this hw instance.
@@ -2960,7 +2971,7 @@ static int dm_hw_fini(struct amdgpu_ip_b
 {
 	struct amdgpu_device *adev = ip_block->adev;
 
-	kfree(adev->dm.oem_i2c);
+	dm_oem_i2c_hw_fini(adev);
 
 	amdgpu_dm_hpd_fini(adev);
 


