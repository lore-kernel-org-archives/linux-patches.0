Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547A733F38A;
	Tue, 31 Mar 2026 16:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974928; cv=none; b=C+I7RrLq1I/kgqKl6+Z+lRX3s7rjuv9Ns5MrBhv929CdBv648EmgMRcmmHO0QwpOS8qJB+HgS9qY2+darpOITI+um5uUCvCuz8lAI5pk/gK/726dPpwAQ/qcePt4aohiuoK2eAgyG2Z1GHuVIA5r8EVR6mKG487TohayRA9KP1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974928; c=relaxed/simple;
	bh=8ok9zZXNfI/ukfF+4xMOhFleoIYse1rhiumM8DO8/XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVYGkSOXjtH3q3AYJ9VoqnJH9k29QqBOk3TkTSWCe+6lq2Ga1CSugoKkBxilSKVkfruaXBZ5up0BiTNd0tqjm12GvQIr2CUSfidHRbPNjs2EYr1p/+PyXfYdipMmP2CJPVOwT+2o7tGkc5B80V957QxOPyDX3kW4GKM/34ZdR+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqWp/exF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqWp/exF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC9CC2BCB1;
	Tue, 31 Mar 2026 16:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974928;
	bh=8ok9zZXNfI/ukfF+4xMOhFleoIYse1rhiumM8DO8/XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqWp/exFEO5PFYEekfHbp1kBmAlx+oZe792Evwq5GA32YT5WLjFM1DyM+y0b8Sj+W
	 Y5jVTerRY0isTgyM3dGGSIp6a0soTNHwOzLIy3GVb7lH3iQYVl6HiB2K+NQsAZysF9
	 EpsytJQeSV8uO99VFQWsxpQVbaP2LwRtbfGw3grs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Leonardo Scorcia <l.scorcia@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 099/342] pinctrl: mediatek: common: Fix probe failure for devices without EINT
Date: Tue, 31 Mar 2026 18:18:52 +0200
Message-ID: <20260331161802.659607585@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Leonardo Scorcia <l.scorcia@gmail.com>

[ Upstream commit 8f9f64c8f90dca07d3b9f1d7ce5d34ccd246c9dd ]

Some pinctrl devices like mt6397 or mt6392 don't support EINT at all, but
the mtk_eint_init function is always called and returns -ENODEV, which
then bubbles up and causes probe failure.

To address this only call mtk_eint_init if EINT pins are present.

Tested on Xiaomi Mi Smart Clock x04g (mt6392).

Fixes: e46df235b4e6 ("pinctrl: mediatek: refactor EINT related code for all MediaTek pinctrl can fit")
Signed-off-by: Luca Leonardo Scorcia <l.scorcia@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common.c b/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
index d6a46fe0cda89..3f518dce6d23f 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
@@ -1135,9 +1135,12 @@ int mtk_pctrl_init(struct platform_device *pdev,
 		goto chip_error;
 	}
 
-	ret = mtk_eint_init(pctl, pdev);
-	if (ret)
-		goto chip_error;
+	/* Only initialize EINT if we have EINT pins */
+	if (data->eint_hw.ap_num > 0) {
+		ret = mtk_eint_init(pctl, pdev);
+		if (ret)
+			goto chip_error;
+	}
 
 	return 0;
 
-- 
2.51.0



