Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085C82DC321;
	Sat, 12 Sep 2026 15:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226537; cv=none; b=G+YSNG4iFO3qyk4EpVPPXEdhk3GAXORSmaw79L/K++RJmA7YP+4l1wT1qLX413JJN0y0fTt6EXNyYGOXXbhD5Kwmw/ep+KCKbM8pa23ncDzKTJXJ40buzzFppvtfaPnfAxbnW/5ZlSByaAoHej7Szj8GWi6bANh+UIQJrUQGPkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226537; c=relaxed/simple;
	bh=qgeExG2bHt9x51FUxBPM27q7KuuZWIu9/ayQdvxbEfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OK7yrjiD9s9jOZmaFrKO2yWvd/pmHBdeHCB9HX+F8yvYd8JB3nOxdH0RvXwTCS6Hf467vL4omp1D0x1LsAKs9SOSqZccyFU7tP8wISYENAWb1olgRFdCbpykIHEV7iRgQJDTdJxMUg7cAZPODqhsFVj/yiXqrm+nYVGHw6QECRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gMZ8IJZi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gMZ8IJZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49AD1F000FF;
	Sat, 12 Sep 2026 15:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226535;
	bh=XoZHf2iCBc6R6T0Yc8MM9cqZrVYTu4N3BIPIJz0bksM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gMZ8IJZi6Ovt7SCv161RhmZ75znEkSydo8WWGwMOgEYDEZkXGCJhNTLlUmzFslTzQ
	 ncAB6Ob/+RIjL0Bdb4VGhYjifEXhAVdkE7TURG1l6XCaa9qK0GnoOwc2ksBb8LXuZN
	 xKmz5aoC0WKiTFmpmARUGxvfkawZKSOX38IolhAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sandipan Das <sandipan.das@amd.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6.6 1423/1424] perf/x86/amd/uncore: Fix the return value of amd_uncore_df_event_init() on error
Date: Sat, 12 Sep 2026 09:04:15 +0200
Message-ID: <20260912065639.126194372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Sandipan Das <sandipan.das@amd.com>

commit 01439286514ce9d13b8123f8ec3717d7135ff1d6 upstream.

If amd_uncore_event_init() fails, return an error irrespective of the
pmu_version. Setting hwc->config should be safe even if there is an
error so use this opportunity to simplify the code.

Closes: https://lore.kernel.org/all/aTaI0ci3vZ44lmBn@stanley.mountain/

Fixes: d6389d3ccc13 ("perf/x86/amd/uncore: Refactor uncore management")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/076935e23a70335d33bd6e23308b75ae0ad35ba2.1765268667.git.sandipan.das@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/amd/uncore.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -546,14 +546,11 @@ static int amd_uncore_df_event_init(stru
 	struct hw_perf_event *hwc = &event->hw;
 	int ret = amd_uncore_event_init(event);
 
-	if (ret || pmu_version < 2)
-		return ret;
-
 	hwc->config = event->attr.config &
 		      (pmu_version >= 2 ? AMD64_PERFMON_V2_RAW_EVENT_MASK_NB :
 					  AMD64_RAW_EVENT_MASK_NB);
 
-	return 0;
+	return ret;
 }
 
 static int amd_uncore_df_add(struct perf_event *event, int flags)


