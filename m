Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10CB535FBB;
	Wed, 23 Sep 2026 14:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174159; cv=none; b=TxIEO5NNZXkumkJsJ3OMoxIIGzzbn3GjGL/3+zDheeAwaXw8mGbuBanSNGnUtL6WqwqBPw8MFr9bRHl/H45hzQf5gWhJr1xa32+pCQ3P7DQPfrB/PURLgRaJNPAG6cH9ao7eO4Ub+V4AnOu5KQtH5HG9MDS9wPKmqzz9+fHUdYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174159; c=relaxed/simple;
	bh=cR1INBKECA85tOPg4aWoU+63o2gUAiQ3GHa/c3aHj9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0pD+d+Dq1OzwcHUXef0YJZOKV+HVtVaIYTG3F201VHT2Zs3FKh3XmOXBagWM/ZpXZHHQtWSzytVYIQRCaLvMg/f6012AAULKeMYo5fkWlpE6hhYFeeV5ZfaJFOS+auC7LB+5QoILfZw6hnael0rH7sB0ltoekNl5sUPisX7rI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sijJiG0B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sijJiG0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEFC1F000FF;
	Wed, 23 Sep 2026 14:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174157;
	bh=6CSseEJ4sKtowC0co+FtsyqOKCdu4AP3L4ryHv7Ufzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sijJiG0BEmTqNZ2z5VQgvCxs5hAeKJKUQPC/VgwW2hxKfGV7iw9YDBZZAjyKxeS0Z
	 Ty8VLFpmbsziN26TJ/lneAdbq3q3Cduqtw0pp6jOpWISp4x7b9XcmEwzG5umsKgR1J
	 ewZP2K3nq6kV+82/rHkJzmw0UO+Lp5i0weeZ8dY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 028/398] clk: scpi: bound-check DVFS index in scpi_dvfs_recalc_rate
Date: Wed, 23 Sep 2026 16:01:42 +0200
Message-ID: <20260923140644.160810489@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e082474250fe3..48a0c314fc3dc 100644
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



