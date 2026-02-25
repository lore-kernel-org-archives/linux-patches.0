Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A081D5141;
	Wed, 25 Feb 2026 01:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983425; cv=none; b=iPUXDWFLHD55UllDNOFZa5DfVy0B0b7pQLWT1ofr3BV2GBcMdWgZ4BRI8QDnnMh9+PS0ox2GpuLPaQAKpBlAza1GTEfXmVMdyJjf/qDlaU4zbEfT6J/VWti88QiTWwqIfqfKaUsyQiG79ttAjF2VHIDVy45vjpEDOlz359lHbfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983425; c=relaxed/simple;
	bh=0vrZy/EgWo7zmZCOknJq3s6cw+Y2P0ty0RUC5dd4TI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KdTnrnWyCJq9SKwH5GrTKVFlnBdvKrh55whRS3NMD/5MygKAAa7Qr82AQn3wc878JqLJwrbRiZmBETop9VCVdc33Md+N5hqGoiZs1vGAolfgvGi9yQkRYd7QNg/1hjWLIJ174xoqL8jYFH/1JTFSU5hD6iQbcoPVFk83NdsAmAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0tQGFw8f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0tQGFw8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B4FC116D0;
	Wed, 25 Feb 2026 01:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983424;
	bh=0vrZy/EgWo7zmZCOknJq3s6cw+Y2P0ty0RUC5dd4TI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0tQGFw8fwOTzqtvxBvBWtHNK/1w33sQYXmWBhu1sMNrPD6EiaG8uPS/5mh2Q5ztfM
	 TurLvgxIvM31VLdK0WJ2hRUkhSxgcllE3kOFLvKsizbjZj4ZMXJAsesH/T3WYPAQ3a
	 bmOh+DsDQx6BrpmX51kPyS6UMIRPy7IWfgAYs708=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 545/781] clk: nuvoton: ma35d1-divider: convert from divider_round_rate() to divider_determine_rate()
Date: Tue, 24 Feb 2026 17:20:54 -0800
Message-ID: <20260225012413.162878571@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 9329d784ca9aad03b12508128797d40fd1f2e0c1 ]

The divider_round_rate() function is now deprecated, so let's migrate
to divider_determine_rate() instead so that this deprecated API can be
removed.

Note that when the main function itself was migrated to use
determine_rate, this was mistakenly converted to:

    req->rate = divider_round_rate(...)

This is invalid in the case when an error occurs since it can set the
rate to a negative value.

Fixes: 215f8aa095a1 ("clk: nuvoton: ma35d1-divider: convert from round_rate() to determine_rate()")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/nuvoton/clk-ma35d1-divider.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/nuvoton/clk-ma35d1-divider.c b/drivers/clk/nuvoton/clk-ma35d1-divider.c
index e39f53d5bf457..e992e7c303419 100644
--- a/drivers/clk/nuvoton/clk-ma35d1-divider.c
+++ b/drivers/clk/nuvoton/clk-ma35d1-divider.c
@@ -44,11 +44,8 @@ static int ma35d1_clkdiv_determine_rate(struct clk_hw *hw,
 {
 	struct ma35d1_adc_clk_div *dclk = to_ma35d1_adc_clk_div(hw);
 
-	req->rate = divider_round_rate(hw, req->rate, &req->best_parent_rate,
-				       dclk->table, dclk->width,
-				       CLK_DIVIDER_ROUND_CLOSEST);
-
-	return 0;
+	return divider_determine_rate(hw, req, dclk->table, dclk->width,
+				      CLK_DIVIDER_ROUND_CLOSEST);
 }
 
 static int ma35d1_clkdiv_set_rate(struct clk_hw *hw, unsigned long rate, unsigned long parent_rate)
-- 
2.51.0



