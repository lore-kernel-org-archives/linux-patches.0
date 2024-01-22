Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA3F53A1;
	Tue, 23 Jan 2024 00:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970802; cv=none; b=HgeHGMWw7JUDfl5bWqH30oUSjCpO1qgUtDpVKPoYrtAdgGhl6fx/HMRkMabmhu/HQkD9J17Wvpk98mG70ik05JAhSs0Lusbm53FpK09a2WIT184YQnmpR/mav/T46pBPoahksUVXtO/dhpV2NWgxk3It6QvfFb7XudnuEuM0Un4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970802; c=relaxed/simple;
	bh=WzjlJLwpwRC/LlUXZ6pzsBhDeTo5RY5giUXilNHTM1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5oUaAo+m9THmawAmfGur9+aFQA5vNnDimG3MjWj4C0DQAkYcK6MaLQYi3TTryIJF9YyXsrYbjIk4pGn94g23x+TVvJ+Osg4Zn+8dssy6gv160V+ueh+S6e8wgNlCcnLKBwuKH8AOY4eBNudmVp7OPXzuZTMDI3GGhfJZJWQUIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VqsSDPou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VqsSDPou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F443C433F1;
	Tue, 23 Jan 2024 00:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970802;
	bh=WzjlJLwpwRC/LlUXZ6pzsBhDeTo5RY5giUXilNHTM1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VqsSDPouxj2PIVSbbcjNLmDtffl2uvyPnkNwFRpGJX0Q0EDMa23uXfTd26xsV1Klj
	 /HXbCURF7hYoxYvf0L71C9xvPI9q//dKkRUrBQQ1FH2TLk2+UbvXfQFXh44YfefNOB
	 UYUrH6nmpE5ZjCKidpFhbKLLVhR8/hHd5SXCxYBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Yang <xiangyang3@huawei.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/286] drm/exynos: fix a potential error pointer dereference
Date: Mon, 22 Jan 2024 15:55:25 -0800
Message-ID: <20240122235732.771641654@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index dc01c188c0e0..981bffacda24 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -1849,6 +1849,8 @@ static int hdmi_bind(struct device *dev, struct device *master, void *data)
 		return ret;
 
 	crtc = exynos_drm_crtc_get_by_type(drm_dev, EXYNOS_DISPLAY_TYPE_HDMI);
+	if (IS_ERR(crtc))
+		return PTR_ERR(crtc);
 	crtc->pipe_clk = &hdata->phy_clk;
 
 	ret = hdmi_create_connector(encoder);
-- 
2.43.0



