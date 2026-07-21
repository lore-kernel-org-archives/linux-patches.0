Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C2043D510;
	Tue, 21 Jul 2026 22:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673839; cv=none; b=e6ge6vx5IX1yvl2Qon0l0q8mBEk1w3PuC14msqN/73DdFYkZZWsewDywAElNigBhwBXZrrLG5kPmCkvLRSUijOHYwua+LejOzs8eZfVZ07YyLbGu/LF7yzMgWeRaIlYasT0P/+nfozQN/u5fA5Bniq78j+xpM95MqXGyzmTIUGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673839; c=relaxed/simple;
	bh=8rGYmSk5owK58SCjCDIztuWN94BN5pr23rGKXhbkeYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gECubxW/3krrL3C7+kut01jDb4SHNYn/wFWOV3ga4hIG/MgJ64GtVUq5eiwRcOkq4qyEdthTaKFkmTeXJnifkLvDS3TJFhzyynGgcDQYeVwsKG+6HvvXxfibk6ZF4IQ2z5xKaQcrBnO1o8WBbtUhRNHZIjsUtUCGWhutaxvrV6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b59QC5uJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b59QC5uJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1361F000E9;
	Tue, 21 Jul 2026 22:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673837;
	bh=h8sSbqaA7WidDJchwLoYmlzzveI4IeTEuOmP4sfTtqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b59QC5uJy2jTJpWzPfeYs1GThgmXus8EK1JNdIjFhauf9oWkB74W1IuFI6J0+q7ZS
	 Ssoj3MTISPemKG3HWWCZyb8jRUJORBDXOjbV/M4Zfi05S/D5mlDbQXCNoxgRUDYuNv
	 Zs9/DSmpNuhxkSfHkvk1E21leBtE+jV5pssB/hzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yadan Fan <ydfan@suse.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 271/699] MIPS: mm: Fix out-of-bounds write in maar_res_walk()
Date: Tue, 21 Jul 2026 17:20:30 +0200
Message-ID: <20260721152401.813753405@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yadan Fan <ydfan@suse.com>

[ Upstream commit 1b001b16bc88f3f7817e228acfd91ee01bdcfcce ]

maar_res_walk() uses wi->num_cfg as the index into the fixed-size
wi->cfg array, but checks whether the array is full only after it has
filled the selected entry. If walk_system_ram_range() reports more than
16 memory ranges, the overflow call writes one struct maar_config past
the end of the array before WARN_ON() prevents num_cfg from advancing.

Move the full-array check before taking the array slot and return non-zero
when the scratch array is full, so walk_system_ram_range() terminates the
walk instead of invoking the callback for further ranges.

Fixes: a5718fe8f70f ("MIPS: mm: Drop boot_mem_map")

Signed-off-by: Yadan Fan <ydfan@suse.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/mm/init.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index 32e7b869a29105..bd819340d1ffae 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -277,9 +277,15 @@ static int maar_res_walk(unsigned long start_pfn, unsigned long nr_pages,
 			 void *data)
 {
 	struct maar_walk_info *wi = data;
-	struct maar_config *cfg = &wi->cfg[wi->num_cfg];
+	struct maar_config *cfg;
 	unsigned int maar_align;
 
+	/* Ensure we don't overflow the cfg array */
+	if (WARN_ON(wi->num_cfg >= ARRAY_SIZE(wi->cfg)))
+		return -1;
+
+	cfg = &wi->cfg[wi->num_cfg];
+
 	/* MAAR registers hold physical addresses right shifted by 4 bits */
 	maar_align = BIT(MIPS_MAAR_ADDR_SHIFT + 4);
 
@@ -288,9 +294,7 @@ static int maar_res_walk(unsigned long start_pfn, unsigned long nr_pages,
 	cfg->upper = ALIGN_DOWN(PFN_PHYS(start_pfn + nr_pages), maar_align) - 1;
 	cfg->attrs = MIPS_MAAR_S;
 
-	/* Ensure we don't overflow the cfg array */
-	if (!WARN_ON(wi->num_cfg >= ARRAY_SIZE(wi->cfg)))
-		wi->num_cfg++;
+	wi->num_cfg++;
 
 	return 0;
 }
-- 
2.53.0



