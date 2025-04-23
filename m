Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B562973A7;
	Wed, 23 Apr 2025 15:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421608; cv=none; b=oKO2cwqilxlFEMuZbFisBapgdeAnyZyjATwOnSCHCggzYMgFOPzvKzp2pciRZc9pnbGEbTLLFS3ZShSzyjgUkMThXypppVx5ld+ev9EJDORIL9G+GW2HsSUwgHZbt4fw/M9HE/VwxEF/PLb0XsQi6zY6Ws0665BARoV3+ZWYvx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421608; c=relaxed/simple;
	bh=MQ1pC99fujJ+SoKy+9evK3VuD+O7Wvp5XlHzjq0Z+a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o8fj/N9Ztz/d0OB10n1jio9dPfb6ST+/3nfIf6ltCmd4RringhvRIZpIoeUuIO+cNlFBBBoIuqK0UbkWNU2sYHU04wCQWQS18CgYAGbk4agbW5xqyhpRhSMskAhuxl2ZryHX2ghLeTheHtcz5+e0Ee/coQ8e38gveDAx0jTH8s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dhj12Pnu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dhj12Pnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74967C4CEE2;
	Wed, 23 Apr 2025 15:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421607;
	bh=MQ1pC99fujJ+SoKy+9evK3VuD+O7Wvp5XlHzjq0Z+a0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dhj12Pnu/4eHtZRfpGbBFBFxEXCJ/UkAM1PQOTwi7jl2SAVZvJ/sjX1im/73VW16p
	 CI/kuyYvOR8E7R0BmfY7qloEI5qfmSgqnMXfwIEzXbr6iPn4zykquZuzN3X0EeeB9m
	 9mYBS56GshoqdJY9anoFVWt582loBBoYVV9LsI+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tom Zanussi <zanussi@kernel.org>,
	Douglas Raillard <douglas.raillard@arm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 199/393] tracing: Do not add length to print format in synthetic events
Date: Wed, 23 Apr 2025 16:41:35 +0200
Message-ID: <20250423142651.609588317@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

commit e1a453a57bc76be678bd746f84e3d73f378a9511 upstream.

The following causes a vsnprintf fault:

  # echo 's:wake_lat char[] wakee; u64 delta;' >> /sys/kernel/tracing/dynamic_events
  # echo 'hist:keys=pid:ts=common_timestamp.usecs if !(common_flags & 0x18)' > /sys/kernel/tracing/events/sched/sched_waking/trigger
  # echo 'hist:keys=next_pid:delta=common_timestamp.usecs-$ts:onmatch(sched.sched_waking).trace(wake_lat,next_comm,$delta)' > /sys/kernel/tracing/events/sched/sched_switch/trigger

Because the synthetic event's "wakee" field is created as a dynamic string
(even though the string copied is not). The print format to print the
dynamic string changed from "%*s" to "%s" because another location
(__set_synth_event_print_fmt()) exported this to user space, and user
space did not need that. But it is still used in print_synth_event(), and
the output looks like:

          <idle>-0       [001] d..5.   193.428167: wake_lat: wakee=(efault)sshd-sessiondelta=155
    sshd-session-879     [001] d..5.   193.811080: wake_lat: wakee=(efault)kworker/u34:5delta=58
          <idle>-0       [002] d..5.   193.811198: wake_lat: wakee=(efault)bashdelta=91
            bash-880     [002] d..5.   193.811371: wake_lat: wakee=(efault)kworker/u35:2delta=21
          <idle>-0       [001] d..5.   193.811516: wake_lat: wakee=(efault)sshd-sessiondelta=129
    sshd-session-879     [001] d..5.   193.967576: wake_lat: wakee=(efault)kworker/u34:5delta=50

The length isn't needed as the string is always nul terminated. Just print
the string and not add the length (which was hard coded to the max string
length anyway).

Cc: stable@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Cc: Douglas Raillard <douglas.raillard@arm.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Link: https://lore.kernel.org/20250407154139.69955768@gandalf.local.home
Fixes: 4d38328eb442d ("tracing: Fix synth event printk format for str fields");
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_synth.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -377,7 +377,6 @@ static enum print_line_t print_synth_eve
 				union trace_synth_field *data = &entry->fields[n_u64];
 
 				trace_seq_printf(s, print_fmt, se->fields[i]->name,
-						 STR_VAR_LEN_MAX,
 						 (char *)entry + data->as_dynamic.offset,
 						 i == se->n_fields - 1 ? "" : " ");
 				n_u64++;


