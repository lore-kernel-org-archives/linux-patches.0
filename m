Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D284F282F1B;
	Sat, 12 Sep 2026 07:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199030; cv=none; b=E2LWRwJ4xO8kBbZ7BopdWGljC5plgTMBQwMTbp8/jH18TDGxxVq153QHvYO5zl+L59hc8tocxSqZROADB7Nmr5XMULPcczHHmRtZLBsHJdpzze/NStaIzHNf1zfIs77+0p2nQ+66+vaIcOeTzTJAp4bTSVU9Ecu0fttJ6JlLkZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199030; c=relaxed/simple;
	bh=cCKLJXso7cdTCrhU41KLRoWTGhmITLJIM56GFLpBsZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5IdeVVO6fXv8UXXoyurFtjdb8MvRujVZZQRkL+i5NZ/D/fYntbLK0Ww050avhNp3Y92Uua+d95slaWyvPu5WQsuizlhOvaavLjbImhw1IQHZ6FhVow5pAThXcJdL+21LLXAHDbLPWaEt8rPEufC+RA7RW+2Omq0vJVk+Bv4PT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uzzh1DI9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uzzh1DI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6491F000FF;
	Sat, 12 Sep 2026 07:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199028;
	bh=xYjXTt6bZO1Ird30fs+hETuAVXfUdLPm5QuV6bGtgBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uzzh1DI9jwr1jBbvr0C/laPeBHjqZa+G3bjxICqlm7P3QelciyDperteGgSQvnsH6
	 W2pAAiUmr0chc/JV2+Vb8RGecZcsQQEpnIbrcGUPTNi1/j8NIKLZzydjq3baEBKeHa
	 0EOP1lZH4Mkptrjkt49KaZoOLKtw+S4UVj1IiQq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gleb Markov <markov.gi@npc-ksb.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0499/1815] misc: rtsx: add missing write register handling
Date: Sat, 12 Sep 2026 08:37:29 +0200
Message-ID: <20260912065700.606748299@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gleb Markov <markov.gi@npc-ksb.ru>

[ Upstream commit 655faba1ccf195e22a7a83146ef6015e3271233c ]

If an error occurs at the stage of working with registers in conjunction
with MCU_Block, it will not be processed.

The occurrence of errors at this stage may signal an impact on writes to
the device's PCI registers and is a more global problem than a
driver-level security problem, but adding a handler would be a good
practice.

Add a missing error handling.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: c0e5f4e73a71 ("misc: rtsx: Add support for RTS5261")
Signed-off-by: Gleb Markov <markov.gi@npc-ksb.ru>
Link: https://patch.msgid.link/20260629130920.1260-1-markov.gi@npc-ksb.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/cardreader/rtsx_pcr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/cardreader/rtsx_pcr.c b/drivers/misc/cardreader/rtsx_pcr.c
index c4d54ca2fa804..c6e602523538e 100644
--- a/drivers/misc/cardreader/rtsx_pcr.c
+++ b/drivers/misc/cardreader/rtsx_pcr.c
@@ -1196,6 +1196,8 @@ static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
 		/* Gating real mcu clock */
 		err = rtsx_pci_write_register(pcr, RTS5261_FW_CFG1,
 			RTS5261_MCU_CLOCK_GATING, 0);
+		if (err < 0)
+			return err;
 		err = rtsx_pci_write_register(pcr, RTS5261_REG_FPDCTL,
 			SSC_POWER_DOWN, 0);
 	} else {
-- 
2.53.0



