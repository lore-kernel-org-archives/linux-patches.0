Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A2B1E89C;
	Tue, 27 May 2025 17:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366627; cv=none; b=qdTdUSIlMYtg3uNwV/D34ZFXsn2sOj98EUHg2X++U8PHlqQOhSovwwzyC5URYsGS7GEQH9jv9ihWh6IEeus4IF4f7lEPwrGQTJa6WDuTs7Zd7vlSW4B35EJAxLn5dgzquc8jb4Rk0u/4KSvJuxrQE/VEPAOaNr2alHGG2tgImFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366627; c=relaxed/simple;
	bh=t39FoV0CA4Omo/tGWUrpwxRywBb/wpdJyoQAuetdpEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aanzlNaCFhn3VArgRTTaHuRq8Kpp9iIJUdrca5IqcEPqIXuOO7I/azV7HAes8EQAHtqwmDzBZ2zXZrRf/aFZ74qkKYyK+FLjRc1xMoYBkaEE7ogcEnCB65kIn3nUq67PYOhjtw6xWDrwVUX5xPEf0/KpuIpgcSbiWMpNR7KjoxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XqlbWW28; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XqlbWW28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F10C4CEE9;
	Tue, 27 May 2025 17:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366627;
	bh=t39FoV0CA4Omo/tGWUrpwxRywBb/wpdJyoQAuetdpEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XqlbWW28PkeG4OCfcDaDIL/30CcUWFPzq0jsxLd9L9ZOqn9HgMsH4LASIrGzZky8q
	 wJtgWHrFXY2kjPx+By4ZTBieMrxFSI+xyw5a7No7xhiJ726wZPT0OfCqlNgRumf2nS
	 tV1/+/hAQBpZ4RcOosEQ1fX2WqjrPtM47xDkTP4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Redkin <me@rarity.fan>,
	Ingo Molnar <mingo@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Rik van Riel <riel@surriel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 130/783] x86/mm: Check return value from memblock_phys_alloc_range()
Date: Tue, 27 May 2025 18:18:47 +0200
Message-ID: <20250527162518.446960768@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Redkin <me@rarity.fan>

[ Upstream commit 631ca8909fd5c62b9fda9edda93924311a78a9c4 ]

At least with CONFIG_PHYSICAL_START=0x100000, if there is < 4 MiB of
contiguous free memory available at this point, the kernel will crash
and burn because memblock_phys_alloc_range() returns 0 on failure,
which leads memblock_phys_free() to throw the first 4 MiB of physical
memory to the wolves.

At a minimum it should fail gracefully with a meaningful diagnostic,
but in fact everything seems to work fine without the weird reserve
allocation.

Signed-off-by: Philip Redkin <me@rarity.fan>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Link: https://lore.kernel.org/r/94b3e98f-96a7-3560-1f76-349eb95ccf7f@rarity.fan
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/init.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 62aa4d66a032d..bfa444a7dbb04 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -645,8 +645,13 @@ static void __init memory_map_top_down(unsigned long map_start,
 	 */
 	addr = memblock_phys_alloc_range(PMD_SIZE, PMD_SIZE, map_start,
 					 map_end);
-	memblock_phys_free(addr, PMD_SIZE);
-	real_end = addr + PMD_SIZE;
+	if (!addr) {
+		pr_warn("Failed to release memory for alloc_low_pages()");
+		real_end = max(map_start, ALIGN_DOWN(map_end, PMD_SIZE));
+	} else {
+		memblock_phys_free(addr, PMD_SIZE);
+		real_end = addr + PMD_SIZE;
+	}
 
 	/* step_size need to be small so pgt_buf from BRK could cover it */
 	step_size = PMD_SIZE;
-- 
2.39.5



