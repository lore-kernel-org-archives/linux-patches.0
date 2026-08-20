Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E26367B6D;
	Thu, 20 Aug 2026 15:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239030; cv=none; b=frprC8X63X0uQq7/9yXsMzMVLnVOA76E7Mhh7Y2SwMd5d+4wBh1rivALJ5sJE5a6H72F+4uaTb7grXxE+G3JZACvqWrM1I2OFA9NEIjlmsbwVkctdEt0tq1lmKagqyv30jFfjHw2jykaSO8bPLpALs9DPMXR7qwCCmBN5yQW6mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239030; c=relaxed/simple;
	bh=sD97YRrlemKyuA80h9ttW/V46Z3mG9quVp2vgOE2aNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frYuKvNvXkVF8fNf5vi0cv3ekf4ZfG4EdULNeQ92fpwhTtqdEyio6X+mtcPVLgySucUDI0O2aK0a2D880rjnUaV8Gz+Hv4b+M8K1bZt61TLNJTFdkfnxuAYqNLx06bnUnE4432Q27le1AFBwkV8WRZHns68Ct+lle7u78joq+Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ZkkJuZ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ZkkJuZ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB571F000E9;
	Thu, 20 Aug 2026 15:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239028;
	bh=VlJ8ipzfXlBvRoHitGBM8+NsD0HEyOw90QbFp8drE+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ZkkJuZ2dehMsU1mtTVKYgcz5y1m3roPVKOeE3vHiLCfP2njMboej1LyWMNedNrSm
	 r+4X1zG1k7oBjVIx6m6e9rlrL73GI59aFSH6DT3Hr6kuMaH6INuRVPpkyUN9dhYI9m
	 OHV2BGzVlrWhkiAU0ZoJYt0TBUOTFDRJsUJ3C8pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 076/217] drm/radeon: fix autosuspend cleanup during teardown
Date: Thu, 20 Aug 2026 16:54:04 +0200
Message-ID: <20260820145239.916283028@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 587be7a17358ef8c0106775fcedae5a7bef50735 upstream.

radeon_driver_load_kms() calls pm_runtime_use_autosuspend() for PX
devices, but radeon_driver_unload_kms() does not call the matching
pm_runtime_dont_use_autosuspend() during teardown.

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
during teardown, this reference is not dropped.

The documentation for pm_runtime_use_autosuspend() also notes that it
is important to undo it with pm_runtime_dont_use_autosuspend() at
driver exit time, unless runtime PM was initially enabled with
devm_pm_runtime_enable().

Add the missing pm_runtime_dont_use_autosuspend() call to the driver
unload path.

This issue was found by manual code inspection.

Fixes: 10ebc0bc0934 ("drm/radeon: add runtime PM support (v2)")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 0fdc1ff82ea14844c22795e9e0813c3ca03235e1)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/radeon_kms.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -71,6 +71,7 @@ void radeon_driver_unload_kms(struct drm
 	if (radeon_is_px(dev)) {
 		pm_runtime_get_sync(dev->dev);
 		pm_runtime_forbid(dev->dev);
+		pm_runtime_dont_use_autosuspend(dev->dev);
 	}
 
 	radeon_acpi_fini(rdev);


