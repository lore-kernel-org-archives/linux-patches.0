Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088196121
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4CEC4339B;
	Sun, 28 May 2023 19:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303035;
	bh=8PQhr6AhhtZa41y6MaX0GaZEPAl3XbCV+1mtU4KPoI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W1DGakblroH8/xWiC/r//clJSIbjx3SBlzdsUBjBDqCcnmuUMfArHDA+LNeG2/FwW
	 BXORy1eeO1zIXKGpYBlYs9xMM2re2p15Z6HlxaKnQWP+tJsgASiUuXqzJH0euUC5a4
	 5551g6KkY3RLMVTssCf+sqBglhP98Pjb1azCAtMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Konrad=20Gr=C3=A4fe?= <k.graefe@gateware.de>
Subject: [PATCH 5.10 128/211] usb: gadget: u_ether: Fix host MAC address case
Date: Sun, 28 May 2023 20:10:49 +0100
Message-Id: <20230528190846.723051654@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konrad Gräfe <k.graefe@gateware.de>

commit 3c0f4f09c063e143822393d99cb2b19a85451c07 upstream.

The CDC-ECM specification [1] requires to send the host MAC address as
an uppercase hexadecimal string in chapter "5.4 Ethernet Networking
Functional Descriptor":
    The Unicode character is chosen from the set of values 30h through
    39h and 41h through 46h (0-9 and A-F).

However, snprintf(.., "%pm", ..) generates a lowercase MAC address
string. While most host drivers are tolerant to this, UsbNcm.sys on
Windows 10 is not. Instead it uses a different MAC address with all
bytes set to zero including and after the first byte containing a
lowercase letter. On Windows 11 Microsoft fixed it, but apparently they
did not backport the fix.

This change fixes the issue by upper-casing the MAC to comply with the
specification.

[1]: https://www.usb.org/document-library/class-definitions-communication-devices-12, file ECM120.pdf

Fixes: bcd4a1c40bee ("usb: gadget: u_ether: construct with default values and add setters/getters")
Cc: stable@vger.kernel.org
Signed-off-by: Konrad Gräfe <k.graefe@gateware.de>
Link: https://lore.kernel.org/r/20230505143640.443014-1-k.graefe@gateware.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_ether.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -17,6 +17,7 @@
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/if_vlan.h>
+#include <linux/string_helpers.h>
 
 #include "u_ether.h"
 
@@ -974,6 +975,8 @@ int gether_get_host_addr_cdc(struct net_
 	dev = netdev_priv(net);
 	snprintf(host_addr, len, "%pm", dev->host_mac);
 
+	string_upper(host_addr, host_addr);
+
 	return strlen(host_addr);
 }
 EXPORT_SYMBOL_GPL(gether_get_host_addr_cdc);


