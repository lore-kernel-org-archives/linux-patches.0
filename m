Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FC936B048;
	Tue,  6 Jan 2026 17:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722143; cv=none; b=tjzYIM8AiBo8q0DE2TCZ21iA+hYnRIjErb2bP+9WsNMwrI66quM6CDZMoS1ksxMZlD7PfbqexcQC2YXYnJzeLLEa2NMDAXyoXGvu+fVTME9FGcYv2RCiktr/Y4pg4hqGqH9KgTPuebveyqqI991RbhEOsh1N097jxos/PDA2tI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722143; c=relaxed/simple;
	bh=43ZkreO2TA02QfvzlZ5UJ2U8G9ZNMRi+aj900q6EUNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBeWuKUckQaiI08cMAVeiB/qgVbm1Mxf0lyJk4PCNpLUgIOl9UyEwHybjXAFZnCimtYOLBNIByEa248vwV/HZQ8CVH2U28V2g6/fxiEoFX2cLokurgU97S8u/dxQ/qxk2NfTLg0JL7lVUkUOuc03SwucSuwkDpicMSHHzp9ZrOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQCudE2B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQCudE2B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDDFC116C6;
	Tue,  6 Jan 2026 17:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722143;
	bh=43ZkreO2TA02QfvzlZ5UJ2U8G9ZNMRi+aj900q6EUNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQCudE2BFFkY5rCrS6hHyUXGpdxp+uWAWOf7B0zWbknGq3U2aBXe+wEMIbUpQq1pk
	 p9UwV3VXVJfUgBEFbCaocOf575JrNvVNUu31A8lkXTkkC1GMwqg+aBIvUDbdz9qanN
	 Gy18Sxt7WXiDEMDmsdgQOkFfKdCDgyypb37EC8/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sandipan Das <sandipan.das@amd.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6.18 161/312] perf/x86/amd/uncore: Fix the return value of amd_uncore_df_event_init() on error
Date: Tue,  6 Jan 2026 18:03:55 +0100
Message-ID: <20260106170553.661971273@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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
@@ -656,14 +656,11 @@ static int amd_uncore_df_event_init(stru
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


