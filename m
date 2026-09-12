Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD653382CB;
	Sat, 12 Sep 2026 19:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242275; cv=none; b=Ug+3Ei0vaspWscXN6iuOw/qqsMVktdk2LJ3hDcVMSz+ATA0NGQbNdt5Sq8LwAxJlCeMOq3+cgpo7/EQtAqwb3MULwhJ3N3IcKtAW3VYBNSfCK/aAWIY1u1/8wkW30gbZso/BuOdp7wIx9Fr0AeMnRVYnx32uuVGuRel+dvJ6kyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242275; c=relaxed/simple;
	bh=eX/shf6KJMyxHvQU9SbrV15ImO0CQas/H1XZro/iX2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZUrxDu0WfxrDxWwVy3f+XnmrHLhDl2NTrWt6JLEeznpxr/Dpc4m9rFuqQlJJ2mVJFHmlsd+lWCrmbMyjeDe3MVwRCuoh4fV/gCdvM/959jVl2QuhsVYs6ueyleXnBkNaqO8PZhbsq9zyPUNnZRrV61nMOxGSLTPctMsc+mrTTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Guggvp5K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Guggvp5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9DC01F000FF;
	Sat, 12 Sep 2026 19:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242274;
	bh=RQh49sY30/lb0L2knQuIbmYFwy3gYpXp8DBK1qGZ/qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Guggvp5KzZKmQodBwMXJojrRsUfyl3Lxbo0Rbf6iPRxsTALyktQk/1m7u+4TjLm3B
	 7f3dP7qrTD91OgChXIdu8xqqyeFSjkqN9ZdTc0P6SpUh+QiIPmHGjhoM6yoHbOfM87
	 W9Gna06dA++67FjzlHKk31cFQUBra7IPPDoazPiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anson Huang <Anson.Huang@nxp.com>,
	Dong Aisheng <aisheng.dong@nxp.com>,
	Abel Vesa <abel.vesa@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 348/798] clk: imx: scu: Add A53 frequency scaling support
Date: Sat, 12 Sep 2026 08:59:36 +0200
Message-ID: <20260912065525.136355521@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anson Huang <Anson.Huang@nxp.com>

[ Upstream commit cd8bd2f3ca64cac701084a5b3fc21e721bb15278 ]

Add i.MX8QM cpufreq support for A53 cluster.

Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@nxp.com>
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Stable-dep-of: 5f2db1ce2012 ("clk: imx: scu: drop redundant init.ops variable assignment")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-scu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/imx/clk-scu.c b/drivers/clk/imx/clk-scu.c
index b8b2072742a56..a48abf788ec87 100644
--- a/drivers/clk/imx/clk-scu.c
+++ b/drivers/clk/imx/clk-scu.c
@@ -192,7 +192,7 @@ static int clk_scu_atf_set_cpu_rate(struct clk_hw *hw, unsigned long rate,
 	struct arm_smccc_res res;
 	unsigned long cluster_id;
 
-	if (clk->rsrc_id == IMX_SC_R_A35)
+	if (clk->rsrc_id == IMX_SC_R_A35 || clk->rsrc_id == IMX_SC_R_A53)
 		cluster_id = 0;
 	else
 		return -EINVAL;
@@ -361,7 +361,7 @@ struct clk_hw *__imx_clk_scu(const char *name, const char * const *parents,
 
 	init.name = name;
 	init.ops = &clk_scu_ops;
-	if (rsrc_id == IMX_SC_R_A35)
+	if (rsrc_id == IMX_SC_R_A35 || rsrc_id == IMX_SC_R_A53)
 		init.ops = &clk_scu_cpu_ops;
 	else
 		init.ops = &clk_scu_ops;
-- 
2.53.0



