Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA382E92BC;
	Tue, 17 Jun 2025 15:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175623; cv=none; b=DkeMdHmN7gVAfhvGmkYUFkvaEURE+dIL87MpLEfjO4XvFw1caJG1hVH8bme79Tua2krJ+BB1mtTybyLSjXVY53XhxfqIoETKIXpamFGivL5Elc0rdxR4jdMNiVas0SouxYqWz2/Rg9YHUIYn/hsXRRgF70Ni5JG6wdCCI9lYFzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175623; c=relaxed/simple;
	bh=AO+GoIcaz7vpGVflnvdAu6X8fvADCAeZOx9FIeHQI44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghBP8iD9hdTlNgcDx3cew7QirwvUjfa4NQG3WPGQTGcfst5QrOuLCuaJdMpnpnU8Vea4RN3L0wGYf3qY3JZPc/S/cEOz5LCIKG2mFA4hwTwyGX3M6ZIz5FccNPTHZeO6pD0A/uJcVJ/RlCQ5F7xm5QHs34QCrvrKZkOJsh/hw88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nzocA2XO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nzocA2XO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD71C4CEE7;
	Tue, 17 Jun 2025 15:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175623;
	bh=AO+GoIcaz7vpGVflnvdAu6X8fvADCAeZOx9FIeHQI44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nzocA2XOITsoNx4x0bAv5jer5drVAYr/zccyIzeGdtiRr4GVDhARN09dvzWntgxwG
	 6/z0xnKaBB6WGmU4MVHvHXLyGQCkW2FLUXLIFfivppaN5XImi0KQhZCEbgplBMv8BC
	 0hJCRAYnqTBrSn2tDpGnppO/IujVenldpC9RIxkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 107/780] drm/panthor: Call panthor_gpu_coherency_init() after PM resume()
Date: Tue, 17 Jun 2025 17:16:55 +0200
Message-ID: <20250617152455.859582366@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 7d5a3b22f5b58ef89ab8770d7a44c24eecde8d66 ]

When the device is coherent, panthor_gpu_coherency_init() will read
GPU_COHERENCY_FEATURES to make sure the GPU supports the ACE-Lite
coherency protocol, which will fail if the clocks/power-domains are
not enabled when the read is done. Move the
panthor_gpu_coherency_init() call after the device has been resumed
to prevent that.

Changes in v2:
- Add Liviu's R-b

Changes in v3:
- Add Steve's R-b

Fixes: dd7db8d911a1 ("drm/panthor: Explicitly set the coherency mode")
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://lore.kernel.org/r/20250404080933.2912674-3-boris.brezillon@collabora.com
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_device.c b/drivers/gpu/drm/panthor/panthor_device.c
index a9da1d1eeb707..c73c1608d6e68 100644
--- a/drivers/gpu/drm/panthor/panthor_device.c
+++ b/drivers/gpu/drm/panthor/panthor_device.c
@@ -171,10 +171,6 @@ int panthor_device_init(struct panthor_device *ptdev)
 	struct page *p;
 	int ret;
 
-	ret = panthor_gpu_coherency_init(ptdev);
-	if (ret)
-		return ret;
-
 	init_completion(&ptdev->unplug.done);
 	ret = drmm_mutex_init(&ptdev->base, &ptdev->unplug.lock);
 	if (ret)
@@ -247,6 +243,10 @@ int panthor_device_init(struct panthor_device *ptdev)
 	if (ret)
 		goto err_rpm_put;
 
+	ret = panthor_gpu_coherency_init(ptdev);
+	if (ret)
+		return ret;
+
 	ret = panthor_mmu_init(ptdev);
 	if (ret)
 		goto err_unplug_gpu;
-- 
2.39.5



