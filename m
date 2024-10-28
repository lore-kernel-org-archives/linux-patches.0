Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F2B15B10D;
	Mon, 28 Oct 2024 06:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097449; cv=none; b=A7gcxK0l5NtypEUU9zhuApgyj75r1n9y8NlZSS/trs8x3jNJUQkxqe3FRcXsQeYiaSyQmlBkEJBsVtK/TGE/EwcblUJKuJFQ1joWbh/DAMD96hZC+ROCdzbSQGP1jht3+5KcNVN5kyzeD3DzGcK5/o9QAsnsJkF8rlJ2ZORihcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097449; c=relaxed/simple;
	bh=k9cEccWXsKDg3cxjVZvEQECl07FchFIofOnzMsp4BNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXV0nJji1E2lpfPrHBHB2RE/VeZe0n6GjllZ+UeW7KSNtqklzfy9mvXcYdmDiWhpT469tGKK6XrvKFZPG6yG2eR/CD2W9Mp7vBhZJ9cWZuWlMP83ZxQ8pZj47SpAhBFkT9ck44ck+SPRav+gI1zAEwnlc1R/3MuXAiL/PrnIncw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2lciAVMM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lciAVMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17262C4CEC3;
	Mon, 28 Oct 2024 06:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097449;
	bh=k9cEccWXsKDg3cxjVZvEQECl07FchFIofOnzMsp4BNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2lciAVMMlOq2cOvg+wlbRad+ggZveSYYkIEc+PQGzsFS3maJePE3c7bTop266uR6e
	 tpxLeyWzNOq3suHN7nFBfBZa8GSqZEJLys9rJoay3FzY7wUpeB4DHPMWnai/unK2Wg
	 cKAvzhXurHOTSlsq5qNGynXP9UHpwcx298PF4pIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 134/137] ASoC: qcom: Fix NULL Dereference in asoc_qcom_lpass_cpu_platform_probe()
Date: Mon, 28 Oct 2024 07:26:11 +0100
Message-ID: <20241028062302.446492638@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1236,6 +1236,8 @@ int asoc_qcom_lpass_cpu_platform_probe(s
 	/* Allocation for i2sctl regmap fields */
 	drvdata->i2sctl = devm_kzalloc(&pdev->dev, sizeof(struct lpaif_i2sctl),
 					GFP_KERNEL);
+	if (!drvdata->i2sctl)
+		return -ENOMEM;
 
 	/* Initialize bitfields for dai I2SCTL register */
 	ret = lpass_cpu_init_i2sctl_bitfields(dev, drvdata->i2sctl,


