Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAEE41F379;
	Sat, 12 Sep 2026 10:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209597; cv=none; b=qbCQcxxJ5QktcqI2il6mXWrmY5x4UxeIpdcvwaFo+pS5gWP6muz68meJQltdPPsmL65QGjh4Rr428xXMd8z4NKUYt6cJMhVDJ7rLVjBhlFaMhQhkpvMETLliaDvOoi58IYI3R/xoWtsP0UnB42sZWGIZ3NnZ6RYSiO/O3s8y2Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209597; c=relaxed/simple;
	bh=FSqoCh5vm4AwPlbcbvuw/5b1883DktJoXlJau8CTonc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d3JQXpoznsdHa9ioilKJvCeME38U99VIhbrg3zTnaA1mDbg3irjCfLBPE52WaQnRci9KmVhJN3nhZTTcR22+T3bXnwrlvu7+2RXVCnR0GYaDo2tBGfBYnvWPqXaObztEZqhc49CP+r/IAnNmyl1gTv0BoAn6vEYrGnaXd1S2Ndg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFmnmqE7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFmnmqE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1D71F000FF;
	Sat, 12 Sep 2026 10:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209595;
	bh=l7XB18g0pOlcKf2c9UkiL5h9t5BCsyIrdCtvNO5lkGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UFmnmqE7ZEU34jacmMPSOnHvCH/zgN5dwZlml8OPKum/YDskHgOsaoOOEqgx0sy6I
	 +oicGclkI1cSzNuTPORZ0ORY8cwAt5vB+9cB5IYxk1MDKzp0CbyaiYMkC/QxhdCDRc
	 ZuZMVFx0IbteNF0zlEBBdLEIwoVquTpvhdrtfqgo=
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
Subject: [PATCH 6.18 0853/1518] perf intel-bts: Fix off-by-one in auxtrace_info minimum size check
Date: Sat, 12 Sep 2026 08:50:22 +0200
Message-ID: <20260912065642.744839391@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3625c62247502..9f5f378cf7743 100644
--- a/tools/perf/util/intel-bts.c
+++ b/tools/perf/util/intel-bts.c
@@ -831,7 +831,7 @@ int intel_bts_process_auxtrace_info(union perf_event *event,
 				    struct perf_session *session)
 {
 	struct perf_record_auxtrace_info *auxtrace_info = &event->auxtrace_info;
-	size_t min_sz = sizeof(u64) * INTEL_BTS_SNAPSHOT_MODE;
+	size_t min_sz = sizeof(u64) * (INTEL_BTS_SNAPSHOT_MODE + 1);
 	struct intel_bts *bts;
 	int err;
 
-- 
2.53.0



