Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47A143FD0D;
	Tue, 21 Jul 2026 22:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671860; cv=none; b=DjSEjQB0JsOuUNRrcOyKrkbUR8xM3vw1Tul7i8SZtVVHvNSIiKalcv5S80if5y+q73Dbk2a3LgmF37Vx0edqlcKHb20z3mlpvAX2ES3Vz5aUsoju3AYbieEEkrm/3ZDajAA+tUwLxakG2SBfs6ihZmoy9GqBW7GbfDhUou/8gIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671860; c=relaxed/simple;
	bh=7OldnQYQHE4J6f94JmjVdjZ+AXnGT+iYTEMLGw2TG0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpA/g0o0sSeFRaywER8EHqeFsluGQ8RLUEfRVm3jh91EiXNbcbPTORPSp3P1UeaE6nZyTtq/BY+ygj1YcByl26EPA/NkGOCcjFV6efw+wL27rXCHHqusR+osoeS2UX3+JleTfCS3f0qkSJtLFzmGoUUKzyNfliQ3mIrcvoDlIlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T1w1iuCh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T1w1iuCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C641F00A3A;
	Tue, 21 Jul 2026 22:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671859;
	bh=VWFbMWhGYK2nscmpI3BCMEaDWXZu5Bz5akIMEC5pMkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T1w1iuChMPpwRZ+mn2rS4D0iHxVJ1i/4Xqz0xxLgs48TeGdxg4nbpeLP8Q0Qci6uJ
	 zS2luD/ke0VXZviX16I9AnY6onrQ9wgROcLOeiJchiXmBq1ScPSBV43FwBxLJkGXQH
	 l8+PzHn2dZndgRCxIjzMxG6dzKohnakmEhAnJTwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yadan Fan <ydfan@suse.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 363/843] MIPS: mm: Fix out-of-bounds write in maar_res_walk()
Date: Tue, 21 Jul 2026 17:19:58 +0200
Message-ID: <20260721152414.194848852@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 81fda8c583ae16..bf9037b662ac4f 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -276,9 +276,15 @@ static int maar_res_walk(unsigned long start_pfn, unsigned long nr_pages,
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
 
@@ -287,9 +293,7 @@ static int maar_res_walk(unsigned long start_pfn, unsigned long nr_pages,
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



