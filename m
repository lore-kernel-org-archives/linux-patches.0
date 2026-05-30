Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B36B263F44;
	Sat, 30 May 2026 17:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161642; cv=none; b=FCPaUgZpksG5Oz3JfAIxHS8W8c3PB9/l7eaXOTox0QpSd0bbSzMlJ0yWOI1B6o2DaVi1J8Vnbo3rTVqNhs1CSCIGNrDNus/+pCTh0s3ELlASDjXjNj5+7tYGYvwTFAwuHGFdTY9t0FegsUmVNgLq0JKLlOqKxkjIrJdf6gAsa8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161642; c=relaxed/simple;
	bh=wq2/pXIiss3oaQb9ywXZ+S8L+qOLRK/5Pu6kuyCtYEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cszXqTvOhe5XeC+FUZmkfiT+3Zcd9rXOZQVfC9Q92xq6RxraDPeHz/qJZgKg25/iTWDPpF7DsRhGNwPUl1Urd6JbxUIluULZQ8J/sEqujuM6zMXm8qC5l3Fi2peGWZnAx2yao3rJF2/uw2K+66PtmXhgtxH94DrbgcA/6Dld7to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNONHlez; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNONHlez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03021F00893;
	Sat, 30 May 2026 17:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161641;
	bh=B+ITKMiX3hM0uwPmRtISfJa7xhAr9o7ys1+jKfuA3dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oNONHlezFtzwVFDh5qxUCXejK8RqPwFvXYK+oUt/6kG9Rj2m47YUNiXyOCKj5SWKP
	 ntX4KE7dKXTzsUwUzUhAIvxIMbUDCIjQseV+8HndBACNcgF/70wlmstKvV6ZdIooAV
	 x/dyiKrk28NNbpQydRA2Z7pRqjuq+DG+T3dq0wqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	=?UTF-8?q?Beno=C3=AEt=20Monin?= <benoit.monin@bootlin.com>,
	Nobuhiro Iwamatsu <nobuhiro.iwamatsu.x90@mail.toshiba>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 666/969] clk: visconti: pll: initialize clk_init_data to zero
Date: Sat, 30 May 2026 18:03:10 +0200
Message-ID: <20260530160318.876133201@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 1603cbb64173a0e9fa7500f2a686f4aa011c58b9 ]

Sashiko reported the following:

> The struct clk_init_data init is declared on the stack without being
> fully zero-initialized. While fields like name, flags, parent_names,
> num_parents, and ops are explicitly assigned, the parent_data and
> parent_hws fields are left containing stack garbage.

clk_core_populate_parent_map() currently prefers the parent names over
the parent data and hws, so this isn't a problem at the moment. If that
ordering ever changed in the future, then this could lead to some
unexpected crashes. Let's just go ahead and make sure that the struct
clk_init_data is initialized to zero as a good practice.

Fixes: b4cbe606dc367 ("clk: visconti: Add support common clock driver and reset driver")
Link: https://sashiko.dev/#/patchset/20260326042317.122536-1-rosenp%40gmail.com
Signed-off-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Benoît Monin <benoit.monin@bootlin.com>
Reviewed-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.x90@mail.toshiba>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/visconti/pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/visconti/pll.c b/drivers/clk/visconti/pll.c
index e9cd80e085dc3..a540936196ca3 100644
--- a/drivers/clk/visconti/pll.c
+++ b/drivers/clk/visconti/pll.c
@@ -244,7 +244,7 @@ static struct clk_hw *visconti_register_pll(struct visconti_pll_provider *ctx,
 					    const struct visconti_pll_rate_table *rate_table,
 					    spinlock_t *lock)
 {
-	struct clk_init_data init;
+	struct clk_init_data init = {};
 	struct visconti_pll *pll;
 	struct clk_hw *pll_hw_clk;
 	size_t len;
-- 
2.53.0



