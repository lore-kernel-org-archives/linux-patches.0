Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3C128BA9F;
	Wed,  7 May 2025 19:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645046; cv=none; b=ljFIViH50u+lPirw+9vm5U6LNTSEcNHqSajUK6Wbiuubfm9CgphHx/HU7k9DAMD5f5iSuTU9Y0IJqljbj4CMEsapXt4oEDLx/4Ns3cdaQfvc1L2uhsRqRSUrelz0tIGi7i19/K4hToWqsvgzf4iBudvC6e21Hv6tD6GDXa7zN6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645046; c=relaxed/simple;
	bh=v2lg4pfQLPnFzF8QU0GaxazkUXjna2lI0MZ8YWG1h7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5k5SZgnr5EKFwSvV8ZPPsE0nOK71bUMFE2cE1Typ1dVHlvojenrKny41ZuHWSCbm86fyJ7Ms6+Y7hvC0sDy1wi3bT4A0mPjEueRgxVYd5Req7aYh3iut9aQ3MzY2yj294BLUgBqGQ2H/q/8ObJjgchVKCdgXqdHS+x9ymYYRis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Asf1DOpC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Asf1DOpC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB42C4CEE2;
	Wed,  7 May 2025 19:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645045;
	bh=v2lg4pfQLPnFzF8QU0GaxazkUXjna2lI0MZ8YWG1h7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Asf1DOpCavGekGbh3bBtPwJmwaPFd2TOs0E9v2aRskGQGppXoL5wKMbEM3mINYVAL
	 Xa95Ds+r0wp51tN3yoJyBDpd8lPa8c0/TFcVS1AdcW20i574/yFIquvrG8CJ8A3/fI
	 +c8m3YQyjraypigAqf5b/6D0r9rgYIx1KhF7Xp+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/129] net: dlink: Correct endianness handling of led_mode
Date: Wed,  7 May 2025 20:40:11 +0200
Message-ID: <20250507183816.555924869@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Simon Horman <horms@kernel.org>

[ Upstream commit e7e5ae71831c44d58627a991e603845a2fed2cab ]

As it's name suggests, parse_eeprom() parses EEPROM data.

This is done by reading data, 16 bits at a time as follows:

	for (i = 0; i < 128; i++)
                ((__le16 *) sromdata)[i] = cpu_to_le16(read_eeprom(np, i));

sromdata is at the same memory location as psrom.
And the type of psrom is a pointer to struct t_SROM.

As can be seen in the loop above, data is stored in sromdata, and thus psrom,
as 16-bit little-endian values.

However, the integer fields of t_SROM are host byte order integers.
And in the case of led_mode this leads to a little endian value
being incorrectly treated as host byte order.

Looking at rio_set_led_mode, this does appear to be a bug as that code
masks led_mode with 0x1, 0x2 and 0x8. Logic that would be effected by a
reversed byte order.

This problem would only manifest on big endian hosts.

Found by inspection while investigating a sparse warning
regarding the crc field of t_SROM.

I believe that warning is a false positive. And although I plan
to send a follow-up to use little-endian types for other the integer
fields of PSROM_t I do not believe that will involve any bug fixes.

Compile tested only.

Fixes: c3f45d322cbd ("dl2k: Add support for IP1000A-based cards")
Signed-off-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250425-dlink-led-mode-v1-1-6bae3c36e736@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/dlink/dl2k.c | 2 +-
 drivers/net/ethernet/dlink/dl2k.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/dlink/dl2k.c b/drivers/net/ethernet/dlink/dl2k.c
index db6615aa921b1..ce46f3ac3b5a1 100644
--- a/drivers/net/ethernet/dlink/dl2k.c
+++ b/drivers/net/ethernet/dlink/dl2k.c
@@ -352,7 +352,7 @@ parse_eeprom (struct net_device *dev)
 	eth_hw_addr_set(dev, psrom->mac_addr);
 
 	if (np->chip_id == CHIP_IP1000A) {
-		np->led_mode = psrom->led_mode;
+		np->led_mode = le16_to_cpu(psrom->led_mode);
 		return 0;
 	}
 
diff --git a/drivers/net/ethernet/dlink/dl2k.h b/drivers/net/ethernet/dlink/dl2k.h
index 195dc6cfd8955..0e33e2eaae960 100644
--- a/drivers/net/ethernet/dlink/dl2k.h
+++ b/drivers/net/ethernet/dlink/dl2k.h
@@ -335,7 +335,7 @@ typedef struct t_SROM {
 	u16 sub_system_id;	/* 0x06 */
 	u16 pci_base_1;		/* 0x08 (IP1000A only) */
 	u16 pci_base_2;		/* 0x0a (IP1000A only) */
-	u16 led_mode;		/* 0x0c (IP1000A only) */
+	__le16 led_mode;	/* 0x0c (IP1000A only) */
 	u16 reserved1[9];	/* 0x0e-0x1f */
 	u8 mac_addr[6];		/* 0x20-0x25 */
 	u8 reserved2[10];	/* 0x26-0x2f */
-- 
2.39.5



