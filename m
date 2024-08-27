Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7C61C689C;
	Tue, 27 Aug 2024 15:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772294; cv=none; b=oNe8SS+Ittq0Fb/qNP5+ljoAdor3FqfvshaMEYLtEB8WovJsCXa8kuePxhi6hHCNqq+0FUwAt5pfDM5d4dF9qXvPHu2hTt9Iz03DEP9ggOXfzEe3Uo8d/18cOYpRUY3oR1llFOaTnZ0f0k6RZdQO994glH0lr8vqshCtMBgyu7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772294; c=relaxed/simple;
	bh=mJugoMKZaO8QmixlGDQhOssOuIK04DIE4AmGL5jOxuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUD5J5Ha6k6U7BIzltVjVukmwZTUIOueuwU/kMeMqwNqYarHEA1OSaOJd+OdnuM8DpUl1WOS+4QNbsjNs1UNb2hm2TbKuD2XU1EtgKO68GLzIueYjM2zm/A/jBvR0JlXqnVC1C3bQX/GwIZl9hJvvN3GSiTHfTAAkAFg8w4m6Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a2vN8Lxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a2vN8Lxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EBDC61071;
	Tue, 27 Aug 2024 15:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772293;
	bh=mJugoMKZaO8QmixlGDQhOssOuIK04DIE4AmGL5jOxuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a2vN8Lxd/e435GTpFN/KH4gpTRwvlRs7DOxk+YIB9V+6Spq+hyQ1PosubZNL/xSnx
	 XXYz97hf7UpMKQwpe9XXs5ppSx2nCT2+wd5EeIw6U1c+9g2rKS1rZ39KgGXGM0wObX
	 sioMqRDHyrQRZvMHR0J7KFuR3SJgqq9k2wStgs5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 140/321] clk: visconti: Add bounds-checking coverage for struct visconti_pll_provider
Date: Tue, 27 Aug 2024 16:37:28 +0200
Message-ID: <20240827143843.568906101@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 397d887c1601a71e8a8abdb6beea67d58f0472d3 ]

In order to gain the bounds-checking coverage that __counted_by provides
to flexible-array members at run-time via CONFIG_UBSAN_BOUNDS (for array
indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family functions),
we must make sure that the counter member, in this particular case `num`,
is updated before the first access to the flex-array member, in this
particular case array `hws`. See below:

commit f316cdff8d67 ("clk: Annotate struct clk_hw_onecell_data with
__counted_by") introduced `__counted_by` for `struct clk_hw_onecell_data`
together with changes to relocate some of assignments of counter `num`
before `hws` is accessed:

include/linux/clk-provider.h:
1380 struct clk_hw_onecell_data {
1381         unsigned int num;
1382         struct clk_hw *hws[] __counted_by(num);
1383 };

However, this structure is used as a member in other structs, in this
case in `struct visconti_pll_provider`:

drivers/clk/visconti/pll.h:
 16 struct visconti_pll_provider {
 17         void __iomem *reg_base;
 18         struct device_node *node;
 19
 20         /* Must be last */
 21         struct clk_hw_onecell_data clk_data;
 22 };

Hence, we need to move the assignments to `ctx->clk_data.num` after
allocation for `struct visconti_pll_provider` and before accessing the
flexible array `ctx->clk_data.hws`. And, as assignments for all members
in `struct visconti_pll_provider` are originally adjacent to each other,
relocate all assignments together, so we don't split up
`ctx->clk_data.hws = nr_plls` from the rest. :)

Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/e3189f3e40e8723b6d794fb2260e2e9ab6b960bd.1697492890.git.gustavoars@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/visconti/pll.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/visconti/pll.c b/drivers/clk/visconti/pll.c
index 1f3234f226674..e9cd80e085dc3 100644
--- a/drivers/clk/visconti/pll.c
+++ b/drivers/clk/visconti/pll.c
@@ -329,12 +329,12 @@ struct visconti_pll_provider * __init visconti_init_pll(struct device_node *np,
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
-	for (i = 0; i < nr_plls; ++i)
-		ctx->clk_data.hws[i] = ERR_PTR(-ENOENT);
-
 	ctx->node = np;
 	ctx->reg_base = base;
 	ctx->clk_data.num = nr_plls;
 
+	for (i = 0; i < nr_plls; ++i)
+		ctx->clk_data.hws[i] = ERR_PTR(-ENOENT);
+
 	return ctx;
 }
-- 
2.43.0



