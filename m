Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF1F1B4231;
	Tue, 15 Jul 2025 13:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587076; cv=none; b=ewXYqHScKxe+NcKwAque0cWKH2tq9vGf/3JBTSFLkttP1WlnqgKg8aT96riWawuTKACGUTY7WEUz3eFsCO8bQoWJBkNAzn7fEHARDSQLeZcl9xUQk+YqtVnhFLL97mgrcR505ghWziT7Tl7kO3S5m4/9lM/kBm1KY1gNwHRTZiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587076; c=relaxed/simple;
	bh=HzW4GP9vfuzH/LfHvkfbqswRorR/KWLjBLCOOz4JocY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltGv+j1cskfEG+B1JD+pXGqtXaXD5M+j1VRqLsvrEBRTaQbGfjrp/l9RJjGm2OTIGwobmB9vaTXE3c8hlBVomZcOzCowqeiNe1+kQnQSTFGz24hbl+E+7plBsKmSUpCY2Fbulw4jvjP9k2A52V7oD/NNVOxQJceYEOSnU/ibSNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jPkz2HFy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jPkz2HFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2951C4CEF6;
	Tue, 15 Jul 2025 13:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587076;
	bh=HzW4GP9vfuzH/LfHvkfbqswRorR/KWLjBLCOOz4JocY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jPkz2HFyVy6taf57M71s5icfrM/oSpfl/wiA0epTPWtnB1zNYaDcGz3Iwi3BW8XcT
	 lfuIGDgljbbbDfiQ/NZyi6qXoOqbhktNcnvtnt64vbU2eTsNhoe3V7DlD515i1R5nX
	 xGzYfEoVEHk9XmkZ45qxfTskeiJkjrs8aZ1rl0xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.15 126/192] netlink: make sure we allow at least one dump skb
Date: Tue, 15 Jul 2025 15:13:41 +0200
Message-ID: <20250715130819.953919366@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2258,11 +2258,11 @@ static int netlink_dump(struct sock *sk,
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
@@ -2294,8 +2294,9 @@ static int netlink_dump(struct sock *sk,
 	if (!skb)
 		goto errout_skb;
 
+	rcvbuf = READ_ONCE(sk->sk_rcvbuf);
 	rmem = atomic_add_return(skb->truesize, &sk->sk_rmem_alloc);
-	if (rmem >= READ_ONCE(sk->sk_rcvbuf)) {
+	if (rmem != skb->truesize && rmem >= rcvbuf) {
 		atomic_sub(skb->truesize, &sk->sk_rmem_alloc);
 		goto errout_skb;
 	}


