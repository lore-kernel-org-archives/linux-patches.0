Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36A07E767;
	Mon,  8 Apr 2024 13:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582366; cv=none; b=thrPlYZP0xRGLeyORuiF4P25lMFhsflO9tNd7v6pUKaHM9EpLDZgUXc7OjEkfqjse6m/ZWNNDUXvnieRt9/8y4RtSV0f93c3DW5eu/mZwyn8sHh6M/VFe2sX0HBw95LHmfVMHZGPJsipIQgcQAuFzZ6LDrL8EWtsi/bhzK+TMe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582366; c=relaxed/simple;
	bh=KAfbm5eVbd6gEdlmR8i75c3SGXg6MIzNKcPTNJr5978=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhJkR5Rz2fnGZpkXitFSo+sGyHZOVrPTUwvZvaOEHYpiOCC4Dvz5djOpNLg2ZEOyhNj0+Afwu8xVwlNXqDr4q8vhtd59DD2UG7LP3/wigRRuNCZyRSdKZfgxt6ZWkazPadQ/kJkQpBvaIPCoyaZxS+59wvRLOzeZWDQkUXO00CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iYk8PO47; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iYk8PO47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DED4C433F1;
	Mon,  8 Apr 2024 13:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582366;
	bh=KAfbm5eVbd6gEdlmR8i75c3SGXg6MIzNKcPTNJr5978=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iYk8PO47Z5UrrlosM5gcrbaT3vaDrishUDpkk/wLMxffPOS/wDfQEv5WnkgZNaSqU
	 w9SkAmftUgSrBklF0IF8RJ96Yat9CjNdEgYraVvxvvYEKxaCVKKiFmpJphvuqZhHx8
	 LDr2nJ1g9UGAitromOZOOYfxQpcD04TbDRWMKtPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 087/252] net: usb: ax88179_178a: avoid the interface always configured as random address
Date: Mon,  8 Apr 2024 14:56:26 +0200
Message-ID: <20240408125309.344497489@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

commit 2e91bb99b9d4f756e92e83c4453f894dda220f09 upstream.

After the commit d2689b6a86b9 ("net: usb: ax88179_178a: avoid two
consecutive device resets"), reset is not executed from bind operation and
mac address is not read from the device registers or the devicetree at that
moment. Since the check to configure if the assigned mac address is random
or not for the interface, happens after the bind operation from
usbnet_probe, the interface keeps configured as random address, although the
address is correctly read and set during open operation (the only reset
now).

In order to keep only one reset for the device and to avoid the interface
always configured as random address, after reset, configure correctly the
suitable field from the driver, if the mac address is read successfully from
the device registers or the devicetree. Take into account if a locally
administered address (random) was previously stored.

cc: stable@vger.kernel.org # 6.6+
Fixes: d2689b6a86b9 ("net: usb: ax88179_178a: avoid two consecutive device resets")
Reported-by: Dave Stevenson  <dave.stevenson@raspberrypi.com>
Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240403132158.344838-1-jtornosm@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ax88179_178a.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1273,6 +1273,8 @@ static void ax88179_get_mac_addr(struct
 
 	if (is_valid_ether_addr(mac)) {
 		eth_hw_addr_set(dev->net, mac);
+		if (!is_local_ether_addr(mac))
+			dev->net->addr_assign_type = NET_ADDR_PERM;
 	} else {
 		netdev_info(dev->net, "invalid MAC address, using random\n");
 		eth_hw_addr_random(dev->net);


