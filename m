Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8558D20EB;
	Mon, 14 Oct 2024 14:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916876; cv=none; b=X9LYR75YTFyPPhLjZYKkouF+BlcsgMEgd5v+xYTWvZdEK2tUFpD21IaqoWKdNKSh0fAmad9CnNGUnxJEGtNy0MgmsRTPyP50ACAZyU33BpqzWsnTCbnVpkrxm+dcrzJHl2Y0pjTH+Tf+eKHC2HdcP/XX+HFK8WP8u70CnDZUtLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916876; c=relaxed/simple;
	bh=RxzxvwyzQivninrxMY1mM20yk7Yg2/5Fbs9+QuVKjuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5vVPUdzMBmokXfrMdc6U57EhSCyNUKyTfK9bTVjK+gK2niOdRpz8xRwNnJ2cDx2G0vstLIjkRcKXIcCiMk/HQmqMeGdu63L2AZIi8X6/X+/Vzj4J2NZWMX3IRT1KbSDbVBKrDvUgU9EjSr9J4ZA7yrDPu2O3Nc4UdRv9bmE1Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kG7YXcRT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kG7YXcRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FC4C4CEC7;
	Mon, 14 Oct 2024 14:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916876;
	bh=RxzxvwyzQivninrxMY1mM20yk7Yg2/5Fbs9+QuVKjuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kG7YXcRTEUNhT7OBLHyvAvNHtZdAZ/H1BQHew/h10wncsGq96ieX5aMYqsPREW8dt
	 wq79cimJQdqnFuNzkPBIQRcBNU++ACJ1AIp+vz1CQmwbt+yiQIUiaE+Arqf8++pA01
	 pIfc2JCKPGDM5IrAlxw2Jb6lMegdBmvwp/Wu18BE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/213] clk: bcm: bcm53573: fix OF node leak in init
Date: Mon, 14 Oct 2024 16:19:38 +0200
Message-ID: <20241014141045.793087668@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



