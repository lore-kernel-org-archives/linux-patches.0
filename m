Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079A014F108;
	Wed, 19 Jun 2024 13:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803616; cv=none; b=bnhnAfWH/OuHzJLjpRDCQ+AAEYtmiyR8Z55Jt6Sa70WSDO5zv1e1wdqx2BIF2ea1lpUZyj9S8nFI3mtY1YkGOuVnq2cAUWLpJj3s4BQXL7eF8opXxrqF1qgHR/+AppPhY0gmNRtRatjKNLy78ulFR5VbvrbWNFzEPKeDRPkRDj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803616; c=relaxed/simple;
	bh=72h1cEcFeBzU7MwoUUC7wu4ZO1RhMYTDLzq9CyJ6bjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qz5G3Vlr44St1qML6XvN+F5z2jaMYppwCw7GqCEHib4MRUDdhjyFTSaN4tDophqjxbNRfV2D01CLxjmtowgl9q+5IIg0b0OWYUaaHYgc0haR+WCKRssh8aQyo7uPzQEyyPknZw4yMtEMrxMeNI5ui0IwQGLT4D7s31wgtZD7iu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smeanmlP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smeanmlP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AAEC4AF1D;
	Wed, 19 Jun 2024 13:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803615;
	bh=72h1cEcFeBzU7MwoUUC7wu4ZO1RhMYTDLzq9CyJ6bjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smeanmlPxjvdmaFR9CB5V6TpW5ayVea9nPqPZ+kNpA3+vItowU718r6DRPPMKBz97
	 nnOfsVHCRt7mIPYwTPpsehyCL9H/OrxR27g6Flrqyo9rBXyg27WA3fy3UGw+vPRTy2
	 92+vGBAktMj8H9Pt+oJXLO4LpJF9aHnz053/dtCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 046/217] af_unix: Use skb_queue_empty_lockless() in unix_release_sock().
Date: Wed, 19 Jun 2024 14:54:49 +0200
Message-ID: <20240619125558.441558772@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 83690b82d228b3570565ebd0b41873933238b97f ]

If the socket type is SOCK_STREAM or SOCK_SEQPACKET, unix_release_sock()
checks the length of the peer socket's recvq under unix_state_lock().

However, unix_stream_read_generic() calls skb_unlink() after releasing
the lock.  Also, for SOCK_SEQPACKET, __skb_try_recv_datagram() unlinks
skb without unix_state_lock().

Thues, unix_state_lock() does not protect qlen.

Let's use skb_queue_empty_lockless() in unix_release_sock().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 02d8612385bd9..bb94a67229aa3 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -619,7 +619,7 @@ static void unix_release_sock(struct sock *sk, int embrion)
 			unix_state_lock(skpair);
 			/* No more writes */
 			WRITE_ONCE(skpair->sk_shutdown, SHUTDOWN_MASK);
-			if (!skb_queue_empty(&sk->sk_receive_queue) || embrion)
+			if (!skb_queue_empty_lockless(&sk->sk_receive_queue) || embrion)
 				WRITE_ONCE(skpair->sk_err, ECONNRESET);
 			unix_state_unlock(skpair);
 			skpair->sk_state_change(skpair);
-- 
2.43.0



