Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5868634E;
	Wed,  5 Feb 2025 14:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765621; cv=none; b=e+oUeynvUFKAkfgsjACYROmuzdJjhwnBMzH0OPKDtha85pdhty2UlFmI3k7ujEdyh3D3/5HcjCbW/zETz4yOGF7IsGJzjJ3s0coAmRhAaAIn6J4Su1I0YLG5yCKxSFl/QoUOFKKB7h1oUM/BU0pvXTs6gtwvCxFWEiWZq3IgJsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765621; c=relaxed/simple;
	bh=S5nwppMebko5rUvS8qCuNdOGIaVu2pAKiCrT/RJcAvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVJ/Qb5exVwSLzdDmfAb3/SFYQau+wtyHVTUSpFH/BP/kkN4t6QUYFG+qSPI6Wd8ma5tIwNi5yqBwqX6uYdVrzRJvSYdDoFWVWYT3bGYHlgAwGnAIX9g2WXp/FYMLWGfRnM3X0/+L1J1nhbhXBLz95VQjez+QEsxuoEAYG0hpVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O73xzljV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O73xzljV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85273C4CED1;
	Wed,  5 Feb 2025 14:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765621;
	bh=S5nwppMebko5rUvS8qCuNdOGIaVu2pAKiCrT/RJcAvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O73xzljVSpUjt+NCBehwEQrZRNBqjqgsJ33eso4SP8KzzoMUmhnHtoTHUEhFihc1E
	 47GDzbXsl3fwwW3buCtZrr+7qq5snvlInUQMV94Bk3oB2Vf+HEDZ0cRRmYAZ38PTpS
	 50/nJswxk2xzHTy7athLvNweS6X6sKtSxLjkc4RQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 284/393] media: marvell: Add check for clk_enable()
Date: Wed,  5 Feb 2025 14:43:23 +0100
Message-ID: <20250205134431.177245879@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit 11f68d2ba2e1521a608af773bf788e8cfa260f68 ]

Add check for the return value of clk_enable() to guarantee the success.

Fixes: 81a409bfd551 ("media: marvell-ccic: provide a clock for the sensor")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
[Sakari Ailus: Fix spelling in commit message.]
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/marvell/mcam-core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/marvell/mcam-core.c b/drivers/media/platform/marvell/mcam-core.c
index 66688b4aece5d..555f560238c9a 100644
--- a/drivers/media/platform/marvell/mcam-core.c
+++ b/drivers/media/platform/marvell/mcam-core.c
@@ -935,7 +935,12 @@ static int mclk_enable(struct clk_hw *hw)
 	ret = pm_runtime_resume_and_get(cam->dev);
 	if (ret < 0)
 		return ret;
-	clk_enable(cam->clk[0]);
+	ret = clk_enable(cam->clk[0]);
+	if (ret) {
+		pm_runtime_put(cam->dev);
+		return ret;
+	}
+
 	mcam_reg_write(cam, REG_CLKCTRL, (mclk_src << 29) | mclk_div);
 	mcam_ctlr_power_up(cam);
 
-- 
2.39.5



