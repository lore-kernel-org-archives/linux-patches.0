Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0B633F8A2;
	Sat, 30 May 2026 18:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164315; cv=none; b=cwDBb/IO2IcSDf+kRVU3XFEbfE1wQQEQAScUGiQ/iWChlcRcEyl6OVsrrbbkExfwIfU+QvW7F5qwwkTFOBnlINGeA0AobJCkkzZhVZNZQ2EA9wRcUt1iL0dOYZhKNFIrPdnDlju+BE+abOUtX2e8nXxGPaE/LV7D5y7c0J8OCqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164315; c=relaxed/simple;
	bh=YxlL8uMfi2qWFn6N1eoqR7f4mshKJLaklP+U8ePg8mI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1Cek9sfjhiWmUOj7fxxO6uGSyaOVbEflpov4xUR90GsSDRqiwmYVolH7OZubBbGHlTxwt37+EThAv0SBBgG6sVbMySK+r0utvH6dtwxM8XMNaMLz8AndlxEPrUjd8Qtr+WpNjAqi8W2RFWGbnaTOi5shyHPewNrUMgh9Ac+oPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ntSRl+09; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ntSRl+09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6811F00893;
	Sat, 30 May 2026 18:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164314;
	bh=z1W+Cplh9r2Nct2JmARiY+pkKChDwN1pkk0yayowh6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ntSRl+09kzEaXpe1O/90Q+rDyIoM5eH8OojmVmH+Hpodg7ElGHxBow0PpvQQ8koQ0
	 osQEzNcW7RkF17LozUmeCC/ysp3J1IUibA8E6xfv3gxBLix2APcRryEjeXZ0c+jc8Z
	 uVVmDkE8WQdoHMj1TiiaCKiBD/WgndXGmRW/JCPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 517/776] perf expr: Return -EINVAL for syntax error in expr__find_ids()
Date: Sat, 30 May 2026 18:03:51 +0200
Message-ID: <20260530160253.605482941@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a850fd0be3ee2..45e54c1caa724 100644
--- a/tools/perf/util/expr.c
+++ b/tools/perf/util/expr.c
@@ -275,7 +275,8 @@ int expr__find_other(const char *expr, const char *one,
 	if (one)
 		expr__del_id(ctx, one);
 
-	return ret;
+	/* A positive value means syntax error, convert to -EINVAL */
+	return ret > 0 ? -EINVAL : ret;
 }
 
 double expr_id_data__value(const struct expr_id_data *data)
-- 
2.53.0



