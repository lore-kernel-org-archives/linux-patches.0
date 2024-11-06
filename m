Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EA51E907E;
	Wed,  6 Nov 2024 13:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898757; cv=none; b=k5No0tH6h7YJNrQhnvcaAO5pmVBY+FjpT+nlFlNl9UQWfwAgRYZgDOOqIBt1Ci7TYZ4POLMVYnK8qQKOEtfuUynkua/KmU4/jhu0vtBKwLrkhG2N3+yHKFw9iw0ciFZfe5pGYgl82si5yzQVebd2/1saXsjMYnLeNZbbzVRONXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898757; c=relaxed/simple;
	bh=/JOqA1VDwYjdvspWW0ZTC/DFOCc23K29AxIIeviSrTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOLHdbdud8Ej5/+uR9RV2/Kp3I3mdP6fBkbFuAnvb927fRsh59rw5yeDlSDmeOkWGPuZPsQLQ9akUY9U5LZ3drKJJ8pmnASx+KQuC5RryGwSuSx4/4CHaHGGPpVRSZwtEFLdt7DLlaz+FifW+uDNGDEnZpWpxu9Hks3bdXP27dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Snb86RK0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Snb86RK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFADC4CECD;
	Wed,  6 Nov 2024 13:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898757;
	bh=/JOqA1VDwYjdvspWW0ZTC/DFOCc23K29AxIIeviSrTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Snb86RK0+pSdi1oFTHlBimaFSb6rU9GobPfnJzA9ug2c/JH+Hwj57QOINh5XxU2UY
	 4iRvcgJtQQjtoW9TGS65ZovgfRKA5b5/NrTrUgCzCajF81XR02rULqT+Tlh87VsDjG
	 El2uYArPHjPJK9mC1SDMZK8m/w/FEj0MTxFxOB2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 309/462] clk: bcm: bcm53573: fix OF node leak in init
Date: Wed,  6 Nov 2024 13:03:22 +0100
Message-ID: <20241106120339.158475622@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



