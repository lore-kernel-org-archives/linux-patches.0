Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D62171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:38:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1ABC433D2;
	Mon, 22 May 2023 19:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784299;
	bh=txq7t9i5V/qxOySKyrwMBWx65mUaBxAK/qvIdXV7sLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hosil0NaSy8Cy2eAPNAIS61fezjh27fCVkK0QK40kZkrIQv8uXKhsddIIzLBEDW1N
	 +o1PmSox30QtEasyaGxPLCHVRzlVLkjaGrMBdJASJuCkUaEzEXdm5S2Yg3ks5teEG6
	 gbu4WLuOs2XIn2YiNgH2N4e1gPKmh/y3/8m8YDJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Jihong <yangjihong1@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 009/364] perf/core: Fix perf_sample_data not properly initialized for different swevents in perf_tp_event()
Date: Mon, 22 May 2023 20:05:14 +0100
Message-Id: <20230522190413.047898081@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Jihong <yangjihong1@huawei.com>

[ Upstream commit 1d1bfe30dad50d4bea83cd38d73c441972ea0173 ]

data->sample_flags may be modified in perf_prepare_sample(),
in perf_tp_event(), different swevents use the same on-stack
perf_sample_data, the previous swevent may change sample_flags in
perf_prepare_sample(), as a result, some members of perf_sample_data are
not correctly initialized when next swevent_event preparing sample
(for example data->id, the value varies according to swevent).

A simple scenario triggers this problem is as follows:

  # perf record -e sched:sched_switch --switch-output-event sched:sched_switch -a sleep 1
  [ perf record: dump data: Woken up 0 times ]
  [ perf record: Dump perf.data.2023041209014396 ]
  [ perf record: dump data: Woken up 0 times ]
  [ perf record: Dump perf.data.2023041209014662 ]
  [ perf record: dump data: Woken up 0 times ]
  [ perf record: Dump perf.data.2023041209014910 ]
  [ perf record: Woken up 0 times to write data ]
  [ perf record: Dump perf.data.2023041209015164 ]
  [ perf record: Captured and wrote 0.069 MB perf.data.<timestamp> ]
  # ls -l
  total 860
  -rw------- 1 root root  95694 Apr 12 09:01 perf.data.2023041209014396
  -rw------- 1 root root 606430 Apr 12 09:01 perf.data.2023041209014662
  -rw------- 1 root root  82246 Apr 12 09:01 perf.data.2023041209014910
  -rw------- 1 root root  82342 Apr 12 09:01 perf.data.2023041209015164
  # perf script -i perf.data.2023041209014396
  0x11d58 [0x80]: failed to process type: 9 [Bad address]

Solution: Re-initialize perf_sample_data after each event is processed.
Note that data->raw->frag.data may be accessed in perf_tp_event_match().
Therefore, need to init sample_data and then go through swevent hlist to prevent
reference of NULL pointer, reported by [1].

After fix:

  # perf record -e sched:sched_switch --switch-output-event sched:sched_switch -a sleep 1
  [ perf record: dump data: Woken up 0 times ]
  [ perf record: Dump perf.data.2023041209442259 ]
  [ perf record: dump data: Woken up 0 times ]
  [ perf record: Dump perf.data.2023041209442514 ]
  [ perf record: dump data: Woken up 0 times ]
  [ perf record: Dump perf.data.2023041209442760 ]
  [ perf record: Woken up 0 times to write data ]
  [ perf record: Dump perf.data.2023041209443003 ]
  [ perf record: Captured and wrote 0.069 MB perf.data.<timestamp> ]
  # ls -l
  total 864
  -rw------- 1 root root 100166 Apr 12 09:44 perf.data.2023041209442259
  -rw------- 1 root root 606438 Apr 12 09:44 perf.data.2023041209442514
  -rw------- 1 root root  82246 Apr 12 09:44 perf.data.2023041209442760
  -rw------- 1 root root  82342 Apr 12 09:44 perf.data.2023041209443003
  # perf script -i perf.data.2023041209442259 | head -n 5
              perf   232 [000]    66.846217: sched:sched_switch: prev_comm=perf prev_pid=232 prev_prio=120 prev_state=D ==> next_comm=perf next_pid=234 next_prio=120
              perf   234 [000]    66.846449: sched:sched_switch: prev_comm=perf prev_pid=234 prev_prio=120 prev_state=S ==> next_comm=perf next_pid=232 next_prio=120
              perf   232 [000]    66.846546: sched:sched_switch: prev_comm=perf prev_pid=232 prev_prio=120 prev_state=R ==> next_comm=perf next_pid=234 next_prio=120
              perf   234 [000]    66.846606: sched:sched_switch: prev_comm=perf prev_pid=234 prev_prio=120 prev_state=S ==> next_comm=perf next_pid=232 next_prio=120
              perf   232 [000]    66.846646: sched:sched_switch: prev_comm=perf prev_pid=232 prev_prio=120 prev_state=R ==> next_comm=perf next_pid=234 next_prio=120

[1] Link: https://lore.kernel.org/oe-lkp/202304250929.efef2caa-yujie.liu@intel.com

Fixes: bb447c27a467 ("perf/core: Set data->sample_flags in perf_prepare_sample()")
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20230425103217.130600-1-yangjihong1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 68baa8194d9f8..db016e4189319 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10150,8 +10150,20 @@ void perf_tp_event(u16 event_type, u64 count, void *record, int entry_size,
 	perf_trace_buf_update(record, event_type);
 
 	hlist_for_each_entry_rcu(event, head, hlist_entry) {
-		if (perf_tp_event_match(event, &data, regs))
+		if (perf_tp_event_match(event, &data, regs)) {
 			perf_swevent_event(event, count, &data, regs);
+
+			/*
+			 * Here use the same on-stack perf_sample_data,
+			 * some members in data are event-specific and
+			 * need to be re-computed for different sweveents.
+			 * Re-initialize data->sample_flags safely to avoid
+			 * the problem that next event skips preparing data
+			 * because data->sample_flags is set.
+			 */
+			perf_sample_data_init(&data, 0, 0);
+			perf_sample_save_raw_data(&data, &raw);
+		}
 	}
 
 	/*
-- 
2.39.2



