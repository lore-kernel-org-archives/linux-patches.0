Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1E7265626;
	Tue,  8 Apr 2025 11:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113553; cv=none; b=mQ70WmQ9uWivR027xHYwDpqmAf0CGWhfot2kx9PqP6dlGfFgr323iu6OfHm+E+4eMsOrrrAo+pxpTTJsZDmLjWE1DCwAUQ7SMyxvSEw2yRuFmlA9z5dYAKQEOzH6hbiOLJoqNBGlkO0Ktm7C4qa7XrKCHReRTGpIlLi4EKAvwwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113553; c=relaxed/simple;
	bh=Lsvbxw6YbNBOdoWgDRkHo2mvBLxm6d7/F2WjO/WqpIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2lflTZvdJDBuMvyaBgt2Fn8XUft0XSM6+oAMrD5RBQWcHb+LQeic5HmnY3M40NcjJPydJKWfmuKondE6vVFF2SK0CfiCIAgd/ZoOpByCOH7x1LUF/G+CkaPR5UtNcrnDcnQQ8/6h/4NlCUDYA1yC11nBOT/vjb2Tk0TksRm1Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJNSjvDn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJNSjvDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDEAC4CEE5;
	Tue,  8 Apr 2025 11:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113553;
	bh=Lsvbxw6YbNBOdoWgDRkHo2mvBLxm6d7/F2WjO/WqpIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJNSjvDnj8dntwONm7ON3pv6u+E45MCK1P4PiJDgN42uojvUVXrcGYKn62rx/NAXd
	 d8KUvicOPv6kPajmcCfs+9r9rjnrMKrmf3czbiPk/KE8l/4jjtdP5+zhEBwv1HBC7q
	 vGXXRyvKBx75LpUJfnotOu6tCZzOoM/NosJGl91M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 203/268] ASoC: imx-card: Add NULL check in imx_card_probe()
Date: Tue,  8 Apr 2025 12:50:14 +0200
Message-ID: <20250408104834.039802809@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f8144bf4c90d3..7128bcf3a743e 100644
--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -742,6 +742,8 @@ static int imx_card_probe(struct platform_device *pdev)
 				data->dapm_routes[i].sink =
 					devm_kasprintf(&pdev->dev, GFP_KERNEL, "%d %s",
 						       i + 1, "Playback");
+				if (!data->dapm_routes[i].sink)
+					return -ENOMEM;
 				data->dapm_routes[i].source = "CPU-Playback";
 			}
 		}
@@ -759,6 +761,8 @@ static int imx_card_probe(struct platform_device *pdev)
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



