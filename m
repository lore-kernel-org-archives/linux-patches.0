Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AAF317152;
	Mon, 13 Apr 2026 16:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099215; cv=none; b=Pqd5qHMyDavb5BOqw5Jus9mqIuYwL8I4t6ENTVrXfzSkQUXQG1FmrSvTTRfipCwpspj8AJxH7pWTZi+ZoLSxRyHJs6jSQvaqDlfIO7mDICncNM47UugxMd/mnSIEgNoPZj0L2KIX1AuUDsA2MFroiBjq4kNuKUebIc2gCVBE+m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099215; c=relaxed/simple;
	bh=kCnbIt9u7LfJgAiLHfez8Yq7bTEhlyjfi/GyGt7eY+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbx2i3VmLN6wBGC4syoXlldmq8MO2n1c389VoDK7wQy9Zc6+jYOer1r6niFaFe0Ll+CODqp0FQvaNcM1kj33bNEa+f9IJU458byNI0r6Bk2Jl7OD/d6PyL5a3Zy9gY6A2l+woaI0PnZ7rcFK8btIWcdVU7Xxx2J2KZHgdyQs/oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sF6wiAey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sF6wiAey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1C3C2BCB3;
	Mon, 13 Apr 2026 16:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099214;
	bh=kCnbIt9u7LfJgAiLHfez8Yq7bTEhlyjfi/GyGt7eY+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sF6wiAeyju4UDoZAtw6/bVeFM1s+CQDbV/5Dct/ce0rdr79dda27F+sY0a9GAq4Y9
	 SZNZY2xSyNNvV9huO5BHEFhOUDnsCld1ZbMhMi8J4ccjilct6x8cJN/gGZfX6IxM06
	 vxmDo9A8pqRVOdMn1EsdqDofqunl8Lps3+R+pzDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Leonardo Scorcia <l.scorcia@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 255/491] pinctrl: mediatek: common: Fix probe failure for devices without EINT
Date: Mon, 13 Apr 2026 17:58:20 +0200
Message-ID: <20260413155828.599734765@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 730581d130649..8045475583186 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
@@ -1111,9 +1111,12 @@ int mtk_pctrl_init(struct platform_device *pdev,
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



