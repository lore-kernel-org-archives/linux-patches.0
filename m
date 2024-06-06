Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E75197A91;
	Thu,  6 Jun 2024 14:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683296; cv=none; b=mN7G2cypvlU2YlFv0PVs0I1hreBOyEea3Tn6HyzRSk4LCo9M30ECjJaoZ1Nv4m/LHaUVZwiJK99peJppV5AgKtNwGOZ/NTOKkMBAEFOzPFzk/nbKfyNNgvTqUGDBqpRCH8yxyyWh44ynbaCimvxuLQHtKq/gFLxVX2lkeyZY2es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683296; c=relaxed/simple;
	bh=Jda6frCktPjEszAw8LuEwN8CAmPWNAM0eceXuQsdKZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+YBLO5F1IyQwsYqeZLBErxnunu2iu0qOfT7/EbnJQprh+pL3hqdkBUN34OxZHqpnBqn/ii9+lcThJ04okE1LtGmMBD7j9jj6Sm/sIxXHSHSbNHGCSmIHmEZ/SPOsJYZCP/TykJCRZF+qvdcJi4VBXnoMVOaAhHVG/gZQZ3P9as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXRr4Hgi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXRr4Hgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF23DC2BD10;
	Thu,  6 Jun 2024 14:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683295;
	bh=Jda6frCktPjEszAw8LuEwN8CAmPWNAM0eceXuQsdKZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXRr4HgiYqSBpEd0p+BUPLfDP7At4Eq09WggipnxeYXAI+xyx+Kvd+cOObv7HutSU
	 W/9LZgHt51cCx1TeI3+Xs8HwVVwX6/C3Jm9BcvIqPZyesCBkpKykqh8M0O19h0u8WU
	 ecLNhAoOzdC11O1EN1JdS6ew4U749TnRiyPWWGOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>,
	Stan Johnson <userm57@yahoo.com>
Subject: [PATCH 6.6 236/744] m68k: mac: Fix reboot hang on Mac IIci
Date: Thu,  6 Jun 2024 15:58:28 +0200
Message-ID: <20240606131739.969635280@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 265a3b322df9a973ff1fc63da70af456ab6ae1d6 ]

Calling mac_reset() on a Mac IIci does reset the system, but what
follows is a POST failure that requires a manual reset to resolve.
Avoid that by using the 68030 asm implementation instead of the C
implementation.

Apparently the SE/30 has a similar problem as it has used the asm
implementation since before git. This patch extends that solution to
other systems with a similar ROM.

After this patch, the only systems still using the C implementation are
68040 systems where adb_type is either MAC_ADB_IOP or MAC_ADB_II. This
implies a 1 MiB Quadra ROM.

This now includes the Quadra 900/950, which previously fell through to
the "should never get here" catch-all.

Reported-and-tested-by: Stan Johnson <userm57@yahoo.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/r/480ebd1249d229c6dc1f3f1c6d599b8505483fd8.1714797072.git.fthain@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/mac/misc.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/m68k/mac/misc.c b/arch/m68k/mac/misc.c
index c7cb29f0ff016..29e06f46ab511 100644
--- a/arch/m68k/mac/misc.c
+++ b/arch/m68k/mac/misc.c
@@ -451,30 +451,18 @@ void mac_poweroff(void)
 
 void mac_reset(void)
 {
-	if (macintosh_config->adb_type == MAC_ADB_II &&
-	    macintosh_config->ident != MAC_MODEL_SE30) {
-		/* need ROMBASE in booter */
-		/* indeed, plus need to MAP THE ROM !! */
-
-		if (mac_bi_data.rombase == 0)
-			mac_bi_data.rombase = 0x40800000;
-
-		/* works on some */
-		rom_reset = (void *) (mac_bi_data.rombase + 0xa);
-
-		local_irq_disable();
-		rom_reset();
 #ifdef CONFIG_ADB_CUDA
-	} else if (macintosh_config->adb_type == MAC_ADB_EGRET ||
-	           macintosh_config->adb_type == MAC_ADB_CUDA) {
+	if (macintosh_config->adb_type == MAC_ADB_EGRET ||
+	    macintosh_config->adb_type == MAC_ADB_CUDA) {
 		cuda_restart();
+	} else
 #endif
 #ifdef CONFIG_ADB_PMU
-	} else if (macintosh_config->adb_type == MAC_ADB_PB2) {
+	if (macintosh_config->adb_type == MAC_ADB_PB2) {
 		pmu_restart();
+	} else
 #endif
-	} else if (CPU_IS_030) {
-
+	if (CPU_IS_030) {
 		/* 030-specific reset routine.  The idea is general, but the
 		 * specific registers to reset are '030-specific.  Until I
 		 * have a non-030 machine, I can't test anything else.
@@ -522,6 +510,18 @@ void mac_reset(void)
 		    "jmp %/a0@\n\t" /* jump to the reset vector */
 		    ".chip 68k"
 		    : : "r" (offset), "a" (rombase) : "a0");
+	} else {
+		/* need ROMBASE in booter */
+		/* indeed, plus need to MAP THE ROM !! */
+
+		if (mac_bi_data.rombase == 0)
+			mac_bi_data.rombase = 0x40800000;
+
+		/* works on some */
+		rom_reset = (void *)(mac_bi_data.rombase + 0xa);
+
+		local_irq_disable();
+		rom_reset();
 	}
 
 	/* should never get here */
-- 
2.43.0



