Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D453F7882;
	Mon, 17 Aug 2026 13:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974237; cv=none; b=g5iV94azHAGrFLfvieijT9j1o7W3gCPmeNMwJ1pkcujj1QxRP5XNT4GKZ5lhpQPhJdlHKXItb57xGlB4KQi8dkShe1K/bFP9Dj0icTQJXyBlMH/UMoyuhzWW2URfXkOBgLCVWw8I6EXRFgnt1bqjqUZ5DhJZ+AGHt4pqT4qFK4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974237; c=relaxed/simple;
	bh=NfY2olrZgkNwgRgDMKB2akgClbkRX2eyZOgaSJgBzhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZXvZBExVwHMelbOLgIej0xSwAVSpUaTWryrTS/JeR+vfUNYX+DNClxjX6HlBYOi00WCDCF4rIvsCIHM9mKHS+2lDIX40EfpAH4myuUYuhksv0gYBXxi3LDLrMlKkQlhUyYs28cYtozV7GAtW8sH9g3Nfs7W791ZOX1MWzvjpQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QXT3/FiO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QXT3/FiO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F021F00A3D;
	Mon, 17 Aug 2026 13:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974235;
	bh=IoISFnfwMOlsnrzeEcxtTXkUlN+Y+NI8bx3t0nMuSYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QXT3/FiOvwlUoJ+Lgi5T+wF3sXPF2fR7oFjaub8s6wGih+ttRHY2sgJC/enTZ73PI
	 1uN4LxIVjijx7RKdiAmjhQA56zeRiin2AyHGKWWRKg7TPFGWC8FKocVH2JaC2YDGsP
	 ZfkrQINM6GWosgrsF/1KTKMK4hdQUv5Ua1mBGqwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	jarod@redhat.com,
	Laurent Vivier <lvivier@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 137/271] usbnet: cap max_mtu for drivers without bind callback
Date: Mon, 17 Aug 2026 15:31:02 +0200
Message-ID: <20260817132542.487543657@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Vivier <lvivier@redhat.com>

commit 1505b2cb6ae1c7e8ac0c6e4590a204ffc3ab2b24 upstream.

usbnet_probe() initializes max_mtu to ETH_MAX_MTU and only caps it
inside the if (info->bind) block. Drivers without a bind callback
never enter this block, so max_mtu stays at ETH_MAX_MTU.

QEMU's usb-net device (0x0525/0xa4a2) is claimed by the cdc_subset
driver which has no bind callback. The guest accepts any MTU from DHCP
(e.g. 65520 from passt), leading to TCP segments that exceed the
device's 2048-byte receive buffer and are silently dropped.

Initialize max_mtu to net->mtu at probe time and update it inside
the bind block.

Fixes: f77f0aee4da4 ("net: use core MTU range checking in USB NIC drivers")
Cc: jarod@redhat.com
Cc: stable@vger.kernel.org
Link: https://gitlab.com/qemu-project/qemu/-/issues/3268
Link: https://bugs.passt.top/show_bug.cgi?id=189
Signed-off-by: Laurent Vivier <lvivier@redhat.com>
Link: https://patch.msgid.link/20260731092711.857684-1-lvivier@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/usbnet.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1798,7 +1798,7 @@ usbnet_probe(struct usb_interface *udev,
 	 */
 	dev->hard_mtu = net->mtu + net->hard_header_len;
 	net->min_mtu = 0;
-	net->max_mtu = ETH_MAX_MTU;
+	net->max_mtu = net->mtu;
 
 	net->netdev_ops = &usbnet_netdev_ops;
 	net->watchdog_timeo = TX_TIMEOUT_JIFFIES;
@@ -1808,6 +1808,7 @@ usbnet_probe(struct usb_interface *udev,
 	// allow device-specific bind/init procedures
 	// NOTE net->name still not usable ...
 	if (info->bind) {
+		net->max_mtu = ETH_MAX_MTU;
 		status = info->bind(dev, udev);
 		if (status < 0)
 			goto out1;


