Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D64F3DD851;
	Mon, 17 Aug 2026 14:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978744; cv=none; b=GdzDMzEIxXvPgHfLahUp2ExpX+QaowU7aqN0pMXhSdUUILqMAd03Fu44Cd9U9apPOHYePpzENRCgyMAWAMlvk46+SxxWSqyxAZtpTY7vAHT5iLpCBMsxTue/yyqZyVWj72o6OVKqYDkAf5USRT5S+Cxkjy/mBy89moU8/BBmR0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978744; c=relaxed/simple;
	bh=2obgAADoT5zdxffaRwito+kZyMviKkuQSukm15PlrAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uU/QFBSktJMPbBAoOuDIZv9LcX6zwLETPuVnj9UVQ7/o62gYAohM40BcS+4/1h9pC5VVSc7iJ5JhuM235eI/5OGUvP8vnE6NKK1Ns9FHZGR2DBJFwndacJNqNT8nXlzlIItNLZ2KNP4XLZeSZv5c+GhBEvx/jwFVjX8t4Ktr6yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppTpyG/W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppTpyG/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760991F000E9;
	Mon, 17 Aug 2026 14:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978743;
	bh=0A00RJ5BWEy6kLSiZB3xDleDVD3KHDefkfYw2EpR8i4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ppTpyG/W8yp4jkU8WWZWGE4ysSGP7UBPAvVtiCs+gUP1418pICQKhlEBElAC8wrhx
	 Atb8JUZ715vVycmrWfcYoPwV1Sfgv0M18HU4rw5d87kyrmGzN5rf0Ckv/9Iuw56/Fp
	 f8hjB7GhCldieFoTA2PKif/M0YPWQjBQPqQu3Yns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tengda Wu <wutengda@huaweicloud.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.6 142/156] ring-buffer: Use current_context for safe per-CPU buffer swap
Date: Mon, 17 Aug 2026 15:34:36 +0200
Message-ID: <20260817132540.269235945@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5458,7 +5458,7 @@ int ring_buffer_swap_cpu(struct trace_bu
 {
 	struct ring_buffer_per_cpu *cpu_buffer_a;
 	struct ring_buffer_per_cpu *cpu_buffer_b;
-	int ret = -EINVAL;
+	int ret = -EBUSY;
 
 	if (!cpumask_test_cpu(cpu, buffer_a->cpumask) ||
 	    !cpumask_test_cpu(cpu, buffer_b->cpumask))
@@ -5494,10 +5494,10 @@ int ring_buffer_swap_cpu(struct trace_bu
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


