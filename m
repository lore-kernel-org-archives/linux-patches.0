Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FDD374F5;
	Tue, 23 Jan 2024 00:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971127; cv=none; b=J1+NnBmJ2ebthxRapQvniqCIg8/f1kawUJhl2LcucabiZANGynBgp6W5IDB51CVWIF1IRrqQX1Lgoaz/LNeYuDRH2uezTuAoe66zk4MFN0+Lj4RYPhboIelIypw4O3+95wMXSGocP1rilREoS+QxZJITHjBZ1LVdo+LUAqeEGQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971127; c=relaxed/simple;
	bh=A4bgd8vL1eX/OHqT/gMzHee+TSJ6BgYjoBlmhWxlj4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8uRs+ycOpRe6S5Y2cvX2B6Zz9G47VpxoUC1jG9maWnbbqoSOFGgtRL1nG/+MP9yREM14VKFin+2TnfG5JW7OdiFzyfDrM1e9Pv0XqOv/lOo3Gt5vGQyvrNxWZPnrBeogBgnGSTrI1IBRqYVd3r76A/gmhy1KE4qO12xYusgvt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSZm+h78; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSZm+h78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5967FC433F1;
	Tue, 23 Jan 2024 00:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971127;
	bh=A4bgd8vL1eX/OHqT/gMzHee+TSJ6BgYjoBlmhWxlj4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSZm+h783m+kVXsHpT4szKxAwyKf5B+M/Nnp/T4k0U79gwLOOZYDwPXMqE9dvo8ji
	 2vFLz82h1cg4rDUF2AfAlbQjJoSEX2MtiQQTnuHVC6ca7e6iE1ga9KubLsW0HNQ9pB
	 ndAUXiNmsHRc8mU0DQNSzR295JwprAko/O6A6lkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 186/417] drm/radeon: check the alloc_workqueue return value in radeon_crtc_init()
Date: Mon, 22 Jan 2024 15:55:54 -0800
Message-ID: <20240122235758.336075206@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 7a2464fac80d42f6f8819fed97a553e9c2f43310 ]

check the alloc_workqueue return value in radeon_crtc_init()
to avoid null-ptr-deref.

Fixes: fa7f517cb26e ("drm/radeon: rework page flip handling v4")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_display.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index ca5598ae8bfc..1814bb8e14f1 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -687,11 +687,16 @@ static void radeon_crtc_init(struct drm_device *dev, int index)
 	if (radeon_crtc == NULL)
 		return;
 
+	radeon_crtc->flip_queue = alloc_workqueue("radeon-crtc", WQ_HIGHPRI, 0);
+	if (!radeon_crtc->flip_queue) {
+		kfree(radeon_crtc);
+		return;
+	}
+
 	drm_crtc_init(dev, &radeon_crtc->base, &radeon_crtc_funcs);
 
 	drm_mode_crtc_set_gamma_size(&radeon_crtc->base, 256);
 	radeon_crtc->crtc_id = index;
-	radeon_crtc->flip_queue = alloc_workqueue("radeon-crtc", WQ_HIGHPRI, 0);
 	rdev->mode_info.crtcs[index] = radeon_crtc;
 
 	if (rdev->family >= CHIP_BONAIRE) {
-- 
2.43.0



