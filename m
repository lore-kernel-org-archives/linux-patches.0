Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF8C2BE655;
	Mon,  1 Dec 2025 11:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588413; cv=none; b=UpcAvdXFJU/zWRo1yNbC7Sq3gFl5Sq5hklOQo7SkiZ4D9l+515guxmzPfSDq7neDOcIfumU4XauUxWuMNaoVsy9m8v2OaoPzegtIbdFWwfhHYU6pRHSWw58Pzq2FKVQqMypG/AYnu1pR2XBmBVmXL9HRDEDrRKDorLZaad8rHws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588413; c=relaxed/simple;
	bh=gDeS/21ndbV12BhzuyG71GWYeVh/VsAN1DN78JF3Y+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ni2N1qd/jBQSXJkBGoK0D81n/i9ZPixoT5nKT9kWhFlxOx7PslSx9X69BU/TuIO1+bKVKAK4orMGbMRwWfSqyWBvRwTdFsYTAgy03scX6f31B8RHJqX5iXIFmVzH23IFliOnbb9HNi16omOl4XdQU9b6T0EW/nIxOr2rml9+MMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GNKOUSV0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GNKOUSV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A47C113D0;
	Mon,  1 Dec 2025 11:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588412;
	bh=gDeS/21ndbV12BhzuyG71GWYeVh/VsAN1DN78JF3Y+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GNKOUSV0p6E8fmWKFkkmPjlLIiJ01n3kP65OTEOCQPYnnKoIbFBZPTUNZgzycAwsS
	 ScSAahWuAk9m5ia3ady8zQgmKushzpSQ7r4IJtIgWcoipo+DL3bf6/Aoc6SHTLtFKm
	 wmvesQe5DhS7qsqolxbIkUCGdBjHqyScZVU6+ExY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Sun <samsun1006219@gmail.com>,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 012/187] usbnet: Prevents free active kevent
Date: Mon,  1 Dec 2025 12:22:00 +0100
Message-ID: <20251201112241.694277404@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 87c0bcfef4801..f0dd0d7b51dc1 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1615,6 +1615,8 @@ void usbnet_disconnect (struct usb_interface *intf)
 	net = dev->net;
 	unregister_netdev (net);
 
+	cancel_work_sync(&dev->kevent);
+
 	while ((urb = usb_get_from_anchor(&dev->deferred))) {
 		dev_kfree_skb(urb->context);
 		kfree(urb->sg);
-- 
2.51.0



