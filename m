Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FED21E098;
	Fri, 21 Nov 2025 13:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733416; cv=none; b=I+PwDp/3oXBTvWnqI/xb5istkLO7Z25iDB750hxKaCWtnRcbjODGxW1jRQjOvXWnxWoBIWOFAXMkhSbAf41Lf68YPxfO30VrbHGBJqJVBjOCW+JtnwAMKxvwhbYiji1Cc1g91VB9fLqOLeJ6zIdMymT8vNgymX6EKxqflmhuNxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733416; c=relaxed/simple;
	bh=+yL6e7n9hOCRZGfDcrhtcdQ2YefVpfQkSYX51AIYkXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d3Yu284PST+oq0Whm0Dl0b7EdIeaJf00SiEFHBkATwI3OkRift9qT1wBXp+JtOIJJccVh4RSZoRzV2BogjtjzrIdigYKafn2+9VwazQCF/FtgTkifKO2PnWhK31ZRUKZ72oE+TsKBLIo5RH4NZ/Fytj1EUvtyH/zWSY7JJzKF/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1h7fRml2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1h7fRml2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B164C16AAE;
	Fri, 21 Nov 2025 13:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733415;
	bh=+yL6e7n9hOCRZGfDcrhtcdQ2YefVpfQkSYX51AIYkXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1h7fRml2cMapIypkT+QeRfhfxvxn4/L5lWJ2ip1aiFDyfJyaKZ2k0LlxJVe9PT0Rk
	 LiU5EZg40sXkuoZx5MaQ6XO256jCwJEx7GnesdqnnDQEGKHby/gd2zxckktAGdfC92
	 9+Wi/PbDy4NWZauwEVCrdxJkXDA6Uin+89RkNSqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 427/529] ASoC: codecs: va-macro: fix resource leak in probe error path
Date: Fri, 21 Nov 2025 14:12:06 +0100
Message-ID: <20251121130246.208806355@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b71ef03c4aef0..c7d6696b1bfdf 100644
--- a/sound/soc/codecs/lpass-va-macro.c
+++ b/sound/soc/codecs/lpass-va-macro.c
@@ -1555,7 +1555,7 @@ static int va_macro_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_clkout;
 
-	va->fsgen = clk_hw_get_clk(&va->hw, "fsgen");
+	va->fsgen = devm_clk_hw_get_clk(dev, &va->hw, "fsgen");
 	if (IS_ERR(va->fsgen)) {
 		ret = PTR_ERR(va->fsgen);
 		goto err_clkout;
-- 
2.51.0



