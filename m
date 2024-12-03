Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52381F7577;
	Tue,  3 Dec 2024 14:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237724; cv=none; b=ltrnCO9rZ2QA1XI5264Y/vRtqP3sZGZrPE0LJ4akZSvEGxnLw+EF1swDOEVUhNkBHVobv6eJdsJkKHYPFGBiFRMAOb+Y1iHSW/6OIjryIUGdGJCaYx0B6P1Ht5xbt2CT9yuBlFUFcocfJ3SN/9dW7Y5pBUhqWYh8FBtBU6rZ/aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237724; c=relaxed/simple;
	bh=8IjAGLMHCT1+aUkO7jJ4I1U1GGPTT7mySlW5VYiw/gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6ldy/frz/9IV0qSrKQUdxIcQTFRIeCkeoBogF5JagWAlNlk2eF5XZNSwVpyUzUA5kB3ffG6TorX1UG8fZZ6C+pVm5E7GfVSjyXYCACnIMKxddpgspdZ6Ee3EdHHuik1LcEIndEfa5Od0Be2cDeMZnyQyPO9BMxAoFwmAcxwvvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGY4ijl9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGY4ijl9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED77C4CECF;
	Tue,  3 Dec 2024 14:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237723;
	bh=8IjAGLMHCT1+aUkO7jJ4I1U1GGPTT7mySlW5VYiw/gI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wGY4ijl9xy5/dd34ArKS1Z3wBGVhYv3litXZkLCOvuSOl9Hk2UJ4NUsBHcvI2OFUO
	 eCw7HtLJmaIzpq2/o5+shtwDUFlvGkP1m3qvwPiKcxX2QXaKCdaBZ6h7EiqnXMCmgx
	 f+T2jxsdRMFhzWMU0wOtrk4UHl0hgkedM9jdPyZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Yifan <luoyifan@cmss.chinamobile.com>,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 034/817] ASoC: stm: Prevent potential division by zero in stm32_sai_get_clk_div()
Date: Tue,  3 Dec 2024 15:33:26 +0100
Message-ID: <20241203143956.981528391@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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
index 19307812ec765..64f52c75e2aa8 100644
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



