Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792775019;
	b=JBK0gFEmx3TL12jFzRNL7G2bIqmbu4BvKDTChV8JJ6NVi/PjFPbOL9QWN8X2iBnXtSXq
	 DkctduJpKuPLqMRB/eMOQ+p4/7R0QTGf6lsI/6WAQY3cDLXpltPgHziLCg29jW/DPWYxD
	 nzrozkH1JMN/dBCMLqaiFVNDgGbPwu+aaz5mbPKrT2J2L88Q1rBA5mUxNh7fCjgv/v1ev
	 e/LTSv3lS+hDr+EpBUInDJgmkv08D/fkeNeo+YNiZovSDTB3YIZIO+Br7wP2m6L4SGydF
	 izhqaPWaxTyFSOOhMBGnW8A3CX+MpMHZzcBQKxOnEOy2CImzH04wC5u/y1D9G62sTmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792775019;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=30ZJOrLXVinV8Dh4E0vGyKrAWCY6jwZ963l67u1Pt6U=;
	b=453cIsfhdYJ8M95g6n+l2HltrRPn6oq9Tr+MCfAnGLUFfpc9ibaYwpven5cc4LcagwAA
	 8oDxWIp+f7A/AySUHc1aSI7z8CXapsGb2mSeX6iJEbE8ZSvr6zLKQuaqsCMg3FgMM9Qk+
	 U7/ppjieHFhvlnb0OnqUSqZXncSFhdIrLcrVKZlOghCYY3/sF0ikOnl06/e9ZCv2KPFRK
	 24aqIPI4j9YzgupPL7sLqorNE67n7nEwoZd3lCu9Fggu89o+UvIuGTMAggtFCc/9GRvnT
	 gJDYHXB+NiqnAs+KTxGPOf6Nwg7uVeSFNbTxqnc5cakJku8+gt16P3IjYiJ6waZRzXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vcvYktW4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74106606A31A;
	Fri, 23 Oct 2026 17:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vcvYktW4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE7B1F01825;
	Fri, 23 Oct 2026 17:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792775019;
	bh=30ZJOrLXVinV8Dh4E0vGyKrAWCY6jwZ963l67u1Pt6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vcvYktW4eXOERsMtg3qVI57BxbnSqx50z8BVDgCxRuXBaKaKOoVE7VTf/1lWpS/fz
	 jgJQy75fbuokLoINu8hdIf+kYOUBsCWrQ20G7NIuqgKVJqh/v4jnwTRmo5r1YRqI6n
	 p01jUgHgoUI1BFo+XbgikZd016h9zZY6VBpgMjZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 234/242] tracing: Fix NULL dereference when copying keys for a field variable
Date: Fri, 23 Oct 2026 18:41:16 +0200
Message-ID: <20261023163719.384569851@linuxfoundation.org>
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
@@ -3078,7 +3078,7 @@ create_field_var_hist(struct hist_trigge
 		key_field = hist_data->fields[i];
 		if (!first)
 			seq_buf_putc(&s, ',');
-		seq_buf_puts(&s, key_field->field->name);
+		expr_field_str(key_field, &s);
 		first = false;
 	}
 


