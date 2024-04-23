Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F14C149C78;
	Tue, 23 Apr 2024 21:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908692; cv=none; b=UC7eNlrAkggtw8vP+fBemradXl9vN6PVvIy+c1BLcOXrBT6KUYdoLSr31GN+gKEGz4hFKHVr+7JPbjvYuo0PcRLs91ih1zTkvitBiszkjwiJJWrHY9RWGz/JU0GmxaQBSxt0XSeTLgbC0VylRGKN6KPz0JvT0iNNgWaj6xJMI5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908692; c=relaxed/simple;
	bh=LmSB6H98JjhVHfj3pQPaROIw85pL6Z97xvYle7JD5vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJnTfWMJ9P3XxarlxKNVU2zzacfus8Js0DK1R/LHtQfVeZcxOJwfrY/vb/synSpTeWw/qEadqOA055/9MgwJ2yFryzGik8U6H29gNwHd/Zb2kFYnaNCUilftiM4EXsb6iTxdAdMJFJvKqhuaD2k8SlgfqAOxsAQQiO47WcfC61M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJ5pPzzW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJ5pPzzW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64AF8C32783;
	Tue, 23 Apr 2024 21:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908692;
	bh=LmSB6H98JjhVHfj3pQPaROIw85pL6Z97xvYle7JD5vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJ5pPzzWQPDvo/xP9zvFXLtbd2PWVzPUFeoy+NkTm/1fJuN602sdO1/W1m6XrC8ls
	 1qaMpFYOLp3QRvAro0Ml4n1KZY11l1iSea2YVEjf1B1LBBTWamhQiNSnS5tjY14wS8
	 ka+ZIOppi23gF2VQfkth2+gUYRevS5PHGZREAdzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/141] af_unix: Call manage_oob() for every skb in unix_stream_read_generic().
Date: Tue, 23 Apr 2024 14:38:28 -0700
Message-ID: <20240423213854.577452185@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

[ Upstream commit 283454c8a123072e5c386a5a2b5fc576aa455b6f ]

When we call recv() for AF_UNIX socket, we first peek one skb and
calls manage_oob() to check if the skb is sent with MSG_OOB.

However, when we fetch the next (and the following) skb, manage_oob()
is not called now, leading a wrong behaviour.

Let's say a socket send()s "hello" with MSG_OOB and the peer tries
to recv() 5 bytes with MSG_PEEK.  Here, we should get only "hell"
without 'o', but actually not:

  >>> from socket import *
  >>> c1, c2 = socketpair(AF_UNIX, SOCK_STREAM)
  >>> c1.send(b'hello', MSG_OOB)
  5
  >>> c2.recv(5, MSG_PEEK)
  b'hello'

The first skb fills 4 bytes, and the next skb is peeked but not
properly checked by manage_oob().

Let's move up the again label to call manage_oob() for evry skb.

With this patch:

  >>> from socket import *
  >>> c1, c2 = socketpair(AF_UNIX, SOCK_STREAM)
  >>> c1.send(b'hello', MSG_OOB)
  5
  >>> c2.recv(5, MSG_PEEK)
  b'hell'

Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20240410171016.7621-2-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 0a75d76535f75..6af6f82e89464 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2753,6 +2753,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 		last = skb = skb_peek(&sk->sk_receive_queue);
 		last_len = last ? last->len : 0;
 
+again:
 #if IS_ENABLED(CONFIG_AF_UNIX_OOB)
 		if (skb) {
 			skb = manage_oob(skb, sk, flags, copied);
@@ -2764,7 +2765,6 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 			}
 		}
 #endif
-again:
 		if (skb == NULL) {
 			if (copied >= target)
 				goto unlock;
-- 
2.43.0



