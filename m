Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF4D1D127;
	Mon, 18 Dec 2023 13:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tnpdm+XZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910E5C433C8;
	Mon, 18 Dec 2023 13:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907958;
	bh=Xm6b1MT/7vuP4yOAf/cQLQ1GbMybGUCRJ0RnGDn9oSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tnpdm+XZOKB23BQ57FR8eEaqZpct68hFmw35rtR8/CQZRp6KF4cEVoBGVfRFUbtE4
	 jljFHwYNiU8Yu6ZmHSLzRVFhGsCfzCI0bxVU+TdfnBS21s24BHNPEV5vsgp/vPm9Il
	 WEPoGQ5fTa+Za5VbOCJ9EKAesRPlhg4NYgqKjWu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 096/106] tracing: Update snapshot buffer on resize if it is allocated
Date: Mon, 18 Dec 2023 14:51:50 +0100
Message-ID: <20231218135059.165518868@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135055.005497074@linuxfoundation.org>
References: <20231218135055.005497074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6268,7 +6268,7 @@ static int __tracing_resize_ring_buffer(
 	if (!tr->array_buffer.buffer)
 		return 0;
 
-	/* Do not allow tracing while resizng ring buffer */
+	/* Do not allow tracing while resizing ring buffer */
 	tracing_stop_tr(tr);
 
 	ret = ring_buffer_resize(tr->array_buffer.buffer, size, cpu);
@@ -6276,7 +6276,7 @@ static int __tracing_resize_ring_buffer(
 		goto out_start;
 
 #ifdef CONFIG_TRACER_MAX_TRACE
-	if (!tr->current_trace->use_max_tr)
+	if (!tr->allocated_snapshot)
 		goto out;
 
 	ret = ring_buffer_resize(tr->max_buffer.buffer, size, cpu);


