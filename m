Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045E364CDA;
	Tue, 23 Jan 2024 00:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971328; cv=none; b=TRPqu341s2vb7AELTM10h4d1FNA6yoxAJ18Ntxp8WH2SPG1VI+p28i3nOi5CUc+9I8/swkyJsetfjqhHFtdvZMtnqoIKnfW7OjEyLwsd4e69YZs2vUHbKHPPiEQNBFCasL9mC4wXf1R1PJisW0nfJLzD92fwyn3Y4Votph+x4pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971328; c=relaxed/simple;
	bh=XHifNW32YfrXfSq+bRXm2K2hAamiisOMOKw/TlTJhLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNc8y6R7kx4e7qFy8a8I/tibqf9JfB73E3jpoQqNPLIupJACDNwIqWVKru2t33lRmCpAqxpVXuPhxKjbdS0R9QJlV3eI7rDxuAMwN1HKWWav1LthoC4fD1LzUO/tn7RxUPqvEVfsM6iE3fjkO4rxafEN94w3M8SIsvfVeHJupWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ba4BecPM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ba4BecPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB1EC433F1;
	Tue, 23 Jan 2024 00:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971327;
	bh=XHifNW32YfrXfSq+bRXm2K2hAamiisOMOKw/TlTJhLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ba4BecPM/q0XcBLjFYC8NAFy6k3HaNnp0tN0gcr4uTpiGcR53eDf1m7/towwaupTs
	 HbP+ueMCYzrf+Y3XPlXZ2SRx/ugkeHJtL14bqbRLJGDgWTPFYepKtQcf1ApWjrSa9A
	 UFW5ht9wzV0AoHrX33rLfzEpCHAq0LpclM8iATX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Looijmans <mike.looijmans@topic.nl>,
	Su Hui <suhui@nfschina.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 224/417] clk: si5341: fix an error code problem in si5341_output_clk_set_rate
Date: Mon, 22 Jan 2024 15:56:32 -0800
Message-ID: <20240122235759.675607079@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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
index c7d8cbd22bac..5acb35236c58 100644
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



