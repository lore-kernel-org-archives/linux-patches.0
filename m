Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303951774B;
	Thu, 18 Jan 2024 10:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575324; cv=none; b=NlJ7Af8N8/3adlpwF5lhrxZscdEsDuRgRk59gVUILtaH1KqIrNqym0UnFNIkW7riVupspP6f1ekwN26UmkG2YfLlitNs/AlUsM6vmswxTiWVlwvFRF4hlXExWJzvstLo38rlErC037FnxdXIMo5BscPU0lfyHW9js83YNC9xvV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575324; c=relaxed/simple;
	bh=ePDPhnBx7P+q6jP3Fu9RDcfDcSL9+0JBAj4dhYpzlMM=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=gjh3VEihPTZd3FF7TzcCrnsYX38S7uoEMX6l9+tZFyYeaNamztYv+ifk/lVkMnqaLVcdeK0Hgqgn3VayrhbOumwZkvN0VxaOW0Th0YVJbQ9svYEK3DiPFLmmb6qDLUG98/P2nuCevj3c6/NVxeObtyERCfuwcqAwof/gAgAGkDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQSf+1uu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQSf+1uu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8787C433C7;
	Thu, 18 Jan 2024 10:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575324;
	bh=ePDPhnBx7P+q6jP3Fu9RDcfDcSL9+0JBAj4dhYpzlMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQSf+1uu37TBM+CKxfjAIc7SWl1xEd7o0LWRCFl5ciZbkrLkdu09Ni+mOwxiQjMAg
	 XTh+7OzxmHwONnBTTQx9Pc6LdzS+KK/0Mp36Q6OPhPJTKlL+onwCMcFHxH8RPebNym
	 7R0grg0tjUcZJMKqn7Cd4trgyER15JvdT53tyS90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Yang <xiangyang3@huawei.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/150] drm/exynos: fix a potential error pointer dereference
Date: Thu, 18 Jan 2024 11:48:04 +0100
Message-ID: <20240118104322.853362117@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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
index f3aaa4ea3e68..dd9903eab563 100644
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



