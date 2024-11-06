Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD961DF738;
	Wed,  6 Nov 2024 12:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895508; cv=none; b=BNtW7vgyaD8pTIkEXhHMrCidsZUEoM2tQ2GryFa8xc4Vm7wZCvmjgP5eVaDA/eeATaTd3S33Br/1z7wmSTOKnDL+P6oPnBzPJ6MghoyiSzwNNLMflki5cxX5Fj8mDbSJWRlxMwlsPdRfzb4RfGMQBU4/bFxW5DhVGlVRwq48MgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895508; c=relaxed/simple;
	bh=QdzHY29gaoVRB6/WK4hdp7st9Qzhgm/HoR+d8i9uQlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7VE2b3MwLMent3UutU9S6yEA1U9KVtGLLa4aovQUZxKCPwngjeNAYIMhko1ctHWZmWdlMhJx2MvH9csq7g1OA1D8frJzMkXaAzHdPfxfrykGkapqXrlpOgV2Z+4rEMkrDZt2djio7Ik7eQtlD+NDME2/3gJ9VYv4sSY4yogCz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y2/mwYp2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y2/mwYp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4603C4CECD;
	Wed,  6 Nov 2024 12:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895508;
	bh=QdzHY29gaoVRB6/WK4hdp7st9Qzhgm/HoR+d8i9uQlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y2/mwYp298ryII5SRNHg5vkeIknLXoBx4OLPx7VMAntskHe5auF2ehqvktgcZzqaZ
	 cB56SeE/Eh7Qr2l78ayHN8etDu16tgVc4hcgwaFQunkdbOQPshL49IGM8V5Iqr+idc
	 h+cUbpONdSb++24SDHTJYbOEHWh7QgLLsnImJWpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 240/350] clk: bcm: bcm53573: fix OF node leak in init
Date: Wed,  6 Nov 2024 13:02:48 +0100
Message-ID: <20241106120326.876572855@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit f92d67e23b8caa81f6322a2bad1d633b00ca000e ]

Driver code is leaking OF node reference from of_get_parent() in
bcm53573_ilp_init().  Usage of of_get_parent() is not needed in the
first place, because the parent node will not be freed while we are
processing given node (triggered by CLK_OF_DECLARE()).  Thus fix the
leak by accessing parent directly, instead of of_get_parent().

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240826065801.17081-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/bcm/clk-bcm53573-ilp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/bcm/clk-bcm53573-ilp.c b/drivers/clk/bcm/clk-bcm53573-ilp.c
index 36eb3716ffb00..3bc6837f844db 100644
--- a/drivers/clk/bcm/clk-bcm53573-ilp.c
+++ b/drivers/clk/bcm/clk-bcm53573-ilp.c
@@ -115,7 +115,7 @@ static void bcm53573_ilp_init(struct device_node *np)
 		goto err_free_ilp;
 	}
 
-	ilp->regmap = syscon_node_to_regmap(of_get_parent(np));
+	ilp->regmap = syscon_node_to_regmap(np->parent);
 	if (IS_ERR(ilp->regmap)) {
 		err = PTR_ERR(ilp->regmap);
 		goto err_free_ilp;
-- 
2.43.0



