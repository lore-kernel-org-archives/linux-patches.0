Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C064D2DF73;
	Mon,  8 Apr 2024 13:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581700; cv=none; b=qb3ay1BtDPZvnYoSoDH6xdTQqlNRUliPxrzx/m9YrSJaY/S5g/1t/XZhYqQX8Oo/ApGVFmr+kSq8qkak+TLLLlfqDH0VEnyJvusFGOTp8IXIB+lfupKK9dlQqhauGkicxqalzZp48CPmwlYKGpp9v1eC0/iGtZNjVXcXwla7zlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581700; c=relaxed/simple;
	bh=sOCntd393LIs/gGnBT+c/J29lBHtmWTyrObYxRU4R6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdLmN/Niayge5yorUnKqieDgtxHqoS6GHn+i13A8czywiQgUSWVigkCbQKpH30mTIBw+Q/FwcSwyGrhNVKWSeH2dmuepSbI8vkRmpHznfcW8HJEu5Acdm2kjwm4LfNRaiav0ohtQvCpPBBiA1d4zV4JwlGi2UrS9KMOeYZvb93I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J913nXrv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J913nXrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2E6C433C7;
	Mon,  8 Apr 2024 13:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581700;
	bh=sOCntd393LIs/gGnBT+c/J29lBHtmWTyrObYxRU4R6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J913nXrvhjuh4QI2Gn6yRsGkRli+MLtKqfhGOxmeHuZSYZ5XwccJyeL6JYz2EullP
	 P/+LiDBRKv9z744Qd8c/RhtnY5EQSD/bV+qF0yvnfw6y89bAp3rCJYYtbyhVo33aQS
	 MEzt9pAlwEnzxYFFRzMYd5lLOA/7gBOito85qBtM=
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
Subject: [PATCH 6.1 045/138] bpf, sockmap: Prevent lock inversion deadlock in map delete elem
Date: Mon,  8 Apr 2024 14:57:39 +0200
Message-ID: <20240408125257.630365536@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -413,6 +413,9 @@ static int __sock_map_delete(struct bpf_
 	struct sock *sk;
 	int err = 0;
 
+	if (irqs_disabled())
+		return -EOPNOTSUPP; /* locks here are hardirq-unsafe */
+
 	raw_spin_lock_bh(&stab->lock);
 	sk = *psk;
 	if (!sk_test || sk_test == sk)
@@ -926,6 +929,9 @@ static int sock_hash_delete_elem(struct
 	struct bpf_shtab_elem *elem;
 	int ret = -ENOENT;
 
+	if (irqs_disabled())
+		return -EOPNOTSUPP; /* locks here are hardirq-unsafe */
+
 	hash = sock_hash_bucket_hash(key, key_size);
 	bucket = sock_hash_select_bucket(htab, hash);
 


