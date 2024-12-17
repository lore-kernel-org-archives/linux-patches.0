Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01971F758F;
	Tue, 17 Dec 2024 17:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456013; cv=none; b=kMdORlzVxuX/sCPvacOGT57oGrrbXQqU++fqQz9Fn1VgCLD5yGCFTORnoyqL/aBMka7/aX9WY9kktzntSq6r+iYSPnVOvCSE9sDF5i41eyeMTHv0CdahNw9NU5f3Gar2+J9scCIw8AzW1pEdUf0917TVr9WeQHlEpTO155iUTQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456013; c=relaxed/simple;
	bh=MJ17NB/K/jMqToE1PI9s2vDUVumdyjDXGgkI4BZZmac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJFw7ElY2QQPXiTTDTDyD1pIZlxr2qXpxerDRucqfWfW/vKtbIbC/WbyxNXJ3lHr1ls4igt3J0omoX4Isu4een9oRLcYfhwnBmarUxe5TllevTNvO3FXSLPzTsR1IrS2tSLFpfxCU3SnE9RyCFko+L8NlVyHjAOgQUV2VeNzPBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xIyZ2o/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xIyZ2o/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473D8C4CED3;
	Tue, 17 Dec 2024 17:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456013;
	bh=MJ17NB/K/jMqToE1PI9s2vDUVumdyjDXGgkI4BZZmac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xIyZ2o/YKvWTL5VWdAwLnvVkG6jC84B5e/VXH+lUiLyPQ6LvjCMTpJcZk+manGZfn
	 3SdBLdLTFMlvHYAngjawEw8rwQcolJOOdmLUXs0rjrXM0AOirF0T7f0aVPHBO6q1Fd
	 o3en2FceZH+2BJ2d/xF9y3NBeNt1nsEfsjjmNj+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederik Deweerdt <deweerdt.lkml@gmail.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Joe Damato <jdamato@fastly.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 004/109] splice: do not checksum AF_UNIX sockets
Date: Tue, 17 Dec 2024 18:06:48 +0100
Message-ID: <20241217170533.519565933@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

From: Frederik Deweerdt <deweerdt.lkml@gmail.com>

commit 6bd8614fc2d076fc21b7488c9f279853960964e2 upstream.

When `skb_splice_from_iter` was introduced, it inadvertently added
checksumming for AF_UNIX sockets. This resulted in significant
slowdowns, for example when using sendfile over unix sockets.

Using the test code in [1] in my test setup (2G single core qemu),
the client receives a 1000M file in:
- without the patch: 1482ms (+/- 36ms)
- with the patch: 652.5ms (+/- 22.9ms)

This commit addresses the issue by marking checksumming as unnecessary in
`unix_stream_sendmsg`

Cc: stable@vger.kernel.org
Signed-off-by: Frederik Deweerdt <deweerdt.lkml@gmail.com>
Fixes: 2e910b95329c ("net: Add a function to splice pages into an skbuff for MSG_SPLICE_PAGES")
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Joe Damato <jdamato@fastly.com>
Link: https://patch.msgid.link/Z1fMaHkRf8cfubuE@xiberoa
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/unix/af_unix.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2219,6 +2219,7 @@ static int unix_stream_sendmsg(struct so
 		fds_sent = true;
 
 		if (unlikely(msg->msg_flags & MSG_SPLICE_PAGES)) {
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
 			err = skb_splice_from_iter(skb, &msg->msg_iter, size,
 						   sk->sk_allocation);
 			if (err < 0) {


