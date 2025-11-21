Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302B4346E72;
	Fri, 21 Nov 2025 13:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732279; cv=none; b=k2SyATkDGvR6sxQPOAXHQeFeFxVkVAJJVBBsQfneJQ9MGlCdQ3GRQ22OCOig4vbBzGpbBFIaiYPr7c1tOVo2Th2PDirFdPqggPEi2KFDxas9hPdABb32rJlNq4kmvUqyTSAPCHclNk22NvwlAAuQVnHi8WOvBP/4E1T3XdkrHnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732279; c=relaxed/simple;
	bh=ojje+MKMyvYFAYUqlgqSU1z5aOS8IVHxYI5zrzfXwtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ehcXJpcBQgRtZw13yhmhclnPYqfkvu8BVwZHzwWf5dpOST7ujS7mn0oSGU/wlxdzlIbDH/wckcMEX6qfLD/xKdsnqjzcmvR7fd2B3DHiwBWVd6F1BMakY1mPAQztuTYlcgDOJtPo7cU5eAxJypoBgT1xPDd35phT47UdD/WID54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SfG1Gk6Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SfG1Gk6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571C4C4CEF1;
	Fri, 21 Nov 2025 13:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732278;
	bh=ojje+MKMyvYFAYUqlgqSU1z5aOS8IVHxYI5zrzfXwtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SfG1Gk6ZVUxhO/tsfLAAtKtA0HXgwtCOemSMSMVzPi9YwiY74l8tf0MAW7uIUiSu3
	 CJu25cOGO+P3NkfPYKo9WSpaY0mbKrbMpz8VH7f6S73pcyw1nS3RDcr3D9binBssKh
	 +Z9DSqT4GNnpGj0KKZ0FZyukkScvbfZe4cFzX1Uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2617fc732430968b45d2@syzkaller.appspotmail.com,
	Noorain Eqbal <nooraineqbal@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/529] bpf: Sync pending IRQ work before freeing ring buffer
Date: Fri, 21 Nov 2025 14:05:21 +0100
Message-ID: <20251121130231.791322174@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Noorain Eqbal <nooraineqbal@gmail.com>

[ Upstream commit 4e9077638301816a7d73fa1e1b4c1db4a7e3b59c ]

Fix a race where irq_work can be queued in bpf_ringbuf_commit()
but the ring buffer is freed before the work executes.
In the syzbot reproducer, a BPF program attached to sched_switch
triggers bpf_ringbuf_commit(), queuing an irq_work. If the ring buffer
is freed before this work executes, the irq_work thread may accesses
freed memory.
Calling `irq_work_sync(&rb->work)` ensures that all pending irq_work
complete before freeing the buffer.

Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier support for it")
Reported-by: syzbot+2617fc732430968b45d2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2617fc732430968b45d2
Tested-by: syzbot+2617fc732430968b45d2@syzkaller.appspotmail.com
Signed-off-by: Noorain Eqbal <nooraineqbal@gmail.com>
Link: https://lore.kernel.org/r/20251020180301.103366-1-nooraineqbal@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/ringbuf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 6aff5ee483b60..c0c5e9b313e43 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -215,6 +215,8 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
 
 static void bpf_ringbuf_free(struct bpf_ringbuf *rb)
 {
+	irq_work_sync(&rb->work);
+
 	/* copy pages pointer and nr_pages to local variable, as we are going
 	 * to unmap rb itself with vunmap() below
 	 */
-- 
2.51.0



