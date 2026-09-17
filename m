Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6946550B40B;
	Thu, 17 Sep 2026 18:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668046; cv=none; b=IdqdMZwDeTOSgvAdv+o20jqzKvJ3YPBI3vnHh/g/TpTorq1je8mTQoAJZ/hrz4m3ajpS68+eGPhbjkeZm1A+9cT1QP+jSJgBInKbbEgLHP2gqwRuIajFxDMTOvYzsk1a/FsH63CBaFHV4Yx4u/BsM6ZoPHaMrGnUFCYzhIlUUaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668046; c=relaxed/simple;
	bh=dgGV8nCR6XR1ktCTj4EFrWsIq521ry9PXwU3h4Gdkpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BU3VOPQFzfcj+y8z6mlRrKmdoRn+wNVV8BuUaiAzVEW/mmmWGodFUe/MQWbCzz4ZhI0mVu5tBi/qCxyFVklBny37F0qmHzfwQlIDi8pVQGzTjM6taBUhXp4tuucXlp2ndsEQ+SpANaPxT+5vKMxFtjTakOy5WOP36jMA4pX2w4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ubfppzaK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ubfppzaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C075F1F000FF;
	Thu, 17 Sep 2026 18:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668045;
	bh=RiK9zNye6QWM81vBFLy+rEYOjsT/9NLOG5c+xKMSFvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ubfppzaKKwXJSs4j1JGNr2W4CmP0vqK6YSkpnsxzxPAd2MaJv68KUQS2+ksNgRYDp
	 o3eCLO2IoGPKmy9ZIpEK2GBURvpTh2+ynYQcAid0q6YST/0eWQ81RCCN43XKLRpvIx
	 FJW2LBO7kz7bEiILh0/Nc6iq9rMZCCIbwW3TM4QI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0296/1102] ASoC: rockchip: rockchip_pdm: Reorder clock enable sequence
Date: Thu, 17 Sep 2026 16:03:59 +0100
Message-ID: <20260917151547.047986849@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 3168721d6ec3b610edf6a3c22ad190722a27d276 ]

Enable the 'hclk' bus clock before the 'clk' controller clock during
runtime resume.
The bus clock provides the register access interface, so enable it before
the controller clock. This also makes the resume sequence the reverse of
the suspend sequence, which keeps the clock ordering consistent.

Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260602101608.45137-4-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_pdm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/rockchip/rockchip_pdm.c b/sound/soc/rockchip/rockchip_pdm.c
index 1549800887416..ff70982e2af76 100644
--- a/sound/soc/rockchip/rockchip_pdm.c
+++ b/sound/soc/rockchip/rockchip_pdm.c
@@ -426,16 +426,16 @@ static int rockchip_pdm_runtime_resume(struct device *dev)
 	struct rk_pdm_dev *pdm = dev_get_drvdata(dev);
 	int ret;
 
-	ret = clk_prepare_enable(pdm->clk);
+	ret = clk_prepare_enable(pdm->hclk);
 	if (ret) {
-		dev_err(pdm->dev, "clock enable failed %d\n", ret);
+		dev_err(pdm->dev, "hclock enable failed %d\n", ret);
 		return ret;
 	}
 
-	ret = clk_prepare_enable(pdm->hclk);
+	ret = clk_prepare_enable(pdm->clk);
 	if (ret) {
-		clk_disable_unprepare(pdm->clk);
-		dev_err(pdm->dev, "hclock enable failed %d\n", ret);
+		clk_disable_unprepare(pdm->hclk);
+		dev_err(pdm->dev, "clock enable failed %d\n", ret);
 		return ret;
 	}
 
-- 
2.53.0



