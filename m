Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCD618DF83;
	Mon, 28 Oct 2024 06:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098493; cv=none; b=WxfnAv8i1kTlPsHmoRvk5aR2g8vurdLDHU2271Is0z+hfSXqrYSB83PEY36FFoPLkMu27z/tM3yL0NZjwU0FwewCFOTGPYBxsNA8JJN8I9VqMbpNi+Iih/Q+ParaJRe/ndqgQ53PHZjjq0Mp/jXuAQZF/cjmHW66oFzgyGJ6dRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098493; c=relaxed/simple;
	bh=b2/UDEj22HUZEz9Uv5tqnCj7+WyZxNcVdPcnfPOkzLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tXCIyd6d95WJRDIJgq8zuYS7JZYPv0kcDHO37AFgVoRNshy1z9fwfpBG+iJeB0d1wTjG2VvQC+j2wab7YOtVkZVN2X+0xpyfS/VR/gFO9WwkzdxZH4Airw5Msw69iVmqcFqQUzmHqZKUxGy0Y0AdEBsqB8LEW3thoYr7qMGbeik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KkkKm4px; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KkkKm4px"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C854C4CEC3;
	Mon, 28 Oct 2024 06:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098493;
	bh=b2/UDEj22HUZEz9Uv5tqnCj7+WyZxNcVdPcnfPOkzLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KkkKm4pxB1Jq4GbjE1u8iD4ClTlUrMEMrLRBd2orzc8nXkAA/XhqsTgSeOfe6Fbaf
	 atKjNHfvksvpAbunZZIck7Y3Uo6oT2DOfms6363ED7xLOMZffM2OHolwXaO6SauZh/
	 lHJMRHBdkbpCJfrBVDmI6rQTwWLjUtVDgNuc5x2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.11 250/261] ASoC: qcom: Fix NULL Dereference in asoc_qcom_lpass_cpu_platform_probe()
Date: Mon, 28 Oct 2024 07:26:32 +0100
Message-ID: <20241028062318.377017942@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1242,6 +1242,8 @@ int asoc_qcom_lpass_cpu_platform_probe(s
 	/* Allocation for i2sctl regmap fields */
 	drvdata->i2sctl = devm_kzalloc(&pdev->dev, sizeof(struct lpaif_i2sctl),
 					GFP_KERNEL);
+	if (!drvdata->i2sctl)
+		return -ENOMEM;
 
 	/* Initialize bitfields for dai I2SCTL register */
 	ret = lpass_cpu_init_i2sctl_bitfields(dev, drvdata->i2sctl,


