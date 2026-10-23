Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774265;
	b=drYtWS1KY4QrUkEvSr/x79XV5iXHu34AxcKOYBgNAD+4+RCh3lKMaSADWHzp66g10JhK
	 3sz0kyNfxNJ/wT4oVr3N0rw3iV+1Lucm3M5vUzn5jYH2aFLei/L6MP0B3sBSWajyRtHpk
	 h8uFkcP4tZTVBiJpvp/YqryhQyANJSMLxs2Lq2ZU9ev71yYjXmoDk06hFDH7sA13YawUi
	 l/nWL7wogzCcQDgXV+ipONdy/8shSYrH7MVyi/draBJz/1iT6TAfWSDV20NsX2x+Z0Aa0
	 BbRw7StO9b3K9CZo6jptDh9qn2jFMMXzUKEhVP5HJecIYlWb0OLAuPdLM6fOff+HWVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774265;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aet5d1VpDMkqmg7sKAMBkyrnbqt1A5iiYmPdMcoduv8=;
	b=cBqReqr4kgXaOldbSvc9O6V+POT40YZOo7fTeqrPDGbC8W9gIpfxn0h1/WqeV7vrFKT5
	 JoG65m0G77ElhW1Lh1xbgQEu5GY47K7FdoQBxJSw8UsV6Gj7cn9MrvdT7yghnTHvmI6O6
	 CgweTKRM+U0Do7VTIdVaU4EO4aQqmCvTgeOGE6Xiolhtm2stDjbrH5PCKLaWE66rOp48c
	 ixtXzhXBg0wNPCkZxmccPrWDi1BWyG6MB95o8OK6gafOwCGh4R0EhYnfSSfwCpFJumbzV
	 e6H6vjOfT0Bui12WUMkde/kHHbVfL9QHbqV3BxI5rp1bb0RnTtASJJG4lwfdC4O/OXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rzS206+F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F105D606A324;
	Fri, 23 Oct 2026 16:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rzS206+F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF981F01825;
	Fri, 23 Oct 2026 16:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774264;
	bh=aet5d1VpDMkqmg7sKAMBkyrnbqt1A5iiYmPdMcoduv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rzS206+F4T0/BwXAOO2g9ghrYHM3bft+MRxvANmAiSgwB+1xcYTegUCU9zrIUhNy6
	 O+IsHWupkcRX9z2HKGe7bAw1VgBqhCt9a7Wu9MRbO657d8xFHNre8iObuolJFLHxvY
	 d7nKXB2SXXbeFyI3DnW7EAEeRgak4OLxBc8SN/34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 174/193] tracing: Fix NULL dereference when copying keys for a field variable
Date: Fri, 23 Oct 2026 18:37:31 +0200
Message-ID: <20261023163718.334119226@linuxfoundation.org>
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

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit a0777b9e53157f1f6848a0fd0650f5465391ea81 ]

In event_hist_trigger_parse() where it needs to create actions like
"onmatch", it calls:

  event_hist_trigger_parse() {
    create_actions() {
      action_create() {
        trace_action_create() {
          trace_action_create_field_var() {
            create_field_var_hist()

Where create_field_var_hist() does a loop on the hist_data
representing the keys. The issue is, if the keys uses one of the
pseudo field types (like common_cpu), the hist_data field element
will have NULL for its field member causing a NULL pointer
dereference when accessing the key_field->field->name.

  # echo 'hist:keys=common_cpu:ts0=common_timestamp.usecs' > \
      events/sched/sched_waking/trigger
  # echo 'my_synth u64 lat; int prio' > synthetic_events
  # echo 'hist:keys=common_cpu:wakeup_lat=common_timestamp.usecs-$ts0:\
      onmatch(sched.sched_waking).my_synth($wakeup_lat,prio)' > \
      events/sched/sched_switch/trigger

  KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
  RIP: 0010:create_field_var_hist+0x771/0x1380
  Call Trace:
   trace_action_create_field_var+0x360/0x600
   trace_action_create+0x393/0xe80
   event_hist_trigger_parse+0x3e47/0x69e0
   trigger_process_regex+0x1a6/0x250
   event_trigger_write+0xce/0x160

Instead of accessing it directly, use the proper handler
expr_field_str() to get the name.

The three previous patches are prerequisites: without them a .buckets
key and a common_stacktrace key each render into a command that cannot
be parsed back.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260914053443.981201-5-donggeunyoo.kernel@gmail.com
Fixes: 02205a6752f2 ("tracing: Add support for 'field variables'")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Assisted-by: Claude:claude-fable-5
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -3081,7 +3081,7 @@ create_field_var_hist(struct hist_trigge
 		key_field = hist_data->fields[i];
 		if (!first)
 			seq_buf_putc(&s, ',');
-		seq_buf_puts(&s, key_field->field->name);
+		expr_field_str(key_field, &s);
 		first = false;
 	}
 


