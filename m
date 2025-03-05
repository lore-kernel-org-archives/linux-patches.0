Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7153678F3A;
	Wed,  5 Mar 2025 18:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197696; cv=none; b=PQH/QgGJQekVxJcACKw0MscduyOKwDsTibdIwQIkasxBAKMozxLAfZRTYGNt02t5c0wkHdQ0rM6zmIDdfAhwkgE7yzt0PJwr65Sgw7VA0NQwByy4MS0oVx8NizNG/jmAXBy7Zzl9K1ZyqPaGJwgss0xkC6DkVLvzN5z09XxS6lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197696; c=relaxed/simple;
	bh=CaXA/81hzLuaQy2z4z2H5XtyarzrppVEfBTXMnkRdMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGbnCZk8xVCTUEA+tsp69fUXTRFLkRkjMibhpjSwbIheMS8ImsX5M6NmMtdajRaPszXzJJptfnVG34xx7neAG6jU2AFdiDGReFoZoWWGDuzaZFAQKucG91ia4dStdCGfq90A7h8s9LZakEbsIIeLrswoJvGer4eEbQLCH99KTLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=omet6OvN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="omet6OvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9560EC4CED1;
	Wed,  5 Mar 2025 18:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197696;
	bh=CaXA/81hzLuaQy2z4z2H5XtyarzrppVEfBTXMnkRdMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=omet6OvNEIHv+NBrGdb9Z2v/NCFI/+gBpby3f1DuW/WJZMzqIu++feyPSt/Wk3VQW
	 13Fwkzvd6KcIxrsSyz61fyrkC6max6zUh1NzKk40wKbbZ1bROmLfDfjbXa+6XefIgO
	 NiGkXv9p0tcb3T32CMUjo5BQ0DiyiHMPHmyVeCoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6.6 067/142] perf/core: Fix low freq setting via IOC_PERIOD
Date: Wed,  5 Mar 2025 18:48:06 +0100
Message-ID: <20250305174503.029243410@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5861,14 +5861,15 @@ static int _perf_event_period(struct per
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
 


