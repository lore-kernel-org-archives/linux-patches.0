Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6D934DB46;
	Wed, 20 May 2026 18:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300952; cv=none; b=dQwiWIAsivJ8SFfF7u976WMU6MgcU+EZoJHQkV6DkQuA+WvtdqGsmAiVSmK8DNQuXNXOaUyR+axDpZ8maRf7KD3+xKSbV0iRMl9mJWAiCXK/gd+6OySGUDbZA0QObRdMFkdSm+p4E3jvqO+SqoO0jy1IGFCHRW40foQxZ2zirrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300952; c=relaxed/simple;
	bh=L7T8mU9U3JlZ4uioISMBAAig2zFR6X/BqXVS4HvomBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jB5cuDl7lVC/7Ys3Th5nuUD91S9xV+7CUBO0TLtXVdT293lbiT7AdhMeEM+283EkaOcO7mgLwir1ej/FX40ontdUTOrzrqyUZNZR7iiA72NrhIcKbrlzqFKLpuWb218n2ZJRIn7FplBAQevw6M9nwvdCURdjOLmBRzAZve9AATg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6GazvgH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6GazvgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D501F000E9;
	Wed, 20 May 2026 18:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300951;
	bh=mopMMH8Iq/51LHEokSY2hhOWbgTo2Acm3de9vcNOOtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J6GazvgHyL5Zshol1SJeI6KOtTpmH4kG0x9hliV2f8DqMcfKS8Jqa+wZBuPDJphhk
	 305VqOL5H3OmgwNVElk++2osjkWIgaNbxRnpRs1oruGri7VH3kpXtVciNYlC+aIfFz
	 UXIx3UCuZZDI564WcleYx2+I1ei2kh2d9IU4YgVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 370/666] perf expr: Return -EINVAL for syntax error in expr__find_ids()
Date: Wed, 20 May 2026 18:19:41 +0200
Message-ID: <20260520162119.261939086@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
index 90c6ce2212e4f..7ceefed276b73 100644
--- a/tools/perf/util/expr.c
+++ b/tools/perf/util/expr.c
@@ -373,7 +373,8 @@ int expr__find_ids(const char *expr, const char *one,
 	if (one)
 		expr__del_id(ctx, one);
 
-	return ret;
+	/* A positive value means syntax error, convert to -EINVAL */
+	return ret > 0 ? -EINVAL : ret;
 }
 
 double expr_id_data__value(const struct expr_id_data *data)
-- 
2.53.0



