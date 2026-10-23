Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774951;
	b=4JH2YE7eiAi0060PJu+Lwm+V0+l2ENLtPH/SLmmageBtMcmK4KtQ0KQCzAY+HVp2QGrn
	 verZStwUyBe8Uz8S3UUcCVX0fayEZ8FnFioR9VZ1gnwLRreEFLdeB+zU6/haO3S6C4nRC
	 NzAnB1LZtFECHp26lz6e8cPTH5cJJcLYUgjmv5edDKC8Z2j1Qu+DOAUNdXJxI9VozeVXt
	 iHLBv9qNK0/OeULVx2pxnu7V1ZLStm6mX9stQ8bSTwvvqT66RYj8Vf43/q9i2Ux1Y2r6c
	 xT2WaEcphB89JnM0nL2hGtfSbEEx7pIBG+8EjVZbbOjwMapbmZGNuic3P0SqCpgl7Ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774951;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6xTzF0cX30jjc3qTAtzBbmWUfXqLOR3vTUK3Teli+mI=;
	b=yj5nau12iIcQNXU1vW8+9lcbF/ScFJHiu7zAi1a/0ynkxCB44OVkuPCcagXI8XW4lwzS
	 vX2AO50Tubt0Gz2jc2N6LuWnvuCQ3AHu5xpSOJk6P0NowpRWm1+D9ZepqSo7t6KhnD3KJ
	 q7SJvHA24TlSFXjyd7AQVcmFIgAJRLLeTJdsyv8KKeFHb1woBA/zp/YJghWBNjnM6olj/
	 LSVgN00zc1XK3V5Ivwsw68qUG7z3wGp71DpUDBTdLcrQdGmztlfCUAdVBDYCPoJ48V/63
	 Mna8FuFsJJNkigl+bpaR458Vq/ngOvCzwJQBhtp7q+xLD/m7h8EjmzFSuDPaBT0yC0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1A+nM2Zt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034B7606A31A;
	Fri, 23 Oct 2026 17:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1A+nM2Zt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0FF1F01825;
	Fri, 23 Oct 2026 17:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774950;
	bh=6xTzF0cX30jjc3qTAtzBbmWUfXqLOR3vTUK3Teli+mI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1A+nM2Ztxtrf8pXCOK/HCp8vA3dD8wsNr5XtwnBxD232Vw7YSrVUc0SAGqmSkmfcO
	 NGsAHgFIUnSWHIh9TWltVxYjy7bLCnNAXt5Oc1X2kHgaIaOnxDIkjU3UdpqzvEdyDJ
	 6AGQjV9lgBJBdYdjxzKN53oWA8ULzxZoOZmnIjqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tengda Wu <wutengda@huaweicloud.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 174/242] tracing: Fix hist trigger timestamps for buffered events
Date: Fri, 23 Oct 2026 18:40:16 +0200
Message-ID: <20261023163717.900871774@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -874,7 +874,7 @@ static u64 hist_field_timestamp(struct h
 	struct hist_trigger_data *hist_data = hist_field->hist_data;
 	struct trace_array *tr = hist_data->event_file->tr;
 
-	u64 ts = ring_buffer_event_time_stamp(buffer, rbe);
+	u64 ts = tracing_event_time_stamp(buffer, rbe);
 
 	if (hist_data->attrs->ts_in_usecs && trace_clock_in_ns(tr))
 		ts = ns2usecs(ts);


