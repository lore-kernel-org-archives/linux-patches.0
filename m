Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D367168C4;
	Mon, 27 May 2024 19:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837679; cv=none; b=hiGzPyaRnMs7t1UxuA3yoikQngvyDIRKwA7kkCYT8ePSIT6qvISYOO9wAkZYfac323Vh0lFv3V0CFhNFp0pByvAs7gZ+PwXS8ByQp5vMWdpRMGDtjdyQzWPYjwkO33YA+UZQRn2MEYsJ9uEOENy6pPMweDp22/pt/+EvyrahwPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837679; c=relaxed/simple;
	bh=P3PXk84rzvp/6qEkg9InCL9tzP9sV/+hTsJLE2855r4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PXavBY+K1mIVo5rlKNytpUOt3JKt5ZVMk1MavAeJ73DBi2IZwTnJ5WRvStve2Y7C1S5io4VFXMm4G7q9xPMzfpwvVkrp2UZa6l/lKyciOeYekZ9CS9drqhpn2sw1tNmwTiMSU8KkUjH/XqBXh7hCeyhAK1kqvhpjhgg0/cRjHvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nf09C6eq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nf09C6eq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A583FC2BBFC;
	Mon, 27 May 2024 19:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837679;
	bh=P3PXk84rzvp/6qEkg9InCL9tzP9sV/+hTsJLE2855r4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nf09C6eq2J5rSQs5+odxae4tm2CV8ETqCgB2y2P+7Hh15ICqLsDULqHjIM2ziymWt
	 +fJWo/Dat1Nx295LZJ4K2W+oa4b5fOY/+PgxfMPq1GmM55fU4jOA+2gVxjXkAa8UC1
	 Fu3DTUOD9Vt/l01ovDYCo+QepQnvdOzVaDVZRS6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 085/493] ALSA: emu10k1: make E-MU FPGA writes potentially more reliable
Date: Mon, 27 May 2024 20:51:27 +0200
Message-ID: <20240527185633.065708574@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>

[ Upstream commit 15c7e87aa88f0ab2d51c2e2123b127a6d693ca21 ]

We did not delay after the second strobe signal, so another immediately
following access could potentially corrupt the written value.

This is a purely speculative fix with no supporting evidence, but after
taking out the spinlocks around the writes, it seems plausible that a
modern processor could be actually too fast. Also, it's just cleaner to
be consistent.

Signed-off-by: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Message-ID: <20240428093716.3198666-7-oswald.buddenhagen@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/emu10k1/io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/emu10k1/io.c b/sound/pci/emu10k1/io.c
index 74df2330015f6..5cb8acf5b158c 100644
--- a/sound/pci/emu10k1/io.c
+++ b/sound/pci/emu10k1/io.c
@@ -285,6 +285,7 @@ static void snd_emu1010_fpga_write_locked(struct snd_emu10k1 *emu, u32 reg, u32
 	outw(value, emu->port + A_GPIO);
 	udelay(10);
 	outw(value | 0x80 , emu->port + A_GPIO);  /* High bit clocks the value into the fpga. */
+	udelay(10);
 }
 
 void snd_emu1010_fpga_write(struct snd_emu10k1 *emu, u32 reg, u32 value)
-- 
2.43.0



