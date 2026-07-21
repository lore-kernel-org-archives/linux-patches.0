Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A853E49CF;
	Tue, 21 Jul 2026 22:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672683; cv=none; b=QCadBlCUnMws8I38sdFBiAofHyJK/3G6tE0SyPPp/QKLL6cqzpRPQPFLWFv6dZI32R0yC1VogeaM5ubFSKy6EStVmXVNoP0//k9kvLqmdSJ2/2DfXZGJ+LGJfg8ShhdLaVWJT8RdrpXGSJYdT2RC+ZRMGlpq7+TVTqLizwUPW4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672683; c=relaxed/simple;
	bh=zJRE50JRpfCNoX/p578JToX9LkxrYl0EBKYoQjLqwrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RHRBZ7FmDuQ0JH3NQNOtX/Lpxv20m1U0LRecwFeU9oG66WtZa4awRCIxtE9pRIr3Ktz5YAg+x+TpeKbLjYLUvuRJfD76DZ/MoM03gR6Jgzx3pvv4nw0g7WPW1tCOhUfzNwln7chNjSljtqA9DO8mEg45E/q77w0Fn6AdlPLKxMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kF66jhV+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kF66jhV+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A72B1F000E9;
	Tue, 21 Jul 2026 22:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672682;
	bh=QzKKr+uBpH6GwUX7Mb1CxZW51ovB4usavmv+ekk4eGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kF66jhV+9i4ENUdL993W6tZZfaN/UBaYALTOJ7LBuDV0LvzTtp0JVPprDPe6B7HS/
	 MP+g7jY8LBghBewYgAFgCbBoqGgwEyazBjSatAWUGs06Px9jH+EcnGEq0Ek61xj74S
	 RZWFC2au8cZiK++p2M5zLZH8U6c99c+7s9iqMrww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Raphael Tiovalen <jamestiotio@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 716/843] macsec: fix promiscuity refcount leak in macsec_dev_open()
Date: Tue, 21 Jul 2026 17:25:51 +0200
Message-ID: <20260721152422.154761367@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: James Raphael Tiovalen <jamestiotio@gmail.com>

commit 7410d11460eb90d6c9281162ccc6a128534d897d upstream.

When a MACsec interface with IFF_PROMISC set is brought up on top of a
device that has hardware offload enabled, macsec_dev_open() first calls
dev_set_promiscuity(real_dev, 1) and then propagates the open to the
offload device. If that propagation fails, the error path jumps to the
clear_allmulti label, which only reverts allmulti and the unicast
address. The promiscuity taken on the lower device is never dropped, so
real_dev is left permanently stuck in promiscuous mode. Its promiscuity
count can no longer be balanced from software.

Add a clear_promisc label that drops the promiscuity reference and
route the two offload failure paths to it. The dev_set_promiscuity()
failure itself still jumps to clear_allmulti, since on that failure the
count was not incremented.

Fixes: 3cf3227a21d1 ("net: macsec: hardware offloading infrastructure")
Cc: stable@vger.kernel.org
Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20260705113629.187490-1-jamestiotio@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macsec.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3556,19 +3556,22 @@ static int macsec_dev_open(struct net_de
 		ops = macsec_get_ops(netdev_priv(dev), &ctx);
 		if (!ops) {
 			err = -EOPNOTSUPP;
-			goto clear_allmulti;
+			goto clear_promisc;
 		}
 
 		ctx.secy = &macsec->secy;
 		err = macsec_offload(ops->mdo_dev_open, &ctx);
 		if (err)
-			goto clear_allmulti;
+			goto clear_promisc;
 	}
 
 	if (netif_carrier_ok(real_dev))
 		netif_carrier_on(dev);
 
 	return 0;
+clear_promisc:
+	if (dev->flags & IFF_PROMISC)
+		dev_set_promiscuity(real_dev, -1);
 clear_allmulti:
 	if (dev->flags & IFF_ALLMULTI)
 		dev_set_allmulti(real_dev, -1);


