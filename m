Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D032210FE;
	Thu, 12 Dec 2024 17:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023680; cv=none; b=CqCh8Jz6QOF50yxaaQODHyoBGygvpONBVu1uuSvUS4K1qz/Rw6357Mr15Rtce+UNEcAwft+6WfJP75rYvOu/HPSr8p9b1UfUmOwt/hR4kLxNQXhI9Rlm3NBaXI76tKvWNF/urhfWQtRftu0IX3YgqVGYjYJFPs5GoVjBOmg1I0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023680; c=relaxed/simple;
	bh=pI2WHqzU34CF1P5l5UL56mY63qtxMVZfTyZ6VL6keRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3SLoH6RdPGaXuFn6oomnsyO6BFEOUkjx6Ux1gCogPUIPnEa8i7iSOgcMFpuxQcTJIJXl8wD8StwfnHEdKrsTSpDOEC7cQoYh6mxXj3Z0X56tSUy1ZkJgs8UxY6SnhTnxUVO59up6ZLShO6wCKtpwdamAMaFMzW5duqAfJ8amzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Plrdb4iQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Plrdb4iQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E870C4CECE;
	Thu, 12 Dec 2024 17:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023680;
	bh=pI2WHqzU34CF1P5l5UL56mY63qtxMVZfTyZ6VL6keRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Plrdb4iQ9V5K1qg5rJ/GNPJ6zTNiw4/XwRxb4Gl96SHy3wbUtmA1Ds0pMnqdnO+xW
	 9bY93DbFv5nNvNqi7WfNYJ5uAvfCFmk4CcVmnKjdxnqIQFZbiGtLUjTRmBwp3drN4P
	 pvA0+uLLD7OMdOoKuHJCXxoswZmjs/36PBqtaUts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Yifan <luoyifan@cmss.chinamobile.com>,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 046/459] ASoC: stm: Prevent potential division by zero in stm32_sai_get_clk_div()
Date: Thu, 12 Dec 2024 15:56:24 +0100
Message-ID: <20241212144255.343103306@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3a7f0102b4c5c..90e4757f76b0f 100644
--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@ -319,7 +319,7 @@ static int stm32_sai_get_clk_div(struct stm32_sai_sub_data *sai,
 	int div;
 
 	div = DIV_ROUND_CLOSEST(input_rate, output_rate);
-	if (div > SAI_XCR1_MCKDIV_MAX(version)) {
+	if (div > SAI_XCR1_MCKDIV_MAX(version) || div <= 0) {
 		dev_err(&sai->pdev->dev, "Divider %d out of range\n", div);
 		return -EINVAL;
 	}
-- 
2.43.0



