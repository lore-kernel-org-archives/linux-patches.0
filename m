Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E22C334C1A;
	Wed,  3 Dec 2025 16:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779332; cv=none; b=UR6FCOHroLHO2A7QV1h8JCzCbc5wYaLZRJZNknhhOh2wslErAD/UkWJTfIi9KzkNkkqJRNwA7NQ65qUefZb5+QP2AmSp5kA+jeG2O5MSftCTOS9Ld1lcrBjlbF7axrS+4pfjlMxDgLOCsEdQ9yd9kO3FWqGuWwZR5pRvCCD67Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779332; c=relaxed/simple;
	bh=DSLoEPUgpOT381LQZLpmzz56fvB0N86D5sphAHFfTo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SdXV4UqafScHPonrVLJpm1LhlZ42FjVVyI8O2zF0nkbQ4oQDeR2tgSs54YmJ4QuctZk7Wu79HFRck3UXWQrOgDvlIPWoL5Buk2HfwWPt0rwWvpEjn6d+tJhjnNulmyQVHCf/Ue3SDoNh0saKR9XlW2HMxcpy8UQh6tpDr0HSC0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2YvR4B0A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2YvR4B0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F110BC4CEF5;
	Wed,  3 Dec 2025 16:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779332;
	bh=DSLoEPUgpOT381LQZLpmzz56fvB0N86D5sphAHFfTo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2YvR4B0A0KB2DJNmY/AlLt8dF/tEM+4AYsY0erUEZlZl/4G6xIsB+nJuTLGP92kjW
	 sO1ZWjVieNdQZanORL1dkkXa+ARvbc1oPAc5mQB9u6lf1UU9lcLs52zU05pe2A3Age
	 y70PwQNyWuIqk1/uvPBvgjcYAOh6h4x/NlKQ5fc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AceLan Kao <acelan.kao@canonical.com>,
	Kai-Heng Feng <kaihengf@nvidia.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Denis Benato <benato.denis96@gmail.com>,
	=?UTF-8?q?Merthan=20Karaka=C5=9F?= <m3rthn.k@gmail.com>,
	Eric Naim <dnaim@cachyos.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 227/568] drm/amd: Avoid evicting resources at S5
Date: Wed,  3 Dec 2025 16:23:49 +0100
Message-ID: <20251203152449.036244947@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit 531df041f2a5296174abd8292d298eb62fe1ea97 ]

Normally resources are evicted on dGPUs at suspend or hibernate and
on APUs at hibernate.  These steps are unnecessary when using the S4
callbacks to put the system into S5.

Cc: AceLan Kao <acelan.kao@canonical.com>
Cc: Kai-Heng Feng <kaihengf@nvidia.com>
Cc: Mark Pearson <mpearson-lenovo@squebb.ca>
Cc: Denis Benato <benato.denis96@gmail.com>
Cc: Merthan Karakaş <m3rthn.k@gmail.com>
Tested-by: Eric Naim <dnaim@cachyos.org>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 18a0802cb74dc..f18f165876043 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4187,6 +4187,10 @@ static int amdgpu_device_evict_resources(struct amdgpu_device *adev)
 	if ((adev->in_s3 || adev->in_s0ix) && (adev->flags & AMD_IS_APU))
 		return 0;
 
+	/* No need to evict when going to S5 through S4 callbacks */
+	if (system_state == SYSTEM_POWER_OFF)
+		return 0;
+
 	ret = amdgpu_ttm_evict_resources(adev, TTM_PL_VRAM);
 	if (ret)
 		DRM_WARN("evicting device resources failed\n");
-- 
2.51.0



