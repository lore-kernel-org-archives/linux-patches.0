Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529733446CA;
	Wed,  8 Apr 2026 18:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671696; cv=none; b=SrfWt6HY97/u2sYNAWEfto/i+xD3E5CIwG4wx3V//os40Z+4xv7cSY4pc5FLD+epjrNUOy9Z5Th2zC1oO5T7xnEcDar8oZA14V0YPcVnM+B0GG6nsyZ1EIdOMX9UKz4a/HIUUXU3Ac2D3XZRtES+FJ+rGoX1e4jFjP0wHToI5kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671696; c=relaxed/simple;
	bh=umjxvQZ2QvgGBgZ3SBYae+j64kbfrelxro4EviO3RII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKc5ha9HRY+Fhg2H5XfOZqotar5XM60uaRt31unFPQlQB35PO0FVDqPYst0eE11alnCT19gj1HkjxNRGiDqfd5dlp6WO96TbE4Px8wG5yPwnYsC/+goNTEPQGtvjeuByPt7zTQYA+3JJhMdtFsK3Pq1dfNWm9w6G3NzHSKkT1y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RckBaNPC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RckBaNPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8AEC19421;
	Wed,  8 Apr 2026 18:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671696;
	bh=umjxvQZ2QvgGBgZ3SBYae+j64kbfrelxro4EviO3RII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RckBaNPCRkN0saja06WOSQgBwlBe0dTgwOU2qK87qRrzS+wXNy7MJQeIZndf5wSiV
	 RUef9kSi3KV7dKASbF4ODW+z9s22ZmHBO6DMYbeSpIGvs8p3re3ciDOKxueHQAN2A3
	 EvHLIcd66fvZeMa3u2i5oRXWnPkTyDkWBANZFrMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Leonardo Scorcia <l.scorcia@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/312] pinctrl: mediatek: common: Fix probe failure for devices without EINT
Date: Wed,  8 Apr 2026 19:59:10 +0200
Message-ID: <20260408175934.965480729@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f25b3e09386bc..096213d618839 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
@@ -1127,9 +1127,12 @@ int mtk_pctrl_init(struct platform_device *pdev,
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



