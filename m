Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D86014883C;
	Tue, 23 Apr 2024 21:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908782; cv=none; b=UGh6f0geGWKb9Z9ozJG0evM6cXpIvllryUbXKGLYC5eeQN2sy4bBI2Oug0DGl/oqugft45gItKmXAd40y+lfNUQ17plMXPF099YP2LL+W/Bn0L6fPk82wR0iEJtHQOCOKNgtFXuzQbrnWJg+TM8qgScJAySdywEmtlt5DcUvdi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908782; c=relaxed/simple;
	bh=MsL0zSREABbxkR4kcZ1CTaxFCZRicE/yy3HZDDRsbMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fb/f02J4CoitBiSoT3ul/nXWOrxU6L+KYgJO1XtllZlCKf6r/5CCusWnQKaq3ycks83mqXSUydCgKO9b6XzFHM+NTbMDPTjH5CiLkZj3vzhG3NwSq7i/uKJpdthEXkBzMjRH9bUDrzWGUWI2dRbn8K8bsy9MGBt9KYTggY8yu/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WnhTCHCz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WnhTCHCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61EAFC116B1;
	Tue, 23 Apr 2024 21:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908782;
	bh=MsL0zSREABbxkR4kcZ1CTaxFCZRicE/yy3HZDDRsbMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WnhTCHCzWVB8R9synE0w5ygmBNreGbYpxYllpEvrKSBVveYpw63ZAQKjsbmAQknQv
	 npwsmtYvmHPr7jQ+IOrNZS9VqzBE9EYW9sX5+9NBhdHCDRowVB4TjDbTBPivsDYLbG
	 a+6szc8l6v+HSst31uPsVh0KOP/2QHk0KzOnaN+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 23/71] af_unix: Dont peek OOB data without MSG_OOB.
Date: Tue, 23 Apr 2024 14:39:36 -0700
Message-ID: <20240423213844.945812138@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 22dd70eb2c3d754862964377a75abafd3167346b ]

Currently, we can read OOB data without MSG_OOB by using MSG_PEEK
when OOB data is sitting on the front row, which is apparently
wrong.

  >>> from socket import *
  >>> c1, c2 = socketpair(AF_UNIX, SOCK_STREAM)
  >>> c1.send(b'a', MSG_OOB)
  1
  >>> c2.recv(1, MSG_PEEK | MSG_DONTWAIT)
  b'a'

If manage_oob() is called when no data has been copied, we only
check if the socket enables SO_OOBINLINE or MSG_PEEK is not used.
Otherwise, the skb is returned as is.

However, here we should return NULL if MSG_PEEK is set and no data
has been copied.

Also, in such a case, we should not jump to the redo label because
we will be caught in the loop and hog the CPU until normal data
comes in.

Then, we need to handle skb == NULL case with the if-clause below
the manage_oob() block.

With this patch:

  >>> from socket import *
  >>> c1, c2 = socketpair(AF_UNIX, SOCK_STREAM)
  >>> c1.send(b'a', MSG_OOB)
  1
  >>> c2.recv(1, MSG_PEEK | MSG_DONTWAIT)
  Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
  BlockingIOError: [Errno 11] Resource temporarily unavailable

Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20240410171016.7621-3-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index e2a2e22d210f6..f66f867049015 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2565,7 +2565,9 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 					WRITE_ONCE(u->oob_skb, NULL);
 					consume_skb(skb);
 				}
-			} else if (!(flags & MSG_PEEK)) {
+			} else if (flags & MSG_PEEK) {
+				skb = NULL;
+			} else {
 				skb_unlink(skb, &sk->sk_receive_queue);
 				WRITE_ONCE(u->oob_skb, NULL);
 				if (!WARN_ON_ONCE(skb_unref(skb)))
@@ -2648,11 +2650,9 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 #if IS_ENABLED(CONFIG_AF_UNIX_OOB)
 		if (skb) {
 			skb = manage_oob(skb, sk, flags, copied);
-			if (!skb) {
+			if (!skb && copied) {
 				unix_state_unlock(sk);
-				if (copied)
-					break;
-				goto redo;
+				break;
 			}
 		}
 #endif
-- 
2.43.0



