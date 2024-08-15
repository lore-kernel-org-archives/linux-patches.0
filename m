Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0B518D64F;
	Thu, 15 Aug 2024 13:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730247; cv=none; b=rNlNTsC5Hm1vPi17iccdydcEI3fK1HY/hF8hIP44H+f6bi708zyc7eZM8QNR/DFAxGRq1RA8bk+wAQAKjEeS2+8dMVC2IdX3Ue4mk8O+YrJ+i6QtHEVBrKGquWcivqUOlocu7Igr8AXx6hvWyw9EcHr+S+IeXJhAg/GZA3UFlc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730247; c=relaxed/simple;
	bh=nwHlLZPuZqxUvXOnS6oblc3veX/n+e+oInHWOz3QDAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jcAxXcNiFPMM28IYAdD/+eYlY9Nihgy85AQCQE9xtWfo+3OKBvWx95wMaz8Zx0b3eGPyqpXGv+LUgXXpTI0fmTZqVNyOodhurCZTo9xshoudlr3huRp01YplVoNmBa734SjeQWAp6J3wyM2bI98JR2sA84ju6shS52D1I9fWi+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KV2X3mF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KV2X3mF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DF1C32786;
	Thu, 15 Aug 2024 13:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730247;
	bh=nwHlLZPuZqxUvXOnS6oblc3veX/n+e+oInHWOz3QDAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KV2X3mF4YDnHy0Fb15asCmvKHo/QUMwpY4ffPgvwnXmAo+C2Xe25t8Yj4sT0m+x3m
	 iE/cqKer45jBHEuiXP8q714YivKJqb+iFijVSI7GlWaUTcDYR9dMdyXYQSlxdiYI7f
	 QeGxK2DxKPu6oMld1UfKHg9mkZtHd1roRynCXTOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Shigeru Yoshida <syoshida@redhat.com>,
	Hariprasad Kelam <hkelam@marvell.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 350/484] net: usb: sr9700: fix uninitialized variable use in sr_mdio_read
Date: Thu, 15 Aug 2024 15:23:28 +0200
Message-ID: <20240815131954.945656749@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


