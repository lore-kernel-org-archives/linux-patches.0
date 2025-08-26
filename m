Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CA11A00F0;
	Tue, 26 Aug 2025 12:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213182; cv=none; b=RGxvIJeNqLjbjIkoS5cFuhjkXtS6uUCyQXmInGQZHVUHWrnhZf7FeqkmrLMWeKnQNl1ESETqtUswfc4VPrqQ9+zCIHhOSDe/L4hPhfK8kN3gmlcIKd9A0j6sckZgTCTVVWxFTLHHu1mC9Lb4csGLTIfvPIAbS2QXZfB2/L1eqrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213182; c=relaxed/simple;
	bh=Tax0sjRT5kSqItI1pkSl/nEHYXPt46kiDbyxmbWUAY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8JFDedOVpfpAXPrjF0hiczJlbBvt12e2GJt0DzRszA3c7A2sw0ftvHIA3NxRikg8k9GJaCkT3C8LmRIjELq28x+DkFIQyAIDPjcumDA4GPkC5pX/kXhfmz7iw5Jo/ZCdXnETBcc8UPAK7lgiUhaP7xkn6anqToERajSBpi2/ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qTLDxSzh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qTLDxSzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C4CC4CEF1;
	Tue, 26 Aug 2025 12:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213181;
	bh=Tax0sjRT5kSqItI1pkSl/nEHYXPt46kiDbyxmbWUAY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qTLDxSzh++mwIolG9rxQTJvV9yEYD0gRWMG6zMOh50kCMobs4oHF38OsnmAgp7itH
	 jCH2Yd3+T761cl+4K8lrKeO5DHA5gF/a+xOg+lUlRZi5CkiJQii3hWfnd5pY6FS3p2
	 Vqwk+6jnS8Rwdq1Qut0upHHVkvhJRLc6rY1fzr74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Thierry Reding <treding@nvidia.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 224/587] clk: tegra: periph: Fix error handling and resolve unsigned compare warning
Date: Tue, 26 Aug 2025 13:06:13 +0200
Message-ID: <20250826110958.635305167@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



