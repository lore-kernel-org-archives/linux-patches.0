Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF131922ED;
	Tue, 20 May 2025 13:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749343; cv=none; b=KF/0Sxic0wTHmV63d4a50nhoW1u4OG8/srUwt8pbXr1BOR/6s+x9hqv4Bm3t6A8DIUr72SlcBABVjL+x5+62vw+to4AvV+IsBMq71q32TCrATKlw+B8qR5653iBRS8FxoHioKyLABPgr2Tdxw61ac5XlTey6kvAESBfPtH2Q5QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749343; c=relaxed/simple;
	bh=qF5yoQKXQ4oY+Gk/eIqzPDMMr3ooSR4FotLGVAuqZPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MDnPhtwjEjQGPVs17xiZhOimzf6OgsQkPf4ucsQdxtzhU+Sa6hxERQaplq46q9oaKzNUKcd9CRXEYgvPXMjwz6uQvujJaTZv5oJpYh7VSwViadu0lwUOwQB/iQAvRyxfve/VWF4Rc2zIZHMMz7cjXRONuebynVmnG4hIkxwSeLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HABz4UyM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HABz4UyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF4AC4CEE9;
	Tue, 20 May 2025 13:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749343;
	bh=qF5yoQKXQ4oY+Gk/eIqzPDMMr3ooSR4FotLGVAuqZPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HABz4UyMVnqoEp5ucg3GVwJOGezJ+gk1Itjo95ujtMpb2pVt6R/PZ7+ngMlfH6H9g
	 1/HAuW/vkOHFSxQe7XWCdcqIyhr/MPRLgM5ysmH2nT52CJ97GOuAFC+TPvL3ZbydFc
	 545Dnrw89gLo+S8qYoHthM1cfSZRiGc9lSFTJ6xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=BCrg=20Billeter?= <j@bitron.ch>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 14/97] drm/amd: Stop evicting resources on APUs in suspend
Date: Tue, 20 May 2025 15:49:39 +0200
Message-ID: <20250520125801.223611647@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 226db36032c61d8717dfdd052adac351b22d3e83 ]

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
Stable-dep-of: d0ce1aaa8531 ("Revert "drm/amd: Stop evicting resources on APUs in suspend"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h        |  2 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c   | 15 +++++++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 11 +++++++++--
 3 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index dd22d2559720c..705703bab2fdd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1408,9 +1408,11 @@ static inline int amdgpu_acpi_smart_shift_update(struct drm_device *dev,
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
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
index 5fa7f6d8aa309..70d761f79770d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -1118,4 +1118,19 @@ bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev)
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
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index fcd0c61499f89..52f4ef4e8b4b0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4195,13 +4195,15 @@ int amdgpu_device_prepare(struct drm_device *dev)
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
 
 	flush_delayed_work(&adev->gfx.gfx_off_delay_work);
 
@@ -4212,10 +4214,15 @@ int amdgpu_device_prepare(struct drm_device *dev)
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
-- 
2.39.5



