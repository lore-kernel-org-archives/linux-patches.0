Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CA14746D4;
	Tue, 21 Jul 2026 20:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667507; cv=none; b=GEUJ3x+MfFgSFBLwGK197CQk1VYnoPyWgMZlbgMGzwQmDPXoToOYg29weiu5s4riYYhZDADmMVZLK9QJoK12W7rQ+zLQmaWzq3lOq2ZvpI9l4WCX1FoiREOa+E94K2TlU+uHf2vQC/aDh13EEOqqKze60O3jLek51Q1/g0ixOjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667507; c=relaxed/simple;
	bh=d0SO0ydimH8tY7SjZh18tQTGf3ar9haFHv/YnrmHdSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ColhAh0pUpR9a5AABvFA0wM1EdETsjedspkHKQr6K6TWCNhoAboYKkFE547iO7vx/dPAEPmOJuQ62+L+BlPL94yYIIDr77pe8ak4Hy4RkXGudqdG4yCbId3+43BBr6Tqlj2alxCO5+hJ/WZIJiG/IO+0/8o4kMeVQv9hJGQv2r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVfW7iEb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVfW7iEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F751F00A3A;
	Tue, 21 Jul 2026 20:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667493;
	bh=EFA6LmHgGSV6a4ZWI6PScGnZJQn5dNaJmYYdUQEZ9ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dVfW7iEb8KoU3IgVo05LHwb4xHrVI6skVjXlGV3pd9twFsv+DzDPojeYNH5YaO4Lk
	 jLp3x5hXC3Hc5yh+JgZv7vqaQtLsWUVMR62J5OBnb9Q5kvQc8jkjxVsABWKFTGAJb+
	 UgzZ2qWupb5RwwDe4Qu1WZtehNvAT69ieRiWi9xU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Linus Walleij <linusw@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 1082/1266] net: ixp4xx_hss: fix duplicate HDLC netdev allocation
Date: Tue, 21 Jul 2026 17:25:19 +0200
Message-ID: <20260721152506.024015389@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit db818b0e8af7bac16860116a19c341a63d6677b4 upstream.

ixp4xx_hss_probe() allocates two HDLC netdevs. The first one is stored
in ndev, initialized, and registered with register_hdlc_device(). The
second one is stored in port->netdev and later used by the remove path
for unregister_hdlc_device() and free_netdev().

This means that the registered netdev is not the same object that is
unregistered and freed on remove. It also leaks the first allocation if
the second alloc_hdlcdev() call fails, and the first allocation is not
checked before ndev is used.

Older code allocated the HDLC netdev only once and stored the same object
in both the local variable and port->netdev. The buggy conversion split
this into two alloc_hdlcdev() calls. A later rename changed the local
variable name to ndev, but the underlying mismatch remained.

Fix this by allocating the HDLC netdev only once and assigning the same
object to port->netdev.

Fixes: 99ebe65eb9c0 ("net: ixp4xx_hss: move out assignment in if condition")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260622043015.643637-1-haoxiang_li2024@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wan/ixp4xx_hss.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wan/ixp4xx_hss.c
+++ b/drivers/net/wan/ixp4xx_hss.c
@@ -1487,11 +1487,11 @@ static int ixp4xx_hss_probe(struct platf
 				     "unable to get CLK internal GPIO\n");
 
 	ndev = alloc_hdlcdev(port);
-	port->netdev = alloc_hdlcdev(port);
-	if (!port->netdev) {
+	if (!ndev) {
 		err = -ENOMEM;
 		goto err_plat;
 	}
+	port->netdev = ndev;
 
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 	hdlc = dev_to_hdlc(ndev);


