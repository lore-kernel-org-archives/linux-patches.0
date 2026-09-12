Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3902737FC;
	Sat, 12 Sep 2026 10:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209594; cv=none; b=QBOpoevCbjkkS+NsonsLCu4EKKsy3hKoW3SRfW6ZjEcIAqydGzy6gEhfM5LTqncFwBAY6G5F0esDv8jrJPHi4mqa/Nhl/Kfjm/R1jWDtJizuX9goc7/mmaq068JmmlkSEFDv6gWnQ0zP5OJaFTJ/Ewp4vsbQrgKH7XipvzeZnmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209594; c=relaxed/simple;
	bh=BqGDqW4j5hl2RwoCI7CdaTO5p7U7/th5dMUReNKfBoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6bxnArrixwETanxMJvTp0rejN0af4z7bZU/vzKyuYYBwq8Rwf4M6vCCvcUJPbv93mEjIk7HIxyHvuSDlkqU0sYnl9fKxHqLNScY19jIqdZEF3cSwjtNMjiJ+aDE82wavnDlALCORTbe0Z/wjnfG8jloP3kuObjUx3BOFWFQmFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jT2lQ53V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jT2lQ53V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E8C1F000FF;
	Sat, 12 Sep 2026 10:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209590;
	bh=XMalrCUSqOu/nROSY3yPc+fnF0nPTULD5VkCyDwIncQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jT2lQ53VmZEKdciCkzGgyyldcUNGIjmJFWTjgzlX8Iil5EqlmI9FGjpEdsoIdl3SH
	 o9vAFmud+obo4DBHEtvynKuZpjl64//h744zY3ZeFihR09dShN9x+zNFzead27JRjb
	 lBec27YrfsatsuVF6enL2sdp8d855G3SWA10K1WE=
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
Subject: [PATCH 6.18 0852/1518] perf intel-pt: Fix off-by-one in auxtrace_info minimum size check
Date: Sat, 12 Sep 2026 08:50:21 +0200
Message-ID: <20260912065642.722049053@linuxfoundation.org>
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

[ Upstream commit c4362d5e1a5ed4ce2098798f655a636c4340fa20 ]

min_sz is set to sizeof(u64) * INTEL_PT_PER_CPU_MMAPS, but the code
accesses auxtrace_info->priv[INTEL_PT_PER_CPU_MMAPS], which requires
at least INTEL_PT_PER_CPU_MMAPS + 1 elements.  A file with exactly
min_sz bytes of priv data passes the size check but the access reads
one u64 past the validated region.

Use (INTEL_PT_PER_CPU_MMAPS + 1) to ensure the highest accessed index
is within bounds.

Fixes: 90e457f7be087005 ("perf tools: Add Intel PT support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/intel-pt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index 9b1011fe48267..fd636f5639cab 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -4411,7 +4411,7 @@ int intel_pt_process_auxtrace_info(union perf_event *event,
 				   struct perf_session *session)
 {
 	struct perf_record_auxtrace_info *auxtrace_info = &event->auxtrace_info;
-	size_t min_sz = sizeof(u64) * INTEL_PT_PER_CPU_MMAPS;
+	size_t min_sz = sizeof(u64) * (INTEL_PT_PER_CPU_MMAPS + 1);
 	struct intel_pt *pt;
 	void *info_end;
 	__u64 *info;
-- 
2.53.0



