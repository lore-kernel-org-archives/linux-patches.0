Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BA27E
	for <patches@lists.linux.dev>; Mon, 19 Dec 2022 12:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651A5C433D2;
	Mon, 19 Dec 2022 12:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671452478;
	bh=n+SE5gIP/i8O/mdjb/S+mxcdjxB2Eeb+0HY2735vIbQ=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=mUpd4t+EaQrOgq9bAfBcwPOg/vJzi53WVAnxrERlcsnRPmbCO6+5pimMmU2jEcV98
	 M9CntuUPybp3l/oEBwmPHFAXsOve0s0GwZ6XgKjWg5VproeRXydIuLwRp6Lb0bbeIF
	 4kQKGiPXZnwbPTSk2wxxGtNEkuUoO1v9Wli7nf1Y=
Subject: Patch "tracing/ring-buffer: Only do full wait when cpu != RING_BUFFER_ALL_CPUS" has been added to the 5.4-stable tree
To: gregkh@linuxfoundation.org,mathieu.desnoyers@efficios.com,mhiramat@kernel.org,patches@lists.linux.dev,primiano@google.com,ptyadav@amazon.de,rostedt@goodmis.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 19 Dec 2022 13:21:16 +0100
In-Reply-To: <20221216134241.81381-1-ptyadav@amazon.de>
Message-ID: <167145247668226@kroah.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    tracing/ring-buffer: Only do full wait when cpu != RING_BUFFER_ALL_CPUS

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     tracing-ring-buffer-only-do-full-wait-when-cpu-ring_buffer_all_cpus.patch
and it can be found in the queue-5.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From ptyadav@amazon.de  Mon Dec 19 13:19:42 2022
From: Pratyush Yadav <ptyadav@amazon.de>
Date: Fri, 16 Dec 2022 14:42:41 +0100
Subject: tracing/ring-buffer: Only do full wait when cpu != RING_BUFFER_ALL_CPUS
To: <stable@vger.kernel.org>
Cc: Pratyush Yadav <ptyadav@amazon.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <patches@lists.linux.dev>, Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Primiano Tucci <primiano@google.com>, "Steven Rostedt (Google)" <rostedt@goodmis.org>
Message-ID: <20221216134241.81381-1-ptyadav@amazon.de>

From: Pratyush Yadav <ptyadav@amazon.de>

full_hit() directly uses cpu as an array index. Since
RING_BUFFER_ALL_CPUS == -1, calling full_hit() with cpu ==
RING_BUFFER_ALL_CPUS will cause an invalid memory access.

The upstream commit 42fb0a1e84ff ("tracing/ring-buffer: Have polling
block on watermark") already does this. This was missed when backporting
to v5.4.y.

This bug was discovered and resolved using Coverity Static Analysis
Security Testing (SAST) by Synopsys, Inc.

Fixes: e65ac2bdda54 ("tracing/ring-buffer: Have polling block on watermark")
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -727,6 +727,7 @@ __poll_t ring_buffer_poll_wait(struct ri
 
 	if (cpu == RING_BUFFER_ALL_CPUS) {
 		work = &buffer->irq_work;
+		full = 0;
 	} else {
 		if (!cpumask_test_cpu(cpu, buffer->cpumask))
 			return -EINVAL;


Patches currently in stable-queue which might be from ptyadav@amazon.de are

queue-5.4/tracing-ring-buffer-only-do-full-wait-when-cpu-ring_buffer_all_cpus.patch
