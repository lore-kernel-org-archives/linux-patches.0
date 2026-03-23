Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C273BD25D;
	Mon, 23 Mar 2026 16:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282696; cv=none; b=jFy3VyP5Aoc0LN9roRYkxGC/V/4Ajy2UaXer5q47lwlUWCQN0+teVt+UE7o2kBBU1beG+IKu78fE69QH50+lAOtsQi/bmJ4kowo+0cXrXfXZCWYmGwxyo2HVKHHVvNE0PV0ej4w2fwyu34st+KfC4+jA98/cHUxFf8oH0uQdB8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282696; c=relaxed/simple;
	bh=2tMW+LeuuGvquACjhba452C38lWmQONr82fqS1EYbf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+uhaWXkqiU6PN74E3VmQK2EtzrriRgqH3zSxC5/ymk5VMxXpBQViSlJMEs50GO7E5esZTnv8BdVV1p0OCgDoZpvVEeu1sf8Zp3hQe6yY0L3MgQ92b07hfiCNUc3+P3FFnFCtBI/+VVan2idrVNDAYbmA4AJ2kIHq8rrIQ7ew0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pyhaj2W4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pyhaj2W4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA858C2BC9E;
	Mon, 23 Mar 2026 16:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282696;
	bh=2tMW+LeuuGvquACjhba452C38lWmQONr82fqS1EYbf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pyhaj2W4ErO75MC8MQqe5gv8MyYjONyB5ViOkRMZLrKYPrbcd+oad6yFst3tSq9dW
	 jiw+dQbkte8iVDyzwlH6M/6ptY56I6qiYmGs00LeIV5ePAolxGmWMPpWD3/d//CSEd
	 Gs3swH6MxJzKyips33kvBZK++DvC3LaDkbtE9ZOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Calvin Owens <calvin@wbinvd.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 252/481] tracing: Fix trace_buf_size= cmdline parameter with sizes >= 2G
Date: Mon, 23 Mar 2026 14:43:54 +0100
Message-ID: <20260323134531.297076103@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Calvin Owens <calvin@wbinvd.org>

commit d008ba8be8984760e36d7dcd4adbd5a41a645708 upstream.

Some of the sizing logic through tracer_alloc_buffers() uses int
internally, causing unexpected behavior if the user passes a value that
does not fit in an int (on my x86 machine, the result is uselessly tiny
buffers).

Fix by plumbing the parameter's real type (unsigned long) through to the
ring buffer allocation functions, which already use unsigned long.

It has always been possible to create larger ring buffers via the sysfs
interface: this only affects the cmdline parameter.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://patch.msgid.link/bff42a4288aada08bdf74da3f5b67a2c28b761f8.1772852067.git.calvin@wbinvd.org
Fixes: 73c5162aa362 ("tracing: keep ring buffer to minimum size till used")
Signed-off-by: Calvin Owens <calvin@wbinvd.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9298,7 +9298,7 @@ static void
 init_tracer_tracefs(struct trace_array *tr, struct dentry *d_tracer);
 
 static int
-allocate_trace_buffer(struct trace_array *tr, struct array_buffer *buf, int size)
+allocate_trace_buffer(struct trace_array *tr, struct array_buffer *buf, unsigned long size)
 {
 	enum ring_buffer_flags rb_flags;
 
@@ -9334,7 +9334,7 @@ static void free_trace_buffer(struct arr
 	}
 }
 
-static int allocate_trace_buffers(struct trace_array *tr, int size)
+static int allocate_trace_buffers(struct trace_array *tr, unsigned long size)
 {
 	int ret;
 
@@ -10278,7 +10278,7 @@ out:
 
 __init static int tracer_alloc_buffers(void)
 {
-	int ring_buf_size;
+	unsigned long ring_buf_size;
 	int ret = -ENOMEM;
 
 


