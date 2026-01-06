Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D104F36402B;
	Tue,  6 Jan 2026 17:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721867; cv=none; b=O7cxFxWLaFx/w1RRDNHaR+SgMyXi8MmTGOW6vokgKL2gEvYieakucL4IfS2Z3nx9lVVGe5l9UOHu1zGNFt4Lb8X1aFj3zt+FiFDqlpxsM59Wb50cGmt9XWbyvgoCbfOq4ctTXg/GoSgWoMtXLWraUZxYQ1wQ+CyhnLrZMqyex7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721867; c=relaxed/simple;
	bh=lQJl3v2Dh2toGpOzd8+tln5521suTJPsHqysdEFDoKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HC/OGMhg+ZQ2xXz9BVbzaDk64PmxNHpRqHJzAuL88f7ELr9amwQNmPDCv0TVCU4J/sZol1z82WpVDLBXj0G41BtygTxorr7qLpZDRKAwF9kRk771wtz6QQ/uOeOVH79LMIuCddD6euz4D/LehwXd3eISSH0QbeIy9Qwc8Wf+hAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GAsxvghp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GAsxvghp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F497C116C6;
	Tue,  6 Jan 2026 17:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721867;
	bh=lQJl3v2Dh2toGpOzd8+tln5521suTJPsHqysdEFDoKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GAsxvghp4M3n/5L5qzvwjOrxpirFG8CgYILN0Ig37ly9bNKxCOHssMBGDHwd4e9Nk
	 hL6DAz8w1WPaj8MnIYPLW7IwgOrwVQpvTg5dG939olvp6eEOLx1E1ZXkFlpdpKG0i8
	 vg6zZhRrTJmLWwdyDNn8H7RkGSyo1CABPOUGCUzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3d43c9066a5b54902232@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 052/312] net: usb: asix: validate PHY address before use
Date: Tue,  6 Jan 2026 18:02:06 +0100
Message-ID: <20260106170549.735541700@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit a1e077a3f76eea0dc671ed6792e7d543946227e8 ]

The ASIX driver reads the PHY address from the USB device via
asix_read_phy_addr(). A malicious or faulty device can return an
invalid address (>= PHY_MAX_ADDR), which causes a warning in
mdiobus_get_phy():

  addr 207 out of range
  WARNING: drivers/net/phy/mdio_bus.c:76

Validate the PHY address in asix_read_phy_addr() and remove the
now-redundant check in ax88172a.c.

Reported-by: syzbot+3d43c9066a5b54902232@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3d43c9066a5b54902232
Tested-by: syzbot+3d43c9066a5b54902232@syzkaller.appspotmail.com
Fixes: 7e88b11a862a ("net: usb: asix: refactor asix_read_phy_addr() and handle errors on return")
Link: https://lore.kernel.org/all/20251217085057.270704-1-kartikey406@gmail.com/T/ [v1]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20251218011156.276824-1-kartikey406@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/asix_common.c | 5 +++++
 drivers/net/usb/ax88172a.c    | 6 +-----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index 7fd763917ae2..6ab3486072cb 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -335,6 +335,11 @@ int asix_read_phy_addr(struct usbnet *dev, bool internal)
 	offset = (internal ? 1 : 0);
 	ret = buf[offset];
 
+	if (ret >= PHY_MAX_ADDR) {
+		netdev_err(dev->net, "invalid PHY address: %d\n", ret);
+		return -ENODEV;
+	}
+
 	netdev_dbg(dev->net, "%s PHY address 0x%x\n",
 		   internal ? "internal" : "external", ret);
 
diff --git a/drivers/net/usb/ax88172a.c b/drivers/net/usb/ax88172a.c
index f613e4bc68c8..758a423a459b 100644
--- a/drivers/net/usb/ax88172a.c
+++ b/drivers/net/usb/ax88172a.c
@@ -210,11 +210,7 @@ static int ax88172a_bind(struct usbnet *dev, struct usb_interface *intf)
 	ret = asix_read_phy_addr(dev, priv->use_embdphy);
 	if (ret < 0)
 		goto free;
-	if (ret >= PHY_MAX_ADDR) {
-		netdev_err(dev->net, "Invalid PHY address %#x\n", ret);
-		ret = -ENODEV;
-		goto free;
-	}
+
 	priv->phy_addr = ret;
 
 	ax88172a_reset_phy(dev, priv->use_embdphy);
-- 
2.51.0



