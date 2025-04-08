Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3869B267F5F;
	Tue,  8 Apr 2025 11:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112200; cv=none; b=IPrjsk2/Mvy63WDrH7pOB9Et/Ic2qG9UUlbrDVhUWrfwInOyVYnMxyRI/u7YjLYehwQMv65jpp1RD9O8naAPu1cjHYS64g/4AjISBKsnXvDo4jWPtVFd73S42LxjBZXuw4ELvhJJhm4f4A2jOhrf+L/MAnwQQ87/wkzPsL9KBDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112200; c=relaxed/simple;
	bh=BE9mTJ4xhBnqaXs8MLDKsTLdbJ3LhpEwL7TOomo5Yz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aKQKJdJ8S1lR99AIqYTSgyxvIx0jEnYLgM5QcFkZQAcMW137MayQajuSW4x/6ZjmB8+rCha9FP5WA5sT9VzK+0NCu8aibdk3WyYZMZNCo+58wM8jg+R3cM09Tapm9haPVX5urHQinD4023MnUJXGT3ejhdOIw4azU464VuI0Lis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fuygwWxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fuygwWxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0EBCC4CEE5;
	Tue,  8 Apr 2025 11:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112200;
	bh=BE9mTJ4xhBnqaXs8MLDKsTLdbJ3LhpEwL7TOomo5Yz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fuygwWxX4KSH1HP9SrBRyQ4u/i2CpTcncQnkMRGyRPZIrsmxzxmWj+2PSDwP4QeMn
	 OquFU8iApI1G/dX7g1+TM2z6Kk/BKu/QGznELyqMTJxhmApdGw9z+iGX72JhKknAJm
	 Tnz/KAl2591Az/B5QIGFMU3VLm0ZZ0iQdQ8yYVVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Libo Chen <libo.chen@oracle.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.14 711/731] tracing: Verify event formats that have "%*p.."
Date: Tue,  8 Apr 2025 12:50:08 +0200
Message-ID: <20250408104930.811248871@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit ea8d7647f9ddf1f81e2027ed305299797299aa03 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events.c                |    7 +++++++
 samples/trace_events/trace-events-sample.h |    8 ++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -470,6 +470,7 @@ static void test_event_printk(struct tra
 			case '%':
 				continue;
 			case 'p':
+ do_pointer:
 				/* Find dereferencing fields */
 				switch (fmt[i + 1]) {
 				case 'B': case 'R': case 'r':
@@ -498,6 +499,12 @@ static void test_event_printk(struct tra
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
--- a/samples/trace_events/trace-events-sample.h
+++ b/samples/trace_events/trace-events-sample.h
@@ -319,7 +319,8 @@ TRACE_EVENT(foo_bar,
 		__assign_cpumask(cpum, cpumask_bits(mask));
 	),
 
-	TP_printk("foo %s %d %s %s %s %s %s %s (%s) (%s) %s", __entry->foo, __entry->bar,
+	TP_printk("foo %s %d %s %s %s %s %s %s (%s) (%s) %s [%d] %*pbl",
+		  __entry->foo, __entry->bar,
 
 /*
  * Notice here the use of some helper functions. This includes:
@@ -370,7 +371,10 @@ TRACE_EVENT(foo_bar,
 
 		  __get_str(str), __get_str(lstr),
 		  __get_bitmask(cpus), __get_cpumask(cpum),
-		  __get_str(vstr))
+		  __get_str(vstr),
+		  __get_dynamic_array_len(cpus),
+		  __get_dynamic_array_len(cpus),
+		  __get_dynamic_array(cpus))
 );
 
 /*


