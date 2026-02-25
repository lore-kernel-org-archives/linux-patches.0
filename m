Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F86D304BB4;
	Wed, 25 Feb 2026 06:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002654; cv=none; b=JBvEVXVAK0IiNCU2bnA53nG3UlwxxahJH1gjotyb1PbmkktALSseuZwzsxyPZgvTy+JMdgM5KNFxDrPFSPnOv5n54QcOFPfPfxzf8y6ETdsKq7whz4zRLOq2LO6GZfJlFwyGlFEdM5l6wmiYDI3d38U8jbZmFvubtVmNMm7HV9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002654; c=relaxed/simple;
	bh=wUl2sntJN/vxJCZKT5UdAUFPmrLEsmVojeOpZVs8nkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNoM7pHQzUWg5AOGCEvcD1uznh6nZdzhxpypRcSPmccIw29ergqXBMzOVNFkZeh2X0T6UWM/uUdiMJLWoFwdUvZIGB55e06ubMUr+8bgFwvbKnNIToReGEV9m5B4Uv3/de91W9LNqJj9s7AfOiyFJV6NfjpDiK7OIoxQmj6I2sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxFJ1Q3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxFJ1Q3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5816FC116D0;
	Wed, 25 Feb 2026 06:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002654;
	bh=wUl2sntJN/vxJCZKT5UdAUFPmrLEsmVojeOpZVs8nkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxFJ1Q3kd+S0QTaEc5fiP9XZ3EOIb26XnP542dMy5v+qD10DR4NjkiMZmXRG7T9P8
	 b56fYvWpy5UhbTlGRZ3DVtZ4rsovTOc6HG3bio8/pbQKtnBRsi+99C8fh/pCeApU+g
	 NRgOzEf6y/AhviK8PiRRXZKKFCTIUmoGoLnWzaE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 430/641] clk: actions: owl-composite: convert from owl_divider_helper_round_rate() to divider_determine_rate()
Date: Tue, 24 Feb 2026 17:22:36 -0800
Message-ID: <20260225012358.963601212@linuxfoundation.org>
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

[ Upstream commit d0b7c5bf6c5520c35fecff34da83d390405d3eaf ]

owl_divider_helper_round_rate() is just a wrapper for
divider_round_rate(), which is deprecated. Let's migrate to
divider_determine_rate() instead so that this deprecated API can be
removed.

Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Stable-dep-of: 3ff3360440fa ("clk: actions: owl-divider: convert from divider_round_rate() to divider_determine_rate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/actions/owl-composite.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/actions/owl-composite.c b/drivers/clk/actions/owl-composite.c
index 00b74f8bc4375..9540444307d6c 100644
--- a/drivers/clk/actions/owl-composite.c
+++ b/drivers/clk/actions/owl-composite.c
@@ -57,15 +57,10 @@ static int owl_comp_div_determine_rate(struct clk_hw *hw,
 				       struct clk_rate_request *req)
 {
 	struct owl_composite *comp = hw_to_owl_comp(hw);
-	long rate;
-
-	rate = owl_divider_helper_round_rate(&comp->common, &comp->rate.div_hw,
-					     req->rate, &req->best_parent_rate);
-	if (rate < 0)
-		return rate;
+	struct owl_divider_hw *div = &comp->rate.div_hw;
 
-	req->rate = rate;
-	return 0;
+	return divider_determine_rate(&comp->common.hw, req, div->table,
+				      div->width, div->div_flags);
 }
 
 static unsigned long owl_comp_div_recalc_rate(struct clk_hw *hw,
-- 
2.51.0



