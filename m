Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062230;
	b=VBNdz9SyjQL5yBN/2ykCmt+8/SogEAcuPlKGPKM143C4LCl3L0xAzoe8Z6+f3ZuO5ec9
	 qtETugpTnR1SGnqcwlT8lWHT2Yiki8DV01NkRJSnaCN2cXC4s6zhl8pRXByH2U63Pqzmn
	 pgw+j7KPMNcnYASjUGR/jyxpYTnFO301HiAld+3NUVdNkzZSfmxszFZs0h0XFO9IHWEHa
	 +FPdKNzhr0JQL7YO9hxG86JyOwW1VqJPcavDENaO2QQy8Lmmlqy4nirVnK0XZRkpTQ+ys
	 SK7pmVu/kMUtiAdmCvoZ1V2GzDupUeqwvHsxjg9EJ6yNce8A1o6qqOvjjivHE1H5bdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iKEaCYH3DnzST8GxsS8AWzltzQiHMzaMSJJg8cDdd+w=;
	b=Yp2OzcsSXoAsj7n15TEtKZSidiaBb3cyFmC5ACDOlmy5H6XDWmrk4ni+qfxAz81NaHvt
	 88fUBJxA1qPMOSYDZHxgpur/v8PGv4hSlx/tFh4gm85IeGGnHzcveLcOP45sb2Pi02Zha
	 TCcVNOXQdaQS3HQp7QjsmnqkHepWEMffAtN0sX0KFjIvgKmu0L4yw7fzadW84Et2m0i0k
	 cTn9zjev1mNSKY1zh7VIo1007Vh1WYx1HG2mv+0qefeLXrEnb1bRMZTH38j1Zv5rR9NNM
	 fJb4wEyrKZQIyuins4lBneX8AlrZwL1E1J+/hWaSXi9uNt2MVql8vRCU/IjVTiuUwnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="sK/EzMGT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986F5606A320;
	Thu, 19 Nov 2026 04:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sK/EzMGT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FF21F000C4;
	Thu, 19 Nov 2026 04:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062230;
	bh=iKEaCYH3DnzST8GxsS8AWzltzQiHMzaMSJJg8cDdd+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sK/EzMGTsXTGofRLkkGCP0LVQLgCj7dfZEZ/4YU/1TXNhM/4Vl3kKvTY1PVpHeRKc
	 3r7Abq/r3SZo8nEBP9G53rvIZVPxtoQMnTadXaDPoWhjKhFNnqnMmRiEe33jNxW0oY
	 61XsRezuwI01PM7ZR0qO3Rda+/QNr3e+4X5sEyww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jhonata Poma-Hansen <jhonata.poma@gmail.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1819/1848] netlink: check sk_rcvbuf before charging the dump skb
Date: Wed, 18 Nov 2026 16:04:17 +0100
Message-ID: <20261118150035.707497810@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index eeb0b633a2e5f..d9d8c98440491 100644
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



