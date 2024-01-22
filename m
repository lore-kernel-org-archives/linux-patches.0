Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787B73FF4;
	Tue, 23 Jan 2024 01:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974635; cv=none; b=Y2KeJ3cNG+I0yXEcdqJ6Cb2uI260fqgvFGiNtUkJw9sF7u8OPERUOqjVM7wqPo3rJzfKjS1Hr/zzkQMWMZdcuRERpO1jOyrgcwcBC81M0nC7+JBjld2wUENUU6vIEKH2x3k9HcKYOBr12wDOxzUWHlo3DrsVhbiu4lek5puvAF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974635; c=relaxed/simple;
	bh=f/atErg02+hHUPemVezEHFdH3orHYMGyljYijJDCrNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0t0HlRRM+7rlkusVsFn8Zbb7P4mkFBzqHxBShphjAykn+VAUm9ZH+6ox3Qok1MLBMvsfdxtlZHCS4GsbwkohE0gpZNnarU1UG7b5La1N1KHh4zaCjt+JYfCgN0I6Tz/D2gq9s3P4mNRYULRE3+WW//tJj6oszpL0XICebg6bAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SItgwUBJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SItgwUBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396CBC43390;
	Tue, 23 Jan 2024 01:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974635;
	bh=f/atErg02+hHUPemVezEHFdH3orHYMGyljYijJDCrNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SItgwUBJicPybPMvSEg0EscGP60Ywj67uTNq7TC0bm9pU7Yh17XngGAz2JWvZthIw
	 9NUCjmYa5usrVsj308UMzykDhslBxaBdqA7Km5EhxysipCdF2tTc5Bk74RNMBwMAbs
	 D03G8nzO0Ixgsxqv0rryzDhpMW0ZOsLELnIlKdgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Looijmans <mike.looijmans@topic.nl>,
	Su Hui <suhui@nfschina.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 223/374] clk: si5341: fix an error code problem in si5341_output_clk_set_rate
Date: Mon, 22 Jan 2024 15:57:59 -0800
Message-ID: <20240122235752.431524646@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 5607068ae5ab02c3ac9cabc6859d36e98004c341 ]

regmap_bulk_write() return zero or negative error code, return the value
of regmap_bulk_write() rather than '0'.

Fixes: 3044a860fd09 ("clk: Add Si5341/Si5340 driver")
Acked-by: Mike Looijmans <mike.looijmans@topic.nl>
Signed-off-by: Su Hui <suhui@nfschina.com>
Link: https://lore.kernel.org/r/20231101031633.996124-1-suhui@nfschina.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-si5341.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/clk/clk-si5341.c b/drivers/clk/clk-si5341.c
index 91a6bc74ebd5..cda5a0f4d9df 100644
--- a/drivers/clk/clk-si5341.c
+++ b/drivers/clk/clk-si5341.c
@@ -892,10 +892,8 @@ static int si5341_output_clk_set_rate(struct clk_hw *hw, unsigned long rate,
 	r[0] = r_div ? (r_div & 0xff) : 1;
 	r[1] = (r_div >> 8) & 0xff;
 	r[2] = (r_div >> 16) & 0xff;
-	err = regmap_bulk_write(output->data->regmap,
+	return regmap_bulk_write(output->data->regmap,
 			SI5341_OUT_R_REG(output), r, 3);
-
-	return 0;
 }
 
 static int si5341_output_reparent(struct clk_si5341_output *output, u8 index)
-- 
2.43.0



