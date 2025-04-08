Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E05269831;
	Tue,  8 Apr 2025 11:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111913; cv=none; b=gTlWqo7D460V5IZcvOtfkmcL6uyYEyuNAEtGPHaPdee5KcvdvE3/xS8Fs2mNOdwgZT+YecHBsz0fqoGdhtkwmeX5Lzsnfwd0ZSXr2pr86U3qOFyxhxB4KPCkM7kfp9g0bs8GAeiTfrKiTDt2eK/5VkbtI2bCsVTcbduS82saIzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111913; c=relaxed/simple;
	bh=eInXYwlS6qHl0eCHCKR/UPD80ssoQmDaCLnXDed4lhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVm/5xGt3j9R7XwK2qdIDyB3rhOlzPeuGAICnBkHcUAzrfbniOFkEAbpuCLtAQW+iCySTH/K7g8vyS8zFCYBM4tbmztx49ChOx24ESfkPJ0INCUIsVmTaIjQV83y/v47cEyEm8RkJIrxy+8I0krMqkXiSEY7yjpAz7Cc7JkDJyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q6p9/F8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q6p9/F8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A13C4CEE5;
	Tue,  8 Apr 2025 11:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111913;
	bh=eInXYwlS6qHl0eCHCKR/UPD80ssoQmDaCLnXDed4lhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q6p9/F8+371YeLHKXGPFtGKGfOYZB79C5RQ42ZwRdbyiSPZwjHYjPxBmAgElLzPow
	 IIT/1n5VzAvJqwn9FUOAZSvI7BxWOk1zt3Jj4sdH3RQJhLTxSeKf39m2qer8AEzTT7
	 PSNEzJnPT+FTEu9sYF7FXRRAcp7bW0tlGe+9hOs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 607/731] ASoC: imx-card: Add NULL check in imx_card_probe()
Date: Tue,  8 Apr 2025 12:48:24 +0200
Message-ID: <20250408104928.390526479@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 93d34608fd162f725172e780b1c60cc93a920719 ]

devm_kasprintf() returns NULL when memory allocation fails. Currently,
imx_card_probe() does not check for this case, which results in a NULL
pointer dereference.

Add NULL check after devm_kasprintf() to prevent this issue.

Fixes: aa736700f42f ("ASoC: imx-card: Add imx-card machine driver")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20250401142510.29900-1-bsdhenrymartin@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-card.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/fsl/imx-card.c b/sound/soc/fsl/imx-card.c
index ac043ad367ace..21f617f6f9fa8 100644
--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -767,6 +767,8 @@ static int imx_card_probe(struct platform_device *pdev)
 				data->dapm_routes[i].sink =
 					devm_kasprintf(&pdev->dev, GFP_KERNEL, "%d %s",
 						       i + 1, "Playback");
+				if (!data->dapm_routes[i].sink)
+					return -ENOMEM;
 				data->dapm_routes[i].source = "CPU-Playback";
 			}
 		}
@@ -784,6 +786,8 @@ static int imx_card_probe(struct platform_device *pdev)
 				data->dapm_routes[i].source =
 					devm_kasprintf(&pdev->dev, GFP_KERNEL, "%d %s",
 						       i + 1, "Capture");
+				if (!data->dapm_routes[i].source)
+					return -ENOMEM;
 				data->dapm_routes[i].sink = "CPU-Capture";
 			}
 		}
-- 
2.39.5



