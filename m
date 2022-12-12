Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA80C28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21287C433EF;
	Mon, 12 Dec 2022 13:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852462;
	bh=bjKzL0ABmnz7AqXAK9DkHcuh9Yodcz4M6I1m/3Xyyj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IiF0exgebkBcXZMdS0wT4ILLLFIKptAaedH/gpdWZBVFD4Sh8Lfe6yBseZWSTf0Xr
	 2JZl2tuC+uN3ahmLDiJT+bNdzSpTjAq0AgBCxSb9Zy0mUudyACnPcOSf82OqatpTnV
	 SMoIBu9W8uS23jFv35UsgzY7oBNHU0xk6DALwMEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2d7f58292cb5b29eb5ad@syzkaller.appspotmail.com,
	Wei Chen <harperchen1110@gmail.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.0 085/157] can: af_can: fix NULL pointer dereference in can_rcv_filter
Date: Mon, 12 Dec 2022 14:17:13 +0100
Message-Id: <20221212130938.206109341@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 0acc442309a0a1b01bcdaa135e56e6398a49439c upstream.

Analogue to commit 8aa59e355949 ("can: af_can: fix NULL pointer
dereference in can_rx_register()") we need to check for a missing
initialization of ml_priv in the receive path of CAN frames.

Since commit 4e096a18867a ("net: introduce CAN specific pointer in the
struct net_device") the check for dev->type to be ARPHRD_CAN is not
sufficient anymore since bonding or tun netdevices claim to be CAN
devices but do not initialize ml_priv accordingly.

Fixes: 4e096a18867a ("net: introduce CAN specific pointer in the struct net_device")
Reported-by: syzbot+2d7f58292cb5b29eb5ad@syzkaller.appspotmail.com
Reported-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20221206201259.3028-1-socketcan@hartkopp.net
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/af_can.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -680,7 +680,7 @@ static int can_rcv(struct sk_buff *skb,
 {
 	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 
-	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CAN_MTU)) {
+	if (unlikely(dev->type != ARPHRD_CAN || !can_get_ml_priv(dev) || skb->len != CAN_MTU)) {
 		pr_warn_once("PF_CAN: dropped non conform CAN skbuff: dev type %d, len %d\n",
 			     dev->type, skb->len);
 		goto free_skb;
@@ -706,7 +706,7 @@ static int canfd_rcv(struct sk_buff *skb
 {
 	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 
-	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CANFD_MTU)) {
+	if (unlikely(dev->type != ARPHRD_CAN || !can_get_ml_priv(dev) || skb->len != CANFD_MTU)) {
 		pr_warn_once("PF_CAN: dropped non conform CAN FD skbuff: dev type %d, len %d\n",
 			     dev->type, skb->len);
 		goto free_skb;


