Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918BA471265;
	Tue, 21 Jul 2026 20:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664324; cv=none; b=XvK6NF/WFu8SDcsTJtA+jyj1FapUd3jCz6/JwAU64m6Cuvky0GlWDF/9ZUt7ZpmW8b/Y4q5UnNspFHVjRwDDuP5vU7772WEPBwdHxztpBJXr4i+UCpyF8ZP5ycbt+ofiyVumCk1l3wyfuEWnQobLaERRkTdUldK57/+3X5m5mw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664324; c=relaxed/simple;
	bh=cLPkbgs9jR2SGmIRkRCMppTf3W8IGxUXoPkXthbP+n8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQrPFzV+b5hJDUhcq5jQej/UUqS4+Hzua6EkIlLpW2FOS8ZyM+aW5f0MOTMm/eKy3NwPJPdCelxgj/O+0WecL+4bn1dT2Itw/ZZbe+oi7hks1p5UAR2ZwXCZ2eowCNE27/JkeOzEDHehkNqF0A7R2kL1kCMK3uGXb6+fzvOA068=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hKOejLl8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKOejLl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35D01F000E9;
	Tue, 21 Jul 2026 20:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664323;
	bh=LX3kZJJDugU2EDmqUnyxzToN+HTE4vWOZs/IDKRBjmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hKOejLl8jVcIyJ62qT8Gd2wKUmPtEGQ4SSYbmmxqURVYN7wTxyi1fC6qGByDSYY9R
	 ydptgfPzfe/LbAPrK6Xgrw0Rz4Z+nSPi66/90RTWKADq1EoMFfAPcjrT6NnuRrbVLI
	 vxK7KbN3N5OjWtIHJ+yhodkQSOXdijTnAjiQtBms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Raphael Tiovalen <jamestiotio@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 1114/1276] macsec: fix promiscuity refcount leak in macsec_dev_open()
Date: Tue, 21 Jul 2026 17:25:57 +0200
Message-ID: <20260721152510.923786841@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3627,19 +3627,22 @@ static int macsec_dev_open(struct net_de
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


