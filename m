Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF0E3403F5;
	Sat, 12 Sep 2026 08:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200224; cv=none; b=EFZzvwrFLE2kdHzhr9m4m+JvYRTkSvId1WIhbPjhbEBr/0ZG3ww2H9CABMpuamLzU2nzzcK1girHf726/pVhqkn+s4ft7oue06ZBVkV+0nlfGBLIUf4/EW2YOFXBZfGyMAIwhHsucMJqCQo9k7elrO7hsNgG0I2SjRN09hPSH/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200224; c=relaxed/simple;
	bh=md/XbnZ7oISUosk/v5EqakeKT+TzSdO8Yg87WmiwzCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IM/kDwQMvTuldY4JUhtyS0u1E8/UbIkTuHM53JY49CbebEwqYOO+cesfqw4gfEUnvY7v/JLA+VDSdXOmJWMe2YaE0kjUIt1GPJTWYr3bBN4acKJSARGt8lytFrachzfpUZpP0uhd/7oPxgeM7AXxlS6xgNtE9oF65pYRnNH7eEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j34J58Ng; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j34J58Ng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493E71F000FF;
	Sat, 12 Sep 2026 08:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200223;
	bh=0ynOLIVvVNp4TR4z4eA8OWs++yC4BESEdnGF1TLt2Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j34J58NgNJ22jaQBvyDKG/w4UPoxcay00jc/sy+2HXnMOMQtzmHiGZ76D96xmVNz0
	 w2elsUagNoyexcib8quV2eVeuvU3yZW2/HdkCF7kWbURiLEYcN25iO30F36lXFtLaC
	 XE2Jn24FBFBB4rGUbm0LlC5otCNcaYFWQg5bgPJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Troy Mitchell <troy.mitchell@linux.spacemit.com>,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0729/1815] clk: spacemit: k3: fix missing /2 factor in i2s sysclk dividers
Date: Sat, 12 Sep 2026 08:41:19 +0200
Message-ID: <20260912065706.013664630@linuxfoundation.org>
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

From: Troy Mitchell <troy.mitchell@linux.spacemit.com>

[ Upstream commit 8a7d4b1924d2a424b1a6fe69de4f9464ee1fb485 ]

The i2s{0,2,3,4,5}_sysclk_div DDNs have an additional fixed 1/2
divider in the hardware IP after the configurable divider, so the
real output rate is:

    rate = parent_rate * den / (num  * 2)

Set pre_div to 2 to account for it.

Fixes: e371a77255b8 ("clk: spacemit: k3: add the clock tree")
Signed-off-by: Troy Mitchell <troy.mitchell@linux.spacemit.com>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Link: https://patch.msgid.link/20260717-k3-clk-fix-i2s-v1-3-e95001a692ee@linux.spacemit.com
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/spacemit/ccu-k3.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/spacemit/ccu-k3.c b/drivers/clk/spacemit/ccu-k3.c
index a82340213763a..e94a5d2687d57 100644
--- a/drivers/clk/spacemit/ccu-k3.c
+++ b/drivers/clk/spacemit/ccu-k3.c
@@ -236,11 +236,11 @@ CCU_MUX_DEFINE(i2s3_sysclk_sel, i2s_sysclk_parents, MPMU_I2S_SYSCLK_CTRL, 12, 2,
 CCU_MUX_DEFINE(i2s4_sysclk_sel, i2s_sysclk_parents, MPMU_I2S_SYSCLK_CTRL, 16, 2, 0);
 CCU_MUX_DEFINE(i2s5_sysclk_sel, i2s_sysclk_parents, MPMU_I2S_SYSCLK_CTRL, 20, 2, 0);
 
-CCU_DDN_DEFINE(i2s0_sysclk_div, i2s0_sysclk_sel, MPMU_I2S0_SYSCLK, 0, 16, 16, 16, 1, 0);
-CCU_DDN_DEFINE(i2s2_sysclk_div, i2s2_sysclk_sel, MPMU_I2S2_SYSCLK, 0, 16, 16, 16, 1, 0);
-CCU_DDN_DEFINE(i2s3_sysclk_div, i2s3_sysclk_sel, MPMU_I2S3_SYSCLK, 0, 16, 16, 16, 1, 0);
-CCU_DDN_DEFINE(i2s4_sysclk_div, i2s4_sysclk_sel, MPMU_I2S4_SYSCLK, 0, 16, 16, 16, 1, 0);
-CCU_DDN_DEFINE(i2s5_sysclk_div, i2s5_sysclk_sel, MPMU_I2S5_SYSCLK, 0, 16, 16, 16, 1, 0);
+CCU_DDN_DEFINE(i2s0_sysclk_div, i2s0_sysclk_sel, MPMU_I2S0_SYSCLK, 0, 16, 16, 16, 2, 0);
+CCU_DDN_DEFINE(i2s2_sysclk_div, i2s2_sysclk_sel, MPMU_I2S2_SYSCLK, 0, 16, 16, 16, 2, 0);
+CCU_DDN_DEFINE(i2s3_sysclk_div, i2s3_sysclk_sel, MPMU_I2S3_SYSCLK, 0, 16, 16, 16, 2, 0);
+CCU_DDN_DEFINE(i2s4_sysclk_div, i2s4_sysclk_sel, MPMU_I2S4_SYSCLK, 0, 16, 16, 16, 2, 0);
+CCU_DDN_DEFINE(i2s5_sysclk_div, i2s5_sysclk_sel, MPMU_I2S5_SYSCLK, 0, 16, 16, 16, 2, 0);
 
 static const struct clk_parent_data i2s2_sysclk_parents[] = {
 	CCU_PARENT_HW(i2s1_sysclk),
-- 
2.53.0



