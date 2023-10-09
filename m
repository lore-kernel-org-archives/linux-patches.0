Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7851339B0
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zd752rXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218A8C433C7;
	Mon,  9 Oct 2023 13:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859048;
	bh=3h8ERZ/VYULHA5vUmJa8xEcwzlJMIR9dwLSLcbjs0Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zd752rXpXp7Et5yZeO4dhVOIxv5dTL305UGlmMKyXR2esdDYkNGig7C51eofUGOty
	 BL5A1feyy/zAX2qSlXrsMBdqfo2sIJIAsuSvFWoF0OPlNJQjBCN9K5CaNKAlvRDUii
	 LTQgFinoWR5yzvzraHrI0PHdUCeA3QhhPz3gtykc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Julia Lawall <julia.lawall@inria.fr>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 154/226] ring-buffer: Update "shortest_full" in polling
Date: Mon,  9 Oct 2023 15:01:55 +0200
Message-ID: <20231009130130.723624152@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 1e0cb399c7653462d9dadf8ab9425337c355d358 upstream.

It was discovered that the ring buffer polling was incorrectly stating
that read would not block, but that's because polling did not take into
account that reads will block if the "buffer-percent" was set. Instead,
the ring buffer polling would say reads would not block if there was any
data in the ring buffer. This was incorrect behavior from a user space
point of view. This was fixed by commit 42fb0a1e84ff by having the polling
code check if the ring buffer had more data than what the user specified
"buffer percent" had.

The problem now is that the polling code did not register itself to the
writer that it wanted to wait for a specific "full" value of the ring
buffer. The result was that the writer would wake the polling waiter
whenever there was a new event. The polling waiter would then wake up, see
that there's not enough data in the ring buffer to notify user space and
then go back to sleep. The next event would wake it up again.

Before the polling fix was added, the code would wake up around 100 times
for a hackbench 30 benchmark. After the "fix", due to the constant waking
of the writer, it would wake up over 11,0000 times! It would never leave
the kernel, so the user space behavior was still "correct", but this
definitely is not the desired effect.

To fix this, have the polling code add what it's waiting for to the
"shortest_full" variable, to tell the writer not to wake it up if the
buffer is not as full as it expects to be.

Note, after this fix, it appears that the waiter is now woken up around 2x
the times it was before (~200). This is a tremendous improvement from the
11,000 times, but I will need to spend some time to see why polling is
more aggressive in its wakeups than the read blocking code.

Link: https://lore.kernel.org/linux-trace-kernel/20230929180113.01c2cae3@rorschach.local.home

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Fixes: 42fb0a1e84ff ("tracing/ring-buffer: Have polling block on watermark")
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Tested-by: Julia Lawall <julia.lawall@inria.fr>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1008,6 +1008,9 @@ __poll_t ring_buffer_poll_wait(struct tr
 	if (full) {
 		poll_wait(filp, &work->full_waiters, poll_table);
 		work->full_waiters_pending = true;
+		if (!cpu_buffer->shortest_full ||
+		    cpu_buffer->shortest_full > full)
+			cpu_buffer->shortest_full = full;
 	} else {
 		poll_wait(filp, &work->waiters, poll_table);
 		work->waiters_pending = true;


