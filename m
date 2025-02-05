Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4B915C13A;
	Wed,  5 Feb 2025 14:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764353; cv=none; b=Le4EsVIQDZMG6C3yqfDsWdh4IqzVUS10y3srmlMl0rbat/133fR69DJSHf6/bzd3+WhZyqCDn8ZxIMxJFEGiA6DAisiOz8ioLh2sHTu0ClIT5Y7LUXTtiOF9jvEMLb89FifabYEe0fUr261nUsPFzMsWLCEVIPurpdUsFMqECoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764353; c=relaxed/simple;
	bh=hffu0T+CYp80z4SkjL3oKgsP7d126LAXPwySP/S0csg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFoQrojQ83fKqG6x5e2h5dS7cbFhBW/9QbiE9cto870Ox276a6FfXPajj8Wz3MYQRw6V3AsDh0PnfuZ21quVpJS/0ZIHXN67gjHSOcSH09Xnn/5jof2Vh7fF1MUJTJhEYOPumdsW6byWvI5O1Kg0MGyoqj11RWB8BasHzy7bOdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3WsVm4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3WsVm4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05083C4CEDD;
	Wed,  5 Feb 2025 14:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764353;
	bh=hffu0T+CYp80z4SkjL3oKgsP7d126LAXPwySP/S0csg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v3WsVm4pJVMaPjKWQfv9T7PPNGG86jbqK1ysT4KWcgIcmabAV09O4vqj4co648nm0
	 Oc+20+M82v7AFfAI/xN5vgGI65MM1Vdr4suehwckhwPO4fbmESP/mWzb4mpJl4Y+s1
	 nHzYYzK0ECY8zXvZYqZIvtU/dH2OKR34KpLgqrGU=
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
Subject: [PATCH 6.6 164/393] perf expr: Initialize is_test value in expr__ctx_new()
Date: Wed,  5 Feb 2025 14:41:23 +0100
Message-ID: <20250205134426.571976167@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b8875aac8f870..fa0473f7a4ff4 100644
--- a/tools/perf/util/expr.c
+++ b/tools/perf/util/expr.c
@@ -292,7 +292,7 @@ struct expr_parse_ctx *expr__ctx_new(void)
 {
 	struct expr_parse_ctx *ctx;
 
-	ctx = malloc(sizeof(struct expr_parse_ctx));
+	ctx = calloc(1, sizeof(struct expr_parse_ctx));
 	if (!ctx)
 		return NULL;
 
@@ -301,9 +301,6 @@ struct expr_parse_ctx *expr__ctx_new(void)
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



