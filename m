Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E027981749;
	Mon,  8 Apr 2024 13:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582653; cv=none; b=i6bwDIThtFhWZ1LRRpK0dfcf9xyGTCuREY1OKqTA91WXi5JD1Xx0MukEPvH+HM2Lw+OS0oXkX6Ed2I5wQaRMHsYLbdrgVH9Rjlbls7XUg6lVBez+p4Y2NPq3V3wTvRMGVva/+GMQ2iOFx3YQdcueoYFTSu6DENd0Gnxxc6SBvo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582653; c=relaxed/simple;
	bh=vRH42ZCmFi1gmn2QjDYr1nvzM7cmhqbDlXtVxmjAhfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ecvyzZxqxjzCaUOYTv+JEmxLdlS4dcOX64IdkW3QnqYjPoyBqr6u69mK08WM6DGqDEv9ObF4Zuu4ryUEfGlu/bqL2B/SqB5Prt9opN5qyN51+o0zqVuu4CNwT3CO8tpwecSJXDdJ+n9Hjkj+Jslj/lI5ciyJjzIXvKUnYkaCdfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aoandXEp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aoandXEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6740FC433C7;
	Mon,  8 Apr 2024 13:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582652;
	bh=vRH42ZCmFi1gmn2QjDYr1nvzM7cmhqbDlXtVxmjAhfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aoandXEpve80FXPQGcdjuAbltHGhD6tZG4scqzmq6Ve/z6mq6EGae/33CqQudCCRj
	 2g3l4oUPRSmJssrdZbcMUhQdZzWx5ru/OhlRKVyU9S4S2MgA/eKBpP/NPZApwDaCWE
	 3iZzQdiMEZT2Q7JwtJrxIAQB0zXMrxPubk86F6L0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xingwei lee <xrivendell7@gmail.com>,
	yue sun <samsun1006219@gmail.com>,
	syzbot+bc922f476bd65abbd466@syzkaller.appspotmail.com,
	syzbot+d4066896495db380182e@syzkaller.appspotmail.com,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH 6.8 093/273] bpf, sockmap: Prevent lock inversion deadlock in map delete elem
Date: Mon,  8 Apr 2024 14:56:08 +0200
Message-ID: <20240408125312.189097959@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Sitnicki <jakub@cloudflare.com>

commit ff91059932401894e6c86341915615c5eb0eca48 upstream.

syzkaller started using corpuses where a BPF tracing program deletes
elements from a sockmap/sockhash map. Because BPF tracing programs can be
invoked from any interrupt context, locks taken during a map_delete_elem
operation must be hardirq-safe. Otherwise a deadlock due to lock inversion
is possible, as reported by lockdep:

       CPU0                    CPU1
       ----                    ----
  lock(&htab->buckets[i].lock);
                               local_irq_disable();
                               lock(&host->lock);
                               lock(&htab->buckets[i].lock);
  <Interrupt>
    lock(&host->lock);

Locks in sockmap are hardirq-unsafe by design. We expects elements to be
deleted from sockmap/sockhash only in task (normal) context with interrupts
enabled, or in softirq context.

Detect when map_delete_elem operation is invoked from a context which is
_not_ hardirq-unsafe, that is interrupts are disabled, and bail out with an
error.

Note that map updates are not affected by this issue. BPF verifier does not
allow updating sockmap/sockhash from a BPF tracing program today.

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Reported-by: xingwei lee <xrivendell7@gmail.com>
Reported-by: yue sun <samsun1006219@gmail.com>
Reported-by: syzbot+bc922f476bd65abbd466@syzkaller.appspotmail.com
Reported-by: syzbot+d4066896495db380182e@syzkaller.appspotmail.com
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: syzbot+d4066896495db380182e@syzkaller.appspotmail.com
Acked-by: John Fastabend <john.fastabend@gmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=d4066896495db380182e
Closes: https://syzkaller.appspot.com/bug?extid=bc922f476bd65abbd466
Link: https://lore.kernel.org/bpf/20240402104621.1050319-1-jakub@cloudflare.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/sock_map.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -411,6 +411,9 @@ static int __sock_map_delete(struct bpf_
 	struct sock *sk;
 	int err = 0;
 
+	if (irqs_disabled())
+		return -EOPNOTSUPP; /* locks here are hardirq-unsafe */
+
 	spin_lock_bh(&stab->lock);
 	sk = *psk;
 	if (!sk_test || sk_test == sk)
@@ -933,6 +936,9 @@ static long sock_hash_delete_elem(struct
 	struct bpf_shtab_elem *elem;
 	int ret = -ENOENT;
 
+	if (irqs_disabled())
+		return -EOPNOTSUPP; /* locks here are hardirq-unsafe */
+
 	hash = sock_hash_bucket_hash(key, key_size);
 	bucket = sock_hash_select_bucket(htab, hash);
 


