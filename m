Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1E7225A3B;
	Tue,  6 Jan 2026 17:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721067; cv=none; b=cYts3lqBIGpSmdUpDZG/OlAtSLsB61WsQhV/42U0Zi6RzG5mOCdtN8fRrTnIdqnPYIr1t0eAN21Jzt21+wm/T9A0rHQIUsHK9T2ADgxiH18+yBGoAW2aXYg6aFmxCpoj+1Edkj8CraNS2Em+sZOuidP7FbP1rz6PMUJ8/XXHaNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721067; c=relaxed/simple;
	bh=8V81BwuHmz4IakOAZcI6bSMMQxACn9z4nYpmi5ggJAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtqAmEP+d4jVmjKuHgIwpPSYpIk6x6ZTxfPTPB/uAbnNP0OOmc0cs2fMfDkfcgep6sAjWY+V4soBBrs+rbahnZkfn7nB+0I8Z3rqB/+5J6P1kdjhXPORJQP2RKO6JnZpB28lVFfNALo8yw+m0wRAHihNqdhZ12KmgAHn93HFQ8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e0lk2GiI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0lk2GiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15143C116C6;
	Tue,  6 Jan 2026 17:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721067;
	bh=8V81BwuHmz4IakOAZcI6bSMMQxACn9z4nYpmi5ggJAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0lk2GiItswsEwtjm7vEZiqafA/S9ZqT1gfelpsRG3LKn/PXHkKhpohJVuN+v/Wse
	 +kHhk60Hdq5Bji5SuqV0yIO50TsBT9wgPG/2Ck2i7sstSW8YYkp0VTZRb9MIaP2gDi
	 7DiPoLSxDw88a0iOPPavN7/NG6YdM3FBmXrsleZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sandipan Das <sandipan.das@amd.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6.12 393/567] perf/x86/amd/uncore: Fix the return value of amd_uncore_df_event_init() on error
Date: Tue,  6 Jan 2026 18:02:55 +0100
Message-ID: <20260106170505.879254617@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
@@ -595,14 +595,11 @@ static int amd_uncore_df_event_init(stru
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


