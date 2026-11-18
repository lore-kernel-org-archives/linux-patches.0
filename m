Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056838;
	b=A4PEAAq2G5mPfNzoxV3qL6DHOXATJBOlHl9K9fkCNMEdwolIRWPbI8mIKrXr2Zt0YcNf
	 EFZnCnH88X630RAYeP2BUAZTE1FPKfVb35vVTWmG2etEN3d9y8XA/dGNmXHG4qZvnekBW
	 xt7vOJic6fzy7mPJAmJECv7vXYOBfTMqW90aCT4r0At9q7zD3M5kc2huM+Ry2NSfmr9PF
	 GRK/+eCZJVI5DIEehVJrfO9xoVBDEgy3gavrMsK4re/n3a/qMEB1veBTiUJyUshlZZE4I
	 vvBVeOYix28A2MxZTn7ODZAlJiGsk1azFFNm9hH4QfgbxBIhwZC6Bgr6BYj4YJWse0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EeAphJfG1RKbMfDFFgXEsGrxH5PcjJw0JlYRgFlVEWk=;
	b=SaNKvqnEGG1zZHcDikofW1ZIBxsC/3G0MyR0NuBjccpI0kgTr8B9KO8yyQSRx+F6hXfs
	 hDi8YGYtEll0JB6BK+wNlNMaeoUyJpjZ9RGRPuXzcuXBpStiqXE3LEfVD06bz1VUK+tzt
	 zuP2DrZQWu910YNmF8JkRqjmr2knUeyQ9YTdo5SqOQDlD4vJ9e1ZsMh9mxS39oRHY2M2E
	 9EIa9Hf5ZP0M+vCR3vLYFKCPX6PSYgs+ftGtjek2HIOh+p/BQt9X+Cz6FW0+6Y3l3qnUC
	 zObzQwBCdlmJXh5u+vdtMt2b1LGN8V1HmgeVIJtD5SUD/bwTsq23nU4FSHFbpDItSLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bbVgpdcL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD5E606A334;
	Thu, 19 Nov 2026 02:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bbVgpdcL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48671F000C4;
	Thu, 19 Nov 2026 02:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056838;
	bh=EeAphJfG1RKbMfDFFgXEsGrxH5PcjJw0JlYRgFlVEWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bbVgpdcLkYncI3UZDH+1/7Yzea2DUaL4KzC5LXLhUl3M992C4RC1FlN4ToWzvooQR
	 D1c/hj6TV6FjYZZOv5W9mI9KpeMGx8Hl1ecz0XWwXL/ueliREI87c2JmwB860FZfzO
	 gytye7c+aG2jAbNGR469cGLzgZChJtBwlqP5ERfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0017742620a9d06f06ef@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2131/2214] tipc: fix refcount panic in tipc_rcv() when receiving shared skb
Date: Wed, 18 Nov 2026 16:03:27 +0100
Message-ID: <20261118150135.799999392@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tung Nguyen <tung.quang.nguyen@est.tech>

[ Upstream commit 5308a2049b764aa55513c90c68933abf596c51d2 ]

TIPC assumes that the received skb is not shared with other users.
However, syzbot reports a bug triggered by receiving a shared skb:

...
RIP: 0010:pskb_expand_head+0x135a/0x13a0 net/core/skbuff.c:2308
__pskb_pull_tail+0x111/0x1870 net/core/skbuff.c:2890
skb_cow_data+0x2ed/0xc50 net/core/skbuff.c:5398
tipc_aead_decrypt net/tipc/crypto.c:892 [inline]
tipc_crypto_rcv+0x346/0x23d0 net/tipc/crypto.c:1843
tipc_rcv+0x4b7/0x1040 net/tipc/node.c:2119
tipc_l2_rcv_msg+0x2d9/0x470 net/tipc/bearer.c:669
deliver_ptype_list_skb net/core/dev.c:2533 [inline]
...

The root cause is that local delivery hooks in the kernel (e.g.,
deliver_skb()) may increment the skb's reference count (`users`) before
TIPC processes it on ingress.

Fix this by calling skb_share_check() to ensure exclusive ownership
before passing the skb to tipc_rcv(). As TIPC needs to modify the skb's
data, the cloned skb needs to be uncloned when needed. This can be
addressed in separate patch.

Reported-by: syzbot+0017742620a9d06f06ef@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0017742620a9d06f06ef
Closes: https://lore.kernel.org/all/20261018145928.58317-1-ngocthang2710.1999@gmail.com/T/
Fixes: b97bf3fd8f6a ("[TIPC] Initial merge")
Co-developed-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Signed-off-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20261023052921.54220-1-tung.quang.nguyen@est.tech
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/bearer.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 986b1fd888544..e72318f1a4183 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -661,6 +661,10 @@ static int tipc_l2_rcv_msg(struct sk_buff *skb, struct net_device *dev,
 {
 	struct tipc_bearer *b;
 
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (!skb)
+		return NET_RX_DROP;
+
 	rcu_read_lock();
 	b = rcu_dereference(dev->tipc_ptr) ?:
 		rcu_dereference(orig_dev->tipc_ptr);
-- 
2.53.0



