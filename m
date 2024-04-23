Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E09714389A;
	Tue, 23 Apr 2024 21:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908462; cv=none; b=qQ+ksYoe5tY6yJTh+WijGKU9AxLpvWAPLKQZO+LGUb7eu9mhlpakYnvDtDwGMzpT1dk/EvPkBrkmaiKdQbf3Zser01qVL/509i47fgnUfGnT9rMk2wmCKYPk8ifMlLOEKOhYMj5mnGIjCvkz9Ga8qBBovsRd8vJjfzRnwYk2Z/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908462; c=relaxed/simple;
	bh=XLPcgZOn8sGpiG0PuoIZ4cyfzZ62gdRYO4zOc9RL34I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4FsJH4fs3hvHun02Jb0hfinZVb5Uru+QzC6fwJjkVBN5E/M5YQWhnnAZJ+rv1J9zjCnafm2gfMPenfWzzYfw18JkKyp8lFmVNyyVN2z/EDWJ8oMfrmS7/FipzPTr0WtZGP873C+i1wz122qQq0BR2H4tS90NZ1c+VadOsAcC/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R340piPB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R340piPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A22C3277B;
	Tue, 23 Apr 2024 21:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908462;
	bh=XLPcgZOn8sGpiG0PuoIZ4cyfzZ62gdRYO4zOc9RL34I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R340piPBALBXD6wONqA21JT5rFhXvO1F7xWIc1+7gYN9u90tNfG/IbnS8oBNdFbTW
	 KmwuX6hVku+I0lgIkpxHBk6/+gvtWaexMaICIDtP24nHufwI7u5tWp8R9Of+ivGhTD
	 jTsl5XeSFCO/GH5NF4cl7BulyAhxofwGg7k6haCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 023/158] af_unix: Dont peek OOB data without MSG_OOB.
Date: Tue, 23 Apr 2024 14:37:25 -0700
Message-ID: <20240423213856.626841769@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index fd931f3005cd8..9df15a7bc2569 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2602,7 +2602,9 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
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
@@ -2684,11 +2686,9 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
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



