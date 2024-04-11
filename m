Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBAA147C7E;
	Thu, 11 Apr 2024 10:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832041; cv=none; b=h55hLRcONiclO3GstOFfpDO1za/nOUnHzkmsgCW/2UanDNdZClh2rr9Ox1ye3NKHiDY1Au1f2/bw3s9wo1dgbQNb4rUcLYA5Q634Rvsp6KUTQHEGTpsLYv4an24YZ99ADAQRZqdO2u01M0YAwbW7Ey1lSQAtu0WrSHNIi26a9kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832041; c=relaxed/simple;
	bh=bYiyivn4e2yFAM+k0iJ4soZoWDX+YLIbOyMryLUGT7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4fx2eWFEsRlBM+uFqPX2GOA4CF0gMfIqBwXjOuUhdWs7smt/zSmBms/3MztlAoNv2NHxDYFmPS0E+O7ngUWUVONZsnpjSzNUBf3/B+dLw2UUIsVMi1COs/5WWL5wfq7kpkixgKdrJCLJw5LMtfvkIBTTLSwp1PSeK4h4srrtVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UAdprBSj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UAdprBSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43227C433B2;
	Thu, 11 Apr 2024 10:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832041;
	bh=bYiyivn4e2yFAM+k0iJ4soZoWDX+YLIbOyMryLUGT7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UAdprBSjp0kj4JH3dqmSbCLre3tAlYzSB+Cqc+Fc4hcH/6W2T6w/wuo1B7jm7OeE4
	 pzQVkm8P3a5sRp6lvLrT2Hq4dSA/uvUQeL4d17fNfLPxunR1mOka/8zCdGG35xsXRI
	 kbVKYPIGln+ei2vhBpoMmFqOwNm6i6oFxPHcO7Io=
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
Subject: [PATCH 5.10 211/294] bpf, sockmap: Prevent lock inversion deadlock in map delete elem
Date: Thu, 11 Apr 2024 11:56:14 +0200
Message-ID: <20240411095441.948963329@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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
@@ -422,6 +422,9 @@ static int __sock_map_delete(struct bpf_
 	struct sock *sk;
 	int err = 0;
 
+	if (irqs_disabled())
+		return -EOPNOTSUPP; /* locks here are hardirq-unsafe */
+
 	raw_spin_lock_bh(&stab->lock);
 	sk = *psk;
 	if (!sk_test || sk_test == sk)
@@ -955,6 +958,9 @@ static int sock_hash_delete_elem(struct
 	struct bpf_shtab_elem *elem;
 	int ret = -ENOENT;
 
+	if (irqs_disabled())
+		return -EOPNOTSUPP; /* locks here are hardirq-unsafe */
+
 	hash = sock_hash_bucket_hash(key, key_size);
 	bucket = sock_hash_select_bucket(htab, hash);
 


