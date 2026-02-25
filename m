Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD06130ACFF;
	Wed, 25 Feb 2026 06:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002661; cv=none; b=M1PLdWpATQBvtVdsMWK5BzDqif3Rdc83mHkGGOMB1pSMF1R8yaF655ZdXfQ+AO+q8Q0ZVmag1SAwCNkfEeOvpVb6pm177Gbb9eV4tC2hFvqKUiGKyhlPFcTuGO2jLCqZPpjegfuCjkR5Uod2YQGDgnr/PLHOTGWH+g/Jv9IlUqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002661; c=relaxed/simple;
	bh=50Kk3+LlnZKasbhmXryJaT4ZNsuhW/k16VDTWOdTsH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJeJq1S7nUkzTPTkPsJ7Qo7tN1FJOBSWIxGxAcbzM/acfTnK2KU3VGhpbnDn/CMxCcIlNHHazrGT/+0YBjdInBy/TJJPkY/stF9Ia6FP0Nra5pckDEQAoed/Wp44/kxjAa34LJBt/LFWfIBesunsrp2NEMusNWO5xsAS7clQ8SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yKe4eDbT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yKe4eDbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BE9C19425;
	Wed, 25 Feb 2026 06:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002661;
	bh=50Kk3+LlnZKasbhmXryJaT4ZNsuhW/k16VDTWOdTsH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yKe4eDbT4A6ctgfJM65jGFmIMHyMQO9mVkSlVvFScEReBJZsXlQ3XnUdqP3HqbWRT
	 aa9a3qjXMMIsELBzfC+HGhVLd7bml28MSaQe3Yo1exZ2NNlLI1TRRVQ4LLwmVgUTHv
	 NMLmKrbnA5brWzjgRb/WZWNUBHBUNXHlkEG+4Qjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 440/641] clk: stm32: stm32-core: convert from divider_ro_round_rate() to divider_ro_determine_rate()
Date: Tue, 24 Feb 2026 17:22:46 -0800
Message-ID: <20260225012359.192381367@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 6587c9dacc89ad7014bf601fe851955429f13230 ]

The divider_ro_round_rate() function is now deprecated, so let's migrate
to divider_ro_determine_rate() instead so that this deprecated API can
be removed.

Note that when the main function itself was migrated to use
determine_rate, this was mistakenly converted to:

    req->rate = divider_round_rate(...)

This is invalid in the case when an error occurs since it can set the
rate to a negative value.

Fixes: cd1cb38836c0 ("clk: stm32: stm32-core: convert from round_rate() to determine_rate()")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/stm32/clk-stm32-core.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/clk/stm32/clk-stm32-core.c b/drivers/clk/stm32/clk-stm32-core.c
index 72825b9c36a4d..b95b9c591fda7 100644
--- a/drivers/clk/stm32/clk-stm32-core.c
+++ b/drivers/clk/stm32/clk-stm32-core.c
@@ -369,13 +369,10 @@ static int clk_stm32_divider_determine_rate(struct clk_hw *hw,
 		val =  readl(div->base + divider->offset) >> divider->shift;
 		val &= clk_div_mask(divider->width);
 
-		req->rate = divider_ro_round_rate(hw, req->rate,
-						  &req->best_parent_rate,
-						  divider->table,
-						  divider->width,
-						  divider->flags, val);
-
-		return 0;
+		return divider_ro_determine_rate(hw, req,
+						 divider->table,
+						 divider->width,
+						 divider->flags, val);
 	}
 
 	req->rate = divider_round_rate_parent(hw, clk_hw_get_parent(hw),
@@ -455,14 +452,9 @@ static int clk_stm32_composite_determine_rate(struct clk_hw *hw,
 		val =  readl(composite->base + divider->offset) >> divider->shift;
 		val &= clk_div_mask(divider->width);
 
-		rate = divider_ro_round_rate(hw, req->rate, &req->best_parent_rate,
-					     divider->table, divider->width, divider->flags,
-					     val);
-		if (rate < 0)
-			return rate;
-
-		req->rate = rate;
-		return 0;
+		return divider_ro_determine_rate(hw, req, divider->table,
+						 divider->width, divider->flags,
+						 val);
 	}
 
 	rate = divider_round_rate_parent(hw, clk_hw_get_parent(hw),
-- 
2.51.0



