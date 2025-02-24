Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BF0233729;
	Mon, 24 Feb 2025 14:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408378; cv=none; b=adi3QhJRgrBP357qmYQlJyX/vohvevgMMciuRhUi6CkCoObq1z0G7OUBa4tsb66+rnfpfEbskhPzDs2eQJQbC7buOOximRHgzqYijiqLrHG1lOEC6ZnHEktheoOp/q90weUM5ygeFuvXuSLRsds0N2cFKiOKwpXk338qlHYmnkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408378; c=relaxed/simple;
	bh=PFY4IPgzfYLxarm6Tz/qDPt4MFqppwsu95XDX0jYx7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0x7De3Wcflv0D3P7etVu6rpV0yFn7BxOTPtm1IuQwLhlqaIC7Nw9s3D5snFDOvxChPcRmxitcwp6GPpZFJgUtkQRedqdannV2e2Eg33j1bgfWpuuiJ0fVJ2SH4gt9XPAf4gosGrnaFAUjUSgRdD/r+FLxr97SbhalEqyKVQBkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QaiGkfxp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QaiGkfxp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADAFBC4CED6;
	Mon, 24 Feb 2025 14:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408378;
	bh=PFY4IPgzfYLxarm6Tz/qDPt4MFqppwsu95XDX0jYx7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QaiGkfxpsJVdeyX795QYA8ssnfZFzDCuBzxoi2JL5rUqeD7zLSPzLhK0ptfktu/xi
	 M9BrF4L0UW9BShgOsknBFWU8jxmnvh8nZ6lXxXd15yKGj06KswPxyQTHFTiN0r7QbT
	 B7+ItjeEjWDEqfLPd6NAYMSfbQjjgO4X3nzSItNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/154] tracing: Have the error of __tracing_resize_ring_buffer() passed to user
Date: Mon, 24 Feb 2025 15:33:59 +0100
Message-ID: <20250224142608.664418350@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 60b8f711143de7cd9c0f55be0fe7eb94b19eb5c7 ]

Currently if __tracing_resize_ring_buffer() returns an error, the
tracing_resize_ringbuffer() returns -ENOMEM. But it may not be a memory
issue that caused the function to fail. If the ring buffer is memory
mapped, then the resizing of the ring buffer will be disabled. But if the
user tries to resize the buffer, it will get an -ENOMEM returned, which is
confusing because there is plenty of memory. The actual error returned was
-EBUSY, which would make much more sense to the user.

Cc: stable@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Vincent Donnefort <vdonnefort@google.com>
Link: https://lore.kernel.org/20250213134132.7e4505d7@gandalf.local.home
Fixes: 117c39200d9d7 ("ring-buffer: Introducing ring-buffer mapping functions")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f03eef90de54c..1142a7802bb60 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5998,8 +5998,6 @@ static int __tracing_resize_ring_buffer(struct trace_array *tr,
 ssize_t tracing_resize_ring_buffer(struct trace_array *tr,
 				  unsigned long size, int cpu_id)
 {
-	int ret;
-
 	guard(mutex)(&trace_types_lock);
 
 	if (cpu_id != RING_BUFFER_ALL_CPUS) {
@@ -6008,11 +6006,7 @@ ssize_t tracing_resize_ring_buffer(struct trace_array *tr,
 			return -EINVAL;
 	}
 
-	ret = __tracing_resize_ring_buffer(tr, size, cpu_id);
-	if (ret < 0)
-		ret = -ENOMEM;
-
-	return ret;
+	return __tracing_resize_ring_buffer(tr, size, cpu_id);
 }
 
 static void update_last_data(struct trace_array *tr)
-- 
2.39.5



