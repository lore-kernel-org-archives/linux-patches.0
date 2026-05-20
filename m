Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC0434EF05;
	Wed, 20 May 2026 16:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296037; cv=none; b=mqzNkyPFKwTEWB22lRqX5PceJpe8gofv69EYzzN3svIl2Hi3Y2aa+isDnFpghB0mx4j6GSFdy3X8srzy8ivcXHGIdUCAOcwRzptjR+dsbcPqvtLKrj+UBIbvAQm4KEgf3LGkp1FQ/uOXb6JeSKMbMEeppHI5/g34qpRnDTUIkJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296037; c=relaxed/simple;
	bh=mk7X6jP6je/nFjMVLwu4awojrSvwYuPj9h3sIs6S72k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c15PSr68H2L03Zx9gV/YirutKVLy42iNxDGJRXgBhFN9Hhu77TXR5Vcy2IreWOXIGRCVuD4MPrYvp5Y1Wfm9fsdiGCub32bh8kEM4288N/LI1/9pd5eY0CniI9g1+IyvtMahIiMtymyyFPGt+i0h6YSF4usq+WReKmg96J4p+ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2QnbqC+n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2QnbqC+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2861F000E9;
	Wed, 20 May 2026 16:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296036;
	bh=v+tu2eLDCtp9zVhDC3uyhQvYoW1F2z4Amb8Kr6jOdNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2QnbqC+naThLW+fJtlgncjcLVejrla/FhxGY+GB5uqOV67VPPyNErjGqp6yMmnWsR
	 RSLzXfBe+9xQ9zC3JZQX81MiqPO8XkiqJnF0YJ/1rV5r+1RNoTTgHtZIevmzphOE6S
	 NRst3BAdet1arr/ueNxkW035W45ymlWVytTbKao8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0645/1146] perf expr: Return -EINVAL for syntax error in expr__find_ids()
Date: Wed, 20 May 2026 18:14:55 +0200
Message-ID: <20260520162202.778865787@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 465fe2e9bbbef..b7664cb68554b 100644
--- a/tools/perf/util/expr.c
+++ b/tools/perf/util/expr.c
@@ -376,7 +376,8 @@ int expr__find_ids(const char *expr, const char *one,
 	if (one)
 		expr__del_id(ctx, one);
 
-	return ret;
+	/* A positive value means syntax error, convert to -EINVAL */
+	return ret > 0 ? -EINVAL : ret;
 }
 
 double expr_id_data__value(const struct expr_id_data *data)
-- 
2.53.0



