Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03B71D8E07;
	Tue, 20 May 2025 14:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749767; cv=none; b=rYUV1ZsBs/Bodi1/XoW4o5nBW389ui1EIJiP3UcisozD9+s1qacqhz4oQOjX2/hZHMPAVqmcgkOCG9xIuv4GNAu9xUgmUr85uePVvnx9Y+2ZBvBr+igpit4dKX9okpgmeAuxJCkEzfXJgLDxCCJg+2I3up1+A09zd6uvKPPfE3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749767; c=relaxed/simple;
	bh=pLueAJD4lwAElQ2tJ5kzXQWE7Al6HUFu9TsplQmlEKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gsg9EvHEz6bhfZ3LSJ6OvZnA9u7MaAbmikiRpR+cZOsVYhRc/o8jOlOWDs2R20gNqCURJKy7Z5enz4Mk7GOafJyw60ibrJLR3nkli2uT+C8q/R/deDs3LduyLNpZMYqm0YnxfmUCvFqKVUeFfEFtBH2IWUMps0N9C0EpxSdT0mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q6I/Hd2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q6I/Hd2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F55C4CEE9;
	Tue, 20 May 2025 14:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749767;
	bh=pLueAJD4lwAElQ2tJ5kzXQWE7Al6HUFu9TsplQmlEKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q6I/Hd2Kse4JBcJDSz/Wwey8KPp08W/cveI3F95LL2eptqoIiLkgY73gXww35tjMs
	 6h7vHUStwANBp3p5OLhuHW+C8AJTaE9FLQhA0kj/4K+7uNt4zNoCVQePmRfT5xSGzH
	 5fjG2bOatAnG57QYuIe182UEyw8jkUi/fmCer1mM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=BCrg=20Billeter?= <j@bitron.ch>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/117] drm/amd: Stop evicting resources on APUs in suspend
Date: Tue, 20 May 2025 15:49:48 +0200
Message-ID: <20250520125804.901974781@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d59e8536192ca..ed4ebc6d32695 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1458,9 +1458,11 @@ static inline int amdgpu_acpi_smart_shift_update(struct drm_device *dev,
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
index 8b2f2b921d9de..8b8e273662b39 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -1525,4 +1525,19 @@ bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev)
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
index 10f5a3d0f5916..b2056228e8699 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4121,13 +4121,15 @@ int amdgpu_device_prepare(struct drm_device *dev)
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
 
@@ -4138,10 +4140,15 @@ int amdgpu_device_prepare(struct drm_device *dev)
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



