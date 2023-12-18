Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655FD1D15C;
	Mon, 18 Dec 2023 14:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oaUgc091"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD80AC433C7;
	Mon, 18 Dec 2023 14:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908763;
	bh=Z6v0K0FcWn53BzdSesnj8EsBjOk5B4QbABeZt/0C6wY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oaUgc091haB9wW5uuIToaAeJwlijlTJl9Hmkdzz5zjfF0SHDc2+M1DPJJDp6cKCC7
	 Za1f86OtQjBP6s06a6ANPWkaCuC8xIX6xb/sWpVdcCFK5t9RjfUlDgM4ACbzX4hM/I
	 IsMxwfHsfIpaC0N6/hr+2ldLrG2H1p9FiQY1DQIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 24/83] net/rose: Fix Use-After-Free in rose_ioctl
Date: Mon, 18 Dec 2023 14:51:45 +0100
Message-ID: <20231218135050.811396659@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135049.738602288@linuxfoundation.org>
References: <20231218135049.738602288@linuxfoundation.org>
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

From: Hyunwoo Kim <v4bel@theori.io>

[ Upstream commit 810c38a369a0a0ce625b5c12169abce1dd9ccd53 ]

Because rose_ioctl() accesses sk->sk_receive_queue
without holding a sk->sk_receive_queue.lock, it can
cause a race with rose_accept().
A use-after-free for skb occurs with the following flow.
```
rose_ioctl() -> skb_peek()
rose_accept() -> skb_dequeue() -> kfree_skb()
```
Add sk->sk_receive_queue.lock to rose_ioctl() to fix this issue.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
Link: https://lore.kernel.org/r/20231209100538.GA407321@v4bel-B760M-AORUS-ELITE-AX
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/af_rose.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 86c93cf1744b0..b3e7a92f1ec19 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1307,9 +1307,11 @@ static int rose_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 	case TIOCINQ: {
 		struct sk_buff *skb;
 		long amount = 0L;
-		/* These two are safe on a single CPU system as only user tasks fiddle here */
+
+		spin_lock_irq(&sk->sk_receive_queue.lock);
 		if ((skb = skb_peek(&sk->sk_receive_queue)) != NULL)
 			amount = skb->len;
+		spin_unlock_irq(&sk->sk_receive_queue.lock);
 		return put_user(amount, (unsigned int __user *) argp);
 	}
 
-- 
2.43.0



