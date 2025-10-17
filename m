Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AF42F12BC;
	Fri, 17 Oct 2025 14:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713097; cv=none; b=EBN1fNJXW/JdkVCDNeWtFWHpgCI/1plKeZJPO7YlNKtv/LH+2LFX50o3JAYnJcEH2zZUGzRdTzwgG2caTAbnbVp6L6fxT+tcorg0M0OOaYXcup34uOWzFlLSn4/42cbhxi7fSJuT2K7fnFedg9EIL22++0SPPeLCp1ryHWWzgMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713097; c=relaxed/simple;
	bh=Hx92tjnXU/tJSO1lLukhIChRcXGc6OTkWzvCXdP2BdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/tsvM3i0dOMKJGaHTKmRDhXc8IScHk663w3j5hhoDpFPtqfbYYk83i91cOjQ4oNsnaVZ/FK6IGMi9tBl9wB5lTE5DKtHOpyB5RI6hvz3KtkHjmYAkLTq9QV/PDOOkF5qHoDTQt87SVk9TpIypxBi+Vt/nMTmJZR3+SdbSUcwoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dOZPctlo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dOZPctlo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B87C4CEE7;
	Fri, 17 Oct 2025 14:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713096;
	bh=Hx92tjnXU/tJSO1lLukhIChRcXGc6OTkWzvCXdP2BdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dOZPctloOavEmNWf8aRzLL4zn3PL2y8aEYLiUqMN+cjdN6ymsWrm4VegLCwANSTeO
	 frvigH2G3Z08bj7kN+B16zB4aIDHmSYQbzfBhs1ZSbZkxmK56Ti+z+Twtsw04Yxe5L
	 ZxXasSTrFRtXLWg3YcXY/q1NsRrBPgpFKlB5y+YI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/168] clk: mediatek: clk-mux: Do not pass flags to clk_mux_determine_rate_flags()
Date: Fri, 17 Oct 2025 16:51:38 +0200
Message-ID: <20251017145129.727075030@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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
index c8593554239d6..93fa67294e5ab 100644
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



