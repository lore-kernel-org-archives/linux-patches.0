Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB471487F4;
	Tue, 30 Sep 2025 15:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244958; cv=none; b=RSX1Sr+MRA8ZtVwvthWMYQuOjfkOrfbaGABWSJ3Uro6yT0O6mgO1JJBYTO5lF/7kCUq2i9YSHjRk70eqN1FxYiAXmzLwzhJ7EI6xTp/JfDhc+xOlvWicgngjNXjcZHfRiR6j38k0fsmto2SEEKALaHcl5C4qIYEXB4Uz0uiZS28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244958; c=relaxed/simple;
	bh=LQ1EdAjpD+DNdV9sYU3w9FW3mRulq/Wy8NX3Ge+xVfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqxJt9Xinj2Xs2gDuwHtNf06qXjbxfjvy2q1UktLGs/mpA1PmcqS+CM9wKIEZNUtiAbyL2f6GqREdfPogPudWhGQbLO448Dz1KP4Hrf0b3ifGMg2kD9wC7CPJ20c440Dl3Ypaxbl+TLLX3oZZ3fXT7tBmkylq3PXTm7W+hkV7EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hjoA3ihq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjoA3ihq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF2CC4CEF0;
	Tue, 30 Sep 2025 15:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244958;
	bh=LQ1EdAjpD+DNdV9sYU3w9FW3mRulq/Wy8NX3Ge+xVfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hjoA3ihqr8TBO2uyRsVwiwW0x9lxbZu6JJZdMlGD8FtA3uauc2iz2hWBkFF3M0A5J
	 5EM2V59+aIjtCMra/WCrog1JrYaoNhyY57OnePqOa4rBGGMxJBa9jTU0g0ZDVHgieU
	 LISuXucAMPx639MS2FuAvhQjg6naJCJdB7gTSZ+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tom Zanussi <zanussi@kernel.org>,
	Douglas Raillard <douglas.raillard@arm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 008/151] tracing: Do not add length to print format in synthetic events
Date: Tue, 30 Sep 2025 16:45:38 +0200
Message-ID: <20250930143827.927075536@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit e1a453a57bc76be678bd746f84e3d73f378a9511 ]

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
[ offset calculations instead of union-based data structures ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_synth.c |    2 --
 1 file changed, 2 deletions(-)

--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -364,13 +364,11 @@ static enum print_line_t print_synth_eve
 				str_field = (char *)entry + data_offset;
 
 				trace_seq_printf(s, print_fmt, se->fields[i]->name,
-						 STR_VAR_LEN_MAX,
 						 str_field,
 						 i == se->n_fields - 1 ? "" : " ");
 				n_u64++;
 			} else {
 				trace_seq_printf(s, print_fmt, se->fields[i]->name,
-						 STR_VAR_LEN_MAX,
 						 (char *)&entry->fields[n_u64],
 						 i == se->n_fields - 1 ? "" : " ");
 				n_u64 += STR_VAR_LEN_MAX / sizeof(u64);


