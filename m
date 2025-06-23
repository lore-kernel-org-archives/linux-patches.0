Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13B4248895;
	Mon, 23 Jun 2025 13:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685916; cv=none; b=geHsVfeLlsCKcucVdxRccRQBXjF/ZgFX3myfDfj3cAVrWQRsEhbp8Z8RC+/+3Zjb1Xl7mKE5sdpHd7uHg6pAIk2WGtvJeDm+y8tFkpKTRrcPjU/dfTAIBi85ut7BslFWJltYSTKS5Oz1CS4JKcSUY4VsF1Uav2+S0iWtmaxx6sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685916; c=relaxed/simple;
	bh=wAqnc522x1zY6TelZkBV6ikwBDQJiKQZcxZlA7On+fU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhT8YACN+5D4uTgWVN7mVINz7iFtv19udfNJNQIJBPb+c9HDkKjDKagRme6Ef69iDcMlDGiUPGB9v/1ao+50ebcQ8PddbV4PhrxmCTSq/99B+0yxbZQOcVIzUotOolNtSiyuOjpVU44EzDYEGniT1o4NOiFXRFT+r+3b2Qnl6f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVJYbaIp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVJYbaIp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74283C4CEEA;
	Mon, 23 Jun 2025 13:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685915;
	bh=wAqnc522x1zY6TelZkBV6ikwBDQJiKQZcxZlA7On+fU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVJYbaIp7oM5pJTqkl+tx70SNBW3vpysBFshfZj54uUWzMjMMT5AyCL48Ct8Lew4k
	 Ov4gnyXW8KrQgUIR7FQ4tX95FjlrolW4AVfufm5I2P2r661JiL648Qv3Gr4rP/tb+2
	 5d9pgT3a6rwUloKvBkTnxIE8t1oJCHfdG/aJcxkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+3361c2d6f78a3e0892f9@syzkaller.appspotmail.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 127/222] net: ch9200: fix uninitialised access during mii_nway_restart
Date: Mon, 23 Jun 2025 15:07:42 +0200
Message-ID: <20250623130615.917827561@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qasim Ijaz <qasdev00@gmail.com>

commit 9ad0452c0277b816a435433cca601304cfac7c21 upstream.

In mii_nway_restart() the code attempts to call
mii->mdio_read which is ch9200_mdio_read(). ch9200_mdio_read()
utilises a local buffer called "buff", which is initialised
with control_read(). However "buff" is conditionally
initialised inside control_read():

        if (err == size) {
                memcpy(data, buf, size);
        }

If the condition of "err == size" is not met, then
"buff" remains uninitialised. Once this happens the
uninitialised "buff" is accessed and returned during
ch9200_mdio_read():

        return (buff[0] | buff[1] << 8);

The problem stems from the fact that ch9200_mdio_read()
ignores the return value of control_read(), leading to
uinit-access of "buff".

To fix this we should check the return value of
control_read() and return early on error.

Reported-by: syzbot <syzbot+3361c2d6f78a3e0892f9@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=3361c2d6f78a3e0892f9
Tested-by: syzbot <syzbot+3361c2d6f78a3e0892f9@syzkaller.appspotmail.com>
Fixes: 4a476bd6d1d9 ("usbnet: New driver for QinHeng CH9200 devices")
Cc: stable@vger.kernel.org
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Link: https://patch.msgid.link/20250526183607.66527-1-qasdev00@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ch9200.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/usb/ch9200.c
+++ b/drivers/net/usb/ch9200.c
@@ -180,6 +180,7 @@ static int ch9200_mdio_read(struct net_d
 {
 	struct usbnet *dev = netdev_priv(netdev);
 	unsigned char buff[2];
+	int ret;
 
 	netdev_dbg(netdev, "ch9200_mdio_read phy_id:%02x loc:%02x\n",
 		   phy_id, loc);
@@ -187,8 +188,10 @@ static int ch9200_mdio_read(struct net_d
 	if (phy_id != 0)
 		return -ENODEV;
 
-	control_read(dev, REQUEST_READ, 0, loc * 2, buff, 0x02,
-		     CONTROL_TIMEOUT_MS);
+	ret = control_read(dev, REQUEST_READ, 0, loc * 2, buff, 0x02,
+			   CONTROL_TIMEOUT_MS);
+	if (ret < 0)
+		return ret;
 
 	return (buff[0] | buff[1] << 8);
 }


