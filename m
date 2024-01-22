Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A78129A82;
	Tue, 23 Jan 2024 00:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968722; cv=none; b=a6ljcT0tVm0dG4HoaZVQBPgPLkROAyZX/CN2xPtLO6WMZs2vEA7cfjnYkx/jTH9/HOX9KALrPClzG5E8q2/aSoEuA/H5GEogy5b4C59m+U+vr1PtcHgvKh07kS2lFJ/F3UQMEIOJCrylOptEg691vBFga4VCjxviph1kYGOa7dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968722; c=relaxed/simple;
	bh=RTvpjYxJ9JnIgVxf0tjltYBk7/Cshe3lqaGf6zrLkz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihmf/cXL7AbFNCUOopaVKYeVuadURHofAiQbBEspDuTwb/CnMIYNUAVuySnhpdeXgnzyk9ylF9IWRnD+y9ANkFV7TJfklbul9U9x+3cjyqIcpUnanc5ZrEr9j4vW6Im6x4Jej7dEVkpXDmN0cWGcs7ow5Bf2UzFie7vcO35Dsco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=baLSwo/8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="baLSwo/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059C2C433C7;
	Tue, 23 Jan 2024 00:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968722;
	bh=RTvpjYxJ9JnIgVxf0tjltYBk7/Cshe3lqaGf6zrLkz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=baLSwo/8n57kFMWsotDSA7G3IAowWqA2B6s2iLv9+35tPRR1RTKNnBfT+sD6zQL9q
	 cRjPH1LNt8LKocBMLeKwuZGctaNwdceK0H83MPWm1YNIZDGXmLFbWWGh0bw8xaD5sd
	 lT8GyRWhbMGo1lUBBHNs5bGnSgq5Cn7YuRdliKaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Yang <xiangyang3@huawei.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 014/194] drm/exynos: fix a potential error pointer dereference
Date: Mon, 22 Jan 2024 15:55:44 -0800
Message-ID: <20240122235719.818508566@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 0073a2b3b80a..93b2af4936d0 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -1850,6 +1850,8 @@ static int hdmi_bind(struct device *dev, struct device *master, void *data)
 		return ret;
 
 	crtc = exynos_drm_crtc_get_by_type(drm_dev, EXYNOS_DISPLAY_TYPE_HDMI);
+	if (IS_ERR(crtc))
+		return PTR_ERR(crtc);
 	crtc->pipe_clk = &hdata->phy_clk;
 
 	ret = hdmi_create_connector(encoder);
-- 
2.43.0



