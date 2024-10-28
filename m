Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5523C15B10D;
	Mon, 28 Oct 2024 06:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097806; cv=none; b=W40YBKkyRHYT3SOL6ryVqpKbH/ZAvrri5sNl+s66HwkOOf5OMt9EAUW9IgRTeXb5KgS10OEg9ItnT5/4G+2IbGXtwb21whbtVSIBl2mmQaUn7zOft/LvPReULRopzhcPnVNyChE/9FZjxFpKrq06T2Fp+P1mQSRAMOTTRwayuH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097806; c=relaxed/simple;
	bh=PGXNlr52wjhfCOb+6I4hwbV1yuuleiBGiQVr9cvSP8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWcxBF/59bbRcqKA2atxWZ/qGQM3E78v4PV3d4TPmcWaIgJRcEzmVpfXTLSy7g0QhA2DBBgsLuBs8Os2CENktZeFMUzZOa3AKgosbtElP69hsrKycrSfu8FwfhT7KzuTzAtuv6TmHLTvcXXWU9UV9BLwPhTeufRXtzHb0eOj9gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dyyQrwne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dyyQrwne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E5EC4CEC3;
	Mon, 28 Oct 2024 06:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097806;
	bh=PGXNlr52wjhfCOb+6I4hwbV1yuuleiBGiQVr9cvSP8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dyyQrwnemSInL8Gm5c9QRU0C0fALy+tmGobGjiEebTYBQ2lg389qdzZlRfQrdcGYT
	 VDGlisdZ4LCx82WC8dWS2wkfo7brWWKeX+DE8WzS55QTV2PP5KQ8R261MX94bCUbC8
	 1ARocIsEK7twRGp5sec1MgmP+zN11dm8SNbcWEYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atlas Yu <atlas.yu@canonical.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 156/208] r8169: avoid unsolicited interrupts
Date: Mon, 28 Oct 2024 07:25:36 +0100
Message-ID: <20241028062310.468124820@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 10ce0db787004875f4dba068ea952207d1d8abeb ]

It was reported that after resume from suspend a PCI error is logged
and connectivity is broken. Error message is:
PCI error (cmd = 0x0407, status_errs = 0x0000)
The message seems to be a red herring as none of the error bits is set,
and the PCI command register value also is normal. Exception handling
for a PCI error includes a chip reset what apparently brakes connectivity
here. The interrupt status bit triggering the PCI error handling isn't
actually used on PCIe chip versions, so it's not clear why this bit is
set by the chip. Fix this by ignoring this bit on PCIe chip versions.

Fixes: 0e4851502f84 ("r8169: merge with version 8.001.00 of Realtek's r8168 driver")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219388
Tested-by: Atlas Yu <atlas.yu@canonical.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/78e2f535-438f-4212-ad94-a77637ac6c9c@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index b499d8ea6d216..6856eb602f826 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4576,7 +4576,9 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
 	if ((status & 0xffff) == 0xffff || !(status & tp->irq_mask))
 		return IRQ_NONE;
 
-	if (unlikely(status & SYSErr)) {
+	/* At least RTL8168fp may unexpectedly set the SYSErr bit */
+	if (unlikely(status & SYSErr &&
+	    tp->mac_version <= RTL_GIGA_MAC_VER_06)) {
 		rtl8169_pcierr_interrupt(tp->dev);
 		goto out;
 	}
-- 
2.43.0



