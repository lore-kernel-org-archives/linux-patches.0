Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4101AB6C9;
	Tue,  3 Dec 2024 15:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241310; cv=none; b=Ze3VceWG/is4oOUuwdfw9DVCbVsKmdc2tgMxjxyVHhL/x2kvtu286sXazxmi+ywz9H89dvDaGXr4FhVx6rIwko4NDYgIBg5OOBo+PyeB6OGNewNXBaE5Jh2S3Df0E9Uhl26EX81uO6AJ9/ZmNGSQaF3cZaG6E6xNg0KxEVawH5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241310; c=relaxed/simple;
	bh=UdnWckvHUyYimbe4wv0rjLka0Id8/jU7VU0CkvPsF+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=juh0biHCOqJoVmy6LWiG0aIOKIU1rqg19h7vaEmDM4DCEWS6zkVtbHYlSVApShklZfpijIPWY5HFXXlD3chLMOMuYplhbYvAfW+0pFtJ2rYv1937wZuGB45Cv9rXIq7ynksdtKY1vetzt/VhIz6ZQ2Fxbhm5y20IirEzoP06RsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h/Aon2kO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/Aon2kO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F25C4CECF;
	Tue,  3 Dec 2024 15:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241310;
	bh=UdnWckvHUyYimbe4wv0rjLka0Id8/jU7VU0CkvPsF+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h/Aon2kOaLqgxClQfa+YIgD0iiBTr7oHJpI9j5ksHI8Gb/lbRgCL5JYQ+K7CbkO13
	 eiz87YCXWlq9Y0CkXNCKHr4+FnPmR7B42OpwYE+B2QfPXEgqYocbbz1ZvtXcF+9Thx
	 jN/tcMN5E3qcD7vgB1mRYLz5ruuItyQUdmKW8g+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	Chen Wang <unicorn_wang@outlook.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 384/826] clk: sophgo: avoid integer overflow in sg2042_pll_recalc_rate()
Date: Tue,  3 Dec 2024 15:41:51 +0100
Message-ID: <20241203144758.744857563@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zichen Xie <zichenxie0106@gmail.com>

[ Upstream commit 00f8f70a0e8c6601861628be26270a0b6f4bbb34 ]

This was found by a static analyzer.
There may be a potential integer overflow issue in
sg2042_pll_recalc_rate(). numerator is defined as u64 while
parent_rate is defined as unsigned long and ctrl_table.fbdiv
is defined as unsigned int. On 32-bit machine, the result of
the calculation will be limited to "u32" without correct casting.
Integer overflow may occur on high-performance systems.

Fixes: 48cf7e01386e ("clk: sophgo: Add SG2042 clock driver")
Signed-off-by: Zichen Xie <zichenxie0106@gmail.com>
Reviewed-by: Chen Wang <unicorn_wang@outlook.com>
Link: https://lore.kernel.org/r/20241023145146.13130-1-zichenxie0106@gmail.com
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sophgo/clk-sg2042-pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/sophgo/clk-sg2042-pll.c b/drivers/clk/sophgo/clk-sg2042-pll.c
index ff9deeef509b8..1537f4f05860e 100644
--- a/drivers/clk/sophgo/clk-sg2042-pll.c
+++ b/drivers/clk/sophgo/clk-sg2042-pll.c
@@ -153,7 +153,7 @@ static unsigned long sg2042_pll_recalc_rate(unsigned int reg_value,
 
 	sg2042_pll_ctrl_decode(reg_value, &ctrl_table);
 
-	numerator = parent_rate * ctrl_table.fbdiv;
+	numerator = (u64)parent_rate * ctrl_table.fbdiv;
 	denominator = ctrl_table.refdiv * ctrl_table.postdiv1 * ctrl_table.postdiv2;
 	do_div(numerator, denominator);
 	return numerator;
-- 
2.43.0



