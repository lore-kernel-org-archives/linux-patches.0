Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0974E77FD;
	Wed, 30 Sep 2026 18:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791858; cv=none; b=LQ7qxsBSzerRTjy1MYR8X7Zk55S0gQYFbpx2WhQ3C0V4BJ3IDUKgDXmFn1P6ckXaBE+0k+y2WX1seWiFYNvCJYrSEf+GCgSNlfAseNiPOZ/d8616MZ8Y8vWXDtRY4Jv6Xbr3rJCoVTjUjVTgSB4YuInJP2vDIUBA/dw1viUDb0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791858; c=relaxed/simple;
	bh=EepfIYNfMNVOxssOGyp+8TfXrRit0Ldp0LmRpbSXLqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6lh+sPpGTKSnF7pFFvJ19Rz7cpMA2ee7d8OCHdS+F67Vrhbju3QSYp3HTwrF2UTAkD3ki/MUbTisa1XArNdv5Qgfor3lpgYqFljtcMXbv6R3y07gznzU0ZlhxFwGHXl1/0IGvNXmRPkCgWU4kGR8lHKi4XcX/HEcfHK+kiDOfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=epz0sjBU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="epz0sjBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633331F000FF;
	Wed, 30 Sep 2026 18:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791856;
	bh=1eV1qNgyv195JLko1FgdN8KlBN1wmxPHRnXPw+GRLuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=epz0sjBU2O3elbR8OboUkKAopmR7q8GKCeBk4GwwU3VSGnEiyXn8jUYasEI6vSIKp
	 3irtWdiATwYconvkTt2Qn0MwAGULow+8CS+E+cvcAKku2/njL2VGDY1OZzA/kIQCxz
	 UOdsB/TgxZ/mnVCqPsiZTrjYXCG9YOmrs/Mgg3tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 449/752] clk: scpi: bound-check DVFS index in scpi_dvfs_recalc_rate
Date: Wed, 30 Sep 2026 17:25:19 +0200
Message-ID: <20260930152407.995333267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xixin Liu <liuxixin@kylinos.cn>

[ Upstream commit 70f4b78d560e592cbf3325b162424737d032fc1d ]

dvfs_get_idx() may return an out-of-range index if the SCP firmware is
buggy or returns a stale value. Only negative indexes were rejected, so a
large index walked past info->opps and could treat garbage as a clock rate
(KASAN OOB / wrong frequency to consumers). The missing upper bound dates
back to the original SCPI clock driver.

Treat indexes >= opp count as invalid and return 0, same as idx < 0.

Fixes: cd52c2a4b5c4 ("clk: add support for clocks provided by SCP(System Control Processor)")
Signed-off-by: Xixin Liu <liuxixin@kylinos.cn>
Link: https://patch.msgid.link/04f9ab766e07.v2.1785200642.git.liuxixin@kylinos.cn
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-scpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-scpi.c b/drivers/clk/clk-scpi.c
index a39af7616b13c..c019b9ee4865e 100644
--- a/drivers/clk/clk-scpi.c
+++ b/drivers/clk/clk-scpi.c
@@ -86,7 +86,7 @@ static unsigned long scpi_dvfs_recalc_rate(struct clk_hw *hw,
 	int idx = clk->scpi_ops->dvfs_get_idx(clk->id);
 	const struct scpi_opp *opp;
 
-	if (idx < 0)
+	if (idx < 0 || idx >= clk->info->count)
 		return 0;
 
 	opp = clk->info->opps + idx;
-- 
2.53.0



