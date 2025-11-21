Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D79352936;
	Fri, 21 Nov 2025 13:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732274; cv=none; b=aF4M0wZV0lCnCJUsBZocp6axLmNIqncxujEl2aEjidX0YZeouxFt/SUlb2JIQ+zkdyLmeUI7EzKGXqIu65gcOMogQgB5v7arqXbgcdqGZoncLCfjKeALDs/lg8rxXtcUPW8I7qo08dAkK6w+yQZUI+J2U1LpjWogdPUZGCAUkZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732274; c=relaxed/simple;
	bh=/RB27YNgfPCoEYTA6/xlV5dPNKpAfB/TBVHUwfFUmjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jhb0f4GOsDAZW8hT7fuNTLm1GFZD3F+0lhZFJQNMNIwahF3QWAFMVew74m3GCMuAskCvavrMPI39Cmu8ar8oJt7AwhJRIHcTiOk4or9ppnOrOp+Hv5uq115F25gWqis/bTlF2+Yltwno/Dy8V52gwWdua6AZowtJE0SVnOIoeH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DO6R61+7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DO6R61+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB627C4CEF1;
	Fri, 21 Nov 2025 13:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732273;
	bh=/RB27YNgfPCoEYTA6/xlV5dPNKpAfB/TBVHUwfFUmjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DO6R61+7Kji6Lf4QcRPYRXsGp3qM8xHAv/snrdjDgAJki2EjxSbM0BCPUe0yFp5XY
	 PBDsSnqfs1wgxjvw1prVpaDS5r4nw9Sqy5GgYJos1N7SAYhVX2NOkkWZksqBmmkGTz
	 /qb3lAHeZtsw4ZLRUYjOHS9Irf4bP7MzqZMeezyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Sun <samsun1006219@gmail.com>,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/529] usbnet: Prevents free active kevent
Date: Fri, 21 Nov 2025 14:05:29 +0100
Message-ID: <20251121130232.070949014@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Lizhi Xu <lizhi.xu@windriver.com>

[ Upstream commit 420c84c330d1688b8c764479e5738bbdbf0a33de ]

The root cause of this issue are:
1. When probing the usbnet device, executing usbnet_link_change(dev, 0, 0);
put the kevent work in global workqueue. However, the kevent has not yet
been scheduled when the usbnet device is unregistered. Therefore, executing
free_netdev() results in the "free active object (kevent)" error reported
here.

2. Another factor is that when calling usbnet_disconnect()->unregister_netdev(),
if the usbnet device is up, ndo_stop() is executed to cancel the kevent.
However, because the device is not up, ndo_stop() is not executed.

The solution to this problem is to cancel the kevent before executing
free_netdev().

Fixes: a69e617e533e ("usbnet: Fix linkwatch use-after-free on disconnect")
Reported-by: Sam Sun <samsun1006219@gmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=8bfd7bcc98f7300afb84
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Link: https://patch.msgid.link/20251022024007.1831898-1-lizhi.xu@windriver.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/usbnet.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index fd6b5865ac513..e6a1864f03f94 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1650,6 +1650,8 @@ void usbnet_disconnect (struct usb_interface *intf)
 	net = dev->net;
 	unregister_netdev (net);
 
+	cancel_work_sync(&dev->kevent);
+
 	while ((urb = usb_get_from_anchor(&dev->deferred))) {
 		dev_kfree_skb(urb->context);
 		kfree(urb->sg);
-- 
2.51.0



