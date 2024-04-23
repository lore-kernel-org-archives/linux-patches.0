Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A1D14389F;
	Tue, 23 Apr 2024 21:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908461; cv=none; b=pQTVFWTsgEy0kGEi4krtj04tAWV2dO2BDKE0nG0GGUoEY5OG/mmob1ZndTDYKp76b6Jt8vSPK81zZr6o2PXk8jPwi5JOCdxcka2ViCKCs/Mg7POeborM2GOAVQol/mgZkfxEkonl/mSRf2D+A5ks/L3vvVgQ06a58RD2I1sMz54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908461; c=relaxed/simple;
	bh=l/WpknqcGPHaCzXjdbYzRGDZUBKfdM5Mk1j2yOkUihM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOt+Hp/03Ax06j0siM76cGQyPSfSxHY0Gy6olT1nupiTo81utWjuOdeQRdT7qD/yycW8BpcbPFsVl+XJ13fwuzApcoY5QYm9uNA7k/1qiJrFL49xd7ed0UjThL4ZF+H5+nKPSM4IKT6Qqwbds5Zy386Z0QH5CfFQRk7ZH99ilfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ISBLtfwa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ISBLtfwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D607C32782;
	Tue, 23 Apr 2024 21:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908461;
	bh=l/WpknqcGPHaCzXjdbYzRGDZUBKfdM5Mk1j2yOkUihM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ISBLtfwaEJyvV4Uq2hohjG1Fix2drFJLfRKTrzAx/0PE5xxCF1KDUDar8ltVRTdm8
	 e4T1Kw5XaXSGMgNEkkQIdsjbIKmgw/fphBJ5moS3FXAdHr1E1UULwpSiQmTQ0S+zcF
	 2rbzguzABYuol1Mqs7iUQWC8AMEGsQS2v4Bya6ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 022/158] af_unix: Call manage_oob() for every skb in unix_stream_read_generic().
Date: Tue, 23 Apr 2024 14:37:24 -0700
Message-ID: <20240423213856.590968398@linuxfoundation.org>
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
index e37cf913818a1..fd931f3005cd8 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2680,6 +2680,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 		last = skb = skb_peek(&sk->sk_receive_queue);
 		last_len = last ? last->len : 0;
 
+again:
 #if IS_ENABLED(CONFIG_AF_UNIX_OOB)
 		if (skb) {
 			skb = manage_oob(skb, sk, flags, copied);
@@ -2691,7 +2692,6 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 			}
 		}
 #endif
-again:
 		if (skb == NULL) {
 			if (copied >= target)
 				goto unlock;
-- 
2.43.0



