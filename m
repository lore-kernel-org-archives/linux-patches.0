Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD22E320CB6;
	Fri,  9 Jan 2026 12:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960691; cv=none; b=NvIrIpZGB9lJix8GrACKGMakgylQUMvIGuWvHrCt/vlK1hxSSgH22kS+hS53XwjpGK+efvT0hQBZuIz8KCwKEIAID9GrWf/f88jC22y3xrhHh0I2SwJ6Lf2Ujz5dZj2TmbFE9YeDiH5V4GbzcyFGFTs/qQCQe/5qMogrNAfg5gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960691; c=relaxed/simple;
	bh=+EU/IC77tM/XYtMpH79gHddAmdgoNQaB4V9K8Dx8ZgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5gUm/XlJzV0mXjrA6QZohJkn6S6i6K6muELnBUYTcCNjswG/B2dp6E6B57eusi471SblQ0VCTFVz8xv10l9gnJSxL73lst8hvfDiWGVPY83kC+Bu1mV6751SL/5Aoe31xic0KBxCWPNY2AZdvg5omQfjRYH032A8WBvPt13qlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4hyb9Ky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4hyb9Ky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64100C4CEF1;
	Fri,  9 Jan 2026 12:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960691;
	bh=+EU/IC77tM/XYtMpH79gHddAmdgoNQaB4V9K8Dx8ZgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4hyb9KyK9QLWXy84LbR+hwx2KhrSh582rdml8vt8cybq0vu9TymYCLn04c1aKSpq
	 C6lX37GUnoZE5TJR2HpCaOq44z6InU6mD6cmNKhc4wetX9F4H6xDQzIRUGLKoQTlw4
	 gRipc5qqzdTX0UvdxkSMBHsT7jo5peHtCAh7rcvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Douglas Raillard <douglas.raillard@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 490/737] tracing: Fix fixed array of synthetic event
Date: Fri,  9 Jan 2026 12:40:29 +0100
Message-ID: <20260109112152.423462560@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


