Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF061514DC;
	Tue,  2 Jul 2024 17:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941400; cv=none; b=foPkSaeat05j8b9pDP2AHs4EUEjBBaDHkwP5Q99k1a11mOz9EtoXWG8hGkOwEOG9cSOh+r1JMhGUKE78aVyXGWibkRUQW4p5CyZHCUv4zEPP2vVHYX7nwbOI0EM9UBc4gmW2UojRboTq1ZP+ZhqD1AUiz0poqHLlkBf94974KNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941400; c=relaxed/simple;
	bh=FXT33upDb2VwdlmbjtF0F0u9NMdms5DL7YhHOeLjyEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U7l2YS81NjvJ1IWxzvtKSFpI99xtZzOBKG/0YrXlWG0mvbM3DkR1ElPEHP2f6zAIvXRZAO9pxR74MbyCZmuSgZf8ZWVFIFrVK9CyezWgwPO0ly87EGV0CQWw0cK2vRhoWOcEyIt7IDU2ZeR3uCE9U8c+lr/D9E+6tMRfBiTXy3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KQ/xI4Sv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KQ/xI4Sv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E559FC116B1;
	Tue,  2 Jul 2024 17:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941400;
	bh=FXT33upDb2VwdlmbjtF0F0u9NMdms5DL7YhHOeLjyEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KQ/xI4SvyuH6TjR+EKwATCBdwZvcaVTz01sof+c2NYJyjxZW6Xc3bBLwh2g/zfKqe
	 u/2g+KcUJd2sV3HcItZNwPrt5AefMxOjzWe2Ud9X1aS6PwNaYD3WscNJ0KPEmLExo2
	 in9utZdgcS4RsCm6rULmdlMrJEHjTLmnro/TzMV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Erick Archer <erick.archer@outlook.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/128] drm/radeon/radeon_display: Decrease the size of allocated memory
Date: Tue,  2 Jul 2024 19:04:13 +0200
Message-ID: <20240702170228.200503207@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Erick Archer <erick.archer@outlook.com>

[ Upstream commit ae6a233092747e9652eb793d92f79d0820e01c6a ]

This is an effort to get rid of all multiplications from allocation
functions in order to prevent integer overflows [1] [2].

In this case, the memory allocated to store RADEONFB_CONN_LIMIT pointers
to "drm_connector" structures can be avoided. This is because this
memory area is never accessed.

Also, in the kzalloc function, it is preferred to use sizeof(*pointer)
instead of sizeof(type) due to the type of the variable can change and
one needs not change the former (unlike the latter).

At the same time take advantage to remove the "#if 0" block, the code
where the removed memory area was accessed, and the RADEONFB_CONN_LIMIT
constant due to now is never used.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments [1]
Link: https://github.com/KSPP/linux/issues/160 [2]
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Erick Archer <erick.archer@outlook.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon.h         | 1 -
 drivers/gpu/drm/radeon/radeon_display.c | 8 +-------
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 166c18d62f6d7..ec86c04a0d989 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -131,7 +131,6 @@ extern int radeon_cik_support;
 /* RADEON_IB_POOL_SIZE must be a power of 2 */
 #define RADEON_IB_POOL_SIZE			16
 #define RADEON_DEBUGFS_MAX_COMPONENTS		32
-#define RADEONFB_CONN_LIMIT			4
 #define RADEON_BIOS_NUM_SCRATCH			8
 
 /* internal ring indices */
diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index 1814bb8e14f10..dbee301b3b2e8 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -683,7 +683,7 @@ static void radeon_crtc_init(struct drm_device *dev, int index)
 	struct radeon_device *rdev = dev->dev_private;
 	struct radeon_crtc *radeon_crtc;
 
-	radeon_crtc = kzalloc(sizeof(struct radeon_crtc) + (RADEONFB_CONN_LIMIT * sizeof(struct drm_connector *)), GFP_KERNEL);
+	radeon_crtc = kzalloc(sizeof(*radeon_crtc), GFP_KERNEL);
 	if (radeon_crtc == NULL)
 		return;
 
@@ -709,12 +709,6 @@ static void radeon_crtc_init(struct drm_device *dev, int index)
 	dev->mode_config.cursor_width = radeon_crtc->max_cursor_width;
 	dev->mode_config.cursor_height = radeon_crtc->max_cursor_height;
 
-#if 0
-	radeon_crtc->mode_set.crtc = &radeon_crtc->base;
-	radeon_crtc->mode_set.connectors = (struct drm_connector **)(radeon_crtc + 1);
-	radeon_crtc->mode_set.num_connectors = 0;
-#endif
-
 	if (rdev->is_atom_bios && (ASIC_IS_AVIVO(rdev) || radeon_r4xx_atom))
 		radeon_atombios_init_crtc(dev, radeon_crtc);
 	else
-- 
2.43.0



