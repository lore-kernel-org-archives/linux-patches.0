Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1461C6F65;
	Tue, 27 Aug 2024 15:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770939; cv=none; b=CfhZ//ob/+n4GcllqtWDY0kSLSQNcrLmDc0+5PoFPIFj+MlrreE/83vouWdB2zvTKjL3NAQGNTQle9/kXASDfvEKqltG/F342WILRlCSG7hZkxXWTagZlnrdmCBo778CYupQFOmL36UWcIdHwQuITqqPUm0tcIz4Q6MxYCtUpU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770939; c=relaxed/simple;
	bh=bUG0G0lZN93kdBjbdRjhl+P5OjQO3MwVn+6SnyAHz20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HeUCFRRx7KJwxmnDePvG/0kdoqLFBpWYxFIufqmC0vcL4SNyB6NwYQ8ZewHm34S+hidDxzS9s1rJO/wFlw24ZGisIGR69WazP8qW9mIVxQ7CNx0ebaULi1JW6B4seWzfwf9/SoEA7GBQVXEC+3bwJrKorWcxIEpGeW2CDbntDyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nHZrHAlH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nHZrHAlH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE21BC4DDF7;
	Tue, 27 Aug 2024 15:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770939;
	bh=bUG0G0lZN93kdBjbdRjhl+P5OjQO3MwVn+6SnyAHz20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHZrHAlHUfrf/20oiyjHRnqngbMBARru5ryS1FEoOKHEb1u501QELe0kWvGxsyI3L
	 nhiibJhlKYZY6EySYDLhYeJgFEVC4/QF3GffUkDKK/faPgjKEZXy49vNSEwsMAD9gx
	 IZBr3CJfaQqGtoq+ZJ1ZY6A/RyVS2aDrDKers7+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.10 039/273] tracing: Return from tracing_buffers_read() if the file has been closed
Date: Tue, 27 Aug 2024 16:36:03 +0200
Message-ID: <20240827143834.884418382@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit d0949cd44a62c4c41b30ea7ae94d8c887f586882 upstream.

When running the following:

 # cd /sys/kernel/tracing/
 # echo 1 > events/sched/sched_waking/enable
 # echo 1 > events/sched/sched_switch/enable
 # echo 0 > tracing_on
 # dd if=per_cpu/cpu0/trace_pipe_raw of=/tmp/raw0.dat

The dd task would get stuck in an infinite loop in the kernel. What would
happen is the following:

When ring_buffer_read_page() returns -1 (no data) then a check is made to
see if the buffer is empty (as happens when the page is not full), it will
call wait_on_pipe() to wait until the ring buffer has data. When it is it
will try again to read data (unless O_NONBLOCK is set).

The issue happens when there's a reader and the file descriptor is closed.
The wait_on_pipe() will return when that is the case. But this loop will
continue to try again and wait_on_pipe() will again return immediately and
the loop will continue and never stop.

Simply check if the file was closed before looping and exit out if it is.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20240808235730.78bf63e5@rorschach.local.home
Fixes: 2aa043a55b9a7 ("tracing/ring-buffer: Fix wait_on_pipe() race")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 10cd38bce2f1..ebe7ce2f5f4a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -7956,7 +7956,7 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 	trace_access_unlock(iter->cpu_file);
 
 	if (ret < 0) {
-		if (trace_empty(iter)) {
+		if (trace_empty(iter) && !iter->closed) {
 			if ((filp->f_flags & O_NONBLOCK))
 				return -EAGAIN;
 
-- 
2.46.0



