Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817521D6DB5;
	Tue, 11 Nov 2025 00:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822389; cv=none; b=MyAcxiPAu7TLRTpJkCPeP5DX6seTpYK9Ckyu8YvEF2zQHjsJ1D5XBLIDYqEvwg5NNsel8PgSeATgL3PAAqwv9wk5WeVzCAx9s97oPjpoC3aXbuiqctRhzS6keVhOhLPob55dDNQbkcnsHTP+FaLpdgLWvSZoDgy//hZAC8wKBFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822389; c=relaxed/simple;
	bh=qoOx7b0N0TgEvo0SlmeygX3Y+0GtwvUUewmDRBZZV4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBSC6iGPdgU/eKdaSsHVnOigzABdqMypVZKK5pZd/NmUvpPskVCX0uKH4uDp3Z/BRRD9hziJKxr+AOu9UbMFVTnlhWiQCsen5G7joWCuOHqWCLLdIDBP+0jGCzDtPjkivTLQ8bSnzVrXISdaTsExo91gDEys3k+CE9fIvLwL18A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ekoe6XII; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ekoe6XII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0D8C4CEFB;
	Tue, 11 Nov 2025 00:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822388;
	bh=qoOx7b0N0TgEvo0SlmeygX3Y+0GtwvUUewmDRBZZV4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ekoe6XIIaeqjFkxYgjF4YxkKd9mvH0CBQVjcUOL6gewK01DuAJ4Ams1Fsa5iRmtVw
	 zeN13Zd+z9qgVKJEmnuG16nZqQIz4JYjoaxHFHwv9mv77kLbQf4/U6i9zDv6o5OpHo
	 YOb+AZZzpVs6bKIEp/kpfrfSFDL/DIx9M43fVy8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Sun <samsun1006219@gmail.com>,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/565] usbnet: Prevents free active kevent
Date: Tue, 11 Nov 2025 09:38:16 +0900
Message-ID: <20251111004527.798972034@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index ccf45ca2feb56..0ff7357c3c91c 100644
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



