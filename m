Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A607D30DECE;
	Wed,  3 Dec 2025 15:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775945; cv=none; b=Ke9fgC0yUhaVvxWdOtZ481sXPFgRTXnrC8hn/siBxmZA0V383QsqQn8XM6P6p3s/DTRVyjaMLLT9tPWymXIpKUGYjhjb1KzO1UGvSh32E+a/icUa7mGMunzpTqv1eIIsolMxcnyB7zwdY139Dz8DR1SHDKSQYA2QWL0FmxB2bnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775945; c=relaxed/simple;
	bh=ot+zeokK+4kUPY+8JFJF4kZ2q0GcENesYgnWCIQa3qM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUwCohbB/NKqvOQq8n1ahZSvGXdkqLP5XSCl911tCT0EWtLpiKQkru2oXd4ZZiisWMrcDQWghEGzIfITXMUcjEYrQBU4PJ34wfEf5uaQDUiV0cpt48vsyytrMrqJ+7aegv4ZOq5aO6EGBGgiVsvD21vZN1NtR4WckS5vIXJF3kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nixY3Rb/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nixY3Rb/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6C3C4CEF5;
	Wed,  3 Dec 2025 15:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764775945;
	bh=ot+zeokK+4kUPY+8JFJF4kZ2q0GcENesYgnWCIQa3qM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nixY3Rb/VOAl1Squ16lY0VjfajcuEAxlacxVrNsWMxTwLvgIwsa5+zdArKkmorInS
	 bcZK34zBtuDwP/s9LuNHcvHAQ1EPD9UVyKnrNAge4s+jBhtEe95JXYzVX9+EJ6KurO
	 u/uwZP7wKYBfYGPAdMu2vz6XxyqgyoTwXx+X2qFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Douglas Raillard <douglas.raillard@arm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 5.10 035/300] tracing: fix declaration-after-statement warning
Date: Wed,  3 Dec 2025 16:23:59 +0100
Message-ID: <20251203152401.763604981@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

When building this kernel version this warning is visible:

  kernel/trace/trace_events_synth.c: In function 'synth_event_reg':
  kernel/trace/trace_events_synth.c:847:9: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
    847 |         int ret = trace_event_reg(call, type, data);
        |         ^~~

This can be easily fixed by declaring 'ret' earlier.

This issue is visible in < v5.18, because -std=gnu89 is used by default,
see commit e8c07082a810 ("Kbuild: move to -std=gnu11").

Please note that in v5.15.y, the 'Fixes' commit has been modified during
the backport, not to have this warning. See commit 72848b81b3dd
("tracing: Ensure module defining synth event cannot be unloaded while
tracing") from v5.15.y.

Fixes: 21581dd4e7ff ("tracing: Ensure module defining synth event cannot be unloaded while tracing")
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Cc: Douglas Raillard <douglas.raillard@arm.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_synth.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -831,6 +831,7 @@ static int synth_event_reg(struct trace_
 		    enum trace_reg type, void *data)
 {
 	struct synth_event *event = container_of(call, struct synth_event, call);
+	int ret;
 
 	switch (type) {
 #ifdef CONFIG_PERF_EVENTS
@@ -844,7 +845,7 @@ static int synth_event_reg(struct trace_
 		break;
 	}
 
-	int ret = trace_event_reg(call, type, data);
+	ret = trace_event_reg(call, type, data);
 
 	switch (type) {
 #ifdef CONFIG_PERF_EVENTS


