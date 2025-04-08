Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5352206F18;
	Tue,  8 Apr 2025 12:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114735; cv=none; b=K+hQiWLEQj/ePeYKvYC3mMBu98mTwvyIC+NZ23V8kK5jIM+9tzJCrCMdIIJh2NAGM8xtaaTKZU5dexQBssiW+uvNE7iPYhMyaggb96q2+G4oeGKWD3KB6OA7o2+VrdD0dJvgWS7EesRxiJ0VIT6UBtMZTaTndyjtmN84ipnBGJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114735; c=relaxed/simple;
	bh=I1llT2oDtEOxrzhiIG46LdmlgMUuxHAWAPHfzQf/Eiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2mBA3xzYOXbEBcnZ+51mTBt/jMU9zAf3Dm0EdxIeqxJs1IanSaYViytZIGGvHcmijX75UB3aNHQSkwLzgZSG/4d9QvAkOPNg1ywcA6bWANhkpIPoDuo/bwTZUubYqeZL3ZI0NQ+DmaOM8K1wxpKfG9hkqjYjEvsJQAsHQOFmGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7MZCS2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7MZCS2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E91C4CEE5;
	Tue,  8 Apr 2025 12:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114735;
	bh=I1llT2oDtEOxrzhiIG46LdmlgMUuxHAWAPHfzQf/Eiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7MZCS2xjJ5BmFCaUv10hKVHXk4AWpsoG4bGWRyxvX18KFge5muk38h7pFf7LVHVg
	 C6dIOvPb/1I+elvsuCprJW57z8Hefxau4veeUdUBpjfO6cnxBnzD7Vc9F1cTYxu76m
	 2Orsbu8KASbWeeoKnQp/YKSC5+YjsxN4HuvDXh0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 209/499] perf tests: Fix Tool PMU test segfault
Date: Tue,  8 Apr 2025 12:47:01 +0200
Message-ID: <20250408104856.419617768@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

From: James Clark <james.clark@linaro.org>

[ Upstream commit 615ec00b06f78912c370b372426190768402a5b9 ]

tool_pmu__event_to_str() now handles skipped events by returning NULL,
so it's wrong to re-check for a skip on the resulting string. Calling
tool_pmu__skip_event() with a NULL string results in a segfault so
remove the unnecessary skip to fix it:

  $ perf test -vv "parsing with PMU name"

  12.2: Parsing with PMU name:
  ...
  ---- unexpected signal (11) ----
  12.2: Parsing with PMU name         : FAILED!

Fixes: ee8aef2d2321 ("perf tools: Add skip check in tool_pmu__event_to_str()")
Signed-off-by: James Clark <james.clark@linaro.org>
Reported-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Acked-by: Kan Liang <kan.liang@linux.intel.com>
Tested-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250212163859.1489916-1-james.clark@linaro.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/tool_pmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/tests/tool_pmu.c b/tools/perf/tests/tool_pmu.c
index 187942b749b7c..1e900ef92e378 100644
--- a/tools/perf/tests/tool_pmu.c
+++ b/tools/perf/tests/tool_pmu.c
@@ -27,7 +27,7 @@ static int do_test(enum tool_pmu_event ev, bool with_pmu)
 	parse_events_error__init(&err);
 	ret = parse_events(evlist, str, &err);
 	if (ret) {
-		if (tool_pmu__skip_event(tool_pmu__event_to_str(ev))) {
+		if (!tool_pmu__event_to_str(ev)) {
 			ret = TEST_OK;
 			goto out;
 		}
@@ -59,7 +59,7 @@ static int do_test(enum tool_pmu_event ev, bool with_pmu)
 		}
 	}
 
-	if (!found && !tool_pmu__skip_event(tool_pmu__event_to_str(ev))) {
+	if (!found && tool_pmu__event_to_str(ev)) {
 		pr_debug("FAILED %s:%d Didn't find tool event '%s' in parsed evsels\n",
 			 __FILE__, __LINE__, str);
 		ret = TEST_FAIL;
-- 
2.39.5



