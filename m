Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5813AA516;
	Mon, 23 Mar 2026 14:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277753; cv=none; b=PgdRby5d6YoVlL1dSOTY1OF1jJxD3JriQaJwkAShYasXtJ90QsL7nzN2g7UK+uqULNe2MrLaCzdm+FudIyqp3v2m+SMUlQhxyXO356mmzPgR3Ql3pI7/DSI+qxJ0mv04oAYI8kk8QaFjxtbuSQrafG4uzL/6D+geQytsCWZjQ8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277753; c=relaxed/simple;
	bh=Zy3KMWEykR1TP2PPrn1RBPHhaORRbtMwkvnprVjUmmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NX0Kp6MtAVWIY965TL35LbZlK1bFYJlL9PkWujtyuoopPXR7WAA7fGheIKdqx7s5HNe5MLEVB46CHVGq12u1Xbg/PUUyyVYn7WkzkhDIktPwqZcAUfZFG+ZtwGJZBrPpQDSTc9Pp+gOHOi1dhv0GzDLFvRytobByW/STkLu21Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UdHs9k5G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UdHs9k5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531D4C4CEF7;
	Mon, 23 Mar 2026 14:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277753;
	bh=Zy3KMWEykR1TP2PPrn1RBPHhaORRbtMwkvnprVjUmmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UdHs9k5Gfl6uHpIJmL3Q/61bSS+bKsChasDsX2Pnke2gi4b6QtBMHsXY/xa4jCDP7
	 nhyHHe4m7uLc8jdM2lSh0f2bTN8E3xQQEMIqK7N98yl8ut3fWBUfFs9M7ColtBol2l
	 LPz7UgrVLjJwxjYWAmDi/hjEhhcL5t49mlEoZPIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 090/567] net: usb: kaweth: validate USB endpoints
Date: Mon, 23 Mar 2026 14:40:10 +0100
Message-ID: <20260323134536.058766821@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


