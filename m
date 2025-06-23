Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF4F4409;
	Mon, 23 Jun 2025 21:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714468; cv=none; b=A6zKk+F2qoiSQzj3G4PB8bl/tNCRH2WbpTXl+Elr862Mui7c/O7io+FTf3n9e+8JFKkAAv7kgtOiERshn2Qi+1tDanC8822NMDNpr8vOnM8azzCWnH4atJ40DF+CX/UJxzHU77IZNmpffY8ucUkhyIf3S76QBd6uY5s+2z0pQkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714468; c=relaxed/simple;
	bh=bvzbXHGq2oMva2bz5FPHxtaocweaqqaCnrwsL3mh+8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BmwObR8Qjh4LrGUBoY7AcFdaQGct7xuvyk2G/TgWPlJG0okVjkaxFjhKRpzqz98dTgQxFwmUGm+7nsMvdzlMl/qyQi1bpuSEFLXvKq/ple50Zab+slDcF+R1zfJ8bl8DiM6BstFpA3nf71eyVyUVaoG3KdKpoh40eheFHW4I/JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mzR2ui1R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzR2ui1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16D2C4CEEA;
	Mon, 23 Jun 2025 21:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714468;
	bh=bvzbXHGq2oMva2bz5FPHxtaocweaqqaCnrwsL3mh+8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mzR2ui1RTxbsyRZ/WBq5uibAy/U9XIM4nv3W5miNbZ9+JNc4nfGGAHnNJeYC7vI60
	 MQBaWPfoRTqqlojstjqmzvw1mlTtoSPqqGktlC1BpbsccL7EYC5Vq/99zqwsATo3X0
	 zl5144r3mqQdVmgH1O8rSV3Talp0WXjoqr8c75II=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+3361c2d6f78a3e0892f9@syzkaller.appspotmail.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 131/414] net: ch9200: fix uninitialised access during mii_nway_restart
Date: Mon, 23 Jun 2025 15:04:28 +0200
Message-ID: <20250623130645.330708494@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


