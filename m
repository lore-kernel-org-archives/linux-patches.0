Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41D530E84D;
	Mon, 23 Jun 2025 13:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684723; cv=none; b=IS9X5gZoC8bAYoht4TTiTS0bUYgbe9fsWC5DNiNnWwle5SVitdJKRUPZF3KKyU+xMaCq5OYQf75hqHEDZt6n7x0j+raXiF6o9//Ghuy03WYzUqwELbsJpvEHKOYBGIF9w6JqFX5G9gIOUhEepd5eKlUnFoYVJ9o9M02oajuR6Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684723; c=relaxed/simple;
	bh=ZQx3bjtQ7oE+adnlT8/Sg7LGYIbxYpcFHa2W1tnIQ1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nsu5XBSd7o+gWTinDmdpt9g3TuSyT0yfaoc5sVfMIOjUZBwVTL12Kn6raYlWl3PMoNgxl1f574KqLta2fAyRtiGA5lUrCUu8Y/W3WSC63p8rWIjGMDiJpv79/WicS7hzFl8+vFLFVtmBpBQ198ar7K41f+HtEZGzVaBB2a9g/1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M5Fq9R39; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M5Fq9R39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD1FC4CEEA;
	Mon, 23 Jun 2025 13:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684722;
	bh=ZQx3bjtQ7oE+adnlT8/Sg7LGYIbxYpcFHa2W1tnIQ1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M5Fq9R39pyv/yZkYNoDhNNyKI1xNv7na2OaRh8/+Z7lTnfbSsEeZgiHtxetoljbGM
	 0EGHz1NljZ9WOCSuk4Hrj8Kaa2k35D5chtpa/y2gQXeOk3ivdIdYGbiuHJFVc8lTVp
	 ftRkqBNiUVA4V7jD+6t+CDgYreyrD0IvZpRj2TEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+3361c2d6f78a3e0892f9@syzkaller.appspotmail.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.15 160/592] net: ch9200: fix uninitialised access during mii_nway_restart
Date: Mon, 23 Jun 2025 15:01:58 +0200
Message-ID: <20250623130704.083168988@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -178,6 +178,7 @@ static int ch9200_mdio_read(struct net_d
 {
 	struct usbnet *dev = netdev_priv(netdev);
 	unsigned char buff[2];
+	int ret;
 
 	netdev_dbg(netdev, "%s phy_id:%02x loc:%02x\n",
 		   __func__, phy_id, loc);
@@ -185,8 +186,10 @@ static int ch9200_mdio_read(struct net_d
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


