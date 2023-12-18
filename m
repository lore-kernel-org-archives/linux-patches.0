Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F519129ED2;
	Mon, 18 Dec 2023 13:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xo1MjN2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F71C433C8;
	Mon, 18 Dec 2023 13:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907558;
	bh=YzVponcZ24teLN8wzxDvEplvgyub0tHMHn9Y0lv/vo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xo1MjN2PCUkWFWMwYFUgbmRkPjIG0T9rtSKR1lHzIyu8s+ecKAP4UWGgmX/Ex4zLX
	 YtdwJ8D9PDzFw52ZdIYEF1LrBb3p8jMI7Q5jn+iWzEba12Ngd3Kz801c50+vHEu/5v
	 /lnrGSpRM0QS0hbaIzgG9MChPyaNxTHd2SvP3XU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 06/26] atm: Fix Use-After-Free in do_vcc_ioctl
Date: Mon, 18 Dec 2023 14:51:08 +0100
Message-ID: <20231218135040.902192753@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135040.665690087@linuxfoundation.org>
References: <20231218135040.665690087@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <v4bel@theori.io>

[ Upstream commit 24e90b9e34f9e039f56b5f25f6e6eb92cdd8f4b3 ]

Because do_vcc_ioctl() accesses sk->sk_receive_queue
without holding a sk->sk_receive_queue.lock, it can
cause a race with vcc_recvmsg().
A use-after-free for skb occurs with the following flow.
```
do_vcc_ioctl() -> skb_peek()
vcc_recvmsg() -> skb_recv_datagram() -> skb_free_datagram()
```
Add sk->sk_receive_queue.lock to do_vcc_ioctl() to fix this issue.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
Link: https://lore.kernel.org/r/20231209094210.GA403126@v4bel-B760M-AORUS-ELITE-AX
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/atm/ioctl.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/atm/ioctl.c b/net/atm/ioctl.c
index 2ff0e5e470e3d..38f7f164e4848 100644
--- a/net/atm/ioctl.c
+++ b/net/atm/ioctl.c
@@ -71,14 +71,17 @@ static int do_vcc_ioctl(struct socket *sock, unsigned int cmd,
 	case SIOCINQ:
 	{
 		struct sk_buff *skb;
+		int amount;
 
 		if (sock->state != SS_CONNECTED) {
 			error = -EINVAL;
 			goto done;
 		}
+		spin_lock_irq(&sk->sk_receive_queue.lock);
 		skb = skb_peek(&sk->sk_receive_queue);
-		error = put_user(skb ? skb->len : 0,
-				 (int __user *)argp) ? -EFAULT : 0;
+		amount = skb ? skb->len : 0;
+		spin_unlock_irq(&sk->sk_receive_queue.lock);
+		error = put_user(amount, (int __user *)argp) ? -EFAULT : 0;
 		goto done;
 	}
 	case SIOCGSTAMP: /* borrowed from IP */
-- 
2.43.0



