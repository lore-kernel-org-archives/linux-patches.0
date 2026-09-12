Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B5A3F7877;
	Sat, 12 Sep 2026 11:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214193; cv=none; b=faw38oSLYrEHieryUR8ke3+lWqyrjfUx/ZtmwiSSDAsoiq6iGn8RAzbqPb9AGdHsDkHmJudw73rAI6LKh36azX/J2zF7OeZ3A6kzBzl7LizaovBpVlRkZImYat42vQO34B4JqhSD6P9BNiiQPa3xbYaylNWuxj3ikwqd4HRWSmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214193; c=relaxed/simple;
	bh=Gm9PJu5PXBecF4CKtdlUQbTeJRutX5+nN0MhUgHAe/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G298oIGpHPd5/RXIuQwydo6yIc8OeXzZLAqHgfOw5L9eKnLIDkbccqvzAQi8AlsuToSBzHTcgMs0was442kL+EE29Zux2xZgEuKBWpAUc/31CYMrx6I3DwLjqZWT7lZgyygjqPPohRziSGXpvDOg697SHKFSD1yxvKwdGlaLQpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXHYNwnx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXHYNwnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB03D1F000FF;
	Sat, 12 Sep 2026 11:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214191;
	bh=G160Tp0zenTd4TgQQhvY1DFM3WbZan4U8MVRdminzdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TXHYNwnx0rUUySqWFU3rR2iqup2YcvBCNRFSNHuY70cfeMHg8Nd8AJyfUwpEpOwFf
	 qBA8i/2qIzYk/l0KzQPM8LWGz1SBAi4BTFecy0quqp8CBmXkGTBtMtSgb+KU7TV5ge
	 PtOrqJq0c9raBn0AG80/WIry/CqHdNKkAjiT0eOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 0276/1376] drm/amdgpu: fix autosuspend cleanup during removal
Date: Sat, 12 Sep 2026 08:45:02 +0200
Message-ID: <20260912065613.696769456@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
@@ -2461,6 +2461,7 @@ amdgpu_pci_remove(struct pci_dev *pdev)
 	if (adev->pm.rpm_mode != AMDGPU_RUNPM_NONE) {
 		pm_runtime_get_sync(dev->dev);
 		pm_runtime_forbid(dev->dev);
+		pm_runtime_dont_use_autosuspend(dev->dev);
 	}
 
 	amdgpu_driver_unload_kms(dev);


