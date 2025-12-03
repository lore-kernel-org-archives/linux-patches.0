Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7741C35BDDB;
	Wed,  3 Dec 2025 16:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779862; cv=none; b=T9vygariALHvN8cFAqKddfAZh1YpwDn89uSyhgRANc1f3dTN8S8NxRwQHFbUOwefeEujMkg0/TBift1IbrJRx1gXWvkHx42W5jGS9QZigQQgTYKmXw0mZ/GxAlcH7AZ0SMuHVTkJwyuptFeo7ZylwyL8cFwvrSHu9RopJM4mj90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779862; c=relaxed/simple;
	bh=q2q76y3OcMEVPtyLSE9a/eTMfJL6z06jiWIyhpktGnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSZAJMo+jAbAJLSoyq0obVcNBrhkWugijrI/cA+1Q8EowpbiDYsVdQga7MdeWk8snquvAcse4gz941L07e77+/aU3f+fnzcDMAZG/NdY7i20Yvru75myB2Gt4kRTcjAUdxRIjWFs9s8fjA3gOZ2f7UTCGt5HStt7fWQnE+Naw4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LFEvJ+b6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LFEvJ+b6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2644C4CEF5;
	Wed,  3 Dec 2025 16:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779862;
	bh=q2q76y3OcMEVPtyLSE9a/eTMfJL6z06jiWIyhpktGnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LFEvJ+b6wVFDTXnwUxflDS6wdH/VkC/Xo4pzCIhyWHVmic5PzkFjG6gAzFVPVu55Q
	 scb7m5RmtCuiWv/zrIQlUPmlvPYEoW8fLoudJkfvru0CJLzrqCN9Ia+pW8d6KZ4Feh
	 MoUEia+ZPqSag5DMFkkm32cGVOSJCrxrvC94GcDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 383/568] ASoC: codecs: va-macro: fix resource leak in probe error path
Date: Wed,  3 Dec 2025 16:26:25 +0100
Message-ID: <20251203152454.722921362@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 3dc8c73365d3ca25c99e7e1a0f493039d7291df5 ]

In the commit referenced by the Fixes tag, clk_hw_get_clk()
was added in va_macro_probe() to get the fsgen clock,
but forgot to add the corresponding clk_put() in va_macro_remove().
This leads to a clock reference leak when the driver is unloaded.

Switch to devm_clk_hw_get_clk() to automatically manage the
clock resource.

Fixes: 30097967e056 ("ASoC: codecs: va-macro: use fsgen as clock")
Suggested-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20251106143114.729-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-va-macro.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/lpass-va-macro.c b/sound/soc/codecs/lpass-va-macro.c
index 1623ba78ddb3d..1f6e27d6a2276 100644
--- a/sound/soc/codecs/lpass-va-macro.c
+++ b/sound/soc/codecs/lpass-va-macro.c
@@ -1554,7 +1554,7 @@ static int va_macro_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_clkout;
 
-	va->fsgen = clk_hw_get_clk(&va->hw, "fsgen");
+	va->fsgen = devm_clk_hw_get_clk(dev, &va->hw, "fsgen");
 	if (IS_ERR(va->fsgen)) {
 		ret = PTR_ERR(va->fsgen);
 		goto err_clkout;
-- 
2.51.0



