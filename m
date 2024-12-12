Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA9C21C166;
	Thu, 12 Dec 2024 15:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018749; cv=none; b=JMpKNSU47WRvhLOsLDleeoEvjtTpjb8WuqZ2tyiUtKKh9+zRTL8lOczTL4gr9pQwhD4/rMR8OKE6vXtqBxBH1RCaz1gmCmWZaFaZZ3wWiCsaQMzQiOT+ZvLxXwtDnKwr2MrNporjDNFFJ6rgX2cIZadkxZut3oip/wRGmsr0Gts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018749; c=relaxed/simple;
	bh=clpWzycMRH0RvvKxU9qFp//7lyUD7Hzw6Aax0JTie4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/BN/mroDPUnN/iaXJJPVf3bWhT10ZbOvPoD/phddnG5ydN2+kOQbriISu0AVt8iQ0jLQVJxlAlwcbGySZrQPX3AaaNedIlMbFOTBG1Lm8vXq2VAAfErbq4pfUMITWU1ES1Tg3eiYE1aLVnsjMvy/gmcBlGheP8JA0u1De4myBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mifN1wjh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mifN1wjh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822B0C4CECE;
	Thu, 12 Dec 2024 15:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018748;
	bh=clpWzycMRH0RvvKxU9qFp//7lyUD7Hzw6Aax0JTie4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mifN1wjhEBVLre87yNmQWYowK6p1j5xccGHgYUd0TX2Q4oUSmKrQwQGWYy9DlsuUr
	 KkHGblqF7S55DAC2A1gGoyHsicXsIcUII4tpLrP6TZjRJlilOe+nD27tD3IXvc3fF2
	 2od5zHfB6J0/k+7t4b7MkQ2b83HSKxeh1KbEHMLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Yifan <luoyifan@cmss.chinamobile.com>,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/772] ASoC: stm: Prevent potential division by zero in stm32_sai_get_clk_div()
Date: Thu, 12 Dec 2024 15:49:26 +0100
Message-ID: <20241212144350.818214908@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Luo Yifan <luoyifan@cmss.chinamobile.com>

[ Upstream commit 23569c8b314925bdb70dd1a7b63cfe6100868315 ]

This patch checks if div is less than or equal to zero (div <= 0). If
div is zero or negative, the function returns -EINVAL, ensuring the
division operation is safe to perform.

Signed-off-by: Luo Yifan <luoyifan@cmss.chinamobile.com>
Reviewed-by: Olivier Moysan <olivier.moysan@foss.st.com>
Link: https://patch.msgid.link/20241107015936.211902-1-luoyifan@cmss.chinamobile.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_sai_sub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/stm/stm32_sai_sub.c b/sound/soc/stm/stm32_sai_sub.c
index 3d237f75e81f5..0629aa5f2fe4b 100644
--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@ -317,7 +317,7 @@ static int stm32_sai_get_clk_div(struct stm32_sai_sub_data *sai,
 	int div;
 
 	div = DIV_ROUND_CLOSEST(input_rate, output_rate);
-	if (div > SAI_XCR1_MCKDIV_MAX(version)) {
+	if (div > SAI_XCR1_MCKDIV_MAX(version) || div <= 0) {
 		dev_err(&sai->pdev->dev, "Divider %d out of range\n", div);
 		return -EINVAL;
 	}
-- 
2.43.0



