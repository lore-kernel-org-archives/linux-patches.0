Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCF7221F17;
	Wed,  4 Feb 2026 14:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216405; cv=none; b=ZJBkajDSzYfBqEyTzObjQepRyu4Pas1G0zTGRbki15DswbdSX+FXvFSsYwHo173np84FlFyE5/Gv9MNc7o0TtEMpbrDDyD6rpd6NHxMrzaZiynuV2NirGE+zEXT0hW5+G+hGKwYMwMgbCC/NumPt4uFnu+PcMZzAbjvJc/kuTEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216405; c=relaxed/simple;
	bh=rPsruh6xD5uDPIEMvTKGK3ULoNEfUxwDeEz/u8+QjIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlpAK591p2LtH+bYzBwGep9ablj61CQPLTY6elel3DCXT4I390xGUvJAlsGyuKlQXvjvrwoU8yEZ3DiY7JjvaRGoVDqQFES3OPx1mjbkT5YnTa9sK3YCDstRI7LPgk1Q+bxmHOj9Q7l2bIqMIjU566QKy7uWXF7qOtEFZ6nCEWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IMKtDjrr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IMKtDjrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E02EC4CEF7;
	Wed,  4 Feb 2026 14:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216405;
	bh=rPsruh6xD5uDPIEMvTKGK3ULoNEfUxwDeEz/u8+QjIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IMKtDjrrsu9jH1AsETTmFyXz8X7T6disWncvDHfGz1ZsSbjIZN6+ILgo1TYqb5V/O
	 Jxl8SGasC+Co+XqaIC3n2sbJk2iVs3ATu6MrpSNTwtJqySioub6cJ3pAtxr9PzAJnU
	 H3zpJM3VY4+f3p5uT5LaSzaNjgaveV/1DH1XWU34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <lvivier@redhat.com>,
	Stefano Brivio <sbrivio@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/161] usbnet: limit max_mtu based on devices hard_mtu
Date: Wed,  4 Feb 2026 15:39:02 +0100
Message-ID: <20260204143854.593546229@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9ac9fbdad5c08..4a83228a2db57 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1745,9 +1745,12 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
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



