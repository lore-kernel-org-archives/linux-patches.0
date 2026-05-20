Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D728A3FA5D5;
	Wed, 20 May 2026 18:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302407; cv=none; b=Vzdz2+tSbME2tKc7Gj9W4krCvu2Y2PKT8o2L0CkHR6a9Vk24yeAvvSAbYNJjN+Lw7XcFpGOLbrsWV+cspgT0ctTj/a5lZuOR13YQR/ZrsWW18LEiUjqq7CGDnW4lzfO/dLipiIb8nZjRP//gcNMkRHIJ0cvpe+oh6laCm3DtiWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302407; c=relaxed/simple;
	bh=tn4n80Hl50CYWpPQvD30/hutT5rw8j2FKgseoRFVxJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFJYDYM8SiBMOojVHp7sAQIJD0gnEbD7Ft/w8LnGFFbdzoaIRhNv0VP9CatlntuVshtm65uoFHWiuTi6irTbNPM94G/cjiIispQNWfyxapOff198fVH1UZ9mPqBby7WXkvt5TcMEb4Le1XmQSoFF7MsMSGZL0pTrepYRZ1xyHpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qu81TS9t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qu81TS9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454D11F0089C;
	Wed, 20 May 2026 18:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302406;
	bh=wHjhS/zZfqUM+5Drzq18mCbxMo+mYLN581AhRwyCgTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qu81TS9tYiGyog8VFZk0Cp5C69F4X5/nAyUlVK0mFeLCIwbR03s6RzWbMNSyGwXED
	 kmGyhTrUHK17T4LiyEET0AdeY0lr9PnHPx6pHIt6afZjUd0ibm+PWBEpWqgMYAsG0t
	 rOcVdM6S18XVdcRCMh6XAH7NDLXUP2EEQJn+SJtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 253/508] perf expr: Return -EINVAL for syntax error in expr__find_ids()
Date: Wed, 20 May 2026 18:21:16 +0200
Message-ID: <20260520162104.131401224@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fa0473f7a4ff4..d952ce37c873b 100644
--- a/tools/perf/util/expr.c
+++ b/tools/perf/util/expr.c
@@ -377,7 +377,8 @@ int expr__find_ids(const char *expr, const char *one,
 	if (one)
 		expr__del_id(ctx, one);
 
-	return ret;
+	/* A positive value means syntax error, convert to -EINVAL */
+	return ret > 0 ? -EINVAL : ret;
 }
 
 double expr_id_data__value(const struct expr_id_data *data)
-- 
2.53.0



