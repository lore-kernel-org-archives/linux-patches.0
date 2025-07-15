Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E772E339C;
	Tue, 15 Jul 2025 13:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585804; cv=none; b=Uk2M8gGhkpgVWn4XMYxIUsu8fnV1GiViGWoh6TuDnaR4J4hxkg81wBxFv2HsmPqElBGHZPTsytnMEWsIRv5gh7ierYye3ejxuvkO8OBtPZ0E+An1ZsXpkwZ19x5gGh0UYi7hLXmyMzP/QzBBtjp6gKSx32cSZfirbqfKhn9dXBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585804; c=relaxed/simple;
	bh=9VCPOr45Xw+wsaN66c44owxHf6U63mlgo8Xa1s/NCn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oB0sfOS4b5dv6Afst1y6rKjRfSuKG8HMevunygpD7U3wP6xYpzdEDTC3qm0SO7RZnJOeRvI5q0iohSmr3h8zKuUnoF3OsGZIYozDK1Yf6DeY4Dqfr9k0fvMd1vooJmNZpm6RPtce8xbbYpXJ6t/rc668XKU1ezgMmp2qjv9BO+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ATktzxIN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ATktzxIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56ECFC4CEE3;
	Tue, 15 Jul 2025 13:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585803;
	bh=9VCPOr45Xw+wsaN66c44owxHf6U63mlgo8Xa1s/NCn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ATktzxIN7vTv3/A/4w99M6M+K0aYqQRNW2h2JcaB745Y87+Lab2s6QMj8GDoaLVYP
	 RH0Qtmg2dJQVbTq4tImCbZbHB2HYVTXkblGs3CItfQDLUlsicc7624nWnXVm0Z6i3f
	 CjSpHQ7SHpSIN7GXijI6InmMiMRrZOTqZyi6mFx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+de6565462ab540f50e47@syzkaller.appspotmail.com,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	David Howells <dhowells@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/109] tcp: Correct signedness in skb remaining space calculation
Date: Tue, 15 Jul 2025 15:12:30 +0200
Message-ID: <20250715130759.451162733@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit d3a5f2871adc0c61c61869f37f3e697d97f03d8c ]

Syzkaller reported a bug [1] where sk->sk_forward_alloc can overflow.

When we send data, if an skb exists at the tail of the write queue, the
kernel will attempt to append the new data to that skb. However, the code
that checks for available space in the skb is flawed:
'''
copy = size_goal - skb->len
'''

The types of the variables involved are:
'''
copy: ssize_t (s64 on 64-bit systems)
size_goal: int
skb->len: unsigned int
'''

Due to C's type promotion rules, the signed size_goal is converted to an
unsigned int to match skb->len before the subtraction. The result is an
unsigned int.

When this unsigned int result is then assigned to the s64 copy variable,
it is zero-extended, preserving its non-negative value. Consequently, copy
is always >= 0.

Assume we are sending 2GB of data and size_goal has been adjusted to a
value smaller than skb->len. The subtraction will result in copy holding a
very large positive integer. In the subsequent logic, this large value is
used to update sk->sk_forward_alloc, which can easily cause it to overflow.

The syzkaller reproducer uses TCP_REPAIR to reliably create this
condition. However, this can also occur in real-world scenarios. The
tcp_bound_to_half_wnd() function can also reduce size_goal to a small
value. This would cause the subsequent tcp_wmem_schedule() to set
sk->sk_forward_alloc to a value close to INT_MAX. Further memory
allocation requests would then cause sk_forward_alloc to wrap around and
become negative.

[1]: https://syzkaller.appspot.com/bug?extid=de6565462ab540f50e47

Reported-by: syzbot+de6565462ab540f50e47@syzkaller.appspotmail.com
Fixes: 270a1c3de47e ("tcp: Support MSG_SPLICE_PAGES")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20250707054112.101081-1-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ff22060f9145f..a4bbe959d1e25 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1132,7 +1132,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		goto do_error;
 
 	while (msg_data_left(msg)) {
-		ssize_t copy = 0;
+		int copy = 0;
 
 		skb = tcp_write_queue_tail(sk);
 		if (skb)
-- 
2.39.5



