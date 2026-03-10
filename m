Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BC12BF3E2;
	Tue, 10 Mar 2026 11:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141105; cv=none; b=OEyS1dsIflgv0Ic+TXRDU4wZWt6X2wEmBhYxyAQUkJKn7ZYHljkCxe78O6sWOyiPIIio3zMRtj5iRQN9ehUlO49v0KunzBAMwGoZm2GvIybxUYLndlqvxQ5Ly0w6kjfrWe1tDBrFOzAocKXlG4jIIycnkMswRf0OcEvXGnHhRD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141105; c=relaxed/simple;
	bh=jt85BVncvHIdkZiZ2NEjZThQNdp77XXPatolFkMZ2rM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFkvh/tpvWdRc5COfwVH63SI2Wp9bF9RhNsaSdp6nj5ZcwqJu8pmHptNM0BFkJTs6AZ2Fv2Yni5fG92GlzRJh/0C5nsN6KuCDoIH4VqCKSPdor6WxzTtQq+duWkPVl4GTPgvfI64B4QHuhzENb49FpC8mb8UW95dA6HhqziSG9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sE28ybm7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sE28ybm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22AF1C2BCAF;
	Tue, 10 Mar 2026 11:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141104;
	bh=jt85BVncvHIdkZiZ2NEjZThQNdp77XXPatolFkMZ2rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sE28ybm7fr/c0+kYN3huXtVqMkB1zkhxe6bCVFF+sYL+03ABUQgDUwlo6srNyp+ds
	 Fg2i+TAFOkcalJGYQpk08M9191R845K+PIFeij+Sng8raRqRRYb+DExtQzJIWq8Hou
	 oT3w9yUmKvrdc3sLYPIhokaoclAdvgqt8NxOEDqP21LwxE4UwBhy6jLRZdNMwSr1Jk
	 IkDhmWTCE0oSFqJ0Rf4diYXivIA5PFNYiqiHjrY4/dNcbiWWWjNLX1fHV80zf36u38
	 IvyiuqvOYeHjbUPZrU8CCP8bzSJVu6vcXQA5Jf2JLd2bSXHpKpLVyTUtBVvJOxKd7u
	 QA7Qme8nJMwuQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Petko Manolov <petkan@nucleusys.com>,
	stable <stable@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.19 106/311] net: usb: pegasus: validate USB endpoints
Date: Tue, 10 Mar 2026 07:02:33 -0400
Message-ID: <bf9a45edef10541e637b991ae3b3853cf4369a1b.1773140655.git.sashal@kernel.org>
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
 drivers/net/usb/pegasus.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 0f16a133c75d1..475b066081c7f 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -815,8 +815,19 @@ static void unlink_all_urbs(pegasus_t *pegasus)
 
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
@@ -1171,6 +1182,7 @@ static int pegasus_probe(struct usb_interface *intf,
 
 	pegasus = netdev_priv(net);
 	pegasus->dev_index = dev_index;
+	pegasus->intf = intf;
 
 	res = alloc_urbs(pegasus);
 	if (res < 0) {
@@ -1182,7 +1194,6 @@ static int pegasus_probe(struct usb_interface *intf,
 
 	INIT_DELAYED_WORK(&pegasus->carrier_check, check_carrier);
 
-	pegasus->intf = intf;
 	pegasus->usb = dev;
 	pegasus->net = net;
 
-- 
2.51.0

