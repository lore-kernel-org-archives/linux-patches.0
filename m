Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFAF5187CA;
	Wed, 30 Sep 2026 17:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788173; cv=none; b=ah6rEcFR8pZ1OqdufzUYb7bvaJNgOz/rR5hyElsgK5FcLWWabE+9D1QPvyuBR8k4aocrHKfQhlPMvuFHJKhhh3bgtXQTeFBz6R7F7FoD1Xiydsmy5EnaRnPck44Hut1HzoaF95TBX/P1RtU7vtV21E+ZU42UUKL5WA7pGjARHrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788173; c=relaxed/simple;
	bh=t6267/MPycLddXPQRzkYREwTvjx+UrH8PKkdBbE1s0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3XzS1GVDN5Eo7LLe2pnHtRfdNhROaVVsgJ0EVfFB9nTPL8wjV6y0We9Ggr518jPhChrDr/yz6v/KGOLbyXXj6PRdGplFDpZZ1ZSQYRBVcIBIVgiS4FeKPLppPyNctRlO9PBPNmNa14abn67S171EbJsTWvHcTG9TqhNtyN/oLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTtLUXJZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTtLUXJZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70B81F000FF;
	Wed, 30 Sep 2026 17:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788172;
	bh=OwYNMQxKurS7QWdhP1zxkyQURyROLesqstb6u6dUzxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bTtLUXJZOVp4TqFhOVxO6n9Bc47APdpXaS9k/zw+/coisSvHc0pypxoeVZ1tqpO+W
	 7DBzLIN00U8mrYnlCxHpRKqNXNX7MrAJV4AxC8Ga+b14O0S41DsZGb5NyIckMFVPuC
	 xQgSgxSvCNK8uX40UE1IcX+Z2Ullkg1Na7nnqZHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/877] clk: scpi: bound-check DVFS index in scpi_dvfs_recalc_rate
Date: Wed, 30 Sep 2026 17:15:43 +0200
Message-ID: <20260930152415.437012171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index 50ac1cd255785..598dc1fd99ade 100644
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



