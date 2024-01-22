Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C301339A7;
	Tue, 23 Jan 2024 01:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972112; cv=none; b=LltOHFyTr5HTciCirvewS3KNCoKBrn4MheFLBRkuxZIFdLNDn8QZHNn5diVWlJnbZgoylu7tKDsLxEbrpkPFBQ8NxGSXYIgoN+OblCkacYkSyV9BdXrd8z0PfDmm0VQQRxl2A/57CBxOTcFC8KGuAm8ORHJoGIi/DadLaaKxjaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972112; c=relaxed/simple;
	bh=uOQEL5cmTZHhfPeSrfGTcuDG+Rn17VyjOkSsFwYrlPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJuGCYp0lwhnov3x/M4JLgFzcMfg91zPSeOgQoLNoTO76yrAcbTnRzAAqztsjpwah9NPaOU3slhUK2el17mlcCoEBkoRK0e0Vn9F3dN0x2p5OGzESVR3Ya9eOzRVR15pJb4ikQPMUXClCj79og/fT0qJMr0Eii7j4yMdoM4q67s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s9D/N7tI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s9D/N7tI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A850AC433C7;
	Tue, 23 Jan 2024 01:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972111;
	bh=uOQEL5cmTZHhfPeSrfGTcuDG+Rn17VyjOkSsFwYrlPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s9D/N7tI0kFSWCIWK0TbNYDmP+r1ujQwiy8xoYUs6k1+p9zU+OyySJLY4noJNW1Im
	 MqbX7uYfIqvP4ttt7S6tdNmEYloKLd/7ycosuxidFtvA2QjVLSy2lU6ZDY7WGypvJq
	 wD0PLzkK/OpiIlR3oIq/kxSq1d00Yfsk2Z8WGU9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Yang <xiangyang3@huawei.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/374] drm/exynos: fix a potential error pointer dereference
Date: Mon, 22 Jan 2024 15:54:38 -0800
Message-ID: <20240122235745.404645862@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7655142a4651..42b6b001405a 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -1861,6 +1861,8 @@ static int hdmi_bind(struct device *dev, struct device *master, void *data)
 		return ret;
 
 	crtc = exynos_drm_crtc_get_by_type(drm_dev, EXYNOS_DISPLAY_TYPE_HDMI);
+	if (IS_ERR(crtc))
+		return PTR_ERR(crtc);
 	crtc->pipe_clk = &hdata->phy_clk;
 
 	ret = hdmi_create_connector(encoder);
-- 
2.43.0



