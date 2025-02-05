Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A0115A86B;
	Wed,  5 Feb 2025 14:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766427; cv=none; b=q08qYtFA8YPINmq1Aw2ukldzUMMGridwqIcbNQ0Fyvd3sGpwzN+mAQ80mvOaPSekSH7mR7MVxqSOkJxQNIMRyRd2tXY8r2b95lPL5ME/N85xsZ+MpI0q5m7SnRmSjbx6okWJG/dIYAMlHh2ZzbQwd7JtLXDGNqAJM6OF/SqLmP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766427; c=relaxed/simple;
	bh=LaTrJkjasUmq7WZbxBA/Heo5rmjBvrmGToans0GILGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5mdwvZ0e58/R4r1hdDhetAnGJR9V3hD94yQzfdIbBFvmY7kSJP7IreFov+lbwybuPZGgQb08FQpTZYIFRGOgrm+UsmvbzYfk8LeoHDo+mfoG+8X6nEaCy8aZWpSG7vp8DI/UK6YdLPhAu4UqJycCZvIiVUU27rD1uRt0WLK7u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LP8xazAh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LP8xazAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A11C4CED1;
	Wed,  5 Feb 2025 14:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766427;
	bh=LaTrJkjasUmq7WZbxBA/Heo5rmjBvrmGToans0GILGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LP8xazAh567oxuxHU6y29U5807xWviUsBO5LPbiWxOsey4kZLoiGPHXdeSJKUX2UI
	 bxBav8gBLR4aREfhBhwHI8IDQ5fXH4PsPcI04NtbfbX/Zhp2VwaV8nVFq9XojMCcKN
	 YKDOq8GsCKzxYoagsH+0QKhUOlqRszsBgGcW6yRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Levi Yun <yeoreum.yun@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 272/623] perf expr: Initialize is_test value in expr__ctx_new()
Date: Wed,  5 Feb 2025 14:40:14 +0100
Message-ID: <20250205134506.634610949@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Levi Yun <yeoreum.yun@arm.com>

[ Upstream commit 1d18ebcfd302a2005b83ae5f13df223894d19902 ]

When expr_parse_ctx is allocated by expr_ctx_new(),
expr_scanner_ctx->is_test isn't initialize, so it has garbage value.
this can affects the result of expr__parse() return when it parses
non-exist event literal according to garbage value.

Use calloc instead of malloc in expr_ctx_new() to fix this.

Fixes: 3340a08354ac286e ("perf pmu-events: Fix testing with JEVENTS_ARCH=all")
Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Levi Yun <yeoreum.yun@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20241108143424.819126-1-yeoreum.yun@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/expr.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/perf/util/expr.c b/tools/perf/util/expr.c
index f289044a1f7c6..c221dcce66660 100644
--- a/tools/perf/util/expr.c
+++ b/tools/perf/util/expr.c
@@ -285,7 +285,7 @@ struct expr_parse_ctx *expr__ctx_new(void)
 {
 	struct expr_parse_ctx *ctx;
 
-	ctx = malloc(sizeof(struct expr_parse_ctx));
+	ctx = calloc(1, sizeof(struct expr_parse_ctx));
 	if (!ctx)
 		return NULL;
 
@@ -294,9 +294,6 @@ struct expr_parse_ctx *expr__ctx_new(void)
 		free(ctx);
 		return NULL;
 	}
-	ctx->sctx.user_requested_cpu_list = NULL;
-	ctx->sctx.runtime = 0;
-	ctx->sctx.system_wide = false;
 
 	return ctx;
 }
-- 
2.39.5



