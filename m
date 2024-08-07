Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E7A126F2A;
	Wed,  7 Aug 2024 15:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043199; cv=none; b=qAwHZfMGtB6brni7PQEjMdTOosVyI5bIWbdN87xzMMdwj0SmOpFJIX7IJmzuVMfXPMBdOW/UR18bEub1yaV2l0/urvaVZVg4tqLnb/zih/XbPDkC0m/8ltlbVHX+V5iAuPNXumtDz94A79+mRq+IWute86Rmh9aTOxQI0kVi/Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043199; c=relaxed/simple;
	bh=BvyHLi3e1BHIdXBpbAbbpRIxHXe69V9LJKmxTp6iD8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPeerWWWPsnRB8DZpYyx/3+74MkLjmhizfg0Rua1ms/pNe1b1VfcSOi1CuiD078FuOUt3R+YJ2D6OpU2ewd2R/X/DcsRRdMjBBgelAHdman3XfGQavnrvlLZO4oW3yIKF3YDSr/k6tQ+zVk8XUxlXYkhLUkmqzt5OO3GgbzZTBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ashngIiz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ashngIiz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A23C32781;
	Wed,  7 Aug 2024 15:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043199;
	bh=BvyHLi3e1BHIdXBpbAbbpRIxHXe69V9LJKmxTp6iD8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ashngIizoj+GZydGIvw3G2lwdxK963HiYwS+5UFBSvS77St+k1mOFNXZhEiCERXHR
	 14bJk/opKRCz7gPvX+4uZ8OrREqF8E0KgfEsDoo/sytxGNeBvmtBM9mZ1Em7f71xM3
	 /XUPDo/ze5JRgKPPaU8ybrInir9xFqBG+u8Hd058=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Shigeru Yoshida <syoshida@redhat.com>,
	Hariprasad Kelam <hkelam@marvell.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.10 108/123] net: usb: sr9700: fix uninitialized variable use in sr_mdio_read
Date: Wed,  7 Aug 2024 17:00:27 +0200
Message-ID: <20240807150024.354058314@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 08f3a5c38087d1569e982a121aad1e6acbf145ce upstream.

It could lead to error happen because the variable res is not updated if
the call to sr_share_read_word returns an error. In this particular case
error code was returned and res stayed uninitialized. Same issue also
applies to sr_read_reg.

This can be avoided by checking the return value of sr_share_read_word
and sr_read_reg, and propagating the error if the read operation failed.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: c9b37458e956 ("USB2NET : SR9700 : One chip USB 1.1 USB2NET SR9700Device Driver Support")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Reviewed-by: Shigeru Yoshida <syoshida@redhat.com>
Reviewed-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/sr9700.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -179,6 +179,7 @@ static int sr_mdio_read(struct net_devic
 	struct usbnet *dev = netdev_priv(netdev);
 	__le16 res;
 	int rc = 0;
+	int err;
 
 	if (phy_id) {
 		netdev_dbg(netdev, "Only internal phy supported\n");
@@ -189,11 +190,17 @@ static int sr_mdio_read(struct net_devic
 	if (loc == MII_BMSR) {
 		u8 value;
 
-		sr_read_reg(dev, SR_NSR, &value);
+		err = sr_read_reg(dev, SR_NSR, &value);
+		if (err < 0)
+			return err;
+
 		if (value & NSR_LINKST)
 			rc = 1;
 	}
-	sr_share_read_word(dev, 1, loc, &res);
+	err = sr_share_read_word(dev, 1, loc, &res);
+	if (err < 0)
+		return err;
+
 	if (rc == 1)
 		res = le16_to_cpu(res) | BMSR_LSTATUS;
 	else


