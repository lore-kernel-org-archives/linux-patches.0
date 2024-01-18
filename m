Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E9F22F0F;
	Thu, 18 Jan 2024 11:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575679; cv=none; b=GRPxv9pjOSIo68+e2pxEJFpMukpf0t5aGNugBKLvim85faNW4ck7HsubvbGlqDTRXO+0S9gv5vmB2WR5Bf/j6i/5VWLLLmHJLqc85h04ByLHjFsb1JJaKJ+1r1PzdK2GW2eEwF3LLnRX6iVxBcnDIkyuVhzhDSTlk7jCrPXs+0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575679; c=relaxed/simple;
	bh=eP+U79DrjpwWWmvrqzuzs87H9FJ06irBTGvXj+UxJw8=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=ObcEvs+EWKoi/WxeRwqzDGSNlJCxLViPWBWTTLPtvsUUMWeFEhE+3caIafaJ3FM7O/3glCo0lTzQWBugUsuUMeJAH6OnXtu6PnN7qLnWuD7vCtFNfVziUTXBnjAwFgwzYQTXJ3vssQaMaN7BKpwjF4R5dGXxn/3eJ8I/IQTmNy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nE89q4Vq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nE89q4Vq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7AF4C433F1;
	Thu, 18 Jan 2024 11:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575679;
	bh=eP+U79DrjpwWWmvrqzuzs87H9FJ06irBTGvXj+UxJw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nE89q4VqJnzgdItWLk/ID7Es8x1g1RSvU7xYVfd45IIwTYuU+kwYIFsRVJClVEpUJ
	 pWds30SJGuMOlziu52Zvrd/pPnwK1ZccmKA+Hw/+7vIdAMaQD4Bdt8t+AccqygfU5V
	 1VvLpJS81HgKz+MPQFwwpWSqQ+qMF650brdFPoH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Yang <xiangyang3@huawei.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/100] drm/exynos: fix a potential error pointer dereference
Date: Thu, 18 Jan 2024 11:48:46 +0100
Message-ID: <20240118104312.571487242@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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
index b7c11bdce2c8..1a7194a653ae 100644
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



