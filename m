Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2927529AB;
	Wed, 21 Feb 2024 13:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521543; cv=none; b=iL0Avl6VC5hyUxwJTO2cRDrkWOJEdMdiHbshL8mz8lb8c/IO4t7O2R3FGLqeMjqs1rkNr3F8+VX8QskL8560lkJL3yREs4MI/FcA9DIhp40y2GE5/s/69x3zkMLGe6mNOICwhwHCxEYm1MBoREug1Z76WmGaWWKrVgwwwHs7weM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521543; c=relaxed/simple;
	bh=d52kfQFeUTVggFyKzfaNxh1ByiyZ4ppFz8jXY+ES2kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSla7x4NI6cur9sSphCssJ3cS0qr2d1nDv7d9gb5x9h2e+e3rjgaoQOiWC18PKVmnno7RVccZ/IlQsnVrb8nIgKrMuI9TLH57YIF70JenFVIMGZQZCVi8rJYkN+G8UZiW9n9AkDZOoBPgOtfNI5JY37BZgdMl2ld4rcKItKRzh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z44zx4be; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z44zx4be"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD42C433F1;
	Wed, 21 Feb 2024 13:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521543;
	bh=d52kfQFeUTVggFyKzfaNxh1ByiyZ4ppFz8jXY+ES2kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z44zx4beQfU6TnpS40UD+H6QYZW4GYTL6Y3xLMjtPNsvii/Q3FPJDCCqprJd+3Plz
	 0Z++RNAfeFclFJ6E8JuxljXWLASYPdwrMT25wjFMdUt1hAEw3EcHuUrlM3V3ikVgTh
	 aNjMkdlhiLdRuroxedTR2JR/gVY2+OEkKIryqY+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 111/202] clk: hi3620: Fix memory leak in hi3620_mmc_clk_init()
Date: Wed, 21 Feb 2024 14:06:52 +0100
Message-ID: <20240221125935.332114058@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

From: Kuan-Wei Chiu <visitorckw@gmail.com>

[ Upstream commit bfbea9e5667cfa9552c3d88f023386f017f6c308 ]

In cases where kcalloc() fails for the 'clk_data->clks' allocation, the
code path does not handle the failure gracefully, potentially leading
to a memory leak. This fix ensures proper cleanup by freeing the
allocated memory for 'clk_data' before returning.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Link: https://lore.kernel.org/r/20231210165040.3407545-1-visitorckw@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/hisilicon/clk-hi3620.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/hisilicon/clk-hi3620.c b/drivers/clk/hisilicon/clk-hi3620.c
index 77072c7778b9..93b4d8933797 100644
--- a/drivers/clk/hisilicon/clk-hi3620.c
+++ b/drivers/clk/hisilicon/clk-hi3620.c
@@ -481,8 +481,10 @@ static void __init hi3620_mmc_clk_init(struct device_node *node)
 		return;
 
 	clk_data->clks = kcalloc(num, sizeof(*clk_data->clks), GFP_KERNEL);
-	if (!clk_data->clks)
+	if (!clk_data->clks) {
+		kfree(clk_data);
 		return;
+	}
 
 	for (i = 0; i < num; i++) {
 		struct hisi_mmc_clock *mmc_clk = &hi3620_mmc_clks[i];
-- 
2.43.0



