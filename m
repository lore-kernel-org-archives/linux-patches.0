Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C4826A0CF;
	Tue,  8 Apr 2025 12:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116924; cv=none; b=FQvI/MMacp9M4i9uNW1Z7pzH1wDzqd3PLBJWfE0P7cHFaOYgjfMDWjA1N0t9umqH18ygXFtQAT7RonuB42wPnSlvEZ1T4DhHJ8pIJzaZT3HUOx0rRe61KaImeuzh7SAdlzloOn8nrs6hfeqJ+3a2aBb+l4XSOf53bvFFgaioqRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116924; c=relaxed/simple;
	bh=u8HnEp3o0zgGxRV1mKO/3ECqOVeA6/zZhXoO0cCtQtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEST4GvwYKDz5Bh9u3HWmXIJAU6xvB/gzjWos6mZP097W2MoWGBHTRWZ4gL9iWZMCMzIxn+CmyOcVMNlerlsjwNEXwG7xnjcPVHsk1u9ZvvjmxNHJs2NaB/5HXJErhRFrsW/2tq1/NUxGFjzvI7ou2ojvJN/IRagn35dJD/dFsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dmZ68Tuc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dmZ68Tuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7624C4CEE7;
	Tue,  8 Apr 2025 12:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116924;
	bh=u8HnEp3o0zgGxRV1mKO/3ECqOVeA6/zZhXoO0cCtQtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dmZ68Tuc+epgnXEdADhP1GPdyGNweNqmAI9wfDtiYrxzzL8vdIO3MPzg+54bLpKFK
	 nVbtz0YD/GXHimcX8D4mXt5EtbeKuq9IpM03hWjq7KjB1FxeVwgRLduDrO91sg+0yP
	 OZ9TpeBgknaSaaIHTdsUJFu1Lubjtt/ud4hsVoFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 320/423] ASoC: imx-card: Add NULL check in imx_card_probe()
Date: Tue,  8 Apr 2025 12:50:46 +0200
Message-ID: <20250408104853.267812985@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a7215bad64845..93dbe40008c00 100644
--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -738,6 +738,8 @@ static int imx_card_probe(struct platform_device *pdev)
 				data->dapm_routes[i].sink =
 					devm_kasprintf(&pdev->dev, GFP_KERNEL, "%d %s",
 						       i + 1, "Playback");
+				if (!data->dapm_routes[i].sink)
+					return -ENOMEM;
 				data->dapm_routes[i].source = "CPU-Playback";
 			}
 		}
@@ -755,6 +757,8 @@ static int imx_card_probe(struct platform_device *pdev)
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



