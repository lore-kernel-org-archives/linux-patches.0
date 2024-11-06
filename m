Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B23154765;
	Wed,  6 Nov 2024 13:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898962; cv=none; b=XPz68BgsKrKaSRZGftfUmeTbUovgNcV/AAXuO/TeVJqbPSLPnSmt/FepkcAUs7ndtHU599DwCEBV2Z4bs8iQhAq6F1rK/MOgAvdkQ2BGLYNgX92+mjPnAzJ2K6dYFtd4YsFPWcQKOoBVbSlgxtuCTO9x18Xg4WR89UEIdtmIqog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898962; c=relaxed/simple;
	bh=8TQ8LPosmLYMaCeJ1M0oFxsd/oS6bnJ++9kcql0Oqdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPb0M6ir3l2YXBDeI/LT/zhe9f0YLuk/QPrdrfA6JxRmVI4MLedXXplK/fcvf8BgpDnvZtXyEQg9oaiAPfaEwn13/+4bzmi9XkL0pX7p4ltA/dzorxeV7ihUhbop2bwRpQsFC9AMvqRe8TqS3Q6lGG5QEMtTMVjK+Ren6qJg/Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vffrdmR7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vffrdmR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843C9C4CECD;
	Wed,  6 Nov 2024 13:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898961;
	bh=8TQ8LPosmLYMaCeJ1M0oFxsd/oS6bnJ++9kcql0Oqdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vffrdmR7fQkweh8aaH75PYWXWxv5A2Jvkqldh3u3gT12qYIgsa85YGKp29793lO6Q
	 z3e3aOdombYI5ahUMpKtEZPBtkHjJHGxvp/FTP06oS2TNTLXQP/U/WdtdXoOGBFLEy
	 EK+YmCow3ro//imDD4dtiVsPoMpdJ4kldRE/XoZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atlas Yu <atlas.yu@canonical.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 413/462] r8169: avoid unsolicited interrupts
Date: Wed,  6 Nov 2024 13:05:06 +0100
Message-ID: <20241106120341.720097188@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index bb5f70ce63b3d..14bac7c0e6f90 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -6237,7 +6237,9 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
 	    !(status & tp->irq_mask))
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



