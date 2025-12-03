Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00E3357A57;
	Wed,  3 Dec 2025 16:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778829; cv=none; b=gpk1XNHc0AWLORF96iS04/DM9I129w6Ax+g8EwKVEwExJcuUXx5xvXzj5gVUkKdm5Uy/7u7u+7BWjftvwlvInoq4oWUHA3+X0K3xFQdqWgFAi83KO4RFxPMKvmHGSU7BbZ14N/rQEoBR6fRUqXDJQfKOqPYhfYKn5gRNb7S4TSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778829; c=relaxed/simple;
	bh=xvRQuJflxuCC2pZi75hwFuCrlj6ZypJDXExTGWVnQCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3Yvv8cfD6cgFAVx/oGgqTGEIS265ZXh6nRrT814lNz3vhGjCY0LQKkwkkmZw2SPzJ49xVxnpj6/EaE682jM6USZUg1UFBUbshkUDcM68Ehgofxh0waNlq2LYQbJ7RCkwVi72vi5rd+sjIfr71pdjnd19BCOzxHsUtmVlHU0QLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2wF/Aylr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2wF/Aylr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E4EC4CEF5;
	Wed,  3 Dec 2025 16:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778829;
	bh=xvRQuJflxuCC2pZi75hwFuCrlj6ZypJDXExTGWVnQCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2wF/Aylro2LFaERpRN7XJrLgFhsIJ7NpqT4QygwBIKXU6ZfLrRl7H/IDZd9ZQQj5L
	 wbewBla9Nz/zWsUaOhuljgt4QOuXyyUzmz1YfxcGiav4H5lENxkHxk1eM2fz/ky4Ok
	 T7GOeJJhIexM++PT2a5h5oTe3klqQHF4ox5SwK+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2617fc732430968b45d2@syzkaller.appspotmail.com,
	Noorain Eqbal <nooraineqbal@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/568] bpf: Sync pending IRQ work before freeing ring buffer
Date: Wed,  3 Dec 2025 16:20:41 +0100
Message-ID: <20251203152442.123261442@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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
index 095416e40df3c..1d49e77a6a01b 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -218,6 +218,8 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
 
 static void bpf_ringbuf_free(struct bpf_ringbuf *rb)
 {
+	irq_work_sync(&rb->work);
+
 	/* copy pages pointer and nr_pages to local variable, as we are going
 	 * to unmap rb itself with vunmap() below
 	 */
-- 
2.51.0



