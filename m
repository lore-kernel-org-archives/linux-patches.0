Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774083;
	b=jE5ztYUgrS9jj+5ldXc5/1PiyTIj/6ybNvaY4qYSDHXzFRgH+vrMJPZt5QcXWSMR5d01
	 s0eLP2Y/E6DdkfhJmHE01k4IbtEFiycwUTY3XEy7ptY5u3JG4j+/cwsMnfjsgPrP4i/To
	 FlK4X8KbVwnGox11jF/reCd9V+WAC1jesyXNyVlX9MhmML6zVGRVGYQT+02+23aanAYpy
	 u6EuZbLKNSHCb0Ptuz8EXI/rxdwTq3ooMOmF2/7yZZi6hemefrdl1zFeqKLQuoP2GXbkp
	 KR3Y6YVWnh+zMzoRh19MSOEBZb3yTvDJF6QMZfB2QEkGAMS4prUerfWBK9UE9mte4Ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774083;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qGVIlRlPye0xcSPaEopcoF/uhepLtB9pSnlYKM0aDpA=;
	b=hzP0okZ2CehShwYy6KxpTu5KyT5cajB0MTy1nXKeXsRUf053Bi8pNDERhfXBzThTaCII
	 kDOV0c6FpD0Ly/N3XKwJeo8rQqn1VW12fMG5gg7lDCDim3j4QCAyoh3eeplY5vB+zXxzH
	 UjRzbXv8cmkQ0gh6LFXlAQcmDFwg9A0aPzxf0yxFNMGIVNiyIJYp5kJInUDHpJOjB3dHe
	 q5RbjpDt7loF1K/cLywj7LQFKNbAlaaJpnh5JvmrwNT9u6eKxbmcGHD8I6iAn+s9UA3d0
	 wgWblYrNCK3NIw0Ug7FIGUt2L0d5MI0g+iZQTdMTRGX0++3Q4E190GMxhETI5QRAbkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GMtmJrBd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DF4606A31A;
	Fri, 23 Oct 2026 16:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GMtmJrBd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EF61F01825;
	Fri, 23 Oct 2026 16:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774083;
	bh=qGVIlRlPye0xcSPaEopcoF/uhepLtB9pSnlYKM0aDpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GMtmJrBdAzZWqx14zKYZjXlz+7noqyMKBRg+yNiPdp4JAqElj1pMPBXckYTdvuYEY
	 Fr/teYITJmL00tjPT9S1R+6TPl+DgPW8Ce45fU4YlmiWfMiUn72PMHuEuPc+UYw3Nd
	 e71rRSSqEbP0RXDHvbWCL0mh26MnXt2vpTupdbJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tengda Wu <wutengda@huaweicloud.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 115/193] tracing: Fix hist trigger timestamps for buffered events
Date: Fri, 23 Oct 2026 18:36:32 +0200
Message-ID: <20261023163716.927053137@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tengda Wu <wutengda@huaweicloud.com>

commit 9414ca3b99e5a7f1f3bf51c2a01b383e1b355dd0 upstream.

Syzkaller triggered a WARN_ON_ONCE(!nest) warning:

  WARNING: kernel/trace/ring_buffer.c:821 at ring_buffer_event_time_stamp
  Call trace:
    ring_buffer_event_time_stamp
    hist_field_timestamp
    hist_fn_call
    event_hist_trigger
    event_triggers_call
    __event_trigger_test_discard
    trace_event_buffer_commit
    do_trace_event_raw_event_sched_switch
    trace_event_raw_event_sched_switch

The warning is probabilistically reproducible and is related to syzkaller
executing the following commands:

  echo 'prev_pid == 999999' > events/sched/sched_switch/filter
  echo 'hist:keys=common_timestamp' > events/sched/sched_switch/trigger

The specific triggering process is as follows:

CPU 0                                           CPU 1
(context switching)                             (echo 'hist:keys=common_timestamp' > \
                                                        events/sched/sched_switch/trigger)
do_trace_event_raw_event_##call
  trace_event_buffer_lock_reserve
    if (!tr->no_filter_buffering_ref &&
        trace_file->flags & EVENT_FILE_FL_FILTERED)
        return entry;  // return directly
                                                event_hist_trigger_parse
                                                  hist_register_trigger
                                                    tracing_set_filter_buffering(file->tr, true);
                                                      tr->no_filter_buffering_ref++;
    __trace_buffer_lock_reserve
      rb_start_commit
        local_inc(&cpu_buffer->committing);  // skipped and not executed
  trace_event_buffer_commit
    __event_trigger_test_discard
      event_triggers_call
        event_hist_trigger
          hist_fn_call
            hist_field_timestamp
              ring_buffer_event_time_stamp
                nest = local_read(&cpu_buffer->committing);
                WARN_ON_ONCE(!nest)  // trigger warning

The root cause is that when an event file has a filter attached and the
hist trigger has not yet been attached, trace_event_buffer_lock_reserve()
writes the event into the per-CPU trace_buffered_event temp buffer instead
of reserving it in the ring buffer, so cpu_buffer->committing is not
incremented. When the event is later processed at commit time by a hist
trigger, hist_field_timestamp() -> ring_buffer_event_time_stamp() sees a
zero committing count, triggering WARN_ON_ONCE(!nest).

tracing_event_time_stamp() was added by commit d8279bfc5e959 ("tracing:
Add tracing_event_time_stamp() API") for exactly this case: if the event
is the per-CPU trace_buffered_event, it returns the current ring buffer
timestamp. But it never gained a caller. Use it in hist_field_timestamp(),
so that a hist trigger that races onto a buffered event records the
current time, which is only marginally later than when the event was
recorded, instead of warning and recording a bogus timestamp.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260929104015.1689921-1-wutengda@huaweicloud.com
Fixes: b94bc80df648 ("tracing: Use a no_filter_buffering_ref to stop using the filter buffer")
Signed-off-by: Tengda Wu <wutengda@huaweicloud.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -868,7 +868,7 @@ static u64 hist_field_timestamp(struct h
 	struct hist_trigger_data *hist_data = hist_field->hist_data;
 	struct trace_array *tr = hist_data->event_file->tr;
 
-	u64 ts = ring_buffer_event_time_stamp(buffer, rbe);
+	u64 ts = tracing_event_time_stamp(buffer, rbe);
 
 	if (hist_data->attrs->ts_in_usecs && trace_clock_in_ns(tr))
 		ts = ns2usecs(ts);


