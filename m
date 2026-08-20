Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C939C379EDA;
	Thu, 20 Aug 2026 15:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238288; cv=none; b=HGjGgaN52Kx51MMgXyoBJSDpb46o103wao2RGtczNPK66pCMtCi6ZkJm5ToRELOa4F/jL3mwpjvEDoRqgTn/HL+E/eqgeyk1YZa+fchlTiqo392q14wz3l7lZcE0dGOgXprbzpO/CJkb3n8z9pMliuXbKA6B/IO+SqJkWXjTeWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238288; c=relaxed/simple;
	bh=iSrsxHOQV+B0nIeRj0+3fhikQV0Sk3FqRociJui7khY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFnDXuJDk7pewlSdPfX/vfD5p9PzaqmEdHzh6798C4DRAKLhRChE8byeblCYpksuGYpMP51wFG/p+BQnDL03QLDg0rzuWjz0Ia9okNEjzbKoAZBWXWtlO1CwVRRoNtY3BNza1qm7KdF0M2T95xf3XUdclLmLxI5/SGue5IMI4PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G8CLjDqZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G8CLjDqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E69B1F000E9;
	Thu, 20 Aug 2026 15:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238287;
	bh=toTiJCU38YZoxrdGOltoJUJlxFVhuyvBMGvMYRaVJLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G8CLjDqZTYTPFn8xjg6ihQ70i785V80vlgKZDH3SEHTVcCb8UXJqHzJAhwklphVH6
	 uklDKURYpvWgQBz5xGCHjxjJS895V3EFo3CZOdxihDlzswU2W0mXxcwZr1qU57vV20
	 ki8ScN/+wWyZVDW0rxVIrBJchqsHa/kgUxqESJp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 094/228] drm/radeon: fix autosuspend cleanup during teardown
Date: Thu, 20 Aug 2026 16:53:56 +0200
Message-ID: <20260820145247.510785568@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


