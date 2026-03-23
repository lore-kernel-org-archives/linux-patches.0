Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADA0387599;
	Mon, 23 Mar 2026 14:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277760; cv=none; b=m1wt9HIQzfYuDMkIwXtFSFiZHRIGtvcf/T9kgHEzMtKRYaJX5a/QlqlXXQ6KUP6Tm4yN5+z29bYGPkrufwXPkmMk37SD0SZWw6yHk0ExD9f0TEAMKbeNFmYhORvlmEeppVDuMGcBN3MDNDTlVUIDMB6hy8QlS1JQQ2wgUXNKiSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277760; c=relaxed/simple;
	bh=a5wEfF6mWhQ0cHUX9/dQicXYjCjccfXuDLGXGevCuDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTbFMKh+lqvIBuKh+anqhn6wUeyvr2aT7NMpIYZ/AcvhTjCRwtTtIL7Coea7JTKfhywG7amAPKEg+7ocFgr3EABSEMy0wCB0k24zUDx5cUgcRKO73t6HibfTzzCqugWvcXunIzdndXMYlhaTDcmFd3VeUtXzZ2IiseSYldviwFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oMsMP6vv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oMsMP6vv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9BDC4CEF7;
	Mon, 23 Mar 2026 14:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277759;
	bh=a5wEfF6mWhQ0cHUX9/dQicXYjCjccfXuDLGXGevCuDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oMsMP6vvblS9xP/yoeECw9Pde6NmUX4Lz3MBp/mdskd1CyPwTSqGqM3KrOm5eOeC5
	 DIc+azXurWwvOZgnrujD2nz0fC1eqhS1j0DJ0QQgb/JByyfhQWNKgrwf+Qcrf+H+1F
	 U9kAIFYcoVYyuLwOq3htRI+9vxG3auFmfSVc4LAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petko Manolov <petkan@nucleusys.com>,
	stable <stable@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 092/567] net: usb: pegasus: validate USB endpoints
Date: Mon, 23 Mar 2026 14:40:12 +0100
Message-ID: <20260323134536.105874210@linuxfoundation.org>
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

commit 11de1d3ae5565ed22ef1f89d73d8f2d00322c699 upstream.

The pegasus driver should validate that the device it is probing has the
proper number and types of USB endpoints it is expecting before it binds
to it.  If a malicious device were to not have the same urbs the driver
will crash later on when it blindly accesses these endpoints.

Cc: Petko Manolov <petkan@nucleusys.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026022347-legibly-attest-cc5c@gregkh
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/pegasus.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -815,8 +815,19 @@ static void unlink_all_urbs(pegasus_t *p
 
 static int alloc_urbs(pegasus_t *pegasus)
 {
+	static const u8 bulk_ep_addr[] = {
+		1 | USB_DIR_IN,
+		2 | USB_DIR_OUT,
+		0};
+	static const u8 int_ep_addr[] = {
+		3 | USB_DIR_IN,
+		0};
 	int res = -ENOMEM;
 
+	if (!usb_check_bulk_endpoints(pegasus->intf, bulk_ep_addr) ||
+	    !usb_check_int_endpoints(pegasus->intf, int_ep_addr))
+		return -ENODEV;
+
 	pegasus->rx_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!pegasus->rx_urb) {
 		return res;
@@ -1171,6 +1182,7 @@ static int pegasus_probe(struct usb_inte
 
 	pegasus = netdev_priv(net);
 	pegasus->dev_index = dev_index;
+	pegasus->intf = intf;
 
 	res = alloc_urbs(pegasus);
 	if (res < 0) {
@@ -1182,7 +1194,6 @@ static int pegasus_probe(struct usb_inte
 
 	INIT_DELAYED_WORK(&pegasus->carrier_check, check_carrier);
 
-	pegasus->intf = intf;
 	pegasus->usb = dev;
 	pegasus->net = net;
 


