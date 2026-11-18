Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028361;
	b=cwULglNgen695PIbyIuW4/BLJGbr5ZcB+A21YfJNBqB+BQyFtHgKSp2yaLcsx9zV2GlT
	 jKpgv/jZJvtMBIch0y2okNF1bBZaAKVkG5RGNq4dO7W8y60kntTgEjJy8bo22F97XFMVS
	 fH3/PUVl5/gcAkKKdMRXhIv/FfZ30eotWB/c1afRtzYmhAL9heijcmKbeMCnVgMGBZbgG
	 KpOrPba9TgPwO3XIymfmImms7qpmSy2snsj/Vno9BOIB9K8vSIjA8Kwtx6dW+L+vUA2Bw
	 NZpeMiZKq8zh2OAXUrF7m7q8PojwGj1AYrD6yCcAVrbW4EZlAUQxQ7vUzmwoPpWWD1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=93TI/TPZ25ona3OM9xgv3ycwybDXhC2R7tIkEbS9CKE=;
	b=5HANNOSmod1xw7VCHylLWHDTw3Ku3HLros9QgRj0/xqBgr+nMIKMxY+wNIV8Lnr/JJRR
	 /18jUhqRbym5ctuRR3upISkgK26caAXkKSb3p4ItBlXCWV61kBmx0dY5PTJ5xBfMzFms3
	 4d79fS6kaoZlkimABfiQUZyfiTnHGlN0NbKm146iQnvsGVUXCmv/68Ejl9u48JjkyMbJl
	 /4QvXfVmVpSjj6DA93s2iUT67WjTXE7rrR2rnniAO/bMD4DbEd9Wh8ZItJaXPit7tUEot
	 /KcDLXHhtrNvPIdeer9PzX/1XizIyfQlVtuCE9nqmQV4mHOqVj+MPU00ZIAODUfR6kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0iYkvS7i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EAC606A320;
	Wed, 18 Nov 2026 18:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0iYkvS7i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301EC1F000C4;
	Wed, 18 Nov 2026 18:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028361;
	bh=93TI/TPZ25ona3OM9xgv3ycwybDXhC2R7tIkEbS9CKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0iYkvS7imZvh6B4GIz3Zenjb6LXu0BOSRi5FMXke8cmHL4yIk7Z0EoW2FImxv8rHr
	 0uk+2IiURNDr/l1BDmogGYsGuokGc+TaLqDGEVl1RU+1/Un9sLsem5ocCUPDgX5C+l
	 F4aAmL7QMJKfB9wJs2ZLOvuQ0woiidycVetI5epc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jhonata Poma-Hansen <jhonata.poma@gmail.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2117/2151] netlink: check sk_rcvbuf before charging the dump skb
Date: Wed, 18 Nov 2026 16:04:12 +0100
Message-ID: <20261118150238.814246383@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7141bbfc241f1..fb7785a59af59 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2307,9 +2307,13 @@ static int netlink_dump(struct sock *sk, bool lock_taken)
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



