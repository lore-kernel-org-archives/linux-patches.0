Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A176193077;
	Tue, 15 Jul 2025 13:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585415; cv=none; b=CdjIkqED1EsCC544xhbnc2b4+bdyFOAGBLEualg00t2w7sNWNag5iNowV4m1my5hnyjvBpyO0hv9opLmcbQ2RgpmR+9vlhYhqF9Up4lC0QAH+o1H0VNHz565hgPt57sZOxJE8cPLpz422T2sD+lfntyAvDQ2KVTcNAWjMU1j9Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585415; c=relaxed/simple;
	bh=qFiy0VxXJTaNE0zswaaVLt2WliJhECdxGPgl9ktVQIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utkZ3qWSrNq1oxEDuRJj934Uq8q0zParQhfa43/enlfvOOprQntt9896DESIBFHNzuhR6p2R78cOlJiMs+KTvTcTO6bCoSWwCBdgAPQMSGTshkS2BdjvrTw9mJQGsolhJ2cfDi41y+r/1esUbhhqX6/tO5p4myFH/42opGqNiNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UB6G4mnl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UB6G4mnl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0C1C4CEE3;
	Tue, 15 Jul 2025 13:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585414;
	bh=qFiy0VxXJTaNE0zswaaVLt2WliJhECdxGPgl9ktVQIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UB6G4mnlF5+7VPUn97nrP5Pzsaq+C70BSTxHWjXzUtKPRtLWUZ5IFgCdh/BgU5/NN
	 Pw5ZABeGLcGP+Ehb7SYT+yIQTykNpBnZKonC2Z6UrQJQMEtuexHJFUdWp6jNG6v4d+
	 Xcd6S0lkIRux6uWNsjXX2JJ+AFddTxnU5NEVUDK4=
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
Subject: [PATCH 6.12 032/163] tcp: Correct signedness in skb remaining space calculation
Date: Tue, 15 Jul 2025 15:11:40 +0200
Message-ID: <20250715130810.044028736@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b731a4a8f2b0d..156da81bce068 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1145,7 +1145,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		goto do_error;
 
 	while (msg_data_left(msg)) {
-		ssize_t copy = 0;
+		int copy = 0;
 
 		skb = tcp_write_queue_tail(sk);
 		if (skb)
-- 
2.39.5



