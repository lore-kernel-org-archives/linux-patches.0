Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE48B32C952;
	Fri, 17 Oct 2025 15:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713509; cv=none; b=d8Sdr55KVFmPw//fJ1bPIypH2RJVHVIr8wFk9TdL3BQoOyFZAv+bf7H3CIG9FWgrSeaHQVlBeSEDAUZshYwprbvEMd6IpmlGnaVQ/IsMagS5iZFJXIgz0KLUM0Y96raTEqTcx3LNgWD7t/fNxfBPyGJ174r8Lx8EoYdOh+k/1QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713509; c=relaxed/simple;
	bh=PJIwibolVz5cz3ryIpZ4/6hnjtKlDFUFfPjcsa0CzCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVdJQcP/FdNxGuOIybKHtEjluzA+SFcG4iDhz77zF/9/fz95bQGNSiWxt7xkc3EaXzeTcTlHNQZ/Kh2ZJm7in9CQLoHXe3Gvf72Rfey/OdP8SyvEBOscVIRbn1QArq+BAnpOktQxC5fNfuCM0EF4miW97cYikr5BRsiE4guOhbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OwxhxlG9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OwxhxlG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CFDC4CEE7;
	Fri, 17 Oct 2025 15:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713508;
	bh=PJIwibolVz5cz3ryIpZ4/6hnjtKlDFUFfPjcsa0CzCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OwxhxlG9hUM8dxRVTOckd6Xa06egvDrVTxHWjzopr1PsXAqh/TrFzOMA6Eu4/6cED
	 5SajwSwDEhgXaYp9HXWJgAueLU374Q7lnTwegYmdk/L9euTyPWE7gt7nF2wJ3gzGLm
	 MFHKbwzeKsc2WJ2kiEnL2otnA32zlb8XmQsY1aT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/201] clk: mediatek: clk-mux: Do not pass flags to clk_mux_determine_rate_flags()
Date: Fri, 17 Oct 2025 16:51:23 +0200
Message-ID: <20251017145135.559101646@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 5e121370a7ad3414c7f3a77002e2b18abe5c6fe1 ]

The `flags` in |struct mtk_mux| are core clk flags, not mux clk flags.
Passing one to the other is wrong.

Since there aren't any actual users adding CLK_MUX_* flags, just drop it
for now.

Fixes: b05ea3314390 ("clk: mediatek: clk-mux: Add .determine_rate() callback")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mux.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/clk/mediatek/clk-mux.c b/drivers/clk/mediatek/clk-mux.c
index c93bc7f926e5d..359f92df826b5 100644
--- a/drivers/clk/mediatek/clk-mux.c
+++ b/drivers/clk/mediatek/clk-mux.c
@@ -132,9 +132,7 @@ static int mtk_clk_mux_set_parent_setclr_lock(struct clk_hw *hw, u8 index)
 static int mtk_clk_mux_determine_rate(struct clk_hw *hw,
 				      struct clk_rate_request *req)
 {
-	struct mtk_clk_mux *mux = to_mtk_clk_mux(hw);
-
-	return clk_mux_determine_rate_flags(hw, req, mux->data->flags);
+	return clk_mux_determine_rate_flags(hw, req, 0);
 }
 
 const struct clk_ops mtk_mux_clr_set_upd_ops = {
-- 
2.51.0



