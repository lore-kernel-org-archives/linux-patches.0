Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6447D08F;
	Wed, 19 Jun 2024 12:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718801946; cv=none; b=R9F0TliYPBS5ypfAwZq86BjQrX+ubyIEbDDlisS9zSXr5oxbBK8y6Z2I0O+3E5NEqwXuyhjXMmbObyzrRe3beqOkBOq8nIDyY1fS/0DcBZ25Y3cgL0siL2gQHDu5vjZ/sk/F1QhkO97bx/Iqvw6ABJVnIau1F7uPZV2OaDQJzGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718801946; c=relaxed/simple;
	bh=AiFGVOOposT7aTeqINnS8G/QN9PMhfBv4P0VfQnwIb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UO0GdC3MKmdofDLChk/I6U5c3j/NrhDz9lgMfE8Tj1/uv0NI6qvJEPLqRe/x6bXAOGuCU64sQ2LQFsojMQTID+WyBMYF1VjROyCVPLDy5Ywkt6eEXXqm+zcu2/f8/vFt431b1lIKbwBjeHFhcmL8zJqPd4xpyIAxcPsxbyOO6Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xl0ZtHnE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xl0ZtHnE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2413EC2BBFC;
	Wed, 19 Jun 2024 12:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718801945;
	bh=AiFGVOOposT7aTeqINnS8G/QN9PMhfBv4P0VfQnwIb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xl0ZtHnE27clWThBSvKL/tOQ/9bsRVjdvca9X5YTWKybnJ8bUtjt0uxQfeofTwQEf
	 xpJ2xMJ+SAlVWdSVTd5+d6rCzacLA15mA3jX9jaHhSWaP6sGbypv8UoYHh4fQaZUGE
	 JxR76tiGTJldcULc5xq2uCUgqzTJ8VGUy2vv7ovs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/267] net: tls: fix marking packets as decrypted
Date: Wed, 19 Jun 2024 14:53:01 +0200
Message-ID: <20240619125607.520816138@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit a535d59432370343058755100ee75ab03c0e3f91 ]

For TLS offload we mark packets with skb->decrypted to make sure
they don't escape the host without getting encrypted first.
The crypto state lives in the socket, so it may get detached
by a call to skb_orphan(). As a safety check - the egress path
drops all packets with skb->decrypted and no "crypto-safe" socket.

The skb marking was added to sendpage only (and not sendmsg),
because tls_device injected data into the TCP stack using sendpage.
This special case was missed when sendpage got folded into sendmsg.

Fixes: c5c37af6ecad ("tcp: Convert do_tcp_sendpages() to use MSG_SPLICE_PAGES")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240530232607.82686-1-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 7bf774bdb9386..a9b33135513d8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1158,6 +1158,9 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 			process_backlog++;
 
+#ifdef CONFIG_SKB_DECRYPTED
+			skb->decrypted = !!(flags & MSG_SENDPAGE_DECRYPTED);
+#endif
 			tcp_skb_entail(sk, skb);
 			copy = size_goal;
 
-- 
2.43.0



