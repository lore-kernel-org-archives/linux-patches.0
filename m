Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891BC32E14E;
	Fri, 17 Oct 2025 15:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714130; cv=none; b=t/Asf6mbt6WH7lDQHitnrgNi1AW5ICVOqHUtX3CXMZkKJYJjJlGwqY6TpON5eeRDhJfc7d8iNO9GfuZHy5RIatDG6Smos8jy//a2nq+wDm71rNk7CZKvkNFxlXLX9cMoyTtpsOG/dIbqHTY7yknUoaCW/0B/zEWRZuvkU7xNW6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714130; c=relaxed/simple;
	bh=n2zBncX+5EO07xpUMbYSbsO5ssY9Qb1siuDjMGYVG6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9xbqN9jsXKjF8ixUcHRwjR0Xvz/EaWU1tpCQGoIa1155Oq3nwlGodCD5715uEnAW/pOMlPrO+hwh6iVSGe4faOHEGQY9vjS4fxyt473IuXYUJ49x4M9nOamF8fEb9435PXtE1jVSK6TPOrydXgn0JZBYTvDRrFNkuoMQzb0RD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WAxNq8B/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WAxNq8B/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3195C4CEFE;
	Fri, 17 Oct 2025 15:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714130;
	bh=n2zBncX+5EO07xpUMbYSbsO5ssY9Qb1siuDjMGYVG6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WAxNq8B/xd++OnCsmZtO5UCPL/YkKgxSK06Yswa1ic1Xn95QJJ5KS5L7ZYGbmkgPL
	 wbfdVPy9m1ERLmqZoU+d2eNQis3WqYtPMieZ7NWQ9hUAVE6hBUEGASfopDZ1xhF8Sc
	 EbA3wqrtVPQcIkh2okytlrcTFOJksR9MUfJjgAcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/277] clk: tegra: do not overallocate memory for bpmp clocks
Date: Fri, 17 Oct 2025 16:50:45 +0200
Message-ID: <20251017145148.539162569@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 49ef6491106209c595476fc122c3922dfd03253f ]

struct tegra_bpmp::clocks is a pointer to a dynamically allocated array
of pointers to 'struct tegra_bpmp_clk'.

But the size of the allocated area is calculated like it is an array
containing actual 'struct tegra_bpmp_clk' objects - it's not true, there
are just pointers.

Found by Linux Verification Center (linuxtesting.org) with Svace static
analysis tool.

Fixes: 2db12b15c6f3 ("clk: tegra: Register clocks from root to leaf")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-bpmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/tegra/clk-bpmp.c b/drivers/clk/tegra/clk-bpmp.c
index 7bfba0afd7783..4ec408c3a26aa 100644
--- a/drivers/clk/tegra/clk-bpmp.c
+++ b/drivers/clk/tegra/clk-bpmp.c
@@ -635,7 +635,7 @@ static int tegra_bpmp_register_clocks(struct tegra_bpmp *bpmp,
 
 	bpmp->num_clocks = count;
 
-	bpmp->clocks = devm_kcalloc(bpmp->dev, count, sizeof(struct tegra_bpmp_clk), GFP_KERNEL);
+	bpmp->clocks = devm_kcalloc(bpmp->dev, count, sizeof(*bpmp->clocks), GFP_KERNEL);
 	if (!bpmp->clocks)
 		return -ENOMEM;
 
-- 
2.51.0



