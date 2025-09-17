Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F223A328984;
	Wed, 17 Sep 2025 12:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113646; cv=none; b=MtmvG/zCgROHdWfmLxeftwXOo+Q0TVo5ZLNNIFhXFGOw8L+OFSJnpRJ1k1GOI822VafA7WYLgBuZopI/L6uDNuMe6NVetQbE0VwiS7eqI2FhD/+ddEIk2G0Gmv50gBip1Szz3JQzL0KV4PDZhOCT/NTrM4ct/sfyfsQ3nAfbAxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113646; c=relaxed/simple;
	bh=f/1rNlaMG255rmKdY4gUlwMFy4Y42v9HnEjOimf10UM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8mYoipVrnD5gEn4JukwENa13HcZM/VM5bHtmEJw36+S4/Z48vNHpILNnb51LYk/vVg1BCBF0/mxUWTvM6m3T+yQPkg/yTfNESlv8mkjjqBij1GS0YDmPCv4wwKtf6l78eALYHRPgNHKznPnJOkGyAidFKNa9vzCgDtyvCpd/wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wvM31Gvf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wvM31Gvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F23CC4CEF0;
	Wed, 17 Sep 2025 12:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113645;
	bh=f/1rNlaMG255rmKdY4gUlwMFy4Y42v9HnEjOimf10UM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wvM31GvfHdBPZCOhwG5SVoVoim8b/XbEEZsya77PXgiqFeoTSm0y58m8HmkUs7uX+
	 h9Q+7GksqZ4WK94A3PLDLfN2fUQpFdPZmBqfNRFf5XkmkS42TtznoQwkEv/iZs12BJ
	 UQxshMXq/XzYLqeFj/+v3p4+WPaflN9t2mCwHGkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Worrell <jworrell@gmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>,
	Scott Mayhew <smayhew@redhat.com>
Subject: [PATCH 6.6 010/101] SUNRPC: call xs_sock_process_cmsg for all cmsg
Date: Wed, 17 Sep 2025 14:33:53 +0200
Message-ID: <20250917123337.117559958@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

From: Justin Worrell <jworrell@gmail.com>

[ Upstream commit 9559d2fffd4f9b892165eed48198a0e5cb8504e6 ]

xs_sock_recv_cmsg was failing to call xs_sock_process_cmsg for any cmsg
type other than TLS_RECORD_TYPE_ALERT (TLS_RECORD_TYPE_DATA, and other
values not handled.) Based on my reading of the previous commit
(cc5d5908: sunrpc: fix client side handling of tls alerts), it looks
like only iov_iter_revert should be conditional on TLS_RECORD_TYPE_ALERT
(but that other cmsg types should still call xs_sock_process_cmsg). On
my machine, I was unable to connect (over mtls) to an NFS share hosted
on FreeBSD. With this patch applied, I am able to mount the share again.

Fixes: cc5d59081fa2 ("sunrpc: fix client side handling of tls alerts")
Signed-off-by: Justin Worrell <jworrell@gmail.com>
Reviewed-and-tested-by: Scott Mayhew <smayhew@redhat.com>
Link: https://lore.kernel.org/r/20250904211038.12874-3-jworrell@gmail.com
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 8b27a21f3b42d..3660ef2647112 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -407,9 +407,9 @@ xs_sock_recv_cmsg(struct socket *sock, unsigned int *msg_flags, int flags)
 	iov_iter_kvec(&msg.msg_iter, ITER_DEST, &alert_kvec, 1,
 		      alert_kvec.iov_len);
 	ret = sock_recvmsg(sock, &msg, flags);
-	if (ret > 0 &&
-	    tls_get_record_type(sock->sk, &u.cmsg) == TLS_RECORD_TYPE_ALERT) {
-		iov_iter_revert(&msg.msg_iter, ret);
+	if (ret > 0) {
+		if (tls_get_record_type(sock->sk, &u.cmsg) == TLS_RECORD_TYPE_ALERT)
+			iov_iter_revert(&msg.msg_iter, ret);
 		ret = xs_sock_process_cmsg(sock, &msg, msg_flags, &u.cmsg,
 					   -EAGAIN);
 	}
-- 
2.51.0



