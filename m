Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE17C30E829;
	Sat, 30 May 2026 17:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161492; cv=none; b=j+x9OfLrpLyjxb1i+UBAjbp0EYc9aoMDeAEKzaidInCBQ2iaG3yg/tNzri1eP3++1qrbDOpEZsRsRILAbVSfDNv1eDzzWUexFThj/zpGmXxqtk8oVPToMmc/94EQJJ3indpLWZNE+0d9Ath65wp3E+SFczxjN6PBq2sxgElQGEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161492; c=relaxed/simple;
	bh=DKHSCYwHwZRIwdRWD7HOxqCvlt00GcBv7uBNdMhn6tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9wYUjSEdW2eAxSXWtn6ZJZj4LOKQejodrm8FM953H57KRBeAWsWYAcE/iAg19VybuBB9bLg9u0Vgc10U9vZGuIR3JsD7L24M8JCbG9vSjzX6DP/ntkYGivFeLK32ya6NCBvFY7QlyYnHwZ7d0xUyxrUQUs6Iv0T5JiM9VyiYCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=keteOori; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="keteOori"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E211F00893;
	Sat, 30 May 2026 17:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161491;
	bh=7mztmAQjvCDzaE+TNyX3EWpiCtzVumCR+WkRm9Cxg64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=keteOoriLKb+WrzcNIwED9jNYg/lyNPUA3+Mg790d2dcGVti/A9tBqirZbWBpYbn8
	 FagFSC3tStdJ1aU2/UnqxA2fudZOACF6Kgx++Ed9OqsKIplAqCdmaNXdmWwaAINHeL
	 w9SKw8ludgprNdNdTdsmPW4QoZbayqzTR1QtTvmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 632/969] perf expr: Return -EINVAL for syntax error in expr__find_ids()
Date: Sat, 30 May 2026 18:02:36 +0200
Message-ID: <20260530160317.903098961@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 3a61fd866ef9aaa1d3158b460f852b74a2df07f4 ]

expr__find_ids() propagates the parser return value directly.  For syntax
errors, the parser can return a positive value, but callers treat it as
success, e.g., for below case on Arm64 platform:

  metric expr 100 * (STALL_SLOT_BACKEND / (CPU_CYCLES * #slots) - BR_MIS_PRED * 3 / CPU_CYCLES) for backend_bound
  parsing metric: 100 * (STALL_SLOT_BACKEND / (CPU_CYCLES * #slots) - BR_MIS_PRED * 3 / CPU_CYCLES)
  Failure to read '#slots' literal: #slots = nan
  syntax error

Convert positive parser returns in expr__find_ids() to -EINVAL, as a
result, the error value will be respected by callers.

Before:

  perf stat -C 5
  Failure to read '#slots'Failure to read '#slots'Failure to read '#slots'Failure to read '#slots'Segmentation fault

After:

  perf stat -C 5
  Failure to read '#slots'Cannot find metric or group `Default'

Fixes: ded80bda8bc9 ("perf expr: Migrate expr ids table to a hashmap")
Signed-off-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/expr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/expr.c b/tools/perf/util/expr.c
index aaacf514dc09c..2afd561a7aab9 100644
--- a/tools/perf/util/expr.c
+++ b/tools/perf/util/expr.c
@@ -380,7 +380,8 @@ int expr__find_ids(const char *expr, const char *one,
 	if (one)
 		expr__del_id(ctx, one);
 
-	return ret;
+	/* A positive value means syntax error, convert to -EINVAL */
+	return ret > 0 ? -EINVAL : ret;
 }
 
 double expr_id_data__value(const struct expr_id_data *data)
-- 
2.53.0



