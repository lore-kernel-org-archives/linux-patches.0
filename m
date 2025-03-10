Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D691C3F34;
	Mon, 10 Mar 2025 18:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630738; cv=none; b=f0p0mPRmtXB00dR0NSl51QDD3hBunr0cMn+6a9eHrAT4rV/kifU4qZaB2rVglfsCVx5fCvKG3QM7xK1ZeMYNMDzBKti/8hiWfohtBzre8cDHrF0d3Jypbe8/IsVUY+Nie2Ko2xgr2a3Ha8q4p9OpE2J455NNUHi+Qp747HG8sY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630738; c=relaxed/simple;
	bh=7tz+K5dHSo+Ud2jCycnj0qpaNIdXtehQPyWcISuWPYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGgNQczN42Qniit0Sne5k08GyJrQerxllUZnB4EDNmQBbz9FfOaF+jvnDDd93NsXvaVM1EoLczoVpqJDfnyAarlz/X43/PysVE0FyohYCKHUOYoA8xkLBmpfriZ5UZs+oArGxO3oeg7xxb1atdU/O88awGyiTWq9Bza7oyQMpwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WyF8gy1C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WyF8gy1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58442C4CEED;
	Mon, 10 Mar 2025 18:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630737;
	bh=7tz+K5dHSo+Ud2jCycnj0qpaNIdXtehQPyWcISuWPYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WyF8gy1ChxXDTKHU4RSuoECanMsLl0jueHuCQ25QiUTAAQwR5zZF2dCa3a74grNCN
	 I+llndOWfkwD+/rkkhl653xSaAFaEGCwZCGZdEgnw/oOAuGXRhyNoLeSFmS2XqhRil
	 EtuziuzWYCUboJf7CwTDWD6y75KHJA3dXsN/HwmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5.15 516/620] perf/core: Fix low freq setting via IOC_PERIOD
Date: Mon, 10 Mar 2025 18:06:02 +0100
Message-ID: <20250310170605.924396695@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5773,14 +5773,15 @@ static int _perf_event_period(struct per
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
 


