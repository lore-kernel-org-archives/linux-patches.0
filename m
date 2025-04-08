Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5512226B2CF;
	Tue,  8 Apr 2025 12:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115925; cv=none; b=Q5z3g6/GOV+OhNKatDh/g1k1k6rFAWkICrnXijWElpYXlA3IuFlzPHUi/XZtkPEfnEYOXogXWzVbxYy0dr/39SUClbzLkVLF+a7DD7y65Vb5XS5ndJS5IeAKyaJusblJXUqQotMtrE8q2zn1d44qAdntrMqS7Psqgqido66o0O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115925; c=relaxed/simple;
	bh=qos0KurL1Q0VM/AlfoRlDpjs9JmcBSXk/Nx/oTsRmwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soeiRAMUNNkLPPx0Q14ZjDE6/RpIvlI1jr4wYCB9IT5LkhPZOSsd7EeiRmJ6FowDRt+rTpuqEiiv0LQqMqv9u1uIEgEVTBL82aqFlET5obhrYpFzBsfP4VX5pr55xO7/pGg2FJU3WdCYxZ/mIJOUlQd5uQyXee2FVXH0oi9SVrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2kiAihjT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2kiAihjT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF33C4CEE5;
	Tue,  8 Apr 2025 12:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115925;
	bh=qos0KurL1Q0VM/AlfoRlDpjs9JmcBSXk/Nx/oTsRmwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2kiAihjTJ8fg3636mr3sJKmg8MxDlhkTI0nNwpPwUnoCkNU9ZIY5+4a1wdSWH/sqj
	 FVR63MbkgJrjzPczS9quZ7M/KGV3C2LpZw2ZEd3M5lglVq0350yZKWo384nXmWekrQ
	 +8Sk0KV3TQdd/t9TJWcdN/QrykVvkFN3xnmUn3r8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 154/204] ASoC: imx-card: Add NULL check in imx_card_probe()
Date: Tue,  8 Apr 2025 12:51:24 +0200
Message-ID: <20250408104824.826858226@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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
index 9c1631c444229..c6d55b21f9496 100644
--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -759,6 +759,8 @@ static int imx_card_probe(struct platform_device *pdev)
 				data->dapm_routes[i].sink =
 					devm_kasprintf(&pdev->dev, GFP_KERNEL, "%d %s",
 						       i + 1, "Playback");
+				if (!data->dapm_routes[i].sink)
+					return -ENOMEM;
 				data->dapm_routes[i].source = "CPU-Playback";
 			}
 		}
@@ -776,6 +778,8 @@ static int imx_card_probe(struct platform_device *pdev)
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



