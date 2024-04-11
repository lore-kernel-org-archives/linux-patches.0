Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA7614430D;
	Thu, 11 Apr 2024 10:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829755; cv=none; b=ZThPLBy2S/X7Ukn9b/a2DZ9TbgETxREv6VnO5VAfKKOImh+2+wtP98BFBiuBbFkrFCIBhsLofR0ayt8ZERU2CMz91QwH5CuHQThtPE+3ZG4yyIvaGvXwYvNwaIuTokmN6JCKXRK2ZRbwU2523RDtaOWnLJM9jdiBmTonlm37sm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829755; c=relaxed/simple;
	bh=7pVZGUsoXK1v8X+d9P9gB+4szEczhw9f+5oL2U1gNkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4u/0JUWIlO8NW4qKH61l0ud75m65GFcS1VAPaeBJ28B2PgegC4YKb2QlRd7u+mU7pnY1FeTzq08g18QxMUAQK2ZDX4pIz/2Klaiz6nKdu1WUSoVq1zc+D6Er8LmuUkPsXNqfPgFpQwvBKcXj4WD/CXc9lY20JY/SVuCZM7yB1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMfqZLCm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMfqZLCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0E3C433C7;
	Thu, 11 Apr 2024 10:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829755;
	bh=7pVZGUsoXK1v8X+d9P9gB+4szEczhw9f+5oL2U1gNkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yMfqZLCmYDsiMIfkGSPSTpZ0dZFfTYtV/TssAxCYAsSMqRgRv9IgNcZfxsLuqgDBL
	 3CJvdDvswJp2pdx/6VqRfQT4GhCf+4ax1MJJiuinfYicZQSwzAFb5PBRhbpq01tg3c
	 DktUtL4jfpa2UDVHZq8Plpg5dJ8iBKVyw3W85+a8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Jihong <yangjihong1@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 4.19 095/175] perf/core: Fix reentry problem in perf_output_read_group()
Date: Thu, 11 Apr 2024 11:55:18 +0200
Message-ID: <20240411095422.427434777@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Jihong <yangjihong1@huawei.com>

commit 6b959ba22d34ca793ffdb15b5715457c78e38b1a upstream.

perf_output_read_group may respond to IPI request of other cores and invoke
__perf_install_in_context function. As a result, hwc configuration is modified.
causing inconsistency and unexpected consequences.

Interrupts are not disabled when perf_output_read_group reads PMU counter.
In this case, IPI request may be received from other cores.
As a result, PMU configuration is modified and an error occurs when
reading PMU counter:

		     CPU0                                         CPU1
						      __se_sys_perf_event_open
							perf_install_in_context
  perf_output_read_group                                  smp_call_function_single
    for_each_sibling_event(sub, leader) {                   generic_exec_single
      if ((sub != event) &&                                   remote_function
	  (sub->state == PERF_EVENT_STATE_ACTIVE))                    |
  <enter IPI handler: __perf_install_in_context>   <----RAISE IPI-----+
  __perf_install_in_context
    ctx_resched
      event_sched_out
	armpmu_del
	  ...
	  hwc->idx = -1; // event->hwc.idx is set to -1
  ...
  <exit IPI>
	      sub->pmu->read(sub);
		armpmu_read
		  armv8pmu_read_counter
		    armv8pmu_read_hw_counter
		      int idx = event->hw.idx; // idx = -1
		      u64 val = armv8pmu_read_evcntr(idx);
			u32 counter = ARMV8_IDX_TO_COUNTER(idx); // invalid counter = 30
			read_pmevcntrn(counter) // undefined instruction

Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20220902082918.179248-1-yangjihong1@huawei.com
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6253,9 +6253,16 @@ static void perf_output_read_group(struc
 {
 	struct perf_event *leader = event->group_leader, *sub;
 	u64 read_format = event->attr.read_format;
+	unsigned long flags;
 	u64 values[6];
 	int n = 0;
 
+	/*
+	 * Disabling interrupts avoids all counter scheduling
+	 * (context switches, timer based rotation and IPIs).
+	 */
+	local_irq_save(flags);
+
 	values[n++] = 1 + leader->nr_siblings;
 
 	if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
@@ -6291,6 +6298,8 @@ static void perf_output_read_group(struc
 
 		__output_copy(handle, values, n * sizeof(u64));
 	}
+
+	local_irq_restore(flags);
 }
 
 #define PERF_FORMAT_TOTAL_TIMES (PERF_FORMAT_TOTAL_TIME_ENABLED|\


