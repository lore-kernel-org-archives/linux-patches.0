Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625841;
	b=wFyvvRna15AA6bdWXTvRVf4ti72IhVFX4pU5/PpqdEk301XOzSlFTkAa0MSC0eSywxV0
	 ifDToGLN8cJDgbdrMHofX0R26ssjEvW56UghOsMcx4uJjsqOg+3ZNx+NqWABcSfnktFDo
	 vvTlLBdEt1gA6kMATmkXq8PivZhdZyB/9GabhOtAJzN0RAnnoXX78bOSKh4hwtCb+6zmp
	 RQz9NyzpNBQ8Nd2R1kLotet7hL2gmnBUMCvktfMm4SdRtkWM+VrlXJmbfwv54zfl1m+6J
	 TsTh2uDPwslGKaW6AREVXaW5kVN8lnbtjHzYhqgLKkEX6aoHj0GV4vSUxXxUlb/15Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625841;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O6DUvv+HecEASWw3omgF295e3vDhOYgdAlfVeEFrS9E=;
	b=qjvEt6+1QFCxNZ4GFCgC0vBdwCK+XY9eYkdNWqlCz3Fazkq3ZcVOZsmWu9etPVV1BViq
	 RX/olXT9SSlUcPFgsws7YGh3ZdmaCY7KobFsRoOJuhDLR42jsYSG8eTbG41qtrYX8QTl0
	 XjNVWrmuVrQIYd2nZL6uTW9YwcA8MZ4x784n9QL7Ztz4jhfP+Ju/fT2mW/7gbLzKvpgRn
	 VVZdQayuydB7J9Swyxg6rBLZGflmu8gCAIAu4sdiVdv95XjGCIlK39ehR9EGuG/qeImTe
	 NlFl1/EfKfy3yXh5Yo8gcNskzTUg+akUMpPH9e0xuQSud2+etD64qJH2XE86Q8y4n0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PfVswbbJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDA5606A323;
	Wed, 25 Nov 2026 16:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PfVswbbJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961C31F000C4;
	Wed, 25 Nov 2026 16:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625841;
	bh=O6DUvv+HecEASWw3omgF295e3vDhOYgdAlfVeEFrS9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PfVswbbJZn2Ddo3+zgi0bnM+EjTwhbNnzrdL3lLNuVSqeBik67I2BzWXNnYcBtDGd
	 10jK+JgNxKBwCGvXcOoMhsC1f52g3q4T9AYjF1zrKrCGFYvlQMBam6Mv3srMvklejP
	 YRpW3fLCZvApqeRhtQmBFwi8mRRpuilEfTTcwBtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 611/816] Bluetooth: L2CAP: Keep recvmsg from resuming a closed channel
Date: Wed, 25 Nov 2026 15:35:59 +0100
Message-ID: <20261125143903.321664382@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

commit 1f2ac56137c51be0601e18a163d817e02a15913f upstream.

Reading buffered ERTM data after ACL link loss can clear local busy and
send a supervisory frame after l2cap_conn_del() has destroyed the HCI
channel, which oopses on a NULL pointer in hci_send_acl(). The socket still
owns its L2CAP channel, so its lifetime does not protect the underlying HCI
channel.

Require BT_CONNECTED before clearing local busy in recvmsg. The socket lock
already held here serializes this check and send with teardown, which
closes the socket before the HCI channel is destroyed. Continue to allow
buffered data to be read after disconnection.

AI assistance was used.

Fixes: 61aa4f5b9f43 ("Bluetooth: Use the transmit state machine for busy state changes")
Cc: stable@vger.kernel.org # needs adjustments for 5.15
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_sock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1289,7 +1289,8 @@ static int l2cap_sock_recvmsg(struct soc
 	 * available.  This avoids resending large numbers of
 	 * frames.
 	 */
-	if (test_bit(CONN_LOCAL_BUSY, &pi->chan->conn_state) &&
+	if (sk->sk_state == BT_CONNECTED &&
+	    test_bit(CONN_LOCAL_BUSY, &pi->chan->conn_state) &&
 	    atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf >> 1)
 		l2cap_chan_busy(pi->chan, 0);
 


