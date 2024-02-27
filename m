Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0925D13B2B3;
	Tue, 27 Feb 2024 13:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040506; cv=none; b=eYL0OHBqFBWP0B+9xoCb9yzdg1tWzUFfToHuY/TZxu1x86vwHVZywjckXVeOPfrjqzRxRAe80SWzmYPh31BD1h4Jo4MH6C2asDxyekHnc09hguZvwTQXwyFvpVKu4hISPiJB9Hs2Nm+G95TOaY08yQlINyuhxfG56qgMnmNsc5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040506; c=relaxed/simple;
	bh=GAw/37hMQpCtqGxBnJRIgvBOBEMKlPO2fjc4sCbtLh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IqcZEB/xD1wuBgV7CosMFktiN1LPskPBpjb4T9MFexjKZ8tt+JtfvXJGSSOY8o2SUOOWmJkuX0g8Pdz6nrBRVID9xZRS3iRfXrGt3VfLnQvVFl/b7Ve7nY911TBllSN97YD6olMPW43xu/K5vXP9slX1rJDtRKCUJMAs5SgjDds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s7ehJ4KQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s7ehJ4KQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA42C433F1;
	Tue, 27 Feb 2024 13:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040505;
	bh=GAw/37hMQpCtqGxBnJRIgvBOBEMKlPO2fjc4sCbtLh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s7ehJ4KQSr0NQrb/64y4yQ6mIEIP26T2txM+W2Wl/OiUH7MaLEXwL+hpneaHYOCJS
	 pi/XGu3bmn1wT7r2f7GLiIk62j3/J8h5qPrACIrwXdleARv4IcjkeWZIiAtC2yo2Sd
	 Bh9VI4d+Lwu79Iw0d6+OhJHJoldUA596sP5Shth4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=BCrg=20Billeter?= <j@bitron.ch>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.7 001/334] drm/amd: Stop evicting resources on APUs in suspend
Date: Tue, 27 Feb 2024 14:17:39 +0100
Message-ID: <20240227131630.687232698@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 3a9626c816db901def438dc2513622e281186d39 upstream.

commit 5095d5418193 ("drm/amd: Evict resources during PM ops prepare()
callback") intentionally moved the eviction of resources to earlier in
the suspend process, but this introduced a subtle change that it occurs
before adev->in_s0ix or adev->in_s3 are set. This meant that APUs
actually started to evict resources at suspend time as well.

Explicitly set s0ix or s3 in the prepare() stage, and unset them if the
prepare() stage failed.

v2: squash in warning fix from Stephen Rothwell

Reported-by: Jürg Billeter <j@bitron.ch>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3132#note_2271038
Fixes: 5095d5418193 ("drm/amd: Evict resources during PM ops prepare() callback")
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h        |    2 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c   |   15 +++++++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   11 +++++++++--
 3 files changed, 26 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1509,9 +1509,11 @@ static inline int amdgpu_acpi_smart_shif
 #if defined(CONFIG_ACPI) && defined(CONFIG_SUSPEND)
 bool amdgpu_acpi_is_s3_active(struct amdgpu_device *adev);
 bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev);
+void amdgpu_choose_low_power_state(struct amdgpu_device *adev);
 #else
 static inline bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev) { return false; }
 static inline bool amdgpu_acpi_is_s3_active(struct amdgpu_device *adev) { return false; }
+static inline void amdgpu_choose_low_power_state(struct amdgpu_device *adev) { }
 #endif
 
 #if defined(CONFIG_DRM_AMD_DC)
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -1519,4 +1519,19 @@ bool amdgpu_acpi_is_s0ix_active(struct a
 #endif /* CONFIG_AMD_PMC */
 }
 
+/**
+ * amdgpu_choose_low_power_state
+ *
+ * @adev: amdgpu_device_pointer
+ *
+ * Choose the target low power state for the GPU
+ */
+void amdgpu_choose_low_power_state(struct amdgpu_device *adev)
+{
+	if (amdgpu_acpi_is_s0ix_active(adev))
+		adev->in_s0ix = true;
+	else if (amdgpu_acpi_is_s3_active(adev))
+		adev->in_s3 = true;
+}
+
 #endif /* CONFIG_SUSPEND */
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4441,13 +4441,15 @@ int amdgpu_device_prepare(struct drm_dev
 	struct amdgpu_device *adev = drm_to_adev(dev);
 	int i, r;
 
+	amdgpu_choose_low_power_state(adev);
+
 	if (dev->switch_power_state == DRM_SWITCH_POWER_OFF)
 		return 0;
 
 	/* Evict the majority of BOs before starting suspend sequence */
 	r = amdgpu_device_evict_resources(adev);
 	if (r)
-		return r;
+		goto unprepare;
 
 	for (i = 0; i < adev->num_ip_blocks; i++) {
 		if (!adev->ip_blocks[i].status.valid)
@@ -4456,10 +4458,15 @@ int amdgpu_device_prepare(struct drm_dev
 			continue;
 		r = adev->ip_blocks[i].version->funcs->prepare_suspend((void *)adev);
 		if (r)
-			return r;
+			goto unprepare;
 	}
 
 	return 0;
+
+unprepare:
+	adev->in_s0ix = adev->in_s3 = false;
+
+	return r;
 }
 
 /**


