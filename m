Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BD1338F5B;
	Wed,  3 Dec 2025 15:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777419; cv=none; b=K7oK4a/nFjEtrfR7H9G6kAWjqfs6OIHfVwVK4zKhXIz7nB2Kbw63D/mqzMOoRVDYZuUJGReuNL0MBaP1Q4nTG6s/dlSIRktU5F8wFs21bagCfI+H7jiswsG3eFaPN7qOVe3g9XsLaP4+JM0OdqUHF5IcG5LXhtZ253+Y1ESFqzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777419; c=relaxed/simple;
	bh=SpdkcNkmL9FpTUlEhCXynXSVQYbB3kcL4IxXPinSoj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HCcvcoYewpA4c3XIpJuFoFk83Y1p/+NISTiQEmLpvhz86kgKI8Y7tzGq/5UvOWt9S39V2f8ROMUtDSR0dAD3ma6bahrqv/lyQrY9V9DtmrpftXuI9vGZaxoZs6PTElkkNLrijoAyhIuDXzgX6HQl1TmB4+DBx4Z9S53tD+/nvyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UzuZBNjR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UzuZBNjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED6EC4AF09;
	Wed,  3 Dec 2025 15:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777418;
	bh=SpdkcNkmL9FpTUlEhCXynXSVQYbB3kcL4IxXPinSoj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UzuZBNjRjJPcplInfNCN9flenvfAtkbcLe6tjdG4y2xAWPT/yJaR2W2CA0wgQII0g
	 AKbAEQ9GiyE+Z5zxvkS1Jhq9K2htecmsLL8DwrehV0P9OlHXvoUg6PAI8LjfocNjR8
	 5l/m8I+v2zGTsPgv8r7vTQT8Gqf4i8M3D5lmshbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Sun <samsun1006219@gmail.com>,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/392] usbnet: Prevents free active kevent
Date: Wed,  3 Dec 2025 16:22:54 +0100
Message-ID: <20251203152414.992425704@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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
index 21f5fdbce0747..aceec2381e802 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1648,6 +1648,8 @@ void usbnet_disconnect (struct usb_interface *intf)
 	net = dev->net;
 	unregister_netdev (net);
 
+	cancel_work_sync(&dev->kevent);
+
 	while ((urb = usb_get_from_anchor(&dev->deferred))) {
 		dev_kfree_skb(urb->context);
 		kfree(urb->sg);
-- 
2.51.0



