Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E308430C61E;
	Wed,  3 Dec 2025 15:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775886; cv=none; b=hjR7mNeMOprYBlO8wuRFP9eA4DIYNDW9JZOgsrE1/KN8OSXpYwRZBaYJNy/vryosHqnZUk1eYmInWvW7r6VkcZ8bHvjWW9aDjSCRCS8Tu9LvZs69aKfAVDOhaE+mHZtRwZ2d1kisdZ9Ddhi2TWXl/f8S3Un0lOypAkiTtFvdcto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775886; c=relaxed/simple;
	bh=y5EMBsRSHwxwhPGQo0f7ZSPAmfDIx7EbZ/KSUHJ4dx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUcOVhFDlZsrkyDGsGmhP9CYe3NG6m7SmW1AWNQlNyWdad5hVsOxMWUZy4HPObNJiK3da5yzO9u1pkg1I819TfX4eJ80mmaLtCE4Eb72o0UgL6VFy67ych/l0WyAxoccefpLmmU8/uwY4o1cAsWGQFil9HQXOuAAcRCtGMX0mrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UV9xxvGq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UV9xxvGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A899C116C6;
	Wed,  3 Dec 2025 15:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764775885;
	bh=y5EMBsRSHwxwhPGQo0f7ZSPAmfDIx7EbZ/KSUHJ4dx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UV9xxvGq6/o6qv5vWwlrRciLdYuJVlDu+QJOPAeMMMJvfRw0LuYidTd2IZJPWSvas
	 VDLV75Ghf6wKnyus7xLdhHOj0WL13FdtNCukwUyUtTwf2YA6oi8ZGVOTrIWteHVAus
	 Dls5cvXaWLdsi34e6ru4+9DUUHFX+GtSQBHCHku4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2617fc732430968b45d2@syzkaller.appspotmail.com,
	Noorain Eqbal <nooraineqbal@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/300] bpf: Sync pending IRQ work before freeing ring buffer
Date: Wed,  3 Dec 2025 16:23:41 +0100
Message-ID: <20251203152401.095630489@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/bpf/ringbuf.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -209,6 +209,8 @@ static void bpf_ringbuf_free(struct bpf_
 	struct page **pages = rb->pages;
 	int i, nr_pages = rb->nr_pages;
 
+	irq_work_sync(&rb->work);
+
 	vunmap(rb);
 	for (i = 0; i < nr_pages; i++)
 		__free_page(pages[i]);


