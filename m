Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028367;
	b=iwytBWsMtLQlOWwXNYRqEI4VByt2OXseDvX/oqRrEAsWQeWKUb29J6FlgBoiizsXg6Gt
	 qvRvQsoH6ef9D8Lh/YCbT69b9kEy2qOY5dW/UiHtHJpxa0JKFSxGg8St1/hnpP/smkYNS
	 t2qpL6DnOdQGHMUJT39p6jGVvMTkXcDIiSGwub+Pc77jxfmpDoePfMgB508Dud8tkoF5B
	 J2JQxzTbbC3lXAIDUzr9bjCobz6uUECM90u9uWv09xFsQT5o1cenaUw1MNmzfGbHuu9Xs
	 BN7Z4AS9/8gsEA4bBTxYD3zydcREiDnrlHJJmHf2cZWHUnJHUn3uM/IJ5Z6RhRrao8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=creIMuBGoRSpZQUJN2Ons5OJQoXpf6aGvmkP/L5GWys=;
	b=R8HequJy6jyHLjhED9Eie6ubO9svwFcNplUvqQvH1w985wVio8reMR9HKMEDuNmxeML6
	 vLDGBHmsrmh+iXIeEaq2aBreUHThjq4xeGb0A85dvYZIFChSAhpABMB4Ruvq8D8woblNw
	 JDvnMr9S1Jb5zYmeZpw4I89G1a8A7S9mopV3+6eZ1dIUeSyXXC0yVPXrtI/XXEo9shbv2
	 QL9HGXbO7EQ96v0tE32MM3AjoPJ7/p1V2r95Qkn4+qAqwn3a6g9kXau/p4bZK5lTtwfI/
	 HzNUEhn9f8IzJptWJFhFSD3W2S4h0jTQ8aESQ2bzTnMW/BKXiFPmUBDgmhkwU2ZrN/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="SDbuTyg/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664BA606A31C;
	Wed, 18 Nov 2026 18:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SDbuTyg/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3901F000C4;
	Wed, 18 Nov 2026 18:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028367;
	bh=creIMuBGoRSpZQUJN2Ons5OJQoXpf6aGvmkP/L5GWys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SDbuTyg/G6BlZ32QFGwPa+GlUX+BOVKVDw38ClgS06MC/5YQBrsLB7jCRmyYh8h31
	 9fwf8VNMrTPvsggC7kvUu8khDJ/VwTWz6QWo23EcRXpZuzoD9ecEcVOZuXbXPlhBat
	 NxC79+oO6N1CJVU9bQukxtpvZeNIbr/bYw1oEG8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2119/2151] tun: drop batched packets while the device is down
Date: Wed, 18 Nov 2026 16:04:14 +0100
Message-ID: <20261118150238.881593828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiao Liang <shaw.leon@gmail.com>

[ Upstream commit 8f44631ba02afe9fff2f0a0fb66560ab19df87fd ]

tun_sendmsg() handles TUN_MSG_PTR batches from vhost-net by calling
tun_xdp_one() instead of tun_get_user(). But this path does not check
IFF_UP, allowing packets from a guest to be injected into the host
receive path while the device is administratively down.

Check IFF_UP in tun_xdp_one() before running XDP or building an skb.
Drop the packet when the device is down, matching tun_get_user().

Fixes: 043d222f93ab ("tuntap: accept an array of XDP buffs through sendmsg()")
Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20261027101830.85327-1-shaw.leon@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index ff1f69589a66a..afb02752b257f 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2417,6 +2417,12 @@ static int tun_xdp_one(struct tun_struct *tun,
 		return -EINVAL;
 	}
 
+	if (unlikely(!(READ_ONCE(tun->dev->flags) & IFF_UP))) {
+		put_page(virt_to_head_page(xdp->data));
+		dev_core_stats_rx_dropped_inc(tun->dev);
+		return -EIO;
+	}
+
 	xdp_prog = rcu_dereference(tun->xdp_prog);
 	if (xdp_prog) {
 		if (gso->gso_type) {
-- 
2.53.0



