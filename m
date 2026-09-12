Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA502D9792;
	Sat, 12 Sep 2026 19:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239733; cv=none; b=IqEb/9YVU0+p261yjCCz65N/ZM+37y/+SOSbMTYW/x08ZnOX0yQwvwdklCfSxnr9xO1DetpkzpkgfOwDwbZ2a4g2vHLeW0Ybewip+hJHubK70/4f0Oq5oGoIK9/2hR5LPOAgSKSZDKlex+yznihrolVn8PIvVPJFmCsX/NsBaic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239733; c=relaxed/simple;
	bh=iQmTCPABMnkbbJTfxD9Ivm+QD5kgv6a0LI6iZMfDSyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMNILaMUnHcpQ4tsiZttfmlMmL7rGOmOkXSM+mtVOfZMB8Y3PAdNZLYrxFv4c7rCUtiH/T4hEgvgQkqpF9nhWMnxbeH+bsQ+k8NEhLArf9ygNuEf+z+QNhiDfQZET0HYfYkAI8BiKlxC9IiHJajf9PLZ7UJpR2XSWijUAk8b2mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZL6QxJ5h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZL6QxJ5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1953A1F000FF;
	Sat, 12 Sep 2026 19:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239732;
	bh=YyJlo0UtclbWRh473B+D/6SQY3jzlOGpteN2MSHGf9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZL6QxJ5hXCMMEIww9TumoOX+w2/Mp5j7Q6Q4fLHXhH6cKJLvC3immAL6z16SKBVon
	 BBGcjFmH0+gnOAyFCXITMhNjtkeWO5TyNXM/5yOugmQ6+snuM0ftretub72XCSJ9qC
	 FpODOF/4wSwol0DQ3cHfkWTtnl3i/P0wd+T1w2ig=
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
Subject: [PATCH 5.15 681/935] perf intel-bts: Fix off-by-one in auxtrace_info minimum size check
Date: Sat, 12 Sep 2026 09:01:51 +0200
Message-ID: <20260912065542.460952328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
index af1e78d76228d..182ebb89afb30 100644
--- a/tools/perf/util/intel-bts.c
+++ b/tools/perf/util/intel-bts.c
@@ -858,7 +858,7 @@ int intel_bts_process_auxtrace_info(union perf_event *event,
 				    struct perf_session *session)
 {
 	struct perf_record_auxtrace_info *auxtrace_info = &event->auxtrace_info;
-	size_t min_sz = sizeof(u64) * INTEL_BTS_SNAPSHOT_MODE;
+	size_t min_sz = sizeof(u64) * (INTEL_BTS_SNAPSHOT_MODE + 1);
 	struct intel_bts *bts;
 	int err;
 
-- 
2.53.0



