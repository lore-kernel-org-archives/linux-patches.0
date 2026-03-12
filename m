Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336E737701D;
	Thu, 12 Mar 2026 20:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346817; cv=none; b=FRC0OujGMLQlyCRlhLWzvn1Dw4mnFI3m0uDpNxn5LNqGA8wAF+sJd3P24uX4kgxDaTdyXCgnI25ONRYzMlc2gsVBP5MMrCUuvmrnv0Uw3nGnPMOFOvMCxKU1HAcp8DHaLm1mVxxt1MVjup/oxQzeSSkuwuSERM3pMzDRB5hxXA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346817; c=relaxed/simple;
	bh=08LvNkjvfWQvGttrlEhV59cx9MtrNnqvgMI0nKSByWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjyzFaPY45enGVWiNf4epiurDcT+myLtXdx6h/PoNrftdoEQZP3Y7Jei5cYt9MIDreww0k1RFVWHW/C7oc3xBBAsLyuaxPgYlwHwKPLbmMjB1J9znRKaxf4+FoKi0szcsTKhz6aj3ikbM1UhxbaAa3uw1A4E8UcOkQCe9D+1GT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5/uzCwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5/uzCwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD66EC2BC86;
	Thu, 12 Mar 2026 20:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346817;
	bh=08LvNkjvfWQvGttrlEhV59cx9MtrNnqvgMI0nKSByWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P5/uzCwJL3wWFXqcDBHj2yo1s8vLq8UyiiqJPrX2NPoRAcjxXYOuFTOrA4A5YTzcP
	 tiQaE8B2CMBkLV7HhOcgYoKGKZokVg0vIA5uRxqqpezosCrly6MNK++2UN0PUeWJ5N
	 LkeMUBHiyRo9VCXDA3g9R87j2iywtd+JTcVNYN9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petko Manolov <petkan@nucleusys.com>,
	stable <stable@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 132/265] net: usb: pegasus: validate USB endpoints
Date: Thu, 12 Mar 2026 21:08:39 +0100
Message-ID: <20260312201023.018708835@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


