Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274853A6B92;
	Sat, 17 Oct 2026 16:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255505; cv=none; b=Dpvv1sXBhfJ0GS+l5wcQMBie8QXEhMMrhLnDrUsUMOIF/l6XLmCklwnw3m49rEa3+fCEPmK20pUSpnpxmh2gHghE89ai+waDcDfE09HtlfJOFA8ecuUc18/m4I431DVit8/JkKdEHC2yS0+p6ywGCvbkqfnUr0u2XQQ//piRDo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255505; c=relaxed/simple;
	bh=+i+tOASXYf8mha1Xa/6mZ+7hTqoki81GCnF0Xuhuzhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fh1IZckPas2YuMWuuYmiR1rMSF/QLOLmIQ7gnd5hPqgohOC2YCKVc3klDt1CplmyMzvNjpJI2E2CK3aHIKTy00wr6/5WA0V1t8bZfeVbZVRRLRIVY8Wkn0a1B8paLCvCkhcJvomjGgcUmhE4x8cbjdvXSTe7ty0Iilrf4g3w0k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z2BmIsCD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2BmIsCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425161F000C4;
	Sat, 17 Oct 2026 16:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255503;
	bh=UUBNyx1IQS/ajT/4Hr5LH8CqArwKPCprRyD8dsVcHzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z2BmIsCDjkiMJqaLb60Ju+SjUt6pSX1HfYbvagOOBiCbfZtwV/1E1BBHLcUpadLIJ
	 4ZEUU9Wf7oyTZSiORFU92k9cMqhIPqubDnHlb2t47tjiiLF36gaurwqzZUv+pFMsjm
	 j2xs859OOnqP2caoy3Hc/R+2/yQlDeLAJrvCy3bQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 746/869] drm/amdgpu: rework i2c init and fini
Date: Sat, 17 Oct 2026 17:59:47 +0200
Message-ID: <20261017160056.064529773@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 1c0b144bf7628a62575a4ec26623f7a6cdf0cb2b ]

No functional change.  Rework the code to allow for
adding some additional i2c buses in conjunction with DC
in the future.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: a99cd231cd92 ("drm/amdgpu: Bound GPIO I2C table entry count from VBIOS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 6 ++----
 drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c    | 8 ++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.h    | 1 +
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 172cc8cd8356b..13363330820a8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4518,8 +4518,7 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 				goto failed;
 			}
 			/* init i2c buses */
-			if (!amdgpu_device_has_dc_support(adev))
-				amdgpu_atombios_i2c_init(adev);
+			amdgpu_i2c_init(adev);
 		}
 	}
 
@@ -4793,8 +4792,7 @@ void amdgpu_device_fini_sw(struct amdgpu_device *adev)
 	amdgpu_reset_fini(adev);
 
 	/* free i2c buses */
-	if (!amdgpu_device_has_dc_support(adev))
-		amdgpu_i2c_fini(adev);
+	amdgpu_i2c_fini(adev);
 
 	if (amdgpu_emu_mode != 1)
 		amdgpu_atombios_fini(adev);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c
index f0765ccde6680..72f73a186dd94 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c
@@ -225,6 +225,14 @@ void amdgpu_i2c_destroy(struct amdgpu_i2c_chan *i2c)
 	kfree(i2c);
 }
 
+void amdgpu_i2c_init(struct amdgpu_device *adev)
+{
+	if (!adev->is_atom_fw) {
+		if (!amdgpu_device_has_dc_support(adev))
+			amdgpu_atombios_i2c_init(adev);
+	}
+}
+
 /* remove all the buses */
 void amdgpu_i2c_fini(struct amdgpu_device *adev)
 {
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.h
index 21e3d1dad0a12..1d3d3806e0ddb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.h
@@ -28,6 +28,7 @@ struct amdgpu_i2c_chan *amdgpu_i2c_create(struct drm_device *dev,
 					  const struct amdgpu_i2c_bus_rec *rec,
 					  const char *name);
 void amdgpu_i2c_destroy(struct amdgpu_i2c_chan *i2c);
+void amdgpu_i2c_init(struct amdgpu_device *adev);
 void amdgpu_i2c_fini(struct amdgpu_device *adev);
 struct amdgpu_i2c_chan *
 amdgpu_i2c_lookup(struct amdgpu_device *adev,
-- 
2.53.0



