Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3061FB3;
	Tue, 27 May 2025 17:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368096; cv=none; b=sLMQ6MSH3y5YK1q3HtmvEpos1ybUxlPelUngBwfAA6BU82OX/6PXiW+MTFwGq2Cx0TJdLjHhoEDvf6EwaoTObL2kj+vgnWp3J3/b/9Azp7+re+3PRnB057AM6St0azVIWW9KcUssT90aIJ/gmJG4s0uGRdejeL2Ua42nea/ts2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368096; c=relaxed/simple;
	bh=VsjAuVXLEJsa0mldV/LAwdl/nnJOE3Ufaxkh2k12deU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/Cidi4HAYeBe5K+tqE0LrKsuduuRsoGVEWeXqTOhpqb0S+eoeDyjsIowrBN9e4Aa3+QSP9cz30ZxUL5mIwfUY673ZCQWMoPRWITdyNZ8giOeZBtntir+ndWlZeQyFUmaop6T1WeVSMXFxXt1vxFODKx5GRExEFzwBhUNiFKkGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i+om0Pe5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i+om0Pe5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F7FC4CEE9;
	Tue, 27 May 2025 17:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368094;
	bh=VsjAuVXLEJsa0mldV/LAwdl/nnJOE3Ufaxkh2k12deU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+om0Pe5nrHwQzR5qYPPZvNT4v1RR4SS0LjaJVdvbMWkLUaDkJPEgpzk4QeJYfryr
	 +2oJ9AM5gk/cpvp7DldFF9UnccKReBVn9v46YmKkS+s7JZH6petuZDFbW68Pq0EluD
	 WuorGoGW1YJw1jCkyd2xoQ66bvYnAm+RzsJjeM3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 596/783] perf/amd/ibs: Fix ->config to sample period calculation for OP PMU
Date: Tue, 27 May 2025 18:26:33 +0200
Message-ID: <20250527162537.408306536@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ravi Bangoria <ravi.bangoria@amd.com>

[ Upstream commit 598bdf4fefff5af4ce6d26d16f7b2a20808fc4cb ]

Instead of using standard perf_event_attr->freq=0 and ->sample_period
fields, IBS event in 'sample period mode' can also be opened by setting
period value directly in perf_event_attr->config in a MaxCnt bit-field
format.

IBS OP MaxCnt bits are defined as:

  (high bits) IbsOpCtl[26:20] = IbsOpMaxCnt[26:20]
  (low bits)  IbsOpCtl[15:0]  = IbsOpMaxCnt[19:4]

Perf event sample period can be derived from MaxCnt bits as:

  sample_period = (high bits) | ((low_bits) << 4);

However, current code just masks MaxCnt bits and shifts all of them,
including high bits, which is incorrect. Fix it.

Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lkml.kernel.org/r/20250115054438.1021-4-ravi.bangoria@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/ibs.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 5d975c39701cb..58ad23205d59d 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -274,7 +274,7 @@ static int perf_ibs_init(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	struct perf_ibs *perf_ibs;
-	u64 max_cnt, config;
+	u64 config;
 	int ret;
 
 	perf_ibs = get_ibs_pmu(event->attr.type);
@@ -321,10 +321,19 @@ static int perf_ibs_init(struct perf_event *event)
 		if (!hwc->sample_period)
 			hwc->sample_period = 0x10;
 	} else {
-		max_cnt = config & perf_ibs->cnt_mask;
+		u64 period = 0;
+
+		if (perf_ibs == &perf_ibs_op) {
+			period = (config & IBS_OP_MAX_CNT) << 4;
+			if (ibs_caps & IBS_CAPS_OPCNTEXT)
+				period |= config & IBS_OP_MAX_CNT_EXT_MASK;
+		} else {
+			period = (config & IBS_FETCH_MAX_CNT) << 4;
+		}
+
 		config &= ~perf_ibs->cnt_mask;
-		event->attr.sample_period = max_cnt << 4;
-		hwc->sample_period = event->attr.sample_period;
+		event->attr.sample_period = period;
+		hwc->sample_period = period;
 	}
 
 	if (!hwc->sample_period)
-- 
2.39.5



