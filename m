Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65923B71A7;
	Sat, 17 Oct 2026 18:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260444; cv=none; b=e9RUpziUtUChlSpmmoc7miTF3G133UZ93/U23zJkT2iDcUE2WRayhF9D8Wz3I9RaMpjODoiAEbIVL4rlqpzBtJ4NkqP+SYc3oTA0Re4CmAUGAkTpLViuxXBPJKUbkcv25ni8BVVMtr4kt+aOY4XAf0cjh+RQUyaTF8vtcJ+QGTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260444; c=relaxed/simple;
	bh=kAQLHmEmW8vVQi2zmayJufZ8PR6faiW0G4L4aIsHUvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FgL1qJ8bgJ3UxcI7maQDcOA9y49fplfj/X9sThDdXIixnbfz0p2cADGuG+ZCUPJCxa/xSNJamckhFcuAu7DTGN0mpwuqTmf6K8jYMxmV87LdY1eZnUOlSuQVB+RbQN3NkwmqaaM+86qX1Rj++OBoLnut9UV5rVnFqmbssK9vFDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iCDihgIX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iCDihgIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB821F000C4;
	Sat, 17 Oct 2026 18:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260443;
	bh=kmYZBlNoKcV+H7c5w2M30Vax7klNRgTmdmn70gc4lUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iCDihgIX+yjFu9XQ11QsJF15B2Dw+VpxyO1VLnVG3A9JTNWNql6Nb6FdxhDvBOjhe
	 nA9ixuLgO76zwq+AP5CEKnpDluakWCtznA8CuISsAKPEKkldrSlZg3R7/+ezyVEmT/
	 FaQ7B+DJxif9AMXZMkYHmMbNZ6co9fQFvXOuS5jQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1540/1674] drm/amdgpu: rework i2c init and fini
Date: Sat, 17 Oct 2026 18:03:32 +0200
Message-ID: <20261017160510.642245759@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bb1dde51c6fe0..23e14c01bc995 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3903,8 +3903,7 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 				goto failed;
 			}
 			/* init i2c buses */
-			if (!amdgpu_device_has_dc_support(adev))
-				amdgpu_atombios_i2c_init(adev);
+			amdgpu_i2c_init(adev);
 		}
 	}
 
@@ -4164,8 +4163,7 @@ void amdgpu_device_fini_sw(struct amdgpu_device *adev)
 	amdgpu_reset_fini(adev);
 
 	/* free i2c buses */
-	if (!amdgpu_device_has_dc_support(adev))
-		amdgpu_i2c_fini(adev);
+	amdgpu_i2c_fini(adev);
 
 	if (amdgpu_emu_mode != 1)
 		amdgpu_atombios_fini(adev);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c
index 7c9add7652daf..d5634f9b41c6a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c
@@ -226,6 +226,14 @@ void amdgpu_i2c_destroy(struct amdgpu_i2c_chan *i2c)
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



