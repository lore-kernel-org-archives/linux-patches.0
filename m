Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1FB1102
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 10:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZvnqnsQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2DBC433C8;
	Mon, 23 Oct 2023 10:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698058741;
	bh=+0vuXxj/fJqSyEhPDchtLurCamAw/9vi644oMSKh2KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZvnqnsQDb4oSybwUCzB1SxDkqiCzw/v5sW7UudBN+PXccBcJyLyv9kcZIIMsjHjn
	 OALuPRGewv6oCu6PnatCZ0qhgQRbrR5qRZwtIGlefe8xAaQJNuOs059czTsbyM4iAF
	 GdvlPWR75OZLqanUgEGoknhnqnhfQAGrEi5bhq3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Peter Korsgaard <peter@korsgaard.com>,
	Jakub Kicinski <kuba@kernel.org>,
	syzbot+1f53a30781af65d2c955@syzkaller.appspotmail.com
Subject: [PATCH 4.14 11/66] net: usb: dm9601: fix uninitialized variable use in dm9601_mdio_read
Date: Mon, 23 Oct 2023 12:56:01 +0200
Message-ID: <20231023104811.204416919@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104810.781270702@linuxfoundation.org>
References: <20231023104810.781270702@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 8f8abb863fa5a4cc18955c6a0e17af0ded3e4a76 upstream.

syzbot has found an uninit-value bug triggered by the dm9601 driver [1].

This error happens because the variable res is not updated if the call
to dm_read_shared_word returns an error. In this particular case -EPROTO
was returned and res stayed uninitialized.

This can be avoided by checking the return value of dm_read_shared_word
and propagating the error if the read operation failed.

[1] https://syzkaller.appspot.com/bug?extid=1f53a30781af65d2c955

Cc: stable@vger.kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reported-and-tested-by: syzbot+1f53a30781af65d2c955@syzkaller.appspotmail.com
Acked-by: Peter Korsgaard <peter@korsgaard.com>
Fixes: d0374f4f9c35cdfbee0 ("USB: Davicom DM9601 usbnet driver")
Link: https://lore.kernel.org/r/20231009-topic-dm9601_uninit_mdio_read-v2-1-f2fe39739b6c@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/dm9601.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/usb/dm9601.c
+++ b/drivers/net/usb/dm9601.c
@@ -221,13 +221,18 @@ static int dm9601_mdio_read(struct net_d
 	struct usbnet *dev = netdev_priv(netdev);
 
 	__le16 res;
+	int err;
 
 	if (phy_id) {
 		netdev_dbg(dev->net, "Only internal phy supported\n");
 		return 0;
 	}
 
-	dm_read_shared_word(dev, 1, loc, &res);
+	err = dm_read_shared_word(dev, 1, loc, &res);
+	if (err < 0) {
+		netdev_err(dev->net, "MDIO read error: %d\n", err);
+		return err;
+	}
 
 	netdev_dbg(dev->net,
 		   "dm9601_mdio_read() phy_id=0x%02x, loc=0x%02x, returns=0x%04x\n",


