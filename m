Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C01243956;
	Wed, 30 Sep 2026 16:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785820; cv=none; b=SnOcFVumC1EVettjy+F8nOppGxPRxdW3rQjAEe2jI8GxEmd+qwLmSDfXsvrwOxvVk4dc9wW2b8s1SwTCfbV2OQ3aXkof2/Nn2GcIQiDIy/nvwDz0PbLYX7VMRpGzYueJz6tlKw92B6YETe+OhSv3axT6a31zLNKuHFguDiAHszw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785820; c=relaxed/simple;
	bh=ypQ07eamezpUscTUlt2yy955hGTD/1qbaowdipf85+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/86jZIKRY6/2tN1G7AiQaFtu/LqPe8jf5RzU/8Dl2egOq9DHhrRKfrBz7GCSNP2u1pokDNovslqAHOWzfHhaWAu+423jQGqW+Xqh0MaOudXkEnVZ/I5EDBQ4Laa3pzuu7U7g+Z8QoS8VnnqYR8fr4GVvHcieGEHwgydc2e1z6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sd2flWKL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sd2flWKL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600621F000FF;
	Wed, 30 Sep 2026 16:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785818;
	bh=kER1VtXTAl0Y1OKLxrYkJKnGx86m8BKwfUJdchvyFhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sd2flWKLYltvYyoatFEibUZdET0R7VZcN59pq4palKN41MDvMDnqSD2fzazp7ioFR
	 hN8kiUPxVZh3YS+UoIramKFDpkqAFSjqi22lhGF3+/xZGKK+vGV6eZ8XU86F5fow4k
	 pkVoa5gbuUPeVDk2wTaCjRBIZ7TOcHO2MVGOO0sA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 598/982] clk: scpi: bound-check DVFS index in scpi_dvfs_recalc_rate
Date: Wed, 30 Sep 2026 17:22:14 +0200
Message-ID: <20260930152429.625975819@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



