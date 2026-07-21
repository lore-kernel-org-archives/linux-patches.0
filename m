Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0C33B71A0;
	Tue, 21 Jul 2026 20:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666207; cv=none; b=Pywhne3vz4QfkPuskUcUNiSh/cj4ms+PBrrGguPfJC7A7gRt1dXb9zY4dSJKQd5aXqIEFaY8TJ2W8+xcuJC+MRRSg1yxwxzWrK1HlvuoXSY9533jtojRtm7SjD7bD6yJW4IOcmJDDAUcjuH2sXb3dingFD13ImnlzFebfCnQSqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666207; c=relaxed/simple;
	bh=h9wBJ/caplwJ9TPz2seXLCyHeHy2wRjdH632vZ1EK/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2KKZ/wIYCNElZrc6YTKXNYM8/yWN6zmfnK0xjBcV3qy5vORG3vkIyurouOga642iDKugK8ZUKn4BLG+EUK/9mbw6M3TR1T+k27zYsNnXC5Z0k5OBPe/ELgwXqFHn4C1RDmemeerTEQwQeeRR2RUKty4iUhcjfyBLoaKoQc6OM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rgai/g6P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rgai/g6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFB91F00A3D;
	Tue, 21 Jul 2026 20:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666203;
	bh=i4J2K18zzQCmvNeWpv2FgDn/1ehK/v2kiTn0QQxLBK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rgai/g6PIQirgQN+63+o1+yyiqj2zV+DopE44mufeUZF5Wi7XULFok0bS0c0qlvtE
	 hqLB6FktRavi9O/O+MrnsHr4bStFb+sDIulL6jkGpbbxFaeB5jPsy4ZDVKYbzT288C
	 yt/i896S0w9W3yHcDnY05hc4utXbXxApIwXRVl4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yadan Fan <ydfan@suse.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0592/1266] MIPS: mm: Fix out-of-bounds write in maar_res_walk()
Date: Tue, 21 Jul 2026 17:17:09 +0200
Message-ID: <20260721152455.113137541@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index 6e368a4658b544..de3713b42cbc2d 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -281,9 +281,15 @@ static int maar_res_walk(unsigned long start_pfn, unsigned long nr_pages,
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
 
@@ -292,9 +298,7 @@ static int maar_res_walk(unsigned long start_pfn, unsigned long nr_pages,
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



