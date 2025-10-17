Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137AB337110;
	Fri, 17 Oct 2025 15:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714974; cv=none; b=fQNhvvpDOXgxM3GIqcTcMJn5z/D3ijU25ww3ZxEzavDDWYj0f00MhoIW22tzA1MsKA78jMsXCQIwr73Y+TDFhIADBoQU9p7WfjzgSe3DyAYJ37NzjN3WnI4JXIMDjULTGn0lBVIzzCOyeoPUH0rDtwCOGv43tMjKa+1OeN/FJ+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714974; c=relaxed/simple;
	bh=zqSQGbjneAmNbXgQIx0nPA+gjBzReAe3wSrmiAQL7pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jpcf6pkUSMoWHX87+TbfR3oArWNzLF1wZncr+TGf9n6Ptw6DNJAbs9PY7bojN+MtxXEYoz1xTwhmGeOui9k3eq+oUFYlEsrhGnFw19GQf4sSpVlcwK07Orr6khPC3bNQARzyvmLRIXZRuA0NJ/s7vGtg98BoozBf1e+lwrEYA1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ff6107Z/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ff6107Z/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878FBC4CEE7;
	Fri, 17 Oct 2025 15:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714973;
	bh=zqSQGbjneAmNbXgQIx0nPA+gjBzReAe3wSrmiAQL7pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ff6107Z/jDaENsVmx7kKSMGPf0D49NUDt9hqRb8nPMyM0CZtobhVm6W18wBjqndl/
	 daIHiWYaxpsI+4IX/zZd8ZeMWLOOKLfEUScOgzn1wx4o5GDT6EA8HW2E3gBJri5Ej4
	 1H+py+xADcTL9eVzXBgBoWLoFMpPR68fvVCtOTpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 052/371] clk: mediatek: clk-mux: Do not pass flags to clk_mux_determine_rate_flags()
Date: Fri, 17 Oct 2025 16:50:27 +0200
Message-ID: <20251017145203.682865354@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



