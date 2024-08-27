Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E73DDC1;
	Tue, 27 Aug 2024 14:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770107; cv=none; b=TfKYTruLUjrtamh9MuTB1XrwAnhCx6KdtDXsnMpKRQ4IUsSG6OG2x/Bo8mTuy/zppy+XEhu+yj9SxaGgnnHqbg+CIv9Hiz0E226oU0ZKCvRxV2wOnKLpSVsC79O5yozBv80BMsn7rrIYRo0Cc3iDb7xOmm5QC/7rdZaPW1yT4N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770107; c=relaxed/simple;
	bh=ahU1hCT/+BsBAF11OUihw4kM1OJBWmozfstSfnxBjZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0GBa4D/sur18dqxXx4To1XR2PKmUfWjyKzSx3NkGsrWqpEPDf7N+4AwXvowMFxSpVgGd5k8qyH+SvR/Vn3IgxyWkOizNNuAH5nHuacHSw+MS83SwnKeG1caNwYZnVHMjuClT+Pr83++4id7trk78yqcevQkBKUAXhuLU3w6Pjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OrsWd4Pj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OrsWd4Pj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58E1C61047;
	Tue, 27 Aug 2024 14:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770107;
	bh=ahU1hCT/+BsBAF11OUihw4kM1OJBWmozfstSfnxBjZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OrsWd4PjsrzPmFcNEDYcgcOKe+jREhu2D7uWF46kfx3ADFQ5KXwtyr9Pyt6cPrgYF
	 aFcXkPBuAVuixYURl+CKuB8+bSIIWg9/5skC5IF88meRJn2yYnwjZzVC7cfKQZ1/ls
	 HNGezNA/oUmBIKMkg4YevPGQOBB16t3SPz8N6qPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/341] clk: visconti: Add bounds-checking coverage for struct visconti_pll_provider
Date: Tue, 27 Aug 2024 16:36:01 +0200
Message-ID: <20240827143848.363672912@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



