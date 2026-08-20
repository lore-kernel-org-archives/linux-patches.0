Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80793272E53;
	Thu, 20 Aug 2026 16:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243591; cv=none; b=QjdHGlwauRJf7DTsUQOpa9XA6km261MdS4oWxtfWVVrIwjL2AyVWaPsUYSviOBhRKYn1VgMDHqIFNH1kdqQCaOAcc2cWOqGsc+bf+C4SDVQu26GV29v1dV3p6lKmI+NLg/zVGZNPKf6PIi9eFtkTA1cFfgFO0rgRcGsP4CyhpRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243591; c=relaxed/simple;
	bh=DTL4AkerCYhLR2DovxAckOqrBJL3KS4J2X/2sCX4hA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZfPRql0dJu/nG5m/pYupbwz00zSkIiJ0X09k13wWtxqKgdo3hvbJ9TaXIGDe1/YUEQvgi0/CYQIwFpU+vznFk5NTeHezFn1qZoPOOVwWVfjKZyCrk7chrVMn1r3Azv529OtZiV34CT+q0W3Y+EAMVcCQlPOMVSgLUHnoZvlQguc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=owFSU5C1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="owFSU5C1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E6A1F000E9;
	Thu, 20 Aug 2026 16:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243590;
	bh=3L8URmQa4z61ag/KMMj/EA5NIen/tRD4Sen96dBpagk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=owFSU5C1nopZtvFpPjlCnw7EhebA3dhuS0XZZj92OE689JZUEaa8RI/l5aQ2JisyE
	 9nwGsMRiuUYOyW+ftjUT0VGaT8ppHfa+raBRL7wUDvNxE+0J1QKZ+Tx7ouMcMBuCF6
	 qGUfVH8ecOl6/CCBUhN9aLmP67bbnxX1YtDpQBFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Linus Walleij <linusw@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/272] net: ixp4xx_hss: fix duplicate HDLC netdev allocation
Date: Thu, 20 Aug 2026 16:55:30 +0200
Message-ID: <20260820145235.689169635@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit db818b0e8af7bac16860116a19c341a63d6677b4 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wan/ixp4xx_hss.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wan/ixp4xx_hss.c
+++ b/drivers/net/wan/ixp4xx_hss.c
@@ -1353,11 +1353,11 @@ static int hss_init_one(struct platform_
 	}
 
 	dev = alloc_hdlcdev(port);
-	port->netdev = alloc_hdlcdev(port);
-	if (!port->netdev) {
+	if (!dev) {
 		err = -ENOMEM;
 		goto err_plat;
 	}
+	port->netdev = dev;
 
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	hdlc = dev_to_hdlc(dev);


