Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F7C1519AF;
	Wed,  5 Feb 2025 14:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765841; cv=none; b=QQff6hOEojQUNis1uWAZtlsEFjehAMzuutZA0t2mJcAR6CPCUGi6QBt6FmSaC68Q5SBG4i1/5KIZPqvCwQRkkuDI7jvzBEEUL6nv242mXWW51ORL8MX3loeMMaUMLYIuq1YSut/IkO+GtwfGax/GTzwotbOKQEV6f8Ulj63Wr3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765841; c=relaxed/simple;
	bh=pm+WncoVjjC+XdAsRbiV6Mc+zlbKJoyMZfnO5u7AnQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPekJTx+3k+G4fnU6yONygQoEQyBy+Y5tge2EV0YBmtYq5H1/DsJP3vcsO9TU1CYjtC4On4vnh17tNwKcuDlHrdoeuMGMYel7mK3xYmyx64QFzzFoVg+qzPFIxkMD+oekHbuvClp7QKFq4RmEBhM29iQoe3hcfH6RzeBz70l/dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DmarlUUB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DmarlUUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6B2C4CED1;
	Wed,  5 Feb 2025 14:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765841;
	bh=pm+WncoVjjC+XdAsRbiV6Mc+zlbKJoyMZfnO5u7AnQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DmarlUUBthODRwTYe43+iClHZYFvdHw5c856S/cgKj22qQA/hQ8i4+3WqA6p7x+2J
	 dxqj520Y7YV+keJujoFItBwNq+0krgrcq/J2QlI1SIdCp3AojLBzonBk9W0oC6aGej
	 QuWIf7Bj1W/ePuQN/okj3BlT18Bulh25aIUAlrAI=
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
Subject: [PATCH 6.12 254/590] perf expr: Initialize is_test value in expr__ctx_new()
Date: Wed,  5 Feb 2025 14:40:09 +0100
Message-ID: <20250205134504.995827339@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b2536a59c44e6..90c6ce2212e4f 100644
--- a/tools/perf/util/expr.c
+++ b/tools/perf/util/expr.c
@@ -288,7 +288,7 @@ struct expr_parse_ctx *expr__ctx_new(void)
 {
 	struct expr_parse_ctx *ctx;
 
-	ctx = malloc(sizeof(struct expr_parse_ctx));
+	ctx = calloc(1, sizeof(struct expr_parse_ctx));
 	if (!ctx)
 		return NULL;
 
@@ -297,9 +297,6 @@ struct expr_parse_ctx *expr__ctx_new(void)
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



