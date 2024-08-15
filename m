Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8568A3214;
	Thu, 15 Aug 2024 14:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732657; cv=none; b=EiA9uTNZm7Y60BLNLQOGVJcIdEZIgk4IxXrSzCJqKbUuU1WY71+DN6z/Igg88XN3TmtNa85aBAoOHpYSjAUx1tnb1CzVRiUArq4quIh+U6iuBJgtJyMXTh73RcBPztGnPsul6/LxZvBhFl4xk7XM6Bh6pgS4uheHgiC0n/8ELcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732657; c=relaxed/simple;
	bh=sNnBGYxrmPIPCTK8ssNdF3vZ6IpKOiWAq3TNwQPm8KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftnC41kE2HXH/ydZQeUaiMYHl2IU0l3wDuXZf4Q6NiWj4UffAKhmsBFixcLh3201cEmNClnaRixvGonlQKfZ3QY6c/FFuvN7xMQz4B+3Pgfz5mEkNaz5dJ0cIesoH0IG1WCQHDxZF/+LgvSCJ6UzdEatZ6ohYL4sub1u8E/4WJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dZD6hhvT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dZD6hhvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7515C32786;
	Thu, 15 Aug 2024 14:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732657;
	bh=sNnBGYxrmPIPCTK8ssNdF3vZ6IpKOiWAq3TNwQPm8KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dZD6hhvToHcyZyQZClivTlwfEk4b9gacIk7otlqExCbiij8BwR2egPs48sAe+39MV
	 dXhUSlpVq8wW0r+kyTGktPOwkWz0mvtzbbMKVTsTjbPYKdT94oDVWqIWtZvFwiTjGx
	 F3EeYI5IO68PrngSlysSb1Mk8yc1GSyV2nZmLsNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Shigeru Yoshida <syoshida@redhat.com>,
	Hariprasad Kelam <hkelam@marvell.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 245/352] net: usb: sr9700: fix uninitialized variable use in sr_mdio_read
Date: Thu, 15 Aug 2024 15:25:11 +0200
Message-ID: <20240815131928.907751934@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -178,6 +178,7 @@ static int sr_mdio_read(struct net_devic
 	struct usbnet *dev = netdev_priv(netdev);
 	__le16 res;
 	int rc = 0;
+	int err;
 
 	if (phy_id) {
 		netdev_dbg(netdev, "Only internal phy supported\n");
@@ -188,11 +189,17 @@ static int sr_mdio_read(struct net_devic
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


