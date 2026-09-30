Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCC04FDA5D;
	Wed, 30 Sep 2026 15:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783450; cv=none; b=V05lg5UkwDOR1w/OMrxBA1F5iKnfh5Hb3raDZZEKa4aglZlUL4cdo2SelwT3H8BH4ZV1949oZV7eQTyFU0pCS/XeFcJjdcxDvfTom9OJQZX9UEa4yX8J8VJ8HUl5ypNyPFzgWWWb5z6/egUv30VhmxyGP6P7nSn+XpWQ3aDt7vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783450; c=relaxed/simple;
	bh=IjuZhBGedg+EiKjA9E3DC7Zvcd1C3DFhLEIZqw4MaHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rf6PB/UZGZ88FM9pTQCs3o6+Szp8FYDwueTISBD0iK6RgBGb7tY10SngaxGapLrlbAhTlNED+lwAvMOaZDhW3axyCApiyMk6zR3vi8cv5qsUTT7eMSfljarQsHWW09g0JTR1xEm+nUvvOauPIXjhGpfz2arRIv1Qm0Z0+X8PAoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hBNgSYL6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hBNgSYL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA501F00893;
	Wed, 30 Sep 2026 15:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783444;
	bh=uN8ubNmN2XJBM721n6U0+x5WG61J3eALwC8H3NzoQkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hBNgSYL61KlbZxr0aRipxbe/CpT0LW2ZvEWSpPBlefR2jHY/fyWb5sAQCwoYOdKlC
	 tMiRKQU3ItwUVGig263u6lIT62D9sUDM4v53xcyBIROCGcjtqmQsgHqIDKlakYQuHO
	 9yjYLg4AEKhYEy7mRspY/LOT2OFHqDAXpVS5BRiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 356/595] clk: scpi: bound-check DVFS index in scpi_dvfs_recalc_rate
Date: Wed, 30 Sep 2026 17:24:09 +0200
Message-ID: <20260930152355.335782512@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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
index 5a9b140dd8c80..41feac548b6ce 100644
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



