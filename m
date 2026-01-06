Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CE63559C0;
	Tue,  6 Jan 2026 17:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720571; cv=none; b=O96DLDnN8A3uR7504QvKAR3yEZgv6CcOk+mGVvMLJFSJAymPHtohnh4inahvK59GBZ9rW/D94I8MN21Dri78eUnkLkqW8zlFDFc/1Y6Zreju1ZW5ZEo3LuBMLGrcU4yK2IdSCsJPSR+4fjevLz33CpIsZKxVgvJKyu2JZi0mYPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720571; c=relaxed/simple;
	bh=4SnzLMZCTHS4Q/CZlojL0FeXrLm/xMtjSMHuJzcBqfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICbLXt9UOVYAI5lA/idixRtB0G+xyAEuYfkGPExF+C4E5XTXkNyL+WfJSHq/iKZVhehaUPdfOObsR4lvZ4HdJi9ZC8dm92a4z77EgnmNsVXBGIl2uGunEvLDHNeJlpwt6F2IU0CAznYXHGrWa2Q43r3tLhtmM5Yh2epDIkN/6hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGKISHhI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGKISHhI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF9CC116C6;
	Tue,  6 Jan 2026 17:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720571;
	bh=4SnzLMZCTHS4Q/CZlojL0FeXrLm/xMtjSMHuJzcBqfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NGKISHhIpqNdpPEdyrWvcO2K3DD/itjJKCvQc6Ep9kX4HrKGZep+3BR+CLYiAmD51
	 AapDemMgjwVi3Qcg8PfhYDy4Nfb4Qvxpm4LD3smFXvBTypiDOtlNTYswnX7dkKAl2D
	 W5TPymexASBONxogiypR19Ga+noiRqE3RPJILkoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Douglas Raillard <douglas.raillard@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 276/567] tracing: Fix fixed array of synthetic event
Date: Tue,  6 Jan 2026 18:00:58 +0100
Message-ID: <20260106170501.535809267@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

commit 47ef834209e5981f443240d8a8b45bf680df22aa upstream.

The commit 4d38328eb442d ("tracing: Fix synth event printk format for str
fields") replaced "%.*s" with "%s" but missed removing the number size of
the dynamic and static strings. The commit e1a453a57bc7 ("tracing: Do not
add length to print format in synthetic events") fixed the dynamic part
but did not fix the static part. That is, with the commands:

  # echo 's:wake_lat char[] wakee; u64 delta;' >> /sys/kernel/tracing/dynamic_events
  # echo 'hist:keys=pid:ts=common_timestamp.usecs if !(common_flags & 0x18)' > /sys/kernel/tracing/events/sched/sched_waking/trigger
  # echo 'hist:keys=next_pid:delta=common_timestamp.usecs-$ts:onmatch(sched.sched_waking).trace(wake_lat,next_comm,$delta)' > /sys/kernel/tracing/events/sched/sched_switch/trigger

That caused the output of:

          <idle>-0       [001] d..5.   193.428167: wake_lat: wakee=(efault)sshd-sessiondelta=155
    sshd-session-879     [001] d..5.   193.811080: wake_lat: wakee=(efault)kworker/u34:5delta=58
          <idle>-0       [002] d..5.   193.811198: wake_lat: wakee=(efault)bashdelta=91

The commit e1a453a57bc7 fixed the part where the synthetic event had
"char[] wakee". But if one were to replace that with a static size string:

  # echo 's:wake_lat char[16] wakee; u64 delta;' >> /sys/kernel/tracing/dynamic_events

Where "wakee" is defined as "char[16]" and not "char[]" making it a static
size, the code triggered the "(efaul)" again.

Remove the added STR_VAR_LEN_MAX size as the string is still going to be
nul terminated.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Douglas Raillard <douglas.raillard@arm.com>
Link: https://patch.msgid.link/20251204151935.5fa30355@gandalf.local.home
Fixes: e1a453a57bc7 ("tracing: Do not add length to print format in synthetic events")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_synth.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -382,7 +382,6 @@ static enum print_line_t print_synth_eve
 				n_u64++;
 			} else {
 				trace_seq_printf(s, print_fmt, se->fields[i]->name,
-						 STR_VAR_LEN_MAX,
 						 (char *)&entry->fields[n_u64].as_u64,
 						 i == se->n_fields - 1 ? "" : " ");
 				n_u64 += STR_VAR_LEN_MAX / sizeof(u64);


