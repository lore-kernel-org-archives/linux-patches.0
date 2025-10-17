Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1FD332ECA;
	Fri, 17 Oct 2025 15:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714216; cv=none; b=DMRzMDFHwYpNOUdiAR27sX322NU9mnDovCPTCsOtsLTaxzRDF/YQNB4jH9bzkAk/0+mkEtNbcvQzphhrxCWUx9hmQ1b2PoUYGLtKQnWbbxNXibaJj+TnTzFO81Tf8HbNiMzmE03a5geIe3jN1145590xG2TxDLRb8r+UiVSRnBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714216; c=relaxed/simple;
	bh=mKGPDx8SfUnVKmer6hKDfS43QfWnO/fdv8YGrg2tZUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FsCv9L36wiBWYxZrgikbKFfNakNcAyebWoaPiuqVGbTAzMY55f69RU7fdUFSp6Ej+TrtRZN+a2dMU8y3aGcaGrWIYoy6bKxYzq3TcyrGx+u6H9+zbrndCtAKixat8rZM3vZ0GTEHtk5ccIcDD2gka9i5CVjk49wC8IIBQvS4NWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sgLXHuRI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sgLXHuRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0F1C4CEE7;
	Fri, 17 Oct 2025 15:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714216;
	bh=mKGPDx8SfUnVKmer6hKDfS43QfWnO/fdv8YGrg2tZUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sgLXHuRIdyeYMGyBzO7N9RkitbdlTPkwA3+4zKT24/30l8GenWxOkPkE+JQIzdequ
	 46YMLhoGtRGvPs6owQIjfkrvoc7vA6cptSfP2Malsp+07NX0IoC+yrh6bliGmVJ4aP
	 6ng140PGi/+V4bfECn5S/A5Xl9SFEYBs4zI61Tls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/277] clk: mediatek: clk-mux: Do not pass flags to clk_mux_determine_rate_flags()
Date: Fri, 17 Oct 2025 16:50:42 +0200
Message-ID: <20251017145148.429915015@linuxfoundation.org>
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
index 60990296450bb..9a12e58230bed 100644
--- a/drivers/clk/mediatek/clk-mux.c
+++ b/drivers/clk/mediatek/clk-mux.c
@@ -146,9 +146,7 @@ static int mtk_clk_mux_set_parent_setclr_lock(struct clk_hw *hw, u8 index)
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



