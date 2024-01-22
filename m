Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9554141991;
	Tue, 23 Jan 2024 00:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968150; cv=none; b=L6FwVEMBxzu6MdLzujx5RU/6R/9KpvLrFXdLmzdvbGgho3jUn33Fpil07rpSASNrh35pdTFkEzRrkod9RPuyDbBBbjpM8u7nDwu0DcTzVuOW/FRuchfVo4xoCXHj0sX8tGSQTTygy4g7SaEpyYKExWjOMyrWebm2DFbaYPjw+IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968150; c=relaxed/simple;
	bh=K+H2XCfi+MmXuhoWRslqKs1+Jkvu6p4BqmNZiiL1iYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GSupPQCOiVfVx1t3d1sB/k+0qfMzRGGlYFXzWA3WqjBeskYa0QtjjDy5qtzFSixOUY7s34Un6G3AJRz+yl4TTCqSlyIRynieqHubToBX5s22MPCv3ycYQjbj45M+Sqrd7xqS7GypKRw0mAwyE2E2Cl+Fe5Kz6V7VKlUjJioNNlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7xoiR3S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7xoiR3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98F8C433F1;
	Tue, 23 Jan 2024 00:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968150;
	bh=K+H2XCfi+MmXuhoWRslqKs1+Jkvu6p4BqmNZiiL1iYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F7xoiR3S58n42VDKAGk0nwDH3PhjyN8qqg05g/VCzHW/ZIfiOCsFu3J6sUCxzUioP
	 AX4/KL3bSUqlq11a2HtuDviZHWKsTaG6FVl7FHaxxFMWOJKfYZB19bq38FyJ7sBfv9
	 o/8Aq8pe7r+hLn6Da/+hDIJnYTpVtkfi3wT/+dxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Yang <xiangyang3@huawei.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 008/148] drm/exynos: fix a potential error pointer dereference
Date: Mon, 22 Jan 2024 15:56:04 -0800
Message-ID: <20240122235712.764768527@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Yang <xiangyang3@huawei.com>

[ Upstream commit 73bf1c9ae6c054c53b8e84452c5e46f86dd28246 ]

Smatch reports the warning below:
drivers/gpu/drm/exynos/exynos_hdmi.c:1864 hdmi_bind()
error: 'crtc' dereferencing possible ERR_PTR()

The return value of exynos_drm_crtc_get_by_type maybe ERR_PTR(-ENODEV),
which can not be used directly. Fix this by checking the return value
before using it.

Signed-off-by: Xiang Yang <xiangyang3@huawei.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_hdmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index 2092a650df7d..551a97e45d97 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -1840,6 +1840,8 @@ static int hdmi_bind(struct device *dev, struct device *master, void *data)
 		return ret;
 
 	crtc = exynos_drm_crtc_get_by_type(drm_dev, EXYNOS_DISPLAY_TYPE_HDMI);
+	if (IS_ERR(crtc))
+		return PTR_ERR(crtc);
 	crtc->pipe_clk = &hdata->phy_clk;
 
 	ret = hdmi_create_connector(encoder);
-- 
2.43.0



