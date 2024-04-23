Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74626143C6C;
	Tue, 23 Apr 2024 21:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908802; cv=none; b=iz1ab4kWYa0gcVeHjTNYlzn1gTWazIq9b8JhlJ2rqdvuoKS+4K4MS5WIDvC5nsiWm5Z4CeL0Sb4btg/oteqEG1iONydGdYbT3FiMPf+MpmfkIHNTq5lX+Z3f6WGCGTQP8RJRfwF2W/re9wsx86uSh5GFQyOi4iqgpgBKUCxnLQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908802; c=relaxed/simple;
	bh=CR9aSOCH06gBunoeAcqvP5GIXNJ214oj8ZXaLssKYaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3C73aQwMw/w3LW0Lz5Ji3KIARvXFVRzHwwgtHVfDb/O+WAuPN26hEwl3vPKgrl+Aw0l3byCxD37xxYVw4wvxopK0UJOIGFprnND0oXGVuHI7p4VCR8EtktHRFd4nW07mUkuzTGZJNPuDrBl6qrBvwlutwxxa5ToT5U3rFoPQRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQvliwgf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQvliwgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B218C3277B;
	Tue, 23 Apr 2024 21:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908802;
	bh=CR9aSOCH06gBunoeAcqvP5GIXNJ214oj8ZXaLssKYaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQvliwgfNKpRD83qUfv8E9cXawynWbqDd0HhfUrmHP2AFgI+tGonSWf/w62H/qvAQ
	 kS8OA8qlzVZG3sHv4Rx6+71DQ2loJCTUfvjA0PAaV4awrLICemuWDFdcLyCoJaJ6B/
	 DvCFsa5a6NCn98ysxkrPTTiv1H5DjwlSBJF29NOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 22/71] af_unix: Call manage_oob() for every skb in unix_stream_read_generic().
Date: Tue, 23 Apr 2024 14:39:35 -0700
Message-ID: <20240423213844.904442048@linuxfoundation.org>
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
index 628d97c195a7e..e2a2e22d210f6 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2644,6 +2644,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 		last = skb = skb_peek(&sk->sk_receive_queue);
 		last_len = last ? last->len : 0;
 
+again:
 #if IS_ENABLED(CONFIG_AF_UNIX_OOB)
 		if (skb) {
 			skb = manage_oob(skb, sk, flags, copied);
@@ -2655,7 +2656,6 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 			}
 		}
 #endif
-again:
 		if (skb == NULL) {
 			if (copied >= target)
 				goto unlock;
-- 
2.43.0



