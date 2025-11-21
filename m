Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AE934676C;
	Fri, 21 Nov 2025 13:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733109; cv=none; b=oWf6gXLXyBY/dBWeYI2403gitPVn4N3FvstFOJVyF5e91qgN25KlvTw9sTmQ0A3UQ5EZmtJ5nhd7JWZi7t/dVsYHrNtJGqj2pRsEFh4Dnm2oz90qA0smtE2OeYuP8moUlej62nMvLBy3yX9a9F2nJsNmqOjRI2xxz0DgFhDvVbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733109; c=relaxed/simple;
	bh=P3ftVvbL2UiDQlfVeYl6kwbfvejN2RVMfbtDjiePcZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DG+USx42T0L6Q8svs/fGJPa2GOsn7kuHt7jrnz8BAU+ROn+GEFLF/7siGfqIuh4QeG3fpL5igqZ5g/nr5iqjwy6chp0r8fTgXBmfMg+g0hYoydYWCJBps6B5OcHdX1l15yzN+5Jc6CH7siJzbkKS+6/kDsNccPxjEOX5Of/mDFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UPlrTkGi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UPlrTkGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F8EC4CEF1;
	Fri, 21 Nov 2025 13:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733109;
	bh=P3ftVvbL2UiDQlfVeYl6kwbfvejN2RVMfbtDjiePcZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UPlrTkGivkLSCia56S6XRIA/brErRHUchod0PiNOPLY9JaNVEov/Ulb+hnXYBaha9
	 xj0SmFUWCQQ5AZeE36Mv2QwoMNu9tO8HOQDC8yKugecuy+R+ju8LliMvccCVEBQ5IA
	 ua6XgXEPunGld3VigpPZluZk7tOU4EimX0mq+2go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Wanner <Ryan.Wanner@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 311/529] clk: at91: clk-master: Add check for divide by 3
Date: Fri, 21 Nov 2025 14:10:10 +0100
Message-ID: <20251121130242.090022086@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Wanner <Ryan.Wanner@microchip.com>

[ Upstream commit e0237f5635727d64635ec6665e1de9f4cacce35c ]

A potential divider for the master clock is div/3. The register
configuration for div/3 is MASTER_PRES_MAX. The current bit shifting
method does not work for this case. Checking for MASTER_PRES_MAX will
ensure the correct decimal value is stored in the system.

Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/clk-master.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/at91/clk-master.c b/drivers/clk/at91/clk-master.c
index 15c46489ba850..4c87a0f789de1 100644
--- a/drivers/clk/at91/clk-master.c
+++ b/drivers/clk/at91/clk-master.c
@@ -580,6 +580,9 @@ clk_sama7g5_master_recalc_rate(struct clk_hw *hw,
 {
 	struct clk_master *master = to_clk_master(hw);
 
+	if (master->div == MASTER_PRES_MAX)
+		return DIV_ROUND_CLOSEST_ULL(parent_rate, 3);
+
 	return DIV_ROUND_CLOSEST_ULL(parent_rate, (1 << master->div));
 }
 
-- 
2.51.0



