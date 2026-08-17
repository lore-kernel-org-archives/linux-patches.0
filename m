Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371152AEE1;
	Mon, 17 Aug 2026 14:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977780; cv=none; b=S+AjQ2jCdOjP4ZQPKhpbun9KKTjea05W+IPzpqzJnAZBp3H1ygqul2MvIbfxi/3VS1af1TETCkdYiWkljv2Ib6coxhDAZ+sKV6bQrYLmd9KPfG9Ups0k+5qPkQIAnY40i+EUEY5MYbRnQVaOqMw/C4QFXWNKE2heGeLA36ezmlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977780; c=relaxed/simple;
	bh=tVqynr1YvF/AlrTouj75C8jfak/llHLo4ynTQor3Lx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MuQyD29p0VhLlZRuAgQOxQLxbCjDtKtJKnIJvk63V+qLQQ7ak/THLtTpqhfd6X+uaVpCxasGWErtnPYQyzHxGFhzuGIY9bKj2ptZskT2FsEZcFmYaulwYPL+pBqrcqmFLzZ/YZJw0Xc6lyNnybaHu1/J4jq9W3afCh7SsSmu49E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nr6As1jD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nr6As1jD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913761F00A3A;
	Mon, 17 Aug 2026 14:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977779;
	bh=K9eD+xs0mAllxml1A9RSgiyngDSvjcdbvZyAOnod+LI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nr6As1jD+ZgWouHl/yp+42NMO7V5ZRlDQvYrkgjnOT2yGlOdZWoyec11qjX4mlkEO
	 4RojtZ6wLscKynIjyaqdRsrB0zteeFbBknouDYVBK4xoouY06j8osHEyY9hlmfGoyx
	 Mt7HAuIvmfCUKavkmwi+c56vGMr2ONvjST2sKJJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tengda Wu <wutengda@huaweicloud.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.15 448/456] ring-buffer: Use current_context for safe per-CPU buffer swap
Date: Mon, 17 Aug 2026 15:33:58 +0200
Message-ID: <20260817132556.574885360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tengda Wu <wutengda@huaweicloud.com>

commit f27bdc43077e4fcb5557dfc315ee8d91e741f483 upstream.

The ring_buffer_swap_cpu() function currently checks the per-CPU
committing counter to determine if a buffer is actively being written to
before performing the swap. However, there exists a race window where
this check can be bypassed:

    ring_buffer_lock_reserve
        cpu_buffer = buffer->buffers[cpu];       // cpu_buffer_a
        rb_reserve_next_event
            rb_start_commit // inc committing
            if (unlikely(READ_ONCE(cpu_buffer->buffer) != buffer)) {...}
            __rb_reserve_next
                rb_move_tail
                    rb_end_commit(cpu_buffer);   // dec committing => 0
                    /* interrupt hits here, successfully swaps! */
                    local_inc(&cpu_buffer->committing);

    ring_buffer_unlock_commit
        cpu_buffer = buffer->buffers[cpu];      // cpu_buffer_b
        rb_commit
            rb_end_commit
            RB_WARN_ON(cpu_buffer, !local_read(&cpu_buffer->committing))
                                                // triggers warning

The committing counter can temporarily drop to 0 during a single write
operation (within rb_move_tail), creating a window where swap can
succeed even though the write is still in progress. This leads to
inconsistent buffer state and triggers the RB_WARN_ON in rb_commit().

Replace the committing counter check with current_context checks, which
are set at the entry of ring_buffer_lock_reserve() and remain valid
throughout the entire write operation, providing a reliable indicator of
buffer busy state during swap.

Cc: stable@vger.kernel.org
Fixes: 4239c38fe0b3 ("ring-buffer: Process commits whenever moving to a new page.")
Link: https://patch.msgid.link/20260803005640.2445666-2-wutengda@huaweicloud.com
Signed-off-by: Tengda Wu <wutengda@huaweicloud.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -5415,7 +5415,7 @@ int ring_buffer_swap_cpu(struct trace_bu
 {
 	struct ring_buffer_per_cpu *cpu_buffer_a;
 	struct ring_buffer_per_cpu *cpu_buffer_b;
-	int ret = -EINVAL;
+	int ret = -EBUSY;
 
 	if (!cpumask_test_cpu(cpu, buffer_a->cpumask) ||
 	    !cpumask_test_cpu(cpu, buffer_b->cpumask))
@@ -5451,10 +5451,10 @@ int ring_buffer_swap_cpu(struct trace_bu
 	atomic_inc(&cpu_buffer_a->record_disabled);
 	atomic_inc(&cpu_buffer_b->record_disabled);
 
-	ret = -EBUSY;
-	if (local_read(&cpu_buffer_a->committing))
+	/* Do not swap if either buffer is in the process of writing */
+	if (cpu_buffer_a->current_context)
 		goto out_dec;
-	if (local_read(&cpu_buffer_b->committing))
+	if (cpu_buffer_b->current_context)
 		goto out_dec;
 
 	/*


