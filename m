Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E6E3876D0;
	Tue, 10 Mar 2026 11:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141995; cv=none; b=pN8jliXQo+cEpcSs8dj3qa+j4DGlBcxIsstCm5mhWP53z+cHOkWvFlOWN12XHn5KZbWR42m3DBtq/Kj3ereuUmZO2L+vHJzwKJ5rj7MvtAE2kSVFDmCTG6BP1HjuxHPmW8e/0ADadb17I09hU9ILEPpflm3y+FKOhuln/y665gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141995; c=relaxed/simple;
	bh=ifczh7gdKAo6Bpbo+SoIpqLV3hnyn0NF6tQI3gRcWWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKsVp6YWK2wh1BP00AI4al/6/iypzi9PR96npn+d3Rv9Af9/53QpppipD5eoFdksUrgkqVaVr3IyMIncaco/Lg46ABk836CjNS6v5Imddbc8wTovyan4OY3txktPeMj1ra3U25JVu1k3hWwarUSgS5GfTk6sofDBYF3+x5k5bLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iiKRMqNt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iiKRMqNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E37C19423;
	Tue, 10 Mar 2026 11:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141995;
	bh=ifczh7gdKAo6Bpbo+SoIpqLV3hnyn0NF6tQI3gRcWWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iiKRMqNtV7cruNO3xR7nxrKu6ScF13rsMlXnUj4SkJOFa8HM4Z4LyfoU7W8oSq5EJ
	 yVoOtYKrUBLNPbvMMB8TveYjf8bTpPg1azv/wFRNlZeqK33p/l4JVPj66NClrY+1Fc
	 wpPD7egxk9muAbxj1rTSCanhTqtX7j6vSku5GTj+vvCiTC/eWayTt1Lk33Qa0aVXT4
	 jo1O4U+LcZtlFK17fQZN+hsERuomJdrljGJnUhPk3JvnXPUaw+T/krC2VGxCWYXjTq
	 fkhdGRApn0acv+R+CWAr3aqH3fVFdpwI4kXHRwP8r6QHn9+HOmNRHb39lTHplbJWbB
	 lvSn6i70121mg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>,
	Cal Peake <cp@absolutedigital.net>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 120/314] drm/amd: Fix hang on amdgpu unload by using pci_dev_is_disconnected()
Date: Tue, 10 Mar 2026 07:16:19 -0400
Message-ID: <bacbba1cc27941ae425297d9cd6a05f915a37d9c.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit f7afda7fcd169a9168695247d07ad94cf7b9798f ]

The commit 6a23e7b4332c ("drm/amd: Clean up kfd node on surprise
disconnect") introduced early KFD cleanup when drm_dev_is_unplugged()
returns true. However, this causes hangs during normal module unload
(rmmod amdgpu).

The issue occurs because drm_dev_unplug() is called in amdgpu_pci_remove()
for all removal scenarios, not just surprise disconnects. This was done
intentionally in commit 39934d3ed572 ("Revert "drm/amdgpu: TA unload
messages are not actually sent to psp when amdgpu is uninstalled"") to
fix IGT PCI software unplug test failures. As a result,
drm_dev_is_unplugged() returns true even during normal module unload,
triggering the early KFD cleanup inappropriately.

The correct check should distinguish between:
- Actual surprise disconnect (eGPU unplugged): pci_dev_is_disconnected()
  returns true
- Normal module unload (rmmod): pci_dev_is_disconnected() returns false

Replace drm_dev_is_unplugged() with pci_dev_is_disconnected() to ensure
the early cleanup only happens during true hardware disconnect events.

Cc: stable@vger.kernel.org
Reported-by: Cal Peake <cp@absolutedigital.net>
Closes: https://lore.kernel.org/all/b0c22deb-c0fa-3343-33cf-fd9a77d7db99@absolutedigital.net/
Fixes: 6a23e7b4332c ("drm/amd: Clean up kfd node on surprise disconnect")
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index fb096bf551ef2..dbcd55611a37d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4991,7 +4991,7 @@ void amdgpu_device_fini_hw(struct amdgpu_device *adev)
 	 * before ip_fini_early to prevent kfd locking refcount issues by calling
 	 * amdgpu_amdkfd_suspend()
 	 */
-	if (drm_dev_is_unplugged(adev_to_drm(adev)))
+	if (pci_dev_is_disconnected(adev->pdev))
 		amdgpu_amdkfd_device_fini_sw(adev);
 
 	amdgpu_device_ip_fini_early(adev);
@@ -5003,7 +5003,7 @@ void amdgpu_device_fini_hw(struct amdgpu_device *adev)
 
 	amdgpu_gart_dummy_page_fini(adev);
 
-	if (drm_dev_is_unplugged(adev_to_drm(adev)))
+	if (pci_dev_is_disconnected(adev->pdev))
 		amdgpu_device_unmap_mmio(adev);
 
 }
-- 
2.51.0

