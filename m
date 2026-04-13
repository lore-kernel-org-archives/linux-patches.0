Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8991D5AD4;
	Mon, 13 Apr 2026 16:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098614; cv=none; b=LBRg3VeJfSv/ZPZf0VK3P/ABkzM1l7TYNIxGOMSyLUrev2pYLv+QoRXB7tmcUUHIT1Upvt69wbd1hvnuYioWB6DTe7hIwh+6mP6hZ0M+5tkNJYZdfVWEyrG3zZfdJL6cM+cR3GGMwaRcKkOJxW3hKlQL/RFg7oYnFPU1THnlaGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098614; c=relaxed/simple;
	bh=FesK3RbHO9+L8zaWbXgv2dSutMrrElizw+gQrvN/uFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EaM4A3plYk4SC7pDC5yeqicmFehqThe2jEKy5S7ivS0wtxPiO/GgaV4XJ1tjnk3TdEypRijkfWdbYiBe+qjcxry5Ksl3abQ1pMHwjn4g55XaR+atvXv85FLXl94/cy0TmI3DyrYRweg7bWxWr5DbH2nIL6Ai1AxvD4bLsK2o9jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rg1/Fn6S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rg1/Fn6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC870C2BCAF;
	Mon, 13 Apr 2026 16:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098614;
	bh=FesK3RbHO9+L8zaWbXgv2dSutMrrElizw+gQrvN/uFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rg1/Fn6STVC0FaZvk7SiXxUz8NaOu7kgz0sHfpB4/jPRZw3x0WOiqHEuVtF8pSjI9
	 F/PtBk9pFoaWleJGyy/4qB2n5GBkcNJbzGMMK68SoL3ilg1WDcCWVokQxhb2Bt4Mfe
	 rLLUL0Mr+dUDN6FJU531BQIavd7ZImcCobvrnSEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 021/491] net: usb: kaweth: validate USB endpoints
Date: Mon, 13 Apr 2026 17:54:26 +0200
Message-ID: <20260413155819.847444627@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


