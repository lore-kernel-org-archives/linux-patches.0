Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74BB350D44;
	Tue, 26 Aug 2025 14:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217242; cv=none; b=VB9wCMswBo3aux8AYbmNHiRzjhPnON+7dWzn7JToNU3KnxfsIxdCxhLEMpHGlfZyvoeBu9qc23b8fryKVM3Dd17nLJFlnxq9i2Zoxeq9d5AbGNxc2r9SB1ujFWUg/a1cU4zXNpKoHW5aSGsrvRu4KNcyuqZNXa4wJZaiv+TALOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217242; c=relaxed/simple;
	bh=vmqw3atvq1qxEMI/G1qsaF7kUlKA6vJBgmu/mnlqCQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQdjq4ewkX2NqbGFtuTiBFoSxcY/OUkKIgRicnylQEyvlLcKH+PAOapKFOmymdKG5Cfr/VEFM8YI28zZRJD5EXb9hk88wcNmLu5hUG8MxSv/zDnhTQZNODoye8OQQVC7V/+8A3MEumyUP0gyi5B5nQ0rhEL3bmVybjYAn2mjZys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXdEAoPv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXdEAoPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097E2C113CF;
	Tue, 26 Aug 2025 14:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217242;
	bh=vmqw3atvq1qxEMI/G1qsaF7kUlKA6vJBgmu/mnlqCQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXdEAoPvR8S/zJY297aWTtJ7u5uZijdg3+5YgX1L/gjxrSWKtkXNBz2aQqZL2UKXj
	 N1RR/RPoKi3CAOW7zHYGjHzud5V2In6xweTlHtdIxB9VhXQxWtia2Q9fc7o5sk/A94
	 Ik+xYpo9BqGIlIufyDs4xtvy3wRFBqxV32r8ljKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3f89ec3d1d0842e95d50@syzkaller.appspotmail.com,
	Oliver Neukum <oneukum@suse.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/523] usb: net: sierra: check for no status endpoint
Date: Tue, 26 Aug 2025 13:04:08 +0200
Message-ID: <20250826110925.538084012@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 777f672f288cb..cfc519bc45451 100644
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



