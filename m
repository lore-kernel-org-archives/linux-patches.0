Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D34614462B;
	Tue, 23 Jan 2024 00:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969547; cv=none; b=IXKcYpfmvUiEBgBqTEHH2CWdVnbgRVdxcPbaB3dQjOAeHviD0Vdf1i5/Ya0ChQmPkXXlFEZxpW6sIAcCgm6bvzmi4SUGkjZhqjgeiMyiKOJt2OO+NJuF+KJy+NfzHhW112yHYo7vI5hAr2e6KvQBDR/JoSDJ46P2/0f6dAYbNf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969547; c=relaxed/simple;
	bh=myIKsyB7GbanUc4mZAsIgHSnMEvMclo7PWP8bCjzIZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YWNN8pKAsvUWln/FCa7rQRsDET11CUgpOXOt/2OCOOebu+f3/2/Owxk0eQK13EjPAJrAWCugaH9uMMgUyogHZjJ4lV/FjH8HO+TJTbXU9obAzlj/OJt3sNN+PesKdBgCLVqJVD8k5btzakPcu0RkDEKHhPKabUgJTUu/GQwyOkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QI3wwE69; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QI3wwE69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41687C43394;
	Tue, 23 Jan 2024 00:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969547;
	bh=myIKsyB7GbanUc4mZAsIgHSnMEvMclo7PWP8bCjzIZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QI3wwE69P2qWAgMMnYPlVOMtjEbA5VQFMvYI8OUXGWUqomJU6zaJbIcpUT530qTqM
	 Pv1fmhcJKQZJocBtOTZ3ZpYoV35zIijHMn3Vgy3DVZQGfcqorvGfw7JIqCs2612sYX
	 Jkv/xfhMC/CKsdwxqUO1CvzBgQnlQH1HgOfgim8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 294/641] drm/radeon: check the alloc_workqueue return value in radeon_crtc_init()
Date: Mon, 22 Jan 2024 15:53:18 -0800
Message-ID: <20240122235827.093171571@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 901e75ec70ff..efd18c8d84c8 100644
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



