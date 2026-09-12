Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FAB35203C;
	Sat, 12 Sep 2026 14:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223484; cv=none; b=NJ0hhjpBMrMwmbgnC2LPK+9MI5CtgCMyUhz1HQQYShQ1j9+m3VZz9gZsiYh7LrC0x5PL/H41cDcwvu/NEEgrFROruIaCKSBeOFMw9moYYAwQatXkMEMOZe2xnNIdGbQwuNX6A19JxO7MDkqs5RKQwyigvQ/FAhWgqdJui9mipWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223484; c=relaxed/simple;
	bh=HdUQEoOnEIS9tz0rhvX46rbB1vB7Gc4FtAJTC5qVar4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jR9oM6lmyCuYX3arZWd0qI1Y+PwgEPwES3cNJwgQprzACDkhNflFu4cxMQH13GJHiycjE4+B5OHr8KBk2WJd69TkEaRAlaiPsp6/hfjMeEw00noQ+sOkYMzV+G5j+a9DqnGajVqAbqaRQIhucSbR4QsPg2D7SNGBu1/51Zsacko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O1cYnIfD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O1cYnIfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276DD1F00893;
	Sat, 12 Sep 2026 14:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223478;
	bh=7rZoJnlJWmvbr2wJQj5KAF0GSEp8N28jF7kSZMgU2TQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O1cYnIfDb4e4bHEk3mLdWZISoueU7ANYlAmrMgO3F4dF+xrltCnn6vOMJD/2Squ+g
	 vqr9WJwNFBsRD5cn/uuBBRrlF4m0ywWqIb5KlPPdxQjQTlzG5sNgYy1B3xNZYs5xVm
	 LRiepAzQVAVex1U9dBbOwXbVcdt4YEOff6yO6R8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gleb Markov <markov.gi@npc-ksb.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0797/1424] misc: rtsx: add missing write register handling
Date: Sat, 12 Sep 2026 08:53:49 +0200
Message-ID: <20260912065625.145662004@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a30751ad37330..7979ec7d7333b 100644
--- a/drivers/misc/cardreader/rtsx_pcr.c
+++ b/drivers/misc/cardreader/rtsx_pcr.c
@@ -1230,6 +1230,8 @@ static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
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



