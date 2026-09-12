Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151A73002B3;
	Sat, 12 Sep 2026 07:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198224; cv=none; b=pBit6JR+b8TgetOEObOmMKkhowNQW3GsPmaJ/ZD4NysZNV81059LojfA0LYWLSUbuPi+v1mGKSkI8Xvap3iANww2MZDSVhKTc9M87HUZlyQyuWGBoxuWxVUfZ+gPvnzmTM2I0tlQ2eR3cQqeq5ccYaFS5UUKmnknEEuL5Mwn7sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198224; c=relaxed/simple;
	bh=rCJbHnQG/OydszlEOPggmcDNf4kf5rOJbPnPvX1cQSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKUL4g9d5WGHfww0YxnHwkGaeucBTXJfpR19EiyeU2fMOf8HM39BmIvvnVw+lC5AIBm555FCQ5optdvF6rmj+OwOWpUQX5ij7kTLrzDKo6SUtru/JhQENjjfTAfKw9TIF2ooq2hQY3bNzAaKsZMuQDdIpWQmCm51TxmsqATZpxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x3pmBBPe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x3pmBBPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B201F000FF;
	Sat, 12 Sep 2026 07:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198223;
	bh=Dm+5ChruhCmwQ85wluGwlPfbeIXQ1WjeHnMjZ2cLdXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x3pmBBPemZDSV/JQbmH92+m/+l5EjYqBY+VsrHgdeBO3BR+nkLDTaWyKFvm3BoSql
	 KVGOn8XU3d5p1yhl3lwz1zs2qKBw1s+JhkbKF0kMqnRqDutMkQ3foqPpxfKxtJElH3
	 wkeAStMwYul7a+iQfn0nkIT6dPiSpGY4ANrSO85U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0336/1815] clk: spacemit: k3: fix parent clock of UFS aclk
Date: Sat, 12 Sep 2026 08:34:46 +0200
Message-ID: <20260912065656.809107087@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yixun Lan <dlan@kernel.org>

[ Upstream commit 7a588b62679c51abd08171d31df6e44589f0097d ]

According to SpacemiT updated clock docs, the previous UFS aclk parent
clock was wrong, the correct one is illustrated below, so fix it.

  --> pll1_d5_491p52 --\
  --> pll1_d6_409p6  --|
  --> pll2_d6        --|--> div --> gate --> ufs_aclk
  --> pll2_d5        --/

Fixes: e371a77255b8 ("clk: spacemit: k3: add the clock tree")
Link: https://patch.msgid.link/20260630-06-clk-ufs-support-v1-1-cf7521d1d0fe@kernel.org
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/spacemit/ccu-k3.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/spacemit/ccu-k3.c b/drivers/clk/spacemit/ccu-k3.c
index 764426359540c..a82340213763a 100644
--- a/drivers/clk/spacemit/ccu-k3.c
+++ b/drivers/clk/spacemit/ccu-k3.c
@@ -926,11 +926,10 @@ CCU_MUX_DIV_GATE_FC_DEFINE(dpu_aclk, dpu_aclk_parents, APMU_LCD_CLK_RES_CTRL5, 1
 			   20, 3, BIT(16), 0);
 
 static const struct clk_parent_data ufs_aclk_parents[] = {
-	CCU_PARENT_HW(pll1_d6_409p6),
 	CCU_PARENT_HW(pll1_d5_491p52),
-	CCU_PARENT_HW(pll1_d4_614p4),
-	CCU_PARENT_HW(pll1_d8_307p2),
-	CCU_PARENT_HW(pll2_d4),
+	CCU_PARENT_HW(pll1_d6_409p6),
+	CCU_PARENT_HW(pll2_d6),
+	CCU_PARENT_HW(pll2_d5),
 };
 CCU_MUX_DIV_GATE_FC_DEFINE(ufs_aclk, ufs_aclk_parents, APMU_UFS_CLK_RES_CTRL, 5, 3, BIT(8),
 			   2, 3, BIT(1), 0);
-- 
2.53.0



