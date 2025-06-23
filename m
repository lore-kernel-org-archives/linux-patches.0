Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1166219E0;
	Mon, 23 Jun 2025 13:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684725; cv=none; b=QiHEruheS23dZpnN+nQTazY0ABtzBCwrVjslb14Vh5WuIBmpuqRWac7EwQ/0Pu2a+kK4yfIuZJsmdU5DlL52ZPQsQWnsCSXJAnhayh9F6RxHdcrKo/c2Bjvqgg17rgEXh4a3onoK6m21P7EAogfDui8oy+faca8zHeV4hgjVKxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684725; c=relaxed/simple;
	bh=IgW28ZByBE1hX0H6jVIs7eA+vQ81JXfS6Tmhlz8DR4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYe30kCoU5rcD524UFQxEYVdN8JfFp9+HwNwB0fD51EUuG5tyi6bT51LKT3lp9aIuvoHUWU5xA7hktQC9kLPG7ygs5d9twyAe1AaM0XAc6GFk8q3s5+MYn40FyxkwmWl7CrPhxyN/pBiPADisGxgzlL5oBFoJ5uucEESELRAv3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFcXMIGW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFcXMIGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2A1C4CEEA;
	Mon, 23 Jun 2025 13:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684725;
	bh=IgW28ZByBE1hX0H6jVIs7eA+vQ81JXfS6Tmhlz8DR4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFcXMIGWsmlIsAg8nsjplPLgJtrjNAORRygbc6hGU6ME38VEXc3qHec6AHJFZ3DGt
	 J5mX7QO+cuYRWmX1WhwypFl1OKG75TmBHM6c+PxXWZUwnRylhv5hNN9jDLJWjlyvHR
	 K/z9jes0gmSvLXF6Y3LrztEkERqomYIcots75yfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaqing Zhao <jiaqing.zhao@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 016/222] x86/mtrr: Check if fixed-range MTRRs exist in mtrr_save_fixed_ranges()
Date: Mon, 23 Jun 2025 15:05:51 +0200
Message-ID: <20250623130612.390964915@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaqing Zhao <jiaqing.zhao@linux.intel.com>

[ Upstream commit 824c6384e8d9275d4ec7204f3f79a4ac6bc10379 ]

When suspending, save_processor_state() calls mtrr_save_fixed_ranges()
to save fixed-range MTRRs.

On platforms without fixed-range MTRRs like the ACRN hypervisor which
has removed fixed-range MTRR emulation, accessing these MSRs will
trigger an unchecked MSR access error. Make sure fixed-range MTRRs are
supported before access to prevent such error.

Since mtrr_state.have_fixed is only set when MTRRs are present and
enabled, checking the CPU feature flag in mtrr_save_fixed_ranges() is
unnecessary.

Fixes: 3ebad5905609 ("[PATCH] x86: Save and restore the fixed-range MTRRs of the BSP when suspending")
Signed-off-by: Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/20250509170633.3411169-2-jiaqing.zhao@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mtrr/generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 4ea906fe1c351..d15152126877b 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -350,7 +350,7 @@ static void get_fixed_ranges(mtrr_type *frs)
 
 void mtrr_save_fixed_ranges(void *info)
 {
-	if (boot_cpu_has(X86_FEATURE_MTRR))
+	if (mtrr_state.have_fixed)
 		get_fixed_ranges(mtrr_state.fixed_ranges);
 }
 
-- 
2.39.5



