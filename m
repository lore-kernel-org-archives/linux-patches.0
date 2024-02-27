Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F0B14264A;
	Tue, 27 Feb 2024 14:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044037; cv=none; b=bLbhxGj/RXP6g8F73iTV00ga+39kvRlrTbfQz6TD8f3Y2H/qe5O7q4y8fAAU9HRkSrGPE5KKGD2SCglm1aT5cTrnfHnvmkvrlRvB4yiGHy497wMmZtWHASOSyB+2ldt4XteJAA2CuV1o9SuPWyVysjE/jWMM1wWejQGUwT+eGF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044037; c=relaxed/simple;
	bh=oVDEWH0UvPuqFaly31k7rR6lJTEmD6vqA3Cmihj4rKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jNRy3yzOEmRhMDO7LBGdCtsWpfMqVIkhK9WnSphOjrAprYF82DgnRN/vA2kVX97Ea5BxlvYMkP6cVin89xhZSD/JayJOQ7WgPSbvM17iwbffE13rurT8QbaGas7vk2M/3MJulQ0TUEzCr5QwQUOhg769qQhJaK5oJlcZPrCeVQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dyNu81E1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dyNu81E1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E901C433C7;
	Tue, 27 Feb 2024 14:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044036;
	bh=oVDEWH0UvPuqFaly31k7rR6lJTEmD6vqA3Cmihj4rKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dyNu81E1J5bxYBOphGdeDNr8XHnvyBClp+ksP8W9bwlQBUyDt0YAciztHNOTiEykr
	 ektVWHmLA22RQVc8MgBjWoSXZDYme1M+s8QLzWvGKV3CpS/r8z7sCNfb/F9ibbzr9/
	 nBdy9sIBWO6bMgGdV/vzvxathmy5ut9PXJA/U7ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cyril Hrubis <chrubis@suse.cz>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Petr Vorel <pvorel@suse.cz>,
	Mel Gorman <mgorman@suse.de>
Subject: [PATCH 5.10 010/122] sched/rt: Fix sysctl_sched_rr_timeslice intial value
Date: Tue, 27 Feb 2024 14:26:11 +0100
Message-ID: <20240227131559.044397307@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cyril Hrubis <chrubis@suse.cz>

commit c7fcb99877f9f542c918509b2801065adcaf46fa upstream.

There is a 10% rounding error in the intial value of the
sysctl_sched_rr_timeslice with CONFIG_HZ_300=y.

This was found with LTP test sched_rr_get_interval01:

sched_rr_get_interval01.c:57: TPASS: sched_rr_get_interval() passed
sched_rr_get_interval01.c:64: TPASS: Time quantum 0s 99999990ns
sched_rr_get_interval01.c:72: TFAIL: /proc/sys/kernel/sched_rr_timeslice_ms != 100 got 90
sched_rr_get_interval01.c:57: TPASS: sched_rr_get_interval() passed
sched_rr_get_interval01.c:64: TPASS: Time quantum 0s 99999990ns
sched_rr_get_interval01.c:72: TFAIL: /proc/sys/kernel/sched_rr_timeslice_ms != 100 got 90

What this test does is to compare the return value from the
sched_rr_get_interval() and the sched_rr_timeslice_ms sysctl file and
fails if they do not match.

The problem it found is the intial sysctl file value which was computed as:

static int sysctl_sched_rr_timeslice = (MSEC_PER_SEC / HZ) * RR_TIMESLICE;

which works fine as long as MSEC_PER_SEC is multiple of HZ, however it
introduces 10% rounding error for CONFIG_HZ_300:

(MSEC_PER_SEC / HZ) * (100 * HZ / 1000)

(1000 / 300) * (100 * 300 / 1000)

3 * 30 = 90

This can be easily fixed by reversing the order of the multiplication
and division. After this fix we get:

(MSEC_PER_SEC * (100 * HZ / 1000)) / HZ

(1000 * (100 * 300 / 1000)) / 300

(1000 * 30) / 300 = 100

Fixes: 975e155ed873 ("sched/rt: Show the 'sched_rr_timeslice' SCHED_RR timeslice tuning knob in milliseconds")
Signed-off-by: Cyril Hrubis <chrubis@suse.cz>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Tested-by: Petr Vorel <pvorel@suse.cz>
Link: https://lore.kernel.org/r/20230802151906.25258-2-chrubis@suse.cz
[ pvorel: rebased for 5.15, 5.10 ]
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/rt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -8,7 +8,7 @@
 #include "pelt.h"
 
 int sched_rr_timeslice = RR_TIMESLICE;
-int sysctl_sched_rr_timeslice = (MSEC_PER_SEC / HZ) * RR_TIMESLICE;
+int sysctl_sched_rr_timeslice = (MSEC_PER_SEC * RR_TIMESLICE) / HZ;
 /* More than 4 hours if BW_SHIFT equals 20. */
 static const u64 max_rt_runtime = MAX_BW;
 


