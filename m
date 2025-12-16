Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E873358A8;
	Tue, 16 Dec 2025 11:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883975; cv=none; b=WhI3CVGJfqQicukY3s/TeGnEHDAeZoel1aXrakaXgp8fRXzChQDs0bKVNusz3gGTuGHH9qv3zS8tCBDlhha36hnRy+TaAi/QFTITHW19KRhzNY8Vh755fn4UNyav7KJuLP5p+PUdJFKtVKnMNrfGlxrC28dMl07ChSX5oXPs3Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883975; c=relaxed/simple;
	bh=D+vmz+KjA1wl8oOVc3g3geEUWNZizbtZpbA8JYDstjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KoNc1lr1qp49+II66/7J5c2vceXpe3RCQmvlAe5l1JTXPcuRNhvMcynt6mj6R7/1P1B7q5sq8VSVqa+RVKx2BTShBE8u+7A+FmSg+mXoVCa/HGRUxLO4FfdpNSPuCWn67sCAOLVFGYKfK7PCk6nLTku0JerD+tpiwbrrfcE3gLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QT0me6Dm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QT0me6Dm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B04C4CEF1;
	Tue, 16 Dec 2025 11:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883975;
	bh=D+vmz+KjA1wl8oOVc3g3geEUWNZizbtZpbA8JYDstjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QT0me6DmMSseCeaynXQMFM3fm4uzqhnmXO3zS4qbOV0zAt0PqQpjQ75aLVdxZVnWg
	 cMuo6CxCKTrJQ9HZ27iRUhb9h+x2U50FSKUE1r5H2ZZJx5qzlGCNywRMDWJsZIGdhJ
	 0rIC0aVKC9u9omOQjGJ1BuQOT7JNeKDRzmltIR8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Tianyou Li <tianyou.li@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/354] perf annotate: Check return value of evsel__get_arch() properly
Date: Tue, 16 Dec 2025 12:10:21 +0100
Message-ID: <20251216111322.875803301@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Tianyou Li <tianyou.li@intel.com>

[ Upstream commit f1204e5846d22fb2fffbd1164eeb19535f306797 ]

Check the error code of evsel__get_arch() in the symbol__annotate().
Previously it checked non-zero value but after the refactoring it does
only for negative values.

Fixes: 0669729eb0afb0cf ("perf annotate: Factor out evsel__get_arch()")
Suggested-by: James Clark <james.clark@linaro.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tianyou Li <tianyou.li@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/annotate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 37ce43c4eb8f6..cb8f191e19fd9 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -974,7 +974,7 @@ int symbol__annotate(struct map_symbol *ms, struct evsel *evsel,
 	int err, nr;
 
 	err = evsel__get_arch(evsel, &arch);
-	if (err < 0)
+	if (err)
 		return err;
 
 	if (parch)
-- 
2.51.0



