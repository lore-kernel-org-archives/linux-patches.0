Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263161EABD7;
	Wed,  6 Nov 2024 12:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896679; cv=none; b=bfS5lo9DCyKmgvtHV230paoWXJN7gsH0KhXBNwAFTM5I2MoDk5fPCphQkKSiBs87RW9xzKnzoGDxGBbK4vRz6nouBGbt8ECxHOxtEZS/AsoBcVHnlNvZwtqiM4Mzld6ObHCVDJZj1RbSXDx5D1XZvZPIq8i8kT+Lvrqab41wS94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896679; c=relaxed/simple;
	bh=OlrhO+/4P7tvPKRkZZ5qnBT9SGYSvlSUCiuUYU1/FbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CehEaWi5l1OMHkiLvNJV+R4ppX5g7kunGhs7VKH1GfeLvAYXPCxdEdxvByi3u3GN4peaZebzDNIq2s9biCbHVIqy7YRcVrbKuH8+qXPxtEiwB1c/msQXDpZjYqZCu7Ef1zEmjWj+C/og+MrprEvq1FlHPYTOEsinfAJzid8S65c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9LcDv8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9LcDv8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2CBC4CED6;
	Wed,  6 Nov 2024 12:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896678;
	bh=OlrhO+/4P7tvPKRkZZ5qnBT9SGYSvlSUCiuUYU1/FbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A9LcDv8Jlo9Pris8wyLs50sIa9YvJHZQSs446F1HAdOc5Ta+XfnjG/zU2h1lkyf/5
	 s7o5phRNunzgwuRk0yfbte4HeAVoraAdn7UBOzD1m4yUQizvoQKe24rdqrmi4PYTLV
	 fPTheEJTSs1Kt6MJzapKKvldD9qtxSl5zYkBk8rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Greg Thelen <gthelen@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	John Sperbeck <jsperbeck@google.com>
Subject: [PATCH 5.10 037/110] net: usb: usbnet: fix name regression
Date: Wed,  6 Nov 2024 13:04:03 +0100
Message-ID: <20241106120304.219631092@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 8a7d12d674ac6f2147c18f36d1e15f1a48060edf ]

The fix for MAC addresses broke detection of the naming convention
because it gave network devices no random MAC before bind()
was called. This means that the check for the local assignment bit
was always negative as the address was zeroed from allocation,
instead of from overwriting the MAC with a unique hardware address.

The correct check for whether bind() has altered the MAC is
done with is_zero_ether_addr

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-by: Greg Thelen <gthelen@google.com>
Diagnosed-by: John Sperbeck <jsperbeck@google.com>
Fixes: bab8eb0dd4cb9 ("usbnet: modern method to get random MAC")
Link: https://patch.msgid.link/20241017071849.389636-1-oneukum@suse.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/usbnet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 669cd20cfe00a..b3d363ebea26e 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1717,7 +1717,8 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 		// can rename the link if it knows better.
 		if ((dev->driver_info->flags & FLAG_ETHER) != 0 &&
 		    ((dev->driver_info->flags & FLAG_POINTTOPOINT) == 0 ||
-		     (net->dev_addr [0] & 0x02) == 0))
+		     /* somebody touched it*/
+		     !is_zero_ether_addr(net->dev_addr)))
 			strscpy(net->name, "eth%d", sizeof(net->name));
 		/* WLAN devices should always be named "wlan%d" */
 		if ((dev->driver_info->flags & FLAG_WLAN) != 0)
-- 
2.43.0



