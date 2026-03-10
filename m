Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7462BF3E2;
	Tue, 10 Mar 2026 11:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141103; cv=none; b=fBbwnjDddBDjBdJU75oGcX6Uqore704IYb0FK5FBAZM0aWHx10HHU1h+ju6+xxhLP4VrRKfyvZLz+lFxmaknRbsyl7qUE0ufBUV72uhhhDM2vsoyA8gcIA7nF7Tds5W6ANVzOwunZEDyF146WCjrfosj3+89i3FxapFI6ENI+Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141103; c=relaxed/simple;
	bh=6IzGLxcD3kElEoQdIDmhCLhOGIZYm7ewgLdVOoob7vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLuYTDtXzzU4wW1aXqaGv02XAKF/GdFXMzCODSOablWkk3OFA0aRy/oQZZ8TLmmy1ul/wt5lLUT1CLjsTtBxhKjsQvb/ZMnfKiAkf2rZWNjA/f+Nt1DUbb6DqUkhotk5d1iXIkg5gHV/ofGH/eDnEHDODuj1O8b62srr3NGs5vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kojDbX+g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kojDbX+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400AAC2BC9E;
	Tue, 10 Mar 2026 11:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141102;
	bh=6IzGLxcD3kElEoQdIDmhCLhOGIZYm7ewgLdVOoob7vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kojDbX+gPQQOjgT7F+S49B/2G8+g5zAsRBYUFncBtzKxSCoCTXrlBws5xtZ8F4ZtB
	 6dE57YdVwuqe6N3mJhJm1HukKF0VYZPLRHBCVVoAngXvDfvsXJRYr3jXpoe2nNYe5s
	 BO1hFEuMZYRg2Y63NGXRdFqjOXC8pko2pud9BN9fyavxqy62J/sffmR0thHaNp+c1V
	 gFY3MruXFFgN9wR/zqtDLIJg9Qp5dMwa3ScGyF5xVawY3980JO9oMfjQIncwjMEzFC
	 +fYajJxUajY4wMqgasUxkBOWpFkuQnyGFttI2+8xb2GGyYuC8ROBHa56pe5msr+xeC
	 6wj8RMcdvXkPw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable <stable@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.19 104/311] net: usb: kaweth: validate USB endpoints
Date: Tue, 10 Mar 2026 07:02:31 -0400
Message-ID: <0c7930573f20ee8e1b28f207ada7baebb9572d4f.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
 drivers/net/usb/kaweth.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/usb/kaweth.c b/drivers/net/usb/kaweth.c
index e01d14f6c3667..cb2472b59e104 100644
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
-- 
2.51.0

