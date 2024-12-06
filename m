Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A38E148832;
	Fri,  6 Dec 2024 15:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497935; cv=none; b=QWRjRe5fhxFA1VHo2JqURPzG1TWVLkswRs8rnmbxx3wLsDJOwZ7AeLCs5N45YCtuodWS1EJQkrLtD6pvI1pSYsJ5k61Da0bfJxpzwHLw9w/dVvyeK8pdtfNxpvaOsTHokAVPi6qs0jKlNfGsleJ4GBDucsP+0DNzoelFpbGTyWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497935; c=relaxed/simple;
	bh=WQ5UtkYHfHRpJy/eiINNH5cGdeC9X2d1msWLW7KpIuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dtXxzEEr9ivlBz912QCcaPrIp/F3tLu0A6SSoLiUIcKklH3ozZFN4p2TY7xazYgLacLNoX7LQwFGEAcb9mIbimkx6+rvIAPPynX3trBGINax9T7KtIahN+dc1pDOqbLJXos2ebafFFON98KRiUCCbHrAtnNiKQ5+y4CMdiSFewE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RAcfsyXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RAcfsyXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D49DC4CED1;
	Fri,  6 Dec 2024 15:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497935;
	bh=WQ5UtkYHfHRpJy/eiINNH5cGdeC9X2d1msWLW7KpIuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RAcfsyXFCJHfsgHJbMXtnqPVxwaRCm6QDYIJOt7r6S1I7TrTnNTKmke0gIOeif6P1
	 i1c+O5kFZK17JYB9N+vpcTJXufMvWBgMqZmdHQ7FklRTkdIU3Dh+pzNBvkkhBWxZa6
	 znCuhZcoE/5OSt34SgLlTJmoMBI/8pIaB6qtrep4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Wu Hoi Pok <wuhoipok@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 436/676] drm/radeon: add helper rdev_to_drm(rdev)
Date: Fri,  6 Dec 2024 15:34:15 +0100
Message-ID: <20241206143710.372115412@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wu Hoi Pok <wuhoipok@gmail.com>

[ Upstream commit a6e23bec8ed184ed2a11080b28cdbd7a3024f0c0 ]

Add helper rdev_to_drm(rdev), similar to amdgpu, most function should
access the "drm_device" with "rdev_to_drm(rdev)" instead, where amdgpu has
"adev_to_drm(adev)". It also makes changing from "*drm_device" to "drm_device"
in "radeon_devicce" later on easier.

Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Tested-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Wu Hoi Pok <wuhoipok@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 7037bb04265e ("drm/radeon: Fix spurious unplug event on radeon HDMI")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 426a49851e349..e0a02b357ce72 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -2478,6 +2478,11 @@ void r100_io_wreg(struct radeon_device *rdev, u32 reg, u32 v);
 u32 cik_mm_rdoorbell(struct radeon_device *rdev, u32 index);
 void cik_mm_wdoorbell(struct radeon_device *rdev, u32 index, u32 v);
 
+static inline struct drm_device *rdev_to_drm(struct radeon_device *rdev)
+{
+	return rdev->ddev;
+}
+
 /*
  * Cast helper
  */
-- 
2.43.0



