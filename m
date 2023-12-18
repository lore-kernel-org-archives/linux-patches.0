Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E194D129EC7;
	Mon, 18 Dec 2023 14:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1P63jw4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68DE3C433C8;
	Mon, 18 Dec 2023 14:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908885;
	bh=aRcW7PHmIKnkm3CoRoqB0Q2MFtC8UwclbsHpoADJczs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y1P63jw4NFc5AQXGxdZW99VsWTSXPanZPDDJ/B4JNixk0+7YUZnOVC7FfHbQONmPc
	 uOxrP0bIe5d4fdkegmOfHN7mpGku6AMYaysD5C2M/1nxMjAyfEw6YRq0iqmSYixxmF
	 G88L3Ryka/SSTI6qArGQVj97ZZA0rASW9JJOBW6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 70/83] tracing: Update snapshot buffer on resize if it is allocated
Date: Mon, 18 Dec 2023 14:52:31 +0100
Message-ID: <20231218135052.816029184@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135049.738602288@linuxfoundation.org>
References: <20231218135049.738602288@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit d06aff1cb13d2a0d52b48e605462518149c98c81 upstream.

The snapshot buffer is to mimic the main buffer so that when a snapshot is
needed, the snapshot and main buffer are swapped. When the snapshot buffer
is allocated, it is set to the minimal size that the ring buffer may be at
and still functional. When it is allocated it becomes the same size as the
main ring buffer, and when the main ring buffer changes in size, it should
do.

Currently, the resize only updates the snapshot buffer if it's used by the
current tracer (ie. the preemptirqsoff tracer). But it needs to be updated
anytime it is allocated.

When changing the size of the main buffer, instead of looking to see if
the current tracer is utilizing the snapshot buffer, just check if it is
allocated to know if it should be updated or not.

Also fix typo in comment just above the code change.

Link: https://lore.kernel.org/linux-trace-kernel/20231210225447.48476a6a@rorschach.local.home

Cc: stable@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Fixes: ad909e21bbe69 ("tracing: Add internal tracing_snapshot() functions")
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6243,7 +6243,7 @@ static int __tracing_resize_ring_buffer(
 	if (!tr->array_buffer.buffer)
 		return 0;
 
-	/* Do not allow tracing while resizng ring buffer */
+	/* Do not allow tracing while resizing ring buffer */
 	tracing_stop_tr(tr);
 
 	ret = ring_buffer_resize(tr->array_buffer.buffer, size, cpu);
@@ -6251,7 +6251,7 @@ static int __tracing_resize_ring_buffer(
 		goto out_start;
 
 #ifdef CONFIG_TRACER_MAX_TRACE
-	if (!tr->current_trace->use_max_tr)
+	if (!tr->allocated_snapshot)
 		goto out;
 
 	ret = ring_buffer_resize(tr->max_buffer.buffer, size, cpu);


