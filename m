Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042814;
	b=Z3gzAiSJPLgRkGQyeMJQ3ODqrn/4B5XHfB5FNz0PP6PPbIThRhoq/Ky/Fa9IkNO35+Dy
	 YNtJwPP57CfMR3pdiwsCCYsldo8IZ/7WAs+E+QlvijcTCtM8406iI4nrFWt+7qR6FtEMo
	 tzEKo4XEE+s/gm/JgDTDaZtqdB69Uced5sdX6ijLmWE47X8HyXjgH7i7ewyTZgOAbJBwc
	 M7Nqx4vuE9MbyX6BbZabrlqHQ8QzDA3yjxC4CLIvwjAtObhJWbXgULavnSnAV3RHvX22Y
	 bX5mCKw1LDfjiuyktZ5gXDQD+Hozsk2xSz5Db7DvVIuEIJGB86/CzNb1dk+O6avFiXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kG5hUXwh5SAYxp6zdjcN1oO124+VDaijCsqMMkczv58=;
	b=azzHod1hK0lhkBPZBQtHYTpcX15yOqG0jyByHpMWsqw/3OjIZEuwmT9WAq2C2Svu0Hax
	 FRgw6eoChIVOSooW67fEBQrNBSSqoNgTKmyzS5JmnCi9EXnV0PHITQu8DN3FUQVVjYkLZ
	 D+i+XSvG3X1Z/mU3N2DxXo7L1Zng1A/1qq9f+WFx1UqhUzIxbDu5Rgf6OiKor9Z4VGfda
	 TQiUrnBu5JMah5wRBYtgz5Xtowl5alRvpsCQmJJ37ZkwdutdtHEL54YS9lSi0rfkRc5+T
	 uqB8WlLd0ZvrtStFkachIITcaJ4JANpSLcce8bOdsoF5o4xTqQaEvk9AaemwuqU8qdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jNWKIVDI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F87606A336;
	Wed, 18 Nov 2026 23:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jNWKIVDI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F3E1F000C4;
	Wed, 18 Nov 2026 23:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042813;
	bh=kG5hUXwh5SAYxp6zdjcN1oO124+VDaijCsqMMkczv58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jNWKIVDIFLq/kSY2SI/oqQMA4YvkGAV8fsvlQb4UzJohpvNdKK8twCMXfyRHUg6Kq
	 4qeWO7pusle5S6SG+BBmsUqO6KB0fskqdqTpIeViyDtUrN0K8P2s10EJTVh7waeuMF
	 u/IqViq8mIKlbaJbAFEsMTpH+thhSN3+fNJA88vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3287/3318] tun: drop batched packets while the device is down
Date: Wed, 18 Nov 2026 16:05:09 +0100
Message-ID: <20261118150458.216068141@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5403ff1da23da..c3349bcff7ab1 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2483,6 +2483,12 @@ static int tun_xdp_one(struct tun_struct *tun,
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



