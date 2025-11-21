Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA4D26CE33;
	Fri, 21 Nov 2025 13:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731127; cv=none; b=nttqgIFxPJR/FyxO+dWJj3OPz0gAy9hGTwUoNfbIWIMkbjpMMb2FeQWtMuNhhw/1hXdf6jgH+8lVz89lYjV7TqJz8mNy3ziLx8WOUKRLIRltmBa1taAE/F0dLMeU4YvT1rgRWzJSUSl7p/N60LfLxLmunuO+XyxsTe3C1oBFdUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731127; c=relaxed/simple;
	bh=ZUoN1wxSzwR+duEfhHV0iSCz7ZcyoNNVNReOm/Bqczc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jmc5eJUxhRz6R3sV0SvR7nEw/lk10out0zp9Ln3LV0SBY79AKC0gJ8XmJU9YY71JP2GntPxz0Ih0QW78rVqPZ99dvYKsb4p1gpPaYJ46SRYA/+yWpv0x9Tmmq89WHHbdmc4Wj2ibOmkfjLNIYzmNnVGRfKV45Mfox9/8O6ST5T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JbhLJ6l0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JbhLJ6l0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABAE7C4CEF1;
	Fri, 21 Nov 2025 13:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731127;
	bh=ZUoN1wxSzwR+duEfhHV0iSCz7ZcyoNNVNReOm/Bqczc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JbhLJ6l05o+QFwe5SBNP95iS1cNjpHoVcrhdh/Gv3Q6wCl3PDksXL8AhVH/+4cznL
	 8uTWPRSPqWKBNohxUcPvZ+/4UUnIKZjpOPgzXixlnZF9ZURCEXAQJwSePb7RfH3++M
	 2aSC2KneixgatqFSHukiwm3n7S+Tur1FPJaTohv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 099/247] ASoC: codecs: va-macro: fix resource leak in probe error path
Date: Fri, 21 Nov 2025 14:10:46 +0100
Message-ID: <20251121130158.143603141@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index a49551f3fb29a..fead5c941f210 100644
--- a/sound/soc/codecs/lpass-va-macro.c
+++ b/sound/soc/codecs/lpass-va-macro.c
@@ -1636,7 +1636,7 @@ static int va_macro_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_clkout;
 
-	va->fsgen = clk_hw_get_clk(&va->hw, "fsgen");
+	va->fsgen = devm_clk_hw_get_clk(dev, &va->hw, "fsgen");
 	if (IS_ERR(va->fsgen)) {
 		ret = PTR_ERR(va->fsgen);
 		goto err_clkout;
-- 
2.51.0



