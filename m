Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC86137B407;
	Sat, 12 Sep 2026 08:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201557; cv=none; b=a1H6FN+qr60pkxp6wV7jMpFpJQmwsxxqvKAG1ZrfqBl9GmApNlHlIEpWr4g7bZqh3kJ+GVj+QbCvBxK7SEg613ZDcsnH6MVPWwoGli4JKympoRnJluKs6N3C1VtbhExAc2yvYMeGRMY+B5mFcJ8Owfg4lEP0B0aMJ59r/iChZbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201557; c=relaxed/simple;
	bh=Qwz9RWaX6HMic/bfoG8pEiimBxOuwpVcEI232D1rfdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SW9dp76gh8qf7ArPp+IS9ZGtHAmYX+RfC+MmJ80raiIgvWZJwQyUJVghcoHLznjcVoMD4Y+wGNNjfxegK4j5VdbwiYgwRzBwKEHnM6sCDxjx4CdYbsE1ykmEvTw4bVZ1UUnvoGWVxwmXQG54UnHQaYxgvkKHzZRjAFPZpZGc7JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWiVmYZI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWiVmYZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2AA71F000FF;
	Sat, 12 Sep 2026 08:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201556;
	bh=hjjga0CHYcpRwEq2DDDhn2jrT2Mkc//IAhYC35WXOmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iWiVmYZIhp/FqY8ZVex/d1CP0CwLXIUxH/gunfnDamQWXPQMRMY1FDkoGwhp5Yayi
	 JFGc9qLwto/cezn0QBHWAhjfq/Q5BI7D6FODLu1OcHh0WVre+9J1lSzoiX8oBEPSLv
	 SvDogbF2lM23OWtKN1AELfYiloxVgfPpdRthr8ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1021/1815] perf intel-bts: Fix off-by-one in auxtrace_info minimum size check
Date: Sat, 12 Sep 2026 08:46:11 +0200
Message-ID: <20260912065712.984821605@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit b9fb8225951ce27e62a2235a71f3ab01137aaec3 ]

Same pattern as the Intel PT fix: min_sz is set to
sizeof(u64) * INTEL_BTS_SNAPSHOT_MODE, but the code accesses
auxtrace_info->priv[INTEL_BTS_SNAPSHOT_MODE], which requires at least
INTEL_BTS_SNAPSHOT_MODE + 1 elements.

Use (INTEL_BTS_SNAPSHOT_MODE + 1) to ensure the highest accessed index
is within bounds.

Fixes: d0170af7004dce9c ("perf tools: Add Intel BTS support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/intel-bts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/intel-bts.c b/tools/perf/util/intel-bts.c
index 0b18ebd13f7c8..02df3e4604891 100644
--- a/tools/perf/util/intel-bts.c
+++ b/tools/perf/util/intel-bts.c
@@ -830,7 +830,7 @@ int intel_bts_process_auxtrace_info(union perf_event *event,
 				    struct perf_session *session)
 {
 	struct perf_record_auxtrace_info *auxtrace_info = &event->auxtrace_info;
-	size_t min_sz = sizeof(u64) * INTEL_BTS_SNAPSHOT_MODE;
+	size_t min_sz = sizeof(u64) * (INTEL_BTS_SNAPSHOT_MODE + 1);
 	struct intel_bts *bts;
 	int err;
 
-- 
2.53.0



