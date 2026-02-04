Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEA3410D10;
	Wed,  4 Feb 2026 14:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216782; cv=none; b=pboO12P0gVtTh+W5IhXczPHEnrQDzciha3NOaMKM4HhUxMvswT3/lkegEuYznBTaisWtpq0s7cjzbZ7febCEH4mJLy5Afw/CoEtF+DlkNJmts5rDqfqLNVlSaMpXwBqySA4wyGTT/d+pif7BEXdEmm9BHi4DCIduamKtmFxBc20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216782; c=relaxed/simple;
	bh=A7jFytY3VROcsRnMmWsw6WKvKdd6KChKtW+hG6mwVYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=az0UZ/hIfvkTVoNsY0fqfPY52bOnwLQ75FI1n67ofoP4On5aSYIZM+jCrLmydlUGEC+T//8DSSsp+nBnG5Ig2vyM2qD2Vz7J612I+ig00JMG0GZoUNQQe68Ffu4gadhCJhjWoH46HxeERZhJXzhXwFCG4/kLb4j2TUWjaB+B7Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bSdjK6s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bSdjK6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB56DC19423;
	Wed,  4 Feb 2026 14:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216782;
	bh=A7jFytY3VROcsRnMmWsw6WKvKdd6KChKtW+hG6mwVYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0bSdjK6sI6fIRtthu3uuL2p3ewJDDGdyBOhrtOf3yO5U50jPghaj8az7CvIq4AswJ
	 0JQoyR+8MX/sV8/9hbopAR59FQTeM4BNgMYxE1X7mzmYHW5YspHMPV1JPJld1w6Jv+
	 VgtoYFs/TxvrceUbQYuRczG9mE17zIzZnkLRma3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Shengwen Xiao <atzlinux@sina.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 030/206] USB: OHCI/UHCI: Add soft dependencies on ehci_platform
Date: Wed,  4 Feb 2026 15:37:41 +0100
Message-ID: <20260204143859.288510302@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit 01ef7f1b8713a78ab1a9512cf8096d2474c70633 upstream.

Commit 9beeee6584b9aa4f ("USB: EHCI: log a warning if ehci-hcd is not
loaded first") said that ehci-hcd should be loaded before ohci-hcd and
uhci-hcd. However, commit 05c92da0c52494ca ("usb: ohci/uhci - add soft
dependencies on ehci_pci") only makes ohci-pci/uhci-pci depend on ehci-
pci, which is not enough and we may still see the warnings in boot log.

To eliminate the warnings we should make ohci-hcd/uhci-hcd depend on
ehci-hcd. But Alan said that the warning introduced by 9beeee6584b9aa4f
is bogus, we only need the soft dependencies in the PCI level rather
than the HCD level.

However, there is really another neccessary soft dependencies between
ohci-platform/uhci-platform and ehci-platform, which is added by this
patch. The boot logs are below.

1. ohci-platform loaded before ehci-platform:

 ohci-platform 1f058000.usb: Generic Platform OHCI controller
 ohci-platform 1f058000.usb: new USB bus registered, assigned bus number 1
 ohci-platform 1f058000.usb: irq 28, io mem 0x1f058000
 hub 1-0:1.0: USB hub found
 hub 1-0:1.0: 4 ports detected
 Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
 usb 1-4: new low-speed USB device number 2 using ohci-platform
 ehci-platform 1f050000.usb: EHCI Host Controller
 ehci-platform 1f050000.usb: new USB bus registered, assigned bus number 2
 ehci-platform 1f050000.usb: irq 29, io mem 0x1f050000
 ehci-platform 1f050000.usb: USB 2.0 started, EHCI 1.00
 usb 1-4: device descriptor read/all, error -62
 hub 2-0:1.0: USB hub found
 hub 2-0:1.0: 4 ports detected
 usb 1-4: new low-speed USB device number 3 using ohci-platform
 input: YSPRINGTECH USB OPTICAL MOUSE as /devices/platform/bus@10000000/1f058000.usb/usb1/1-4/1-4:1.0/0003:10C4:8105.0001/input/input0
 hid-generic 0003:10C4:8105.0001: input,hidraw0: USB HID v1.11 Mouse [YSPRINGTECH USB OPTICAL MOUSE] on usb-1f058000.usb-4/input0

2. ehci-platform loaded before ohci-platform:

 ehci-platform 1f050000.usb: EHCI Host Controller
 ehci-platform 1f050000.usb: new USB bus registered, assigned bus number 1
 ehci-platform 1f050000.usb: irq 28, io mem 0x1f050000
 ehci-platform 1f050000.usb: USB 2.0 started, EHCI 1.00
 hub 1-0:1.0: USB hub found
 hub 1-0:1.0: 4 ports detected
 ohci-platform 1f058000.usb: Generic Platform OHCI controller
 ohci-platform 1f058000.usb: new USB bus registered, assigned bus number 2
 ohci-platform 1f058000.usb: irq 29, io mem 0x1f058000
 hub 2-0:1.0: USB hub found
 hub 2-0:1.0: 4 ports detected
 usb 2-4: new low-speed USB device number 2 using ohci-platform
 input: YSPRINGTECH USB OPTICAL MOUSE as /devices/platform/bus@10000000/1f058000.usb/usb2/2-4/2-4:1.0/0003:10C4:8105.0001/input/input0
 hid-generic 0003:10C4:8105.0001: input,hidraw0: USB HID v1.11 Mouse [YSPRINGTECH USB OPTICAL MOUSE] on usb-1f058000.usb-4/input0

In the later case, there is no re-connection for USB-1.0/1.1 devices,
which is expected.

Cc: stable <stable@kernel.org>
Reported-by: Shengwen Xiao <atzlinux@sina.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260112084802.1995923-1-chenhuacai@loongson.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-platform.c |    1 +
 drivers/usb/host/uhci-platform.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/usb/host/ohci-platform.c
+++ b/drivers/usb/host/ohci-platform.c
@@ -359,3 +359,4 @@ MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_AUTHOR("Hauke Mehrtens");
 MODULE_AUTHOR("Alan Stern");
 MODULE_LICENSE("GPL");
+MODULE_SOFTDEP("pre: ehci_platform");
--- a/drivers/usb/host/uhci-platform.c
+++ b/drivers/usb/host/uhci-platform.c
@@ -190,3 +190,4 @@ static struct platform_driver uhci_platf
 		.of_match_table = platform_uhci_ids,
 	},
 };
+MODULE_SOFTDEP("pre: ehci_platform");


