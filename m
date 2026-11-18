Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033265;
	b=D7Xp2M/Zsj9GyxCm9UVY9XTifFnrghloW9KP+8WylNQkIdv8t0ZBW0xuiAB46prE6Uhy
	 IH68Gc9Qrc8jQVJy93wzJ61myQP6UWlT+z+uuQibXObgFLSR5jzvDgp1ooPI3b3mnc5fN
	 DdEErCGIb5jeB1QDOOaUbvX+mahlhkq4FMjYU6AmG46iyjikPfRkJXwDMR0os14pArG0I
	 0WUkBwBusuPN34IbeUiEToSbj69x5JRcU+yPRjmBsp8KD1SnjBtGtAPMuiiZsaHLuB4y8
	 YEMlQFKh13pMABmpLxK6B9IozZn1IXmBl8SWUeCWPAb6eLdNTQUhuU5u9v7aWRXU3mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033265;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ph3qBCBC7nukCEFhpojeT66nQo39VIhdZ9MDTW49MXo=;
	b=UvGAIUZRhspRzk4Ajc9t0b2rgrip6TzRR6DcPCbM348AiaNsHxz29f5UWALGR6MGtjkO
	 7+PhWkm7hp9QI7Iw94AV+U4HWIWFMeNgoXOfvd6UHAKE+Ut7Q3/dSTZA5RwnmSxEDbBlm
	 wsBxITX1a9+GCc5fu7YTSlfa3HABW0GsT9imlpPzOVRHc76PHz8JDvsqgvHpSw0hhhdru
	 xKHlVDTTRy9HrXXuh9TG2ZhIU/jY/R9k6LCnziGQnpasqoFLGwi/mpeHJn+Md1ezvVyBV
	 /aK3uHI4Wj++Qj9PlzZ8Gt5Zb5DLB+zyJFBTENf/EAOBFqpjHVFboaY5UoncZ7+IvFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="T/K8izHN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C610606A32C;
	Wed, 18 Nov 2026 20:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T/K8izHN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FF51F000C6;
	Wed, 18 Nov 2026 20:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033265;
	bh=ph3qBCBC7nukCEFhpojeT66nQo39VIhdZ9MDTW49MXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T/K8izHNmO5mtEcsqnBUrIQSITfTCnYYKs87XeUnyLF3JjgD92xxs3pZ8j3cYmNr/
	 YB6PJ18KV8TaoLE+eLPAQAYslK9n9octpYE/eTfNdXoqEYB+dfdWjDxTuzvb3HjYIY
	 hN5d/35F9FByVRR6WJaKG+pHtUoZ36Yb1khb+fUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jhonata Poma-Hansen <jhonata.poma@gmail.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1708/1756] netlink: check sk_rcvbuf before charging the dump skb
Date: Wed, 18 Nov 2026 16:03:55 +0100
Message-ID: <20261118150117.626254442@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fb84eaa63d0ac..8977798d42322 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2300,9 +2300,13 @@ static int netlink_dump(struct sock *sk, bool lock_taken)
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



