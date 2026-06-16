Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A803A5E91;
	Tue, 16 Jun 2026 17:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631759; cv=none; b=M/m1LrGkC6g6msL5d3XL4AqO/AAkuDbyAl49ieh/haUq+7Vm/SnF56ML4Dv62xRj1/yIvD+dXm+YIJUsKhhYFqyU/AHj9uSUn3qM24FvZJBesEocBpE/t+YvqV7Shg+qJ0Ac3bgWjfGIzRSMX26cnrmp9bA3JmedZSOHvvRSE74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631759; c=relaxed/simple;
	bh=+PN8f3NK+Zs8Wh+psyDla8qoBl4COEJwMzue7T80+OE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KzxM981ohokdK2hDkCRHXs2/0lPGhZBNp/aL/ckvByrUbkh6KGtB0ou6mZp51S2ll4eIOVZ82SR6Ln5dXorVKzSd1bqlDXRhbuZLu2ILT1SCJ9HjCol9NGMdoxpPN5UCLVJm91LLqPI2Oq1uHUetRqfB232tCy96VlEOGTtVC94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Li8rMHd8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Li8rMHd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0771F000E9;
	Tue, 16 Jun 2026 17:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631757;
	bh=Ug8SFWMTa1Qe5V+Oyiq7bkt075lDxYR8ZEZckdsD2vY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Li8rMHd8xXuReZxcfj8nlLOK/Yg9pG9MdEGCUy0K3wi7uZRJynDEKfPstL8smjujE
	 ab5/exDCOWA8IJBP30Dhsu9Ol9LpWY30fdampv3h75VV8e8CmrkOF9zr4gdE1yk5dN
	 glYPpnGF1RybxiyxZpI/OCxJ0/xNuaLzC7HlAlmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih Kai Hsu <hsu.chih.kai@realtek.com>,
	Hayes Wang <hayeswang@realtek.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 250/522] r8152: handle the return value of usb_reset_device()
Date: Tue, 16 Jun 2026 20:26:37 +0530
Message-ID: <20260616145137.668348265@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Chih Kai Hsu <hsu.chih.kai@realtek.com>

[ Upstream commit 19440600e729d4f74a42591a872099cf25c7d28a ]

If usb_reset_device() returns a negative error code, stop the
process of probing.

Fixes: 10c3271712f5 ("r8152: disable the ECM mode")
Signed-off-by: Chih Kai Hsu <hsu.chih.kai@realtek.com>
Reviewed-by: Hayes Wang <hayeswang@realtek.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260604092247.27158-450-nic_swsd@realtek.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index e8a69d3d418379..c0f7a15e406fee 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9754,7 +9754,12 @@ static int rtl8152_probe_once(struct usb_interface *intf,
 	struct net_device *netdev;
 	int ret;
 
-	usb_reset_device(udev);
+	ret = usb_reset_device(udev);
+	if (ret < 0) {
+		dev_err(&intf->dev, "USB reset failed, errno=%d\n", ret);
+		return ret;
+	}
+
 	netdev = alloc_etherdev(sizeof(struct r8152));
 	if (!netdev) {
 		dev_err(&intf->dev, "Out of memory\n");
-- 
2.53.0



