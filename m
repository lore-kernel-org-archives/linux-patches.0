Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4801EA80;
	Tue, 11 Mar 2025 15:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706193; cv=none; b=KLE3ThlZdyKGfv4s+LLcnl2skW3nWV/ZSefJ44cZSYSQxkvLeBkIX1NRmU4dokgIEt0r48wJ+Qzc3Y2sx3gq4ejI7bmMkfTZ6ELRTVOwC5Ku+PF11gI2WEBfcrvKpq/78Ot5gJZ20oGC1joWFpv3EQJSDpodx74BXnU11pLgWqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706193; c=relaxed/simple;
	bh=3erE5VPvPXlIJiZS8DPbH4LPO+pGurxlwT92ZpgNNlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWgvlcs2CJcWvMIRXsG+BFyPETQyttA5a1ojr/0SNbBlif/xq+NUtoP9T9asVPt4a9OAti0LU8EjZBDpjbAtd7/AMv0b+2QpWF5f09vdGX1p0DRWPOucceUStOvAXfamYJijGVoByz8KrE3JdV7jWFJ6iCz2B/fSIdBNcELgNf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2kMexcsx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2kMexcsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04874C4CEE9;
	Tue, 11 Mar 2025 15:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706193;
	bh=3erE5VPvPXlIJiZS8DPbH4LPO+pGurxlwT92ZpgNNlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2kMexcsxaNcAw0Hh/Dzf2rrHrzEhUAcdyvnzfx6lgTueS9ZDrJHrTgZBr+ohVoBQF
	 P8/XqPGjDaZ852Z4IH4trWQtcYm/taswfJ2mrHVaaa4U/AYCqmSF203HbmvBZkcl1N
	 k9AMaAO5Bd1aMu4UlDLcBonQG42d+OEcAkm4hvB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5.4 266/328] perf/core: Fix low freq setting via IOC_PERIOD
Date: Tue, 11 Mar 2025 16:00:36 +0100
Message-ID: <20250311145725.479327746@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

commit 0d39844150546fa1415127c5fbae26db64070dd3 upstream.

A low attr::freq value cannot be set via IOC_PERIOD on some platforms.

The perf_event_check_period() introduced in:

  81ec3f3c4c4d ("perf/x86: Add check_period PMU callback")

was intended to check the period, rather than the frequency.
A low frequency may be mistakenly rejected by limit_period().

Fix it.

Fixes: 81ec3f3c4c4d ("perf/x86: Add check_period PMU callback")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250117151913.3043942-2-kan.liang@linux.intel.com
Closes: https://lore.kernel.org/lkml/20250115154949.3147-1-ravi.bangoria@amd.com/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5217,14 +5217,15 @@ static int perf_event_period(struct perf
 	if (!value)
 		return -EINVAL;
 
-	if (event->attr.freq && value > sysctl_perf_event_sample_rate)
-		return -EINVAL;
-
-	if (perf_event_check_period(event, value))
-		return -EINVAL;
-
-	if (!event->attr.freq && (value & (1ULL << 63)))
-		return -EINVAL;
+	if (event->attr.freq) {
+		if (value > sysctl_perf_event_sample_rate)
+			return -EINVAL;
+	} else {
+		if (perf_event_check_period(event, value))
+			return -EINVAL;
+		if (value & (1ULL << 63))
+			return -EINVAL;
+	}
 
 	event_function_call(event, __perf_event_period, &value);
 


