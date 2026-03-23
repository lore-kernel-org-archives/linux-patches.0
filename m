Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9F0284881;
	Mon, 23 Mar 2026 16:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282211; cv=none; b=Z5NHjcsqQWLMhf/Z9Ix+q+I7xkYo36o2UApdQSYKy7slR4SbIQcYCjSkyazbBmfH6kmQB7EeOKexXRQ9SDEwC28njX9bm8LDFIMjyEYaJbgPAXFL+3HMQXr5fo/Lv9evgLpBXeBWqsNoRW/QEsi4dbFgzJKpmENnfOA0Nz5TLfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282211; c=relaxed/simple;
	bh=EOGRllbt3+BVLHoG5Tapza5bIBZqNiKi8p1AwAY0PFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMs/2FxlTIw/9dJG7er5X7A3XvoPh1LyTNqOuBsBg1VhFmTHCVhXYF74KJoUQz/OZ37WQmUsRn4Fu2+7+x8deIriRYlkgnaX5fxTt6PzVuydkqMY7aw1NKXjnsAzWK5oC/hroOW1yt5Qp7SOZSKt3NMq985pqyOozFRk0el07mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RoMMpUfn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RoMMpUfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F29C4CEF7;
	Mon, 23 Mar 2026 16:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282211;
	bh=EOGRllbt3+BVLHoG5Tapza5bIBZqNiKi8p1AwAY0PFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RoMMpUfn02iWo+Qvud7vdCbCbuWQFen9Uw7OVunHC5FhdPX9uE/aHTQ3ap3259w/p
	 vuLn3xcUaZAILbu+H45Y/GOr10yXDhzurh99aeA93ZacxOEt0uKORRjUkCud/JD7um
	 osPU+H/xYVpeB9SQylTCoNeX1MWOqGT85+KV0cVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 072/481] net: usb: kaweth: validate USB endpoints
Date: Mon, 23 Mar 2026 14:40:54 +0100
Message-ID: <20260323134526.991838834@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 4b063c002ca759d1b299988ee23f564c9609c875 upstream.

The kaweth driver should validate that the device it is probing has the
proper number and types of USB endpoints it is expecting before it binds
to it.  If a malicious device were to not have the same urbs the driver
will crash later on when it blindly accesses these endpoints.

Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://patch.msgid.link/2026022305-substance-virtual-c728@gregkh
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/kaweth.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/net/usb/kaweth.c
+++ b/drivers/net/usb/kaweth.c
@@ -883,6 +883,13 @@ static int kaweth_probe(
 	const eth_addr_t bcast_addr = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 	int result = 0;
 	int rv = -EIO;
+	static const u8 bulk_ep_addr[] = {
+		1 | USB_DIR_IN,
+		2 | USB_DIR_OUT,
+		0};
+	static const u8 int_ep_addr[] = {
+		3 | USB_DIR_IN,
+		0};
 
 	dev_dbg(dev,
 		"Kawasaki Device Probe (Device number:%d): 0x%4.4x:0x%4.4x:0x%4.4x\n",
@@ -896,6 +903,12 @@ static int kaweth_probe(
 		(int)udev->descriptor.bLength,
 		(int)udev->descriptor.bDescriptorType);
 
+	if (!usb_check_bulk_endpoints(intf, bulk_ep_addr) ||
+	    !usb_check_int_endpoints(intf, int_ep_addr)) {
+		dev_err(dev, "couldn't find required endpoints\n");
+		return -ENODEV;
+	}
+
 	netdev = alloc_etherdev(sizeof(*kaweth));
 	if (!netdev)
 		return -ENOMEM;


