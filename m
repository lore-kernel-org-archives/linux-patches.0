Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB662D73A4;
	Fri, 21 Nov 2025 13:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733055; cv=none; b=TbJsy1FXE9Vz7nts1cDTSPDZecwwGx5SMDK1aTA9jXFZnvhcKeP2gX4MY8Oc6dMckzw6UXshFPzbEiAMZrU/NhPlmVyzSBqIzLvK/NOs2x1bVDgN02qkIjfka+8MyiasK6S/LaiwdFxYIZXb9rvTv9bvXAKr1wpy5lnk5GK0zUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733055; c=relaxed/simple;
	bh=JObM2gwCZ5PcN24grPfCfHyfdRogqGGMCsHa9P4pHO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdBUITmDrPwHwXwID/ci+52IYgUZuG3l5zjnA+zSyl6vXx6S4RqFAVX7nuCI4Wq+RugIHOfark78AAS75ce5q2BvYa9WcDUVedCvwCx16iwu4KyEgzt+fUA5MR5sOBZAhvoSsaFdRQGzmsKmfy7yXen5gYqFa/hXmbWHm2Eeg+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dvPO3Zzg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dvPO3Zzg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B4AC4CEF1;
	Fri, 21 Nov 2025 13:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733055;
	bh=JObM2gwCZ5PcN24grPfCfHyfdRogqGGMCsHa9P4pHO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dvPO3ZzgU/X7HMzroBm4lqtc1eZ0/gALG0rI9+iRaPMggf5Vyg2UdiJWbjorieu73
	 THhyGHX02Wm9+Yf3WR3EqFTxipRLHqYBqNaRN6ul7qtRDcFoq9hGuPWvOnudXDqUNJ
	 DZj8HOqLJiOtpttsZHRk6uffC9ovOHQRyOdrzrDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josephine Pfeiffer <hi@josie.lol>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 335/529] riscv: ptdump: use seq_puts() in pt_dump_seq_puts() macro
Date: Fri, 21 Nov 2025 14:10:34 +0100
Message-ID: <20251121130242.951066351@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Josephine Pfeiffer <hi@josie.lol>

[ Upstream commit a74f038fa50e0d33b740f44f862fe856f16de6a8 ]

The pt_dump_seq_puts() macro incorrectly uses seq_printf() instead of
seq_puts(). This is both a performance issue and conceptually wrong,
as the macro name suggests plain string output (puts) but the
implementation uses formatted output (printf).

The macro is used in ptdump.c:301 to output a newline character. Using
seq_printf() adds unnecessary overhead for format string parsing when
outputting this constant string.

This bug was introduced in commit 59c4da8640cc ("riscv: Add support to
dump the kernel page tables") in 2020, which copied the implementation
pattern from other architectures that had the same bug.

Fixes: 59c4da8640cc ("riscv: Add support to dump the kernel page tables")
Signed-off-by: Josephine Pfeiffer <hi@josie.lol>
Link: https://lore.kernel.org/r/20251018170451.3355496-1-hi@josie.lol
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/ptdump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/mm/ptdump.c b/arch/riscv/mm/ptdump.c
index e9090b38f8117..52cc3d9380c08 100644
--- a/arch/riscv/mm/ptdump.c
+++ b/arch/riscv/mm/ptdump.c
@@ -22,7 +22,7 @@
 #define pt_dump_seq_puts(m, fmt)	\
 ({					\
 	if (m)				\
-		seq_printf(m, fmt);	\
+		seq_puts(m, fmt);	\
 })
 
 /*
-- 
2.51.0



