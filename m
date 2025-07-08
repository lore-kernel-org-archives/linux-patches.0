Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713522E540B;
	Tue,  8 Jul 2025 16:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993932; cv=none; b=BO0Tkj3I80NIB3FouVD4cePrIlTbR/PBxVeGO91Qs3ojaSz2NDuUnzeMGcNrPKGT/1nhNLBWn7reOdUwr3u+1bNnqt8CzHccCw1S7hE8rpEie3Ait3Lx97n5cHAy9tlQpaxfOivVtf6oOHBfQovnMagMU1N0IWUJHywThTmwa0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993932; c=relaxed/simple;
	bh=MN0LfTHrksqXxYAH5Tfgy+Bbn3/E5ddAnXgGyyoUTaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBedsTV+E27t7S7fOz6YAYnUhhkEYLT4BY4ZOYISfbHZqYQTOxnI1z6NKEE4pFI5FdVvUYkUXRR3mzwCB+LnSbw/QVuo7JM+e8XFPL+3iI1OfNPlOOyaUz49kXGqFqpWbpYBik8yla6E/iSIbvdkfdKlCSSPFYlT9zaWHKfa1zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SI/Hcl32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SI/Hcl32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCAEC4CEED;
	Tue,  8 Jul 2025 16:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993932;
	bh=MN0LfTHrksqXxYAH5Tfgy+Bbn3/E5ddAnXgGyyoUTaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SI/Hcl32uWpvKE2zl2yfJXPVPcFfdkaQ+UZxh0ogm9aW4HE2OFLEyeOy2l29t+e12
	 7p0PznaaBLiDHxZdGOiWD1jm+C9JOiNbVtk6UZLPszAxeRNpl7t3CHs1MP/fg+Y7Yh
	 FWFuYZuV43WlAfefJpOictNdBRUpjlNfyRcIeBWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/160] af_unix: Dont set -ECONNRESET for consumed OOB skb.
Date: Tue,  8 Jul 2025 18:21:43 +0200
Message-ID: <20250708162233.383301325@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 2a5a4841846b079b5fca5752fe94e59346fbda40 ]

Christian Brauner reported that even after MSG_OOB data is consumed,
calling close() on the receiver socket causes the peer's recv() to
return -ECONNRESET:

  1. send() and recv() an OOB data.

    >>> from socket import *
    >>> s1, s2 = socketpair(AF_UNIX, SOCK_STREAM)
    >>> s1.send(b'x', MSG_OOB)
    1
    >>> s2.recv(1, MSG_OOB)
    b'x'

  2. close() for s2 sets ECONNRESET to s1->sk_err even though
     s2 consumed the OOB data

    >>> s2.close()
    >>> s1.recv(10, MSG_DONTWAIT)
    ...
    ConnectionResetError: [Errno 104] Connection reset by peer

Even after being consumed, the skb holding the OOB 1-byte data stays in
the recv queue to mark the OOB boundary and break recv() at that point.

This must be considered while close()ing a socket.

Let's skip the leading consumed OOB skb while checking the -ECONNRESET
condition in unix_release_sock().

Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Reported-by: Christian Brauner <brauner@kernel.org>
Closes: https://lore.kernel.org/netdev/20250529-sinkt-abfeuern-e7b08200c6b0@brauner/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Acked-by: Christian Brauner <brauner@kernel.org>
Link: https://patch.msgid.link/20250619041457.1132791-4-kuni1840@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index eb916b2eb6739..12c4a27e1655c 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -516,6 +516,11 @@ static void unix_sock_destructor(struct sock *sk)
 #endif
 }
 
+static unsigned int unix_skb_len(const struct sk_buff *skb)
+{
+	return skb->len - UNIXCB(skb).consumed;
+}
+
 static void unix_release_sock(struct sock *sk, int embrion)
 {
 	struct unix_sock *u = unix_sk(sk);
@@ -552,10 +557,16 @@ static void unix_release_sock(struct sock *sk, int embrion)
 
 	if (skpair != NULL) {
 		if (sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET) {
+			struct sk_buff *skb = skb_peek(&sk->sk_receive_queue);
+
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
+			if (skb && !unix_skb_len(skb))
+				skb = skb_peek_next(skb, &sk->sk_receive_queue);
+#endif
 			unix_state_lock(skpair);
 			/* No more writes */
 			WRITE_ONCE(skpair->sk_shutdown, SHUTDOWN_MASK);
-			if (!skb_queue_empty_lockless(&sk->sk_receive_queue) || embrion)
+			if (skb || embrion)
 				WRITE_ONCE(skpair->sk_err, ECONNRESET);
 			unix_state_unlock(skpair);
 			skpair->sk_state_change(skpair);
@@ -2479,11 +2490,6 @@ static long unix_stream_data_wait(struct sock *sk, long timeo,
 	return timeo;
 }
 
-static unsigned int unix_skb_len(const struct sk_buff *skb)
-{
-	return skb->len - UNIXCB(skb).consumed;
-}
-
 struct unix_stream_read_state {
 	int (*recv_actor)(struct sk_buff *, int, int,
 			  struct unix_stream_read_state *);
-- 
2.39.5



