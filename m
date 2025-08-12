Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272D4285043;
	Tue, 12 Aug 2025 19:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025325; cv=none; b=KNaVS7if72Gvg7edWlDdCrFI8sEYDy50KwyivzivRDNY1R+VjljmzczgQE2RMbZpcRusyXOxBloFoH9u1kabJ9TV3LWXH6Z1SRVxi4P1sKwvI3+NeLeQ5DlBFdMlJ1fvoiX0uC6zxlFCGVh4rWXH4aINA26s8hJ2bvBTPZ7DSYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025325; c=relaxed/simple;
	bh=mQ5iqox3gXKUPXcouqRqNZLcp+h2ewzs8/7e8mx/p2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J24DwLI5KLGs4unzMYSm+lG9Mcot9ndpgH0MgwaOel4tGHugJOfZZutGW5L8wSfY75IjSKXokEj87PNJ7xlTUV8lLBep/zr3P3AyJiH2VonRRkb5poAutHQLex1TyHLVor8HEXa8bSXIdSxsehRtrfSKp1Gz/hkZpDJhOWUL2/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1smFa3qY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1smFa3qY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0807C4CEF0;
	Tue, 12 Aug 2025 19:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025325;
	bh=mQ5iqox3gXKUPXcouqRqNZLcp+h2ewzs8/7e8mx/p2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1smFa3qYShgCixjoY7OAUQPyjKLDLzuitTywWQoMeEnifQK0bCCH6UJeIS3hGvdfj
	 CXrzRYg2T/JZf9AlknY1fxRV0JZIXhNGbJ8oYl79ZtFKt0Gh8M5gQiakw8FT+7KoAk
	 y6Hz1MPNhpTvAHHxSAq3Ff2oSTW55XMocGxusCrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 001/480] drm/radeon: Do not hold console lock while suspending clients
Date: Tue, 12 Aug 2025 19:43:29 +0200
Message-ID: <20250812174357.349879194@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 5dd0b96118e09a3725e3f83543e133b1fd02c18c ]

The radeon driver holds the console lock while suspending in-kernel
DRM clients. This creates a circular dependency with the client-list
mutex, which is supposed to be acquired first. Reported when combining
radeon with another DRM driver.

Therefore, do not take the console lock in radeon, but let the fbdev
DRM client acquire the lock when needed. This is what all other DRM
drivers so.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reported-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Closes: https://lore.kernel.org/dri-devel/0a087cfd-bd4c-48f1-aa2f-4a3b12593935@oss.qualcomm.com/
Suggested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 612ec7c69d04cb58beb1332c2806da9f2f47a3ae)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_device.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index bbd39348a7ab..6f50cfdfe5a2 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1635,11 +1635,9 @@ int radeon_suspend_kms(struct drm_device *dev, bool suspend,
 		pci_set_power_state(pdev, PCI_D3hot);
 	}
 
-	if (notify_clients) {
-		console_lock();
-		drm_client_dev_suspend(dev, true);
-		console_unlock();
-	}
+	if (notify_clients)
+		drm_client_dev_suspend(dev, false);
+
 	return 0;
 }
 
-- 
2.39.5



