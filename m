Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C670D2459D1;
	Mon, 13 Apr 2026 16:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097200; cv=none; b=a13SKsVzRFrTBibduz71QD72qNs1IIkn9cwcFGuKqIH/Mw4pT0+FwUvlWNBL6iE/EL5PhRFKmHI7nZoI0GzKa6GYIwhms9JSvWvPsTduqSFeUj9GY5+52QXePY8emiOnzxonT4kEj1FdEzrJpCrSVTXzGYqXE5TD84NzcWy5ui8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097200; c=relaxed/simple;
	bh=PYYI5E0U9g1ReYrKcVS3W96kPt7YIu0Sv80zqvdMW28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+GGe65d3TyImiUSDJi/ahoP2LU1sA6ieSum85IsT8NdG5Y5vjrFSPA3+ppz8YxBU0JWZ3vkFwTWRyn236U/kPG6G5LqWpb+CiP0E5S5PhrCIC5Bd3VXpEN4HdSxsWxFhcHS6n0PIITIcw+EYdB6ZjNrjUf6TWB8PUk56I03rvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ou7l08dT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ou7l08dT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0534BC2BCAF;
	Mon, 13 Apr 2026 16:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097200;
	bh=PYYI5E0U9g1ReYrKcVS3W96kPt7YIu0Sv80zqvdMW28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ou7l08dTl7uXSKyjwO2rKcI83D8XrAYkOy2suIM7obhBJvJAL1NcwFsQYav9Evu9u
	 cMJD42mcKQOYDZahwqnSWsja+XAkvaSkvemUWW+5tpVwHfqPMNLtOl44CQovI5TfLb
	 kVgvj26FZrKIE9TfxNgGSOQkmdlXHkphylbI1aR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 044/570] net: usb: kaweth: validate USB endpoints
Date: Mon, 13 Apr 2026 17:52:55 +0200
Message-ID: <20260413155832.079006484@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


