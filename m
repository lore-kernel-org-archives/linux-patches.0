Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E590324B37;
	Mon, 27 Oct 2025 19:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592911; cv=none; b=IKM1YBs1tngRSWJwut87nvvogAVfv214AZ1Erf0mctrZHhXf6jWxmHz4iJkrbbWI2LvYyFw+aFkOSDux0RApH1RHZnJyZYp+wZfaBRMXCsO/trNzyXXiuBYkVpNI1hqUDXBgJC6AA6QRqN+YNOt7cjZtG/5Vhnb7rx1LC79L8Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592911; c=relaxed/simple;
	bh=qSoahRxM8yQ4V5slepN8JtBWGoLjfqRpUQZdCTxb0k0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BR14w+Bc9Ue2rVCmMBBRHMEBVMIq5U/w8hE4sqUE8I8a0tLnLjIcRHFPe7ihjvq842tAclcjgCOQbhx+i+xdn5tugY74hFyu7H+QByIC+W8poG2d3ubiLIvBBeYMZibsfihxR1lWRnTWapXd0pZ8GCin6JxO4ZZTzILlJJJ0JS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aZv85/4t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aZv85/4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226D9C4CEF1;
	Mon, 27 Oct 2025 19:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592911;
	bh=qSoahRxM8yQ4V5slepN8JtBWGoLjfqRpUQZdCTxb0k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aZv85/4tg8vbYp5lH/bNLCLcg1Di9w60cLsHnB+i/Bqm4g5bwTZ8LxM61zR4iDCLb
	 VMlo3IRe4rLepCzh3xUxX9MKlX1tEySgI6uiUCMTvoPCw+rI7lPBmf2Xs8BYiGbFvr
	 WS4HJXYC0Z7zfSTz/4H+7PlyfFzIlMem0FiaYhbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.12 058/117] MIPS: Malta: Fix keyboard resource preventing i8042 driver from registering
Date: Mon, 27 Oct 2025 19:36:24 +0100
Message-ID: <20251027183455.586909906@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit bf5570590a981d0659d0808d2d4bcda21b27a2a5 upstream.

MIPS Malta platform code registers the PCI southbridge legacy port I/O
PS/2 keyboard range as a standard resource marked as busy.  It prevents
the i8042 driver from registering as it fails to claim the resource in
a call to i8042_platform_init().  Consequently PS/2 keyboard and mouse
devices cannot be used with this platform.

Fix the issue by removing the busy marker from the standard reservation,
making the driver register successfully:

  serio: i8042 KBD port at 0x60,0x64 irq 1
  serio: i8042 AUX port at 0x60,0x64 irq 12

and the resource show up as expected among the legacy devices:

  00000000-00ffffff : MSC PCI I/O
    00000000-0000001f : dma1
    00000020-00000021 : pic1
    00000040-0000005f : timer
    00000060-0000006f : keyboard
      00000060-0000006f : i8042
    00000070-00000077 : rtc0
    00000080-0000008f : dma page reg
    000000a0-000000a1 : pic2
    000000c0-000000df : dma2
    [...]

If the i8042 driver has not been configured, then the standard resource
will remain there preventing any conflicting dynamic assignment of this
PCI port I/O address range.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/alpine.DEB.2.21.2510211919240.8377@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/mti-malta/malta-setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/mti-malta/malta-setup.c
+++ b/arch/mips/mti-malta/malta-setup.c
@@ -47,7 +47,7 @@ static struct resource standard_io_resou
 		.name = "keyboard",
 		.start = 0x60,
 		.end = 0x6f,
-		.flags = IORESOURCE_IO | IORESOURCE_BUSY
+		.flags = IORESOURCE_IO
 	},
 	{
 		.name = "dma page reg",


