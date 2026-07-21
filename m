Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81E746EC85;
	Tue, 21 Jul 2026 18:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659469; cv=none; b=tTzSZ63oE/A6TkIf44vSDtZJybs+S4KuHWgBfPXrdCDKJZQ1wB0gXN5zE4JGhORfGXvSRuQTFvmeuZ4vKpooLCmonVJ6eql5/MTrYhWTFUVImt8Fb4xcgr/fXDbei722j04MNMW/PhNmzLAK+sLaO5pCCIH5AE8kM9UkbMl3N6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659469; c=relaxed/simple;
	bh=9lIV2TCczHw90zz7eYmGuIjeDN02O9AiRRUXd4dFu8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=suqnZg+iddTsxd+K7AqlNJD1ri+S2KkIRX/393B3LuBlRLo2fI3T9A9KKUIQu2N2lcdJNTZ/APV392faXpqu37c0RKb4YXqiVlwvZpX4yh+LpuQMGlYzC4G6j93kGkbB+tVqFVt0Tgz8MVho6PwA5+1D4xSBtjtTWBcGf5Ji+p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B35MYJHQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B35MYJHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3C11F00A3A;
	Tue, 21 Jul 2026 18:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659467;
	bh=ji9sqL35oD0GPm7ufL07yV5hHqSLZYt1BLIHSIlfL90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B35MYJHQmyd87imh91CNm1RZ0F0rEDVBenG6X8iZe8/r0U2SAuhbJP6Oud7TXsfjC
	 LjkKHJaLRztrPAjVQnltYAypQxl5mwQme/i/ylgI4VzUpVLX7s/B/7/gBe8wRPx+V6
	 9T5U9TDDrNZANEdKswG0tJ4am7ys41hzFyY9uZPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Raphael Tiovalen <jamestiotio@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 1489/1611] macsec: fix promiscuity refcount leak in macsec_dev_open()
Date: Tue, 21 Jul 2026 17:26:45 +0200
Message-ID: <20260721152548.936008463@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3609,19 +3609,22 @@ static int macsec_dev_open(struct net_de
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


