Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD93331A41;
	Mon,  6 Apr 2026 11:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775473558; cv=none; b=tqm95zkwj9T+uFTAho9v8nNoxkaK6v6CuZdeiZGxWn4elHBlpyHfg2U+tvH0waceeHo7HW9eXb0z3wwt7R7kNX0fhQnNaeenG1zwBTa7IuhGGNWhqyZTiZViuo4bA+mKkw6nEGtdS7tHEkveOOfsWAjFuNp4QJkCJj8AKg1r7S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775473558; c=relaxed/simple;
	bh=GF9J9vpWFVIBF4raC9wLtC1QxUxzDdkVQpZiaEy7ESs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njMMSXW6OKvTW6ck6T47cerzA9MEgO7V6wx5MQ1HA6skgizCpdm91hrJ9A4UiHc9rQBK+9BNyNKUKLkyrAM7ns9zoRKMRrMM4OwFa+0uug8Idgg6i7/3vlt7mA9jBpoV52VGSePXqwRrCvnWzYbFpO88OzlQURXve8DFN8IjSss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GGGAF5QJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GGGAF5QJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2113BC19425;
	Mon,  6 Apr 2026 11:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775473557;
	bh=GF9J9vpWFVIBF4raC9wLtC1QxUxzDdkVQpZiaEy7ESs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GGGAF5QJiDPGbh9+ATaluyOgvvc1tylCmSjFydq5Tc8jX2QBjhyimLqphg4LnTJ+3
	 QVtY14aR+5kBd06WJhUNW3YHBBrEJ4tRhd8LmoZ4wR38IzWBeU1MCgIetSzsHI17eJ
	 CJ6/GUl4zDO3gJbhMN3eQxeXKchmT+aaF8KjBY9dO8WyBczGJURiLf9bQhIngLv3pO
	 CZiFTv9Al3Pb+H/66OrcIpN0WRVv8P9dhXcuMhcAr4ifSdIVGDA4cM5qlMkjaAK+pY
	 gmggP0CiwxrDw4nU8veQJTQvEobVSvxslGeixf2WdZLJzeY9wEVS4d1A2RbGBQMuCN
	 n/6FSb2h1HeCA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>,
	linux-mips@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] MIPS: mm: Suppress TLB uniquification on EHINV hardware
Date: Mon,  6 Apr 2026 07:05:37 -0400
Message-ID: <20260406110553.3783076-3-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406110553.3783076-1-sashal@kernel.org>
References: <20260406110553.3783076-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.11
Content-Transfer-Encoding: 8bit

From: "Maciej W. Rozycki" <macro@orcam.me.uk>

[ Upstream commit 74283cfe216392c7b776ebf6045b5b15ed9dffcd ]

Hardware that supports the EHINV feature, mandatory for R6 ISA and FTLB
implementation, lets software mark TLB entries invalid, which eliminates
the need to ensure no duplicate matching entries are ever created.  This
feature is already used by local_flush_tlb_all(), via the UNIQUE_ENTRYHI
macro, making the preceding call to r4k_tlb_uniquify() superfluous.

The next change will also modify uniquification code such that it'll
become incompatible with the FTLB and MMID features, as well as MIPSr6
CPUs that do not implement 4KiB pages.

Therefore prevent r4k_tlb_uniquify() from being used on EHINV hardware,
as denoted by `cpu_has_tlbinv'.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/mm/tlb-r4k.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
index 44a662536148e..27bb644696047 100644
--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -640,7 +640,8 @@ static void r4k_tlb_configure(void)
 	temp_tlb_entry = current_cpu_data.tlbsize - 1;
 
 	/* From this point on the ARC firmware is dead.	 */
-	r4k_tlb_uniquify();
+	if (!cpu_has_tlbinv)
+		r4k_tlb_uniquify();
 	local_flush_tlb_all();
 
 	/* Did I tell you that ARC SUCKS?  */
-- 
2.53.0

