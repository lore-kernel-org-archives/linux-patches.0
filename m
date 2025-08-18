Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFF730DD2C;
	Mon, 18 Aug 2025 13:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522321; cv=none; b=fnzbmQgsilJTIxPCXRrBokSoGdm86qizcmnU0qbyhEtnFmusSGPSE19QKK2v8z/nnj89ivDjPwUPDcvAfpatJL7dDjw/b3Fph0i1Tky0oIzjNsEUseMJlSCyQUVnu489NcwFtSgeBRD9VcJgDS5Y9uVz53N9AtCCHNrLGSSoGgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522321; c=relaxed/simple;
	bh=bUEIX4LfBnxM/ZEonUAAT+j/aJWnOMYd2JeaPsoUiL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pa9CumYhfptVXj1XzWpoK6BMmVzTXDEum/LNs9ZXVYSCtdMeaSeQM0DI7acyc7Dg8P7QTDpnoEC+aSdsJiVvZM9xc1mOxF4ynDZi2MWnibHU947gGpzNjY5SVK6wQw/Z1zLjKzgpkyLZWxHiPs9mTMbO0jiD6qoshxdE5fko9rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EthgPfrt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EthgPfrt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BDBC19421;
	Mon, 18 Aug 2025 13:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522321;
	bh=bUEIX4LfBnxM/ZEonUAAT+j/aJWnOMYd2JeaPsoUiL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EthgPfrtNHQsZDrhZINFKjUYWlrfoT8KUj5SHgobA7PgTKryd/kiG7xmxm35fE/He
	 unFoBY9pDBypvWGikjt6jT5mY1Z7apth1GxIdOtX+OcS/h8LEo+1kAJ/oOUF1x++Jk
	 MrPVwwGTzKMfeKXHHo3D2OjYuSSq6bB4I9gt8M3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Thierry Reding <treding@nvidia.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 281/444] clk: tegra: periph: Fix error handling and resolve unsigned compare warning
Date: Mon, 18 Aug 2025 14:45:07 +0200
Message-ID: <20250818124459.503148948@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



