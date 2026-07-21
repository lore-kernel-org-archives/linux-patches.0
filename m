Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014E73B6BEB;
	Tue, 21 Jul 2026 21:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667635; cv=none; b=eydlZQcNeLmDNC7xkuG3fDklo95KePc8dwgDDfeWhDhKleFtkI7ratXDBJIKdItVOLUMxZA6RRF224i+qlc+D2mJwKOK0BKJkEyNv4YzqAz4FJv1rLGMYeow8ku8kaWQH3lc1M3Gibe8gGqt9t38QDEYDveIIj1+whY7T4Z59rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667635; c=relaxed/simple;
	bh=u4mMHx7RQ8Va/9ic/FAiE1Tya8A0JHgpa3FvcYg8Tv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uewLzuoUiJ2TNcCrH9rflUDAtQ2DMETaHUb6qrDTZ4htQ0NGLwuHLOIDS/kts/ri1wD0ahXXwZw8z24PwYLeCdZVYZSf8l9CHwxagPIz7FwHNifIwaecYMPCcgGx/uf4Qacm/rsh6v08eVUZw2yLDo4j0roXqdULb5MqacZBnKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UMu6STB+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UMu6STB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591B71F000E9;
	Tue, 21 Jul 2026 21:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667633;
	bh=pB0Ymh3JVmy/fY1Sgqq8fyrPcGEEUW4qEDnUFj+scqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UMu6STB+hOEho6W88i0wwCp8k8m/Q0fU+FgUslKuBNqCo+zGfohh8BZUX1XUKPQ5v
	 LoN6xLIQoJ/Wq09PyLZ2FGOt3uQxNjNF+wgkfPonD+Zp1nIAlSjL9QBb3gfhGnvVPM
	 QQwqr3WN1jAR2SoMfERKavyqPv0qlDJpXxJmlGiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Raphael Tiovalen <jamestiotio@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 1134/1266] macsec: fix promiscuity refcount leak in macsec_dev_open()
Date: Tue, 21 Jul 2026 17:26:11 +0200
Message-ID: <20260721152507.171868800@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3558,19 +3558,22 @@ static int macsec_dev_open(struct net_de
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


