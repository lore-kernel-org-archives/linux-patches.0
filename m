Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659FA2288CB;
	Thu, 12 Dec 2024 16:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021801; cv=none; b=NJ5SOfQFfiNLK7wzFrN07J+Qi5RNX+LezYT+VirxOYgXrknodChahgg0btPTBikMY2gef2C2AgijVGFv6y7w1EvCmMe35gDfSrzSjRaYkHRhAcuocpSc+3JrWfxputzvXUqXUZXjGF4lQMjIq4/yNDfuweUdhSLWA1yb8FlUmVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021801; c=relaxed/simple;
	bh=YQsekKBikgQqdRN5Xl6OnXDE0GNvltAAad3gtwOtT5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4STnzRydq7arbnf4EYey9AqGIEf9BK7kkMc92ptBNvUwGCV1scegbEzIL4/z53L3WOgdADRqMVifT2i1/A6uKpaAbVF5DYtAg7k9JuEFkAT+O/KqVEwAlnPfooSIJ5q8MTHo4w6i0qhFVuJabl4FSCBIpbC3X/LaVawH/08ypM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0THrzejx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0THrzejx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D264BC4CECE;
	Thu, 12 Dec 2024 16:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021801;
	bh=YQsekKBikgQqdRN5Xl6OnXDE0GNvltAAad3gtwOtT5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0THrzejx7j+CMe8KY3bCK11RLLIEdu4m7ziJvgnPj5aHBbRBjNFhC0PHk8IrtmK1H
	 crpB9AcIccYTVLGl1eVehtsAs+NIM/Os74gKKFmiuwOIcSwgn6mDaSKG/h/OkE32Dj
	 vntevdRlvTa1kY2Op3GHeNl0lEBLDSaAqqSy8U6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Yifan <luoyifan@cmss.chinamobile.com>,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/565] ASoC: stm: Prevent potential division by zero in stm32_sai_get_clk_div()
Date: Thu, 12 Dec 2024 15:54:22 +0100
Message-ID: <20241212144314.141789249@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index aa9cdd93b5778..d71b4aecd269f 100644
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



