Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057005;
	b=5N/9soyfbBAMde88WWVKXUY68wwuNwFD8gLMAuGBX271AOzvVgV06dxgbZBZxDgUw0eH
	 WBT4YaTY2Z5IHyxp3ApfG8E16vMLJnbE1WG2FYs0kAYqp+k80fisMADf5qZUXrPNlLJ9Q
	 R+lU7hSpf590HFKNRlNvzCR3mgHmt9jKFejn1gzQgmQzqtKPZb8SnY1MkAU26D08ieXTQ
	 dWWPyV2dIbCfti+sR+Xqxkfwju/wGvtIbOq6DuaoWwZnYd9zJ8q3LmPE5UHdJYW0SfwGI
	 Oormk3EYy6Y7KCKdvOHg99ZhfXU+Ys0WNiYUF5/1nQwGko9Rwlo/cvJDHrXpR2pgbfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057005;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wqLhiSG1Rd0W3Oszzvfkd363BqM2dS1VlmYH9ULrqlY=;
	b=yQQFhsp4uem0H2dkpU9QjpKDrjInaHJFtEFIMxfm9UF3R80uDaVRRS3u6Emlk78o3g9A
	 iBilipBQrJ0PvuoLL9zD1yx/Lvkmf/yufXue5VJYw2WF1FwzVXL4bjssf+MpHKwVKMbFI
	 NAr4vQsJF3InMPc/y9ktCKZUzCVR3mLt4jRsyc+NdNIALsk9JxxJjjdCEML2pNWBI5SN7
	 R6kIKx81y0rp81vTWVOMlU+1kykoVLIm/4W6AYQe3bV8tcdNcnq69HqvSbbdbnk6Ls/9n
	 G0I4SIHqLizgZRhdIPfqrk3M2ypIDzz0SwDoU/HGALs51v4WivRLWGgsTmwEBX4KGQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ft9gcHpM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B345B606A33E;
	Thu, 19 Nov 2026 02:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ft9gcHpM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E021F000C4;
	Thu, 19 Nov 2026 02:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057005;
	bh=wqLhiSG1Rd0W3Oszzvfkd363BqM2dS1VlmYH9ULrqlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ft9gcHpM65IfmPW0/MqQDiW64xqeBd//EePsmQp+mJ8dYoP3L8AltEGQZV4kcMIlw
	 Vb49l6SYsTq/DJGo0vireCx/8kIJhcYrfnfcwZtgilHAZUtaluPg8vPpBpKkr8DTBd
	 BvHGmxeK742Q6PwNC773BpWbk3cABQCRBs1KmP7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jhonata Poma-Hansen <jhonata.poma@gmail.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2190/2214] netlink: check sk_rcvbuf before charging the dump skb
Date: Wed, 18 Nov 2026 16:04:26 +0100
Message-ID: <20261118150137.939296691@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jhonata Poma-Hansen <jhonata.poma@gmail.com>

[ Upstream commit b45d37740cfb4bdfccef3fbd9fd970fd3224438f ]

Since commit ae8f160e7eb2 ("netlink: Fix wraparounds of
sk->sk_rmem_alloc."), netlink_dump() charges the dump skb first and
queues it only if sk_rmem_alloc is still below sk_rcvbuf. Commit
a215b5723922 ("netlink: make sure we allow at least one dump skb")
added an exception for an empty socket.

A dump that starts while something else is still charged to a socket
with a small receive buffer fails with ENOBUFS and stays running.
Every recvmsg() retries it, fails again and sets sk_err, so a reader
that peeks before reading, as libnl does, gets ENOBUFS on the read
after each peek, never consumes the message at the head of the queue
and spins forever.

I hit this with "iw dev wlan0 scan" hanging at 100% CPU on an arm64
board with a 6.6 based kernel (iw 5.19 sets SO_RCVBUF to 8KiB). A
kprobe trace showed the scan dump starting while the NEW_SCAN_RESULTS
notification iw had just read was still charged to its socket,
because iw had preempted the sender before netlink_broadcast()
returned.

Check the limit before charging, as before ae8f160e7eb2, which also
covers the empty socket. netlink_recvmsg() continues a dump only at
or below half of sk_rcvbuf, so the skb is then always queued, and a
dump goes over the limit by at most one skb. Refuse a skb that would
take sk_rmem_alloc past INT_MAX, so the wraparound stays fixed.

Reproduced on net in a KVM guest with a userspace reproducer and the
selftest in the next patch; both pass with this fix.

Fixes: ae8f160e7eb2 ("netlink: Fix wraparounds of sk->sk_rmem_alloc.")
Signed-off-by: Jhonata Poma-Hansen <jhonata.poma@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261027-netlink-dump-livelock-v2-1-c4bb05352a33@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index d3536f9d50cb3..5fa5fadb5f0f7 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2264,9 +2264,13 @@ static int netlink_dump(struct sock *sk, bool lock_taken)
 	if (!skb)
 		goto errout_skb;
 
+	/* Check the limit before charging the skb: netlink_recvmsg() continues
+	 * the dump at or below half of sk_rcvbuf, and the skb must be queued
+	 * then. Keep sk_rmem_alloc at or below INT_MAX.
+	 */
 	rcvbuf = READ_ONCE(sk->sk_rcvbuf);
 	rmem = atomic_add_return(skb->truesize, &sk->sk_rmem_alloc);
-	if (rmem != skb->truesize && rmem >= rcvbuf) {
+	if (rmem - skb->truesize >= rcvbuf || rmem > INT_MAX) {
 		atomic_sub(skb->truesize, &sk->sk_rmem_alloc);
 		goto errout_skb;
 	}
-- 
2.53.0



