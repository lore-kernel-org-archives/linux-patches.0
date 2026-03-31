Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417F830E0DC;
	Tue, 31 Mar 2026 16:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974413; cv=none; b=DNkc8Ka/SLHIVIDh4Upo4tKz57n7NF0jhB3PekjrMznQMwMoS6U4Xs0HvppzojnFJmLIDVrnxfhjYrQWnOZyRa/QOpxSxglbkZ/w2ykF6uO3Uw8HNBIeXgFcbM31IrHt4jAy+bt1n1aoZPGUjLD39teGohxaa4dBQG8hK/wezu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974413; c=relaxed/simple;
	bh=jEOtWODDj0eimGVtCsjcOYJedYf228cQPCL5844q6/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4T3bb1VRDS+rJdR8hwatVJXRU00nlzeOYBqPsqSvxWtMenxfv8OtMP7p38QTph226i0FkL/RdL5kyNyER4PaVxEtiaL+N3DiUH3ko1uRmTtu7MKs9Csh+LcanCNcZPUlrAvfPg3PB+oixhf1UE4cx9Tys+DJ8adt3RQLzg9MA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cwsRW49/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cwsRW49/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B8CC19424;
	Tue, 31 Mar 2026 16:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974412;
	bh=jEOtWODDj0eimGVtCsjcOYJedYf228cQPCL5844q6/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cwsRW49/JYRouDaikzD/ik3S92T1jrOEKDJ+k3HgrU6YuHsc19tAcFlhsY1JhuHQe
	 aHZsoZj4K4sWhHtU2oy/5t7Ga10E2RaaukG3cD4wVdYfnPcVSqbKtLNAQNhHlByXqz
	 O3r+KdwxNonv2f1oVkbt9I3oWxMxWFb+EZIGWw1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Leonardo Scorcia <l.scorcia@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/175] pinctrl: mediatek: common: Fix probe failure for devices without EINT
Date: Tue, 31 Mar 2026 18:20:27 +0200
Message-ID: <20260331161731.368170284@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 74b15952b742e..7066fab7621e9 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
@@ -1133,9 +1133,12 @@ int mtk_pctrl_init(struct platform_device *pdev,
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



