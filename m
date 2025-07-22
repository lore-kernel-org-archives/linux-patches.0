Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8920A2EA726;
	Tue, 22 Jul 2025 14:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193560; cv=none; b=M839NC8Gsu8Doi8/2F6+qIjaIZbpppfFK52DU9gIpI86V5gRG9bmtu8gYdQ7gXQRoJy0U8U+XWUMHXUe7QYbVxUFt80VL7KOAbFcNKeCZivmhJaZazYTKQTCeNJYC9IOT3pF/FCdpJW0orhtsWQ0kd9MgWyspkznDH+mW8SFP+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193560; c=relaxed/simple;
	bh=ZFZ+UI1//as8vwtvvy5Cg33TX7Z5oj6ZKM67lXyYa2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3YxTsZ+5ixAi18VwKyWiro2GBK/w8maMh6l2o9sIcYrQC9TR7gis6ZBjeINMPH/HC2uOD64WDakzTJ28/3GMKN11gWug66KZqW6/pprdcRjB3J/ZXCSyWP0ZjBqgGdLUhTHTKbLW1P/6J5qwEKWIv/fLdUb6U6Zsk4oxW/zq9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xj4a3NmP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xj4a3NmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937D9C4CEEB;
	Tue, 22 Jul 2025 14:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193560;
	bh=ZFZ+UI1//as8vwtvvy5Cg33TX7Z5oj6ZKM67lXyYa2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xj4a3NmPSoe9egX5BAXz07ZRAlwQFBk74KnRr8qysU4hxraf321JJPIyj77Xm8lcT
	 Nv3h8uMSiD1zjaCtRcSokhvaviJ6ndcf+IcTN9Wr6x4dABikvx11qi0N0A5xM9UWmN
	 LYqicCGZnTbTK9xTaUdOXuRyhMOaeNy4kC6fNUnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3f89ec3d1d0842e95d50@syzkaller.appspotmail.com,
	Oliver Neukum <oneukum@suse.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 129/187] usb: net: sierra: check for no status endpoint
Date: Tue, 22 Jul 2025 15:44:59 +0200
Message-ID: <20250722134350.549539563@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 4c4ca3c46167518f8534ed70f6e3b4bf86c4d158 ]

The driver checks for having three endpoints and
having bulk in and out endpoints, but not that
the third endpoint is interrupt input.
Rectify the omission.

Reported-by: syzbot+3f89ec3d1d0842e95d50@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-usb/686d5a9f.050a0220.1ffab7.0017.GAE@google.com/
Tested-by: syzbot+3f89ec3d1d0842e95d50@syzkaller.appspotmail.com
Fixes: eb4fd8cd355c8 ("net/usb: add sierra_net.c driver")
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://patch.msgid.link/20250714111326.258378-1-oneukum@suse.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/sierra_net.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/usb/sierra_net.c b/drivers/net/usb/sierra_net.c
index dec6e82eb0e03..fc9e560e197d4 100644
--- a/drivers/net/usb/sierra_net.c
+++ b/drivers/net/usb/sierra_net.c
@@ -689,6 +689,10 @@ static int sierra_net_bind(struct usbnet *dev, struct usb_interface *intf)
 			status);
 		return -ENODEV;
 	}
+	if (!dev->status) {
+		dev_err(&dev->udev->dev, "No status endpoint found");
+		return -ENODEV;
+	}
 	/* Initialize sierra private data */
 	priv = kzalloc(sizeof *priv, GFP_KERNEL);
 	if (!priv)
-- 
2.39.5



