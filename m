Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B902E339B;
	Tue, 15 Jul 2025 13:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586597; cv=none; b=BvDaZTny8ig4Frkj4fSyF2v19OWZW0paTqjOBgD6yPAYn7Tmo/1dPj+toq0m6cSpuQUg0jUewBCYWuOW5v+Kj5IJN8j6IKaHrN8JlwKnRzGKBkKHGf7KsaLkcDejYCG7DnPdS4BjZgh9EgB1T2rndtkZGx5CKelVVG8czNC7T5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586597; c=relaxed/simple;
	bh=AL3Hd6xQiiPVmXPowzOlVLyIs1wpjv7PFBDLJFXPD2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkmVJ3HJotRO/KkEUOzcjAjl8ok2QZQf+z+ZKq5h7E/lUPDqUq85GtYnGaqP6B+HLJAQbHeBdAS44Wspnj2ovIFtpFA820fWnC9Q+tEGDezkVd6FGGLcUo89TBtHfY0lIRqSy6qzaCKAL9WZ9vsoIPRnQlrLfSuxXa3rfPDxHPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smLeglw2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smLeglw2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDEC2C4CEE3;
	Tue, 15 Jul 2025 13:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586597;
	bh=AL3Hd6xQiiPVmXPowzOlVLyIs1wpjv7PFBDLJFXPD2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smLeglw2cOCnluaPlAxwoNeNsFqoEUy3DZWxjyTB2EUNeUGRnA5DdufyQyV2u0LFV
	 FyUQsnbiGmEcEOxkooVDGVrh9tbvQq8LIV4J2x3HhzdVBoiUsYTURKHSz4hcmYENgF
	 9kxE/uWMgSjO1soIv3sMrU75U/coZK7OobDqpEH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 125/148] netlink: make sure we allow at least one dump skb
Date: Tue, 15 Jul 2025 15:14:07 +0200
Message-ID: <20250715130805.300163679@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2186,11 +2186,11 @@ static int netlink_dump(struct sock *sk)
 	struct netlink_ext_ack extack = {};
 	struct netlink_callback *cb;
 	struct sk_buff *skb = NULL;
+	unsigned int rmem, rcvbuf;
 	struct nlmsghdr *nlh;
 	struct module *module;
 	int err = -ENOBUFS;
 	int alloc_min_size;
-	unsigned int rmem;
 	int alloc_size;
 
 	mutex_lock(nlk->cb_mutex);
@@ -2220,8 +2220,9 @@ static int netlink_dump(struct sock *sk)
 	if (!skb)
 		goto errout_skb;
 
+	rcvbuf = READ_ONCE(sk->sk_rcvbuf);
 	rmem = atomic_add_return(skb->truesize, &sk->sk_rmem_alloc);
-	if (rmem >= READ_ONCE(sk->sk_rcvbuf)) {
+	if (rmem != skb->truesize && rmem >= rcvbuf) {
 		atomic_sub(skb->truesize, &sk->sk_rmem_alloc);
 		goto errout_skb;
 	}


