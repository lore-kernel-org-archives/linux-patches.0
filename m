Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA01335BD3;
	Mon, 18 Aug 2025 13:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523996; cv=none; b=Y++X1Hg+sqUykqLQyzQ5CV8Kwx7R8JJea825YaH+z6XulD4tUYf7zRcHiO+51Xdp21hzF6uXniuqygs8LlrQ90Y/RhU9Ylqz2z7nLK6LuBs5rYeTf0Nj21SaU19KIsxsmpIFWfrw+sTLir4aOWXyipBEqA9V/aUi83NUjzh2M7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523996; c=relaxed/simple;
	bh=rBvNH53nbDQvh1cbU84nVJmnvOJNLk3Oxrj/ONm+LO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMPw7VQAf8JSdViOD0UA4AaHB4Eyt+y7NaostNcWAYRStA0zgz+WX8RzEtk/G1l3FAkon/iNdsKTg50gPbqkAjN0CbcypRsIPW+bWIfOS5ueQ8bZWrb0CZY+iyzT/vXsPEmLQu4pYFFafh9nF4Q3nHAQT0VpB8bMJTjFOXtV6g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bsLiMf8u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bsLiMf8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1AE6C4CEEB;
	Mon, 18 Aug 2025 13:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523996;
	bh=rBvNH53nbDQvh1cbU84nVJmnvOJNLk3Oxrj/ONm+LO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bsLiMf8uIv4OSuH7YYhblbnZTNApXVDwwM0bIzZ5BiTc108zLQzxtAhpnyqBdEajx
	 O4pvVsB/bmV7bu1frUOzOx8bfnlPf52BjabTkvyy8gtX7oeh6Hn5KRIFOOjk3CT/It
	 uCeBXny+ij9RvLkkhT9fgLsQrVvFQKpPEukhTgMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Thierry Reding <treding@nvidia.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 337/515] clk: tegra: periph: Fix error handling and resolve unsigned compare warning
Date: Mon, 18 Aug 2025 14:45:23 +0200
Message-ID: <20250818124511.407291625@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 2dc2ca9000eea2eb749f658196204cb84d4306f7 ]

./drivers/clk/tegra/clk-periph.c:59:5-9: WARNING:
	Unsigned expression compared with zero: rate < 0

The unsigned long 'rate' variable caused:
- Incorrect handling of negative errors
- Compile warning: "Unsigned expression compared with zero"

Fix by changing to long type and adding req->rate cast.

Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://lore.kernel.org/r/79c7f01e29876c612e90d6d0157fb1572ca8b3fb.1752046270.git.xiaopei01@kylinos.cn
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-periph.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/tegra/clk-periph.c b/drivers/clk/tegra/clk-periph.c
index 0626650a7011..c9fc52a36fce 100644
--- a/drivers/clk/tegra/clk-periph.c
+++ b/drivers/clk/tegra/clk-periph.c
@@ -51,7 +51,7 @@ static int clk_periph_determine_rate(struct clk_hw *hw,
 	struct tegra_clk_periph *periph = to_clk_periph(hw);
 	const struct clk_ops *div_ops = periph->div_ops;
 	struct clk_hw *div_hw = &periph->divider.hw;
-	unsigned long rate;
+	long rate;
 
 	__clk_hw_set_clk(div_hw, hw);
 
@@ -59,7 +59,7 @@ static int clk_periph_determine_rate(struct clk_hw *hw,
 	if (rate < 0)
 		return rate;
 
-	req->rate = rate;
+	req->rate = (unsigned long)rate;
 	return 0;
 }
 
-- 
2.39.5



