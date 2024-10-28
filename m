Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E531DFFD;
	Mon, 28 Oct 2024 06:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097909; cv=none; b=X0IRJvMn7oRLcOvVPPt/Eqc6roDiLVipCUpTSTnhLk6tKiP90XmwK8Fcu9Z4FnvHF36+7CeDoShclMMm2KvYsQ9gr3MEChebC8jtRfQgxn88m8yTS3aFWYtxqu4GfW58uEn2w+eFgJTjJagNDkWkP0iGgbhjv/2dkY2RhRFcljI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097909; c=relaxed/simple;
	bh=zq3l2T1JHwnFFvg35hMlsIrm7tTTG+QddcKqBC+qKcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kC24BmdevG1Ylftf5ogTNfMwSQpmtOiaJF+0TzAB8T5QMaAk4hPeUTrDSGfP163wdu7QOD7DCwqjQe6N5hdAzXmg5YJxVEgyzMFjVmjqGLBjDJSk1KZfXH424OXvJH7ig59FxvAEJAj69JxrTmT4ZmVerrxq8QfzeRT0e8bG8Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OpkiwmfJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OpkiwmfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D334FC4CEC3;
	Mon, 28 Oct 2024 06:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097909;
	bh=zq3l2T1JHwnFFvg35hMlsIrm7tTTG+QddcKqBC+qKcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OpkiwmfJniz/nq0XJZ8ZE0+41hBTWJR/+vK1mYA57MvfbOUje6TvMd9517YVgciyS
	 nigPOnRQj0AfK4OF80SoXZSlhj5lub8+0wEQeRa53O2biVjhbUvc3a8W3Pmi9LAWYg
	 L50vocoFA3yJ7bzhp9fh6VcArrZcOSA50k+xI0X0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 201/208] ASoC: qcom: Fix NULL Dereference in asoc_qcom_lpass_cpu_platform_probe()
Date: Mon, 28 Oct 2024 07:26:21 +0100
Message-ID: <20241028062311.593168129@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Zichen Xie <zichenxie0106@gmail.com>

commit 49da1463c9e3d2082276c3e0e2a8b65a88711cd2 upstream.

A devm_kzalloc() in asoc_qcom_lpass_cpu_platform_probe() could
possibly return NULL pointer. NULL Pointer Dereference may be
triggerred without addtional check.
Add a NULL check for the returned pointer.

Fixes: b5022a36d28f ("ASoC: qcom: lpass: Use regmap_field for i2sctl and dmactl registers")
Cc: stable@vger.kernel.org
Signed-off-by: Zichen Xie <zichenxie0106@gmail.com>
Link: https://patch.msgid.link/20241006205737.8829-1-zichenxie0106@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/lpass-cpu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -1246,6 +1246,8 @@ int asoc_qcom_lpass_cpu_platform_probe(s
 	/* Allocation for i2sctl regmap fields */
 	drvdata->i2sctl = devm_kzalloc(&pdev->dev, sizeof(struct lpaif_i2sctl),
 					GFP_KERNEL);
+	if (!drvdata->i2sctl)
+		return -ENOMEM;
 
 	/* Initialize bitfields for dai I2SCTL register */
 	ret = lpass_cpu_init_i2sctl_bitfields(dev, drvdata->i2sctl,


