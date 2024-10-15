Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F421AF0B0;
	Tue, 15 Oct 2024 13:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998369; cv=none; b=MjgzXWrOxlHuoNTYJkQs4JKM/uQv3DO/nUVzrr+7xJkbWeS+r2vYlxVBU0gN8X08vPvyZFXWX/RWVioC1QtlTjwUC8WrTLC0uGPK2avLStBX/dOPyK7meRLookilNQ2xz1dxFHfqGqejI1DhTZkW/kmwJH7xo9xnIbq/aB+nc24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998369; c=relaxed/simple;
	bh=Dw/Kni9CqAUFPxzU2wftXNMOZOAYF4rcfX86vcEDR5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mi0EAGjveOQWG6XOC0uz/FU3Ila3iZAxujRcWftJ1sgzAVhRaFlXnR2dOgVZHIxN5pjh84Fs05TW+Afg8gH/Ur+uI4F0rlOgo4mMOCouhEZhEKDRmf81CZFgwvqEztiA0AXewB9zdQAr2R0K4CG+MCPDkARevONxRg5x3zahgXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPK7DlW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPK7DlW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8E0C4CEC6;
	Tue, 15 Oct 2024 13:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998369;
	bh=Dw/Kni9CqAUFPxzU2wftXNMOZOAYF4rcfX86vcEDR5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RPK7DlW398pKvrmHpp2lnb7MXuXeUR7zls0gMiKr0mZVVJIXtj1mOdi62e4/cHP0E
	 0t5MlpNi9nlXnP4NAu8TKcNQKCh73pP+ktFeaWbvvjXGrumJIGyMFquVvs6j2VZ/BX
	 m+p7ELz+dMEMzig5clatcr1QE3814HygJXodhp3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 457/518] clk: bcm: bcm53573: fix OF node leak in init
Date: Tue, 15 Oct 2024 14:46:01 +0200
Message-ID: <20241015123934.644790734@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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
index 84f2af736ee8a..83ef41d618be3 100644
--- a/drivers/clk/bcm/clk-bcm53573-ilp.c
+++ b/drivers/clk/bcm/clk-bcm53573-ilp.c
@@ -112,7 +112,7 @@ static void bcm53573_ilp_init(struct device_node *np)
 		goto err_free_ilp;
 	}
 
-	ilp->regmap = syscon_node_to_regmap(of_get_parent(np));
+	ilp->regmap = syscon_node_to_regmap(np->parent);
 	if (IS_ERR(ilp->regmap)) {
 		err = PTR_ERR(ilp->regmap);
 		goto err_free_ilp;
-- 
2.43.0



