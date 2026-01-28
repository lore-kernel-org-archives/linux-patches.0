Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A862874FE;
	Wed, 28 Jan 2026 15:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615793; cv=none; b=qP+nK4ub3Nvw1p1HdalEGG037s9u7754NO5z6fbWwHDamypWFwYQZ3H2ty96Ok2R9dQGSVPcR15rjQ4PCoWcqvQivQub/hAl5wrT4eDfF2g89UDBEFEIc6zTUMFxUljBeKpWqA/5S0rKrmm1V8v5XNZ5wC5FzkjiEvCCZiwsGdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615793; c=relaxed/simple;
	bh=XB5eoqvX9b0GesXKkIDvUNiiq5sgGs8ABiuFChLcae0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AitYNNDg+CoZxCr0bhbHfnNKWWFl2q5FfyRuAlMXy69kDAIdl95pSRbIKxbiXOUbTEEHJgmhwsd4opL7fQpbgy+j0xhQl3z15XUjMZyo94nRijhJIStxuzytnW7iPNy92cRfQDgVaupgvXgzYWWmx/ARQmZ2udraGIzM1O5I2mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjJwwdnj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjJwwdnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554D5C4CEF1;
	Wed, 28 Jan 2026 15:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615792;
	bh=XB5eoqvX9b0GesXKkIDvUNiiq5sgGs8ABiuFChLcae0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjJwwdnjp+ZprDRWhPoC9LoVT7M/sdc7tBFTB9QIsbBRCXs5TWE8rKXHIUZdRAr4J
	 L3ShKiAoH/hlutpHI4THkXZ860DQFs1L1NeAT/S+2Uo+Mhpzg53IhX8DGxdX30pozM
	 ILNHBy0g8Zto/NtmC7sGcFUoI32ZN0vd5sbUTuZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <lvivier@redhat.com>,
	Stefano Brivio <sbrivio@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 116/227] usbnet: limit max_mtu based on devices hard_mtu
Date: Wed, 28 Jan 2026 16:22:41 +0100
Message-ID: <20260128145348.639674155@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Vivier <lvivier@redhat.com>

[ Upstream commit c7159e960f1472a5493ac99aff0086ab1d683594 ]

The usbnet driver initializes net->max_mtu to ETH_MAX_MTU before calling
the device's bind() callback. When the bind() callback sets
dev->hard_mtu based the device's actual capability (from CDC Ethernet's
wMaxSegmentSize descriptor), max_mtu is never updated to reflect this
hardware limitation).

This allows userspace (DHCP or IPv6 RA) to configure MTU larger than the
device can handle, leading to silent packet drops when the backend sends
packet exceeding the device's buffer size.

Fix this by limiting net->max_mtu to the device's hard_mtu after the
bind callback returns.

See https://gitlab.com/qemu-project/qemu/-/issues/3268 and
    https://bugs.passt.top/attachment.cgi?bugid=189

Fixes: f77f0aee4da4 ("net: use core MTU range checking in USB NIC drivers")
Signed-off-by: Laurent Vivier <lvivier@redhat.com>
Link: https://bugs.passt.top/show_bug.cgi?id=189
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Link: https://patch.msgid.link/20260119075518.2774373-1-lvivier@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/usbnet.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 697cd9d866d3d..ab5ded8f38cf8 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1803,9 +1803,12 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 		if ((dev->driver_info->flags & FLAG_NOARP) != 0)
 			net->flags |= IFF_NOARP;
 
-		/* maybe the remote can't receive an Ethernet MTU */
-		if (net->mtu > (dev->hard_mtu - net->hard_header_len))
-			net->mtu = dev->hard_mtu - net->hard_header_len;
+		if (net->max_mtu > (dev->hard_mtu - net->hard_header_len))
+			net->max_mtu = dev->hard_mtu - net->hard_header_len;
+
+		if (net->mtu > net->max_mtu)
+			net->mtu = net->max_mtu;
+
 	} else if (!info->in || !info->out)
 		status = usbnet_get_endpoints (dev, udev);
 	else {
-- 
2.51.0



