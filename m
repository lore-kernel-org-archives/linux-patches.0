Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB472D8790;
	Tue, 15 Jul 2025 13:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585941; cv=none; b=ooqX1zuLA0qrMktQhj2NmJKm2kPE5s+ayDlMqttaRpMoTxwAfDaiwH1e39G3++/Y+DzSs5VEOZTdStaaL9VF03hQpTrg0CpHC5gLi1yqT8CK2yWSSZKzH3BdAjQk1GVawrNMNdRN9vq6I31Q0qXQdBku3CcMcpJOT/SnGfh8THY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585941; c=relaxed/simple;
	bh=RGk+SBSUIn6Y2JD4pNIk+WJa3npAyNn/DjJji86qFjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmKMvQEg3xmex2pxGWeuj4yjfDst4FyYMYnLXQdl/eA5WhxPHjxo4RyYvZ/JHst0V7OmexW4eijOC6yM6njOPjngphHvL7SDzgnxHIUU1QLNije3bULY1P4KCOQOickHE156D6ZLbE8RnvWoBhP9JanqNZgnbu7PCKqVYc5klHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+cZ3nwR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+cZ3nwR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC500C4CEE3;
	Tue, 15 Jul 2025 13:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585941;
	bh=RGk+SBSUIn6Y2JD4pNIk+WJa3npAyNn/DjJji86qFjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+cZ3nwRIylumBmwSMbRQWjksi4PH3EjoBTyCsXJXK80Aj7RRaXX12aLKSVjNmOKC
	 X2zZa6dHe6iqVZZWoGFXJAQTPGvsUS0auqT9oYQJnjkq50IisEVZ4NXzNRJs0mxEP/
	 lS+cYEXDKQcQB9+Um/fFPXBX6VKWwPzphMBmyixI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 065/109] netlink: make sure we allow at least one dump skb
Date: Tue, 15 Jul 2025 15:13:21 +0200
Message-ID: <20250715130801.486195763@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

commit a215b5723922f8099078478122f02100e489cb80 upstream.

Commit under Fixes tightened up the memory accounting for Netlink
sockets. Looks like the accounting is too strict for some existing
use cases, Marek reported issues with nl80211 / WiFi iw CLI.

To reduce number of iterations Netlink dumps try to allocate
messages based on the size of the buffer passed to previous
recvmsg() calls. If user space uses a larger buffer in recvmsg()
than sk_rcvbuf we will allocate an skb we won't be able to queue.

Make sure we always allow at least one skb to be queued.
Same workaround is already present in netlink_attachskb().
Alternative would be to cap the allocation size to
  rcvbuf - rmem_alloc
but as I said, the workaround is already present in other places.

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/9794af18-4905-46c6-b12c-365ea2f05858@samsung.com
Fixes: ae8f160e7eb2 ("netlink: Fix wraparounds of sk->sk_rmem_alloc.")
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250711001121.3649033-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netlink/af_netlink.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2199,11 +2199,11 @@ static int netlink_dump(struct sock *sk,
 	struct netlink_ext_ack extack = {};
 	struct netlink_callback *cb;
 	struct sk_buff *skb = NULL;
+	unsigned int rmem, rcvbuf;
 	size_t max_recvmsg_len;
 	struct module *module;
 	int err = -ENOBUFS;
 	int alloc_min_size;
-	unsigned int rmem;
 	int alloc_size;
 
 	if (!lock_taken)
@@ -2235,8 +2235,9 @@ static int netlink_dump(struct sock *sk,
 	if (!skb)
 		goto errout_skb;
 
+	rcvbuf = READ_ONCE(sk->sk_rcvbuf);
 	rmem = atomic_add_return(skb->truesize, &sk->sk_rmem_alloc);
-	if (rmem >= READ_ONCE(sk->sk_rcvbuf)) {
+	if (rmem != skb->truesize && rmem >= rcvbuf) {
 		atomic_sub(skb->truesize, &sk->sk_rmem_alloc);
 		goto errout_skb;
 	}


