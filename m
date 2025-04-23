Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9FF1A23B0;
	Wed, 23 Apr 2025 14:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420255; cv=none; b=lpZ++cwxBKN8nxlxaGq6fJ/SkNaaaOghKtCozk0HwI8LWUO4BOITK20uF2abBHc8mVTqZunV5awFaZG0NucdBCZcCLuSAYzTa933dyqVOIw63tpuo0+Qekvdn5h11YnW8qqiWoPhvCs9kGByaIoAsra+lt/JaWBPloP90/4N4jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420255; c=relaxed/simple;
	bh=dPic0aBFEPifqzB3rcJEG7amT6fgbhjLneFMG8v+qWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9TLvLSAml1EG1I8gSAi9et5Io88ypsi700jds2byrjHaMvaOgk1PReNkuM+pY/Wmo8wobwnbAwmRZA5N65+/W5BRoduEhxI9A1u6lSb0KY7rRan3sU0rIcnMS1MFEyRypFJT/4sM6+2svnElSb8ZN3t9ezRe5kHFnLQ3o0+o9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EXiR75Oj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EXiR75Oj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F781C4CEE2;
	Wed, 23 Apr 2025 14:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420255;
	bh=dPic0aBFEPifqzB3rcJEG7amT6fgbhjLneFMG8v+qWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EXiR75OjxHTBPd8ozwodfga7T86ihTZxOVpRtssnj7rjfGNFAfB5x2+VMlZn8bGw1
	 5Eh6azUVZcOdnO29grPvb4zQB1+WjvvDkkRbyuXjWoOmcO9oxxfl8E0HCThy5sU4Kf
	 F3avOJHaSZZ3hQn0RDWklucxs5Aj6NaO8Sw2NHBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/291] ASoC: fsl_audmix: register card device depends on dais property
Date: Wed, 23 Apr 2025 16:40:20 +0200
Message-ID: <20250423142625.669233446@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 294a60e5e9830045c161181286d44ce669f88833 ]

In order to make the audmix device linked by audio graph card, make
'dais' property to be optional.

If 'dais' property exists, then register the imx-audmix card driver.
otherwise, it should be linked by audio graph card.

Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20250226100508.2352568-5-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_audmix.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/sound/soc/fsl/fsl_audmix.c b/sound/soc/fsl/fsl_audmix.c
index 672148dd4b234..acb499a5043c8 100644
--- a/sound/soc/fsl/fsl_audmix.c
+++ b/sound/soc/fsl/fsl_audmix.c
@@ -492,11 +492,17 @@ static int fsl_audmix_probe(struct platform_device *pdev)
 		goto err_disable_pm;
 	}
 
-	priv->pdev = platform_device_register_data(dev, "imx-audmix", 0, NULL, 0);
-	if (IS_ERR(priv->pdev)) {
-		ret = PTR_ERR(priv->pdev);
-		dev_err(dev, "failed to register platform: %d\n", ret);
-		goto err_disable_pm;
+	/*
+	 * If dais property exist, then register the imx-audmix card driver.
+	 * otherwise, it should be linked by audio graph card.
+	 */
+	if (of_find_property(pdev->dev.of_node, "dais", NULL)) {
+		priv->pdev = platform_device_register_data(dev, "imx-audmix", 0, NULL, 0);
+		if (IS_ERR(priv->pdev)) {
+			ret = PTR_ERR(priv->pdev);
+			dev_err(dev, "failed to register platform: %d\n", ret);
+			goto err_disable_pm;
+		}
 	}
 
 	return 0;
-- 
2.39.5



