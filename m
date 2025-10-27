Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E824F329C7D;
	Mon, 27 Oct 2025 19:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592638; cv=none; b=TWf9/WttHSad1+guusdu/ogN4vSyr0rlGwqPhhmPukKIRTX4iIUX/QoSs1MiHii9Smdh81jliLFxL5EJF5v+M5B5Ka3oUHvZ3zLTainwy/4U+na6vITlYRBlpKMmatQ7wRcaLfEAmtMPeI8izCs6L5tZ7rdLwzexgyIJ4LwEylU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592638; c=relaxed/simple;
	bh=93shxL/l6H87Ab/6whoqzKvqINsVvSM9Sy/QfWBqYmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C8+YAftEPke0RRCHC3QLEO5DgIlBHtKkh0JgwLNq30ucN6cnaTnoXZTuLI8OUkuH4Nar5IIh1JW+o+hzW7ScrX8j96W00n5kd4z92ntWIQ6iI1cbOvkTrgTmxELFVQmmE4e917s72+Cff/cZR0Ye/J1IzaEDZZ6Syubc0XiCFxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oDWZyP8W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oDWZyP8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799ECC116B1;
	Mon, 27 Oct 2025 19:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592637;
	bh=93shxL/l6H87Ab/6whoqzKvqINsVvSM9Sy/QfWBqYmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oDWZyP8W5leYLcqlVWzbkoC246KE9/4FPlZgKsJShW2+uY0LNSzEgTJZCSIbfHpEW
	 1IlNMx4VdGtRy6mKddrKxTtbTHaeHVC3hlX1Ei2WCgXGLOl9fMqpS3DEeXyzv8SqXN
	 yeOFOIyo3IEEqtUzR7bg1LRQoOWlIXzJIz3Cd2SA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.6 40/84] MIPS: Malta: Fix keyboard resource preventing i8042 driver from registering
Date: Mon, 27 Oct 2025 19:36:29 +0100
Message-ID: <20251027183439.888055114@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


