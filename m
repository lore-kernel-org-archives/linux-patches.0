Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF6C2D94AF;
	Mon, 13 Apr 2026 16:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096653; cv=none; b=cUX8Q9DGy2pgtM/Qi3r/qB7yHwK8XKBZKj21wyfFG7Uul6ADCMqdbgTGWkiMuXTinX7xUddUSSBy9k2Y7DL6WYI38+do7dSldEhcJZBuC56w2fJcqejptmaSwWEvdYYzZ0ghjoSoHFV9xw9VT4zDqAokErahpwPuyse8IoidzKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096653; c=relaxed/simple;
	bh=ijGBOI9tIdZ/wvyXCVBVoovvhkzSktqAiWwJdVFCAMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArD9GV4jseB4vfxV24LDK2qJfBfrsYR1gpcgboVVvDAvErUyIGNtOhN2Kj23U3pzPLiO76TEX+4kHlnu+oK8irVVte/SoTbPZLemJh5wmnjtapBgmbAjyd/BNROEbRSqPUOts665FJlHQr08upQyqUdYZlJEyDzRv8GHuMa3zAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pkXVuKd6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pkXVuKd6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E92C2BCAF;
	Mon, 13 Apr 2026 16:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096653;
	bh=ijGBOI9tIdZ/wvyXCVBVoovvhkzSktqAiWwJdVFCAMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pkXVuKd64j/ZtulwzJq9Ex3s4E9yc9WDWji6aXYfs46zPFeZ63614eCpRbu+H42II
	 w1qmtw9RQKx7Fpa2Igq/AM4Nu9B1Vem8vkYnAaF8LpF8gKG7JXafuFAEWw+l8lyC0a
	 flNXhpCFgeUyf3LhG9m1cfwiq97rWKr2UeWSy/BI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 11/70] MIPS: mm: Suppress TLB uniquification on EHINV hardware
Date: Mon, 13 Apr 2026 18:00:06 +0200
Message-ID: <20260413155728.607160933@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 74283cfe216392c7b776ebf6045b5b15ed9dffcd upstream.

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
index 645f77e09d5b8..65f0357958fc7 100644
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



