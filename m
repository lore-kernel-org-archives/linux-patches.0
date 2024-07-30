Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4DB1A6192;
	Tue, 30 Jul 2024 17:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359026; cv=none; b=iWm/5qcKp+X1Rt5uOj8lOFoChW02ul3g+FtoBcFaDw0op5lo3WHVuENYlNzSAHTjhhttPbMo/m/S4YcDCQFC7daIbIPIA1Zo+Tg7vvNbLYT1vogvnz0EmFCYUGnuG5TKT2Mmpu5H1nPgELLdOS7W6H7Q1RoFeHTD3f1ahHwJzjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359026; c=relaxed/simple;
	bh=llcJPjbQk+UzYwFg7hdAG5jM1UVEBFtmImOk4hY4yv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCDucEeXAfiauDxpjOVVAqNkS8I/dwamCdDOL0/N/1cZQ94eTKndxK8GAr6XTLbZfMPqkbuxwTpQwmSto5D1BAsitVRN5qDzCj3K3Dbj7/2FeNu3J3JJk3n+QLKmyL+gn3uOJalFNiXM2EompmynjdQQ/H4qboW7qK4T72BiBac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n3KA4X8p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n3KA4X8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B068C32782;
	Tue, 30 Jul 2024 17:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359026;
	bh=llcJPjbQk+UzYwFg7hdAG5jM1UVEBFtmImOk4hY4yv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n3KA4X8ph45kRFEbkcalYErNjLitbyokGYPOj+l5CNpBBCV3t9wv2uzdCi1+a77y0
	 YkCZTNiF1EuHtdRAeVfzrqq89/feWcSNjYpZxrdC4jjBGd+WJJvCqxguGH06Wc106W
	 7t5Q+8oggua6QlD7ZvTIQvNQDvghigon3UJyxcYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 423/809] ASoC: qcom: Adjust issues in case of DT error in asoc_qcom_lpass_cpu_platform_probe()
Date: Tue, 30 Jul 2024 17:44:59 +0200
Message-ID: <20240730151741.401980452@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit f9f7f29f64454bb20896c7d918c3abc3a1aa487b ]

If IORESOURCE_MEM "lpass-rxtx-cdc-dma-lpm" or "lpass-va-cdc-dma-lpm"
resources is not provided in Device Tree due to any error,
platform_get_resource_byname() will return NULL which is later
dereferenced. According to sound/qcom,lpass-cpu.yaml, these resources
are provided, but DT can be broken due to any error. In such cases driver
must be able to protect itself, since the DT is external data for the
driver.
Adjust this issues by adding NULL return check.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: b138706225c9 ("ASoC: qcom: Add regmap config support for codec dma driver")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Link: https://patch.msgid.link/20240605104953.12072-1-amishin@t-argos.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass-cpu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/qcom/lpass-cpu.c b/sound/soc/qcom/lpass-cpu.c
index b0f3e02cb043c..5a47f661e0c6f 100644
--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -1166,9 +1166,13 @@ int asoc_qcom_lpass_cpu_platform_probe(struct platform_device *pdev)
 		}
 
 		res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "lpass-rxtx-cdc-dma-lpm");
+		if (!res)
+			return -EINVAL;
 		drvdata->rxtx_cdc_dma_lpm_buf = res->start;
 
 		res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "lpass-va-cdc-dma-lpm");
+		if (!res)
+			return -EINVAL;
 		drvdata->va_cdc_dma_lpm_buf = res->start;
 	}
 
-- 
2.43.0



