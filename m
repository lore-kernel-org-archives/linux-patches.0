Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667F613FD67;
	Tue, 23 Apr 2024 21:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908584; cv=none; b=h8V0AvXSEq3hxj6J4FstiaaWwg9SyYeUKQTKyJVmbnx5TNO+rI2GtOM4zO+TBP6R9TFP13ekB89gDZcacrWPtuDvD0Yt5S822dCaBf/cwFVIPPejBXS1AzMlLKlfoajmCYfmwk1neZ8UG/E3n4YhHcstrRuEr21NljNbVd+0xKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908584; c=relaxed/simple;
	bh=/CZWSdM6pLXqckJqw461whgeWYiqD1fa++gia1tbAKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+zBsfd58yEeUa7xzd2zge68sdAISWBmBg6IEWir1SCDmdka235OqN28Yy1l5Yi9XuPbuNhjcwB+vtsQ32HgiP3E5Y3xcxsNGfQYN+rdmTskDzsanbT5OKr8/Cp2h793mm+vPx1R/mFLV24qbJZRNToWngfRyj1sg1BQChhrakU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHcSQxRg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHcSQxRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3404CC32782;
	Tue, 23 Apr 2024 21:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908584;
	bh=/CZWSdM6pLXqckJqw461whgeWYiqD1fa++gia1tbAKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHcSQxRgDpJvbVq5rSkfOmueDlrvpzzfYa6eCeyllwu2bhiK5DUAc3fpT8RrnqSiy
	 83lPRac/xxDgOkS/KuX/HNwMRxUwaLXR/hMLEBZrX6xsIuRxAoBTd2on+CAFyKxczK
	 3asCqKHnZh29t/O25BdS/KbbEF6fnMnQK1jKNP9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/158] af_unix: Dont peek OOB data without MSG_OOB.
Date: Tue, 23 Apr 2024 14:37:57 -0700
Message-ID: <20240423213857.050566859@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1340cb86f104c..6eab35a5e2f3b 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2587,7 +2587,9 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
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
@@ -2669,11 +2671,9 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
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



