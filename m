Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E29D13C67E;
	Wed,  5 Mar 2025 18:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198616; cv=none; b=uwtw8UaHbiZ57GpTyZGgHON8QaRBprqLZ48GfIgk0xbxkeqrGpmYGCJKbYYAGbX+h3GabGU224AhAf4hPOZhQpkuD4A21/MhsIcf9XLTmhT6LKuTbOjPAe+aPCfx1l40/DLqFeXbfgl2f8MUAyWivr4GxG4xUCDlEVVGQt1EJLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198616; c=relaxed/simple;
	bh=wyrdkgaIrAGPyWFb39uQeh5I+c817IBiNGeyCbeNmq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WkJPZe2dccr3DShd9JuLv8Kdyi3qlvlnx8zc+Sp1dZKJTjb3REx5N0XjNrlHZqALm83RDf1beOVbympdh2iE8iJQ3HYrr7ZHS1n8uWwesHbKb40b8HqO8IvMAJz+0Lqn3eBnP1QctNOt0habXzr7awEFDkZ6/wSgE5ohBYsB008=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O+LO2Kku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O+LO2Kku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7655C4CED1;
	Wed,  5 Mar 2025 18:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198616;
	bh=wyrdkgaIrAGPyWFb39uQeh5I+c817IBiNGeyCbeNmq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O+LO2KkukSX1P68YOnQ/ESVP2Ku91othqgkBvHXwff3RHgihLnS3exct5S86LFiEw
	 RgwS2UkMT/56BVuiY2/Mt9Nwg9Blr0CXOLw49E6BNDYpiGu7KCQPVGrOOXjIgZ8Ik2
	 krp90KzuRlmIzpwQBkcE/qefi8sU2g7l6ZI4Hjhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6.13 088/157] perf/core: Fix low freq setting via IOC_PERIOD
Date: Wed,  5 Mar 2025 18:48:44 +0100
Message-ID: <20250305174508.845217243@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5969,14 +5969,15 @@ static int _perf_event_period(struct per
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
 


