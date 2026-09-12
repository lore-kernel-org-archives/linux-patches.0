Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52602368D47;
	Sat, 12 Sep 2026 15:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228644; cv=none; b=Ne8QMYyl9ghOijoP2lhmqbrGAGhvf0a2DtiwB1aYm7ku16adesPoUnsyKZ+Yugz8hpvhOkTar3+WhfroDq9eCfLSXYS2eUZ2bWsaYBFFzBF6woDe2P5VTamAcCP+iLwrI75zGulrDSLRgLwe0ubOXI2BvrcCl2TSB2SXnQuBH2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228644; c=relaxed/simple;
	bh=YgNM21H0IctumxZVd7pR79a8UD80tPZ9UsS1/h0yNNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRZpEJ828LvzjaDQJLAnRCQ5OCv5gJ8yRuHG4bh/HNUH4+vf4Ch9K2I+3doyly9YY0x9SelBnohxuxeHMGRlaDbYyzHOFtsMv7Yjdei2wRLfFt0eOrx5oHM7aEWcLMU3H7UG0dq/YTAdidt4MddqrbpGNh2lg/u/h0FilflZVJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oDOlMqtQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oDOlMqtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2416B1F000FF;
	Sat, 12 Sep 2026 15:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228643;
	bh=TsaclXw8YuCfHnXjMBu2r8yFjSDj+09TN++ebHjqo2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oDOlMqtQo9usF1P3X/AEhhY2bXm/ZWzE1GXd9LgjYA8PyNXYqr7bCtPbUd4J305PV
	 vCXk5OCoreZPBNbYKfibDhQB2ka08lPNPIj/FQ2z/ulbY5idDvZPX+3VmIdElptwpO
	 XXNZ+203mqFFHkHeD1gMd8ynmwvu6WH6SJJT6wGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 0428/1191] drm/amdgpu: fix autosuspend cleanup during removal
Date: Sat, 12 Sep 2026 08:52:36 +0200
Message-ID: <20260912065557.850020917@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit ef5fcf2a6c320676bf8be2dadac93d9023b468b7 upstream.

amdgpu_pci_probe() calls pm_runtime_use_autosuspend(), but
amdgpu_pci_remove() does not call the matching
pm_runtime_dont_use_autosuspend().

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
during teardown, this reference is not dropped and usage_count remains
unbalanced.

The documentation for pm_runtime_use_autosuspend() also notes that it
is important to undo it with pm_runtime_dont_use_autosuspend() at
driver exit time, unless runtime PM was initially enabled with
devm_pm_runtime_enable().

Add the missing pm_runtime_dont_use_autosuspend() call to the remove
path.

This issue was found by manual code inspection.

Fixes: d38ceaf99ed0 ("drm/amdgpu: add core driver (v4)")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20260808120934.2813010-1-lgs201920130244@gmail.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2251,6 +2251,7 @@ amdgpu_pci_remove(struct pci_dev *pdev)
 	if (adev->pm.rpm_mode != AMDGPU_RUNPM_NONE) {
 		pm_runtime_get_sync(dev->dev);
 		pm_runtime_forbid(dev->dev);
+		pm_runtime_dont_use_autosuspend(dev->dev);
 	}
 
 	if (adev->ip_versions[MP1_HWIP][0] == IP_VERSION(13, 0, 2) &&


