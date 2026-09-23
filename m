Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAE3527599;
	Wed, 23 Sep 2026 14:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172743; cv=none; b=ppCe2xLHmDamWUGl77PofgnkemSM0+1Sav2Y3tXiZxRSQ39RztKD8VBR6YXcluXBtKkGSuIx20C3qExbMPqcrUd/66i84W+l5PTJ+7p6agLFCKmk/+hPOp836Wj7l0SUIchgPV6IejzHdAJ5W8NYH4FrDLp/G0R8DPZ0jdxsoAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172743; c=relaxed/simple;
	bh=lXADqwXi8CK9byXsOmGaPjqGEcY8ASKz1WCwVL2Q2hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knkekuuHj6ljU+Pq69n+ARiCEV04smILlCdrjupf8cU7XmnuvXCV1Y61GZ0uTxkjCcY8jHsyvdCYTdH7pmzQN6od5YNmpfwHe6VlnzuKvPAHEedJVMCyr07liuchfaI5WDECW9BONeOLsjquMgAooJsF0T7IcTCKbyTCVIvlvtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DGQYiwvh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DGQYiwvh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B781F000FF;
	Wed, 23 Sep 2026 14:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172742;
	bh=peaZQzrBD0/b/LAzAlh2vV2KnbCZbXTTnVCC403EK/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DGQYiwvhOZuhB3HHbfrR/o0V0WVLGAmUwgqmeaunOoRdUNPh7qpqOHTjZRZAB+JC5
	 JZdrVNeiGbiz1hyR1PKZOubmtFqo1GTAjxIg2HWH6uhhfZb4mnEa1+FbcUlo2TnTXq
	 TQQ1xQOySdA5UzAJyRe/ell5SS7TeeGZGKzH2I4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 022/438] clk: scpi: bound-check DVFS index in scpi_dvfs_recalc_rate
Date: Wed, 23 Sep 2026 16:00:43 +0200
Message-ID: <20260923140645.352017559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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
index 24cee7c9fda6c..3c33a9e3c6909 100644
--- a/drivers/clk/clk-scpi.c
+++ b/drivers/clk/clk-scpi.c
@@ -85,7 +85,7 @@ static unsigned long scpi_dvfs_recalc_rate(struct clk_hw *hw,
 	int idx = clk->scpi_ops->dvfs_get_idx(clk->id);
 	const struct scpi_opp *opp;
 
-	if (idx < 0)
+	if (idx < 0 || idx >= clk->info->count)
 		return 0;
 
 	opp = clk->info->opps + idx;
-- 
2.53.0



