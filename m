Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A684252905;
	Tue, 29 Apr 2025 18:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949703; cv=none; b=sWZu8XBFYS/j0sfli+t0orsAWXEEQvxw90js5b39RAW3s64OR1UHJNhOWUj22Be+RgvStX75lpcYYvQSh3Ixl5KB4gG8b3TGmGi+Lgnn9wWP4HRBVIgLiTD5IMI05FdA6OPBwJtf5ELVMyHJJgHuQoqBNXzw/qSaXh4K8WW4E78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949703; c=relaxed/simple;
	bh=G74FP6qlEzUNNDSsv68y0azF0kCaaDYNYstZNIFOxSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqkTKiz2uLZkhiIB2AtXrFLqxvLt312XHBFC9MXU3oChc2mLtxvaeHfQEcE1Hsps/nbBGySFmC2nErIYYIr1QlKCpfAnJPdn7UYaqnT76dfGdniCSTaRJlmjxL+0bSZsV68/SoMj6xFiGtkNDIqFH0jjDDDl572d5NSEx7SULn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+ieZkPG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+ieZkPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE0BC4CEEE;
	Tue, 29 Apr 2025 18:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949703;
	bh=G74FP6qlEzUNNDSsv68y0azF0kCaaDYNYstZNIFOxSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+ieZkPGElcuSVQfwexMCEQqYJ5DgcxEWLMBmLVpu5JkT8w5lbTyvKuawCV7TZ2Jq
	 yrh6Kz40a5x/uq3OqCj9V03lq0doHJznIRi1bg707jIXMA4ze0m0qph5PPdM5KZ1hh
	 4loBn54Dpr9DMIpbUVSBRCXWSGT6TVaZV1nDTcLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Libo Chen <libo.chen@oracle.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/167] tracing: Verify event formats that have "%*p.."
Date: Tue, 29 Apr 2025 18:41:55 +0200
Message-ID: <20250429161052.048388375@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit ea8d7647f9ddf1f81e2027ed305299797299aa03 ]

The trace event verifier checks the formats of trace events to make sure
that they do not point at memory that is not in the trace event itself or
in data that will never be freed. If an event references data that was
allocated when the event triggered and that same data is freed before the
event is read, then the kernel can crash by reading freed memory.

The verifier runs at boot up (or module load) and scans the print formats
of the events and checks their arguments to make sure that dereferenced
pointers are safe. If the format uses "%*p.." the verifier will ignore it,
and that could be dangerous. Cover this case as well.

Also add to the sample code a use case of "%*pbl".

Link: https://lore.kernel.org/all/bcba4d76-2c3f-4d11-baf0-02905db953dd@oracle.com/

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Fixes: 5013f454a352c ("tracing: Add check of trace event print fmts for dereferencing pointers")
Link: https://lore.kernel.org/20250327195311.2d89ec66@gandalf.local.home
Reported-by: Libo Chen <libo.chen@oracle.com>
Reviewed-by: Libo Chen <libo.chen@oracle.com>
Tested-by: Libo Chen <libo.chen@oracle.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events.c                | 7 +++++++
 samples/trace_events/trace-events-sample.h | 8 ++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index ed0d0c8a2b4bb..8723ad2f9c63b 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -456,6 +456,7 @@ static void test_event_printk(struct trace_event_call *call)
 			case '%':
 				continue;
 			case 'p':
+ do_pointer:
 				/* Find dereferencing fields */
 				switch (fmt[i + 1]) {
 				case 'B': case 'R': case 'r':
@@ -484,6 +485,12 @@ static void test_event_printk(struct trace_event_call *call)
 						continue;
 					if (fmt[i + j] == '*') {
 						star = true;
+						/* Handle %*pbl case */
+						if (!j && fmt[i + 1] == 'p') {
+							arg++;
+							i++;
+							goto do_pointer;
+						}
 						continue;
 					}
 					if ((fmt[i + j] == 's')) {
diff --git a/samples/trace_events/trace-events-sample.h b/samples/trace_events/trace-events-sample.h
index 24ec968d481fb..06be777b3b14b 100644
--- a/samples/trace_events/trace-events-sample.h
+++ b/samples/trace_events/trace-events-sample.h
@@ -317,7 +317,8 @@ TRACE_EVENT(foo_bar,
 		__assign_cpumask(cpum, cpumask_bits(mask));
 	),
 
-	TP_printk("foo %s %d %s %s %s %s %s %s (%s) (%s) %s", __entry->foo, __entry->bar,
+	TP_printk("foo %s %d %s %s %s %s %s %s (%s) (%s) %s [%d] %*pbl",
+		  __entry->foo, __entry->bar,
 
 /*
  * Notice here the use of some helper functions. This includes:
@@ -368,7 +369,10 @@ TRACE_EVENT(foo_bar,
 
 		  __get_str(str), __get_str(lstr),
 		  __get_bitmask(cpus), __get_cpumask(cpum),
-		  __get_str(vstr))
+		  __get_str(vstr),
+		  __get_dynamic_array_len(cpus),
+		  __get_dynamic_array_len(cpus),
+		  __get_dynamic_array(cpus))
 );
 
 /*
-- 
2.39.5



