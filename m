Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E9D50AC16;
	Wed, 30 Sep 2026 15:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783472; cv=none; b=ZEmE8/AsYuWZ78Ujb0180GhaMz4rgrLnveILv/8+XyZu1Psht+Uo9tgUc5V0xc1OFvdfWTtXOc92/quW3AhEO4q6LZOAoE8dZ79Y22qh/kp8eY/MPaSZJaIH2bhI8jsaQQGmF8dtrEhJ4qPJ8R/zy4dEzhgTvxuplzFSy0wWTRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783472; c=relaxed/simple;
	bh=oaTTwQufGh+kTGAmMTVY5WqfPcDks3uGsoyMZtC+pEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7FPx6tHBQVnsk1XH4mb2l7XlY2ZCYA0VD64w+dnPrIvfONwsYFvCfgVXhmRR0uPTFdbCk7Tx94LEgjyX9cRN4z6d7QmWmeyTqdC6doz2tVTgPLEJMcyVRjXmMrfbxFo/olXwTpE/7uZmuKkDWIfcqqrg9sflBgVK13X4Ii4sq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=os84E+f5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="os84E+f5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795DF1F00898;
	Wed, 30 Sep 2026 15:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783467;
	bh=ccwElL4w9QCle9M6CO2EGtbVxgSoQfT+F5VcECVhTYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=os84E+f5Ngz+MmWSOlZBXehdbYbJquPyulG3Z8u1xMZxKD9/cJ9404rWZNBOq8KUD
	 O+gLYMcGA32FvdXVcQ9uq9giAwRDrWRLv/LgrcDp1D6r99ffI0t4qlCFEmGNmY+mXr
	 +VXwXGKmKdmGxbLkCnQEIQVhFI5FiNQ8xkdemAxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 410/595] ASoC: ux500: Parenthesize MSP_{RX,TX}_CLKPOL_BIT() arguments
Date: Wed, 30 Sep 2026 17:25:03 +0200
Message-ID: <20260930152356.495509785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

[ Upstream commit 11fc0048a6930f4fca44fe3bd16a0023e78846a2 ]

arm allmodconfig fails to build with gcc:

  In file included from sound/soc/ux500/ux500_msp_i2s.c:20:
  sound/soc/ux500/ux500_msp_i2s.h:151:38: error: suggest parentheses
  around arithmetic in operand of '^' [-Werror=parentheses]
  sound/soc/ux500/ux500_msp_i2s.c:204:21: note: in expansion of macro
  'MSP_TX_CLKPOL_BIT'
  cc1: all warnings being treated as errors

The macros never parenthesized their argument:

  #define MSP_TX_CLKPOL_BIT(n)  ((n & TCKPOL_MASK) << TCKPOL_SHIFT)

That went unnoticed while every caller passed a plain variable, but
configure_protocol() now passes an XOR expression, which binds as
"a ^ (b & MASK)" rather than "(a ^ b) & MASK", and gcc rightly
complains.

No functional change: tx_clk_pol and rx_clk_pol only ever hold
MSP_FALLING_EDGE (0) or MSP_RISING_EDGE (1), and bclk_inverted is a
bool, so masking before or after the XOR gives the same 0/1 result.
Parenthesize the argument anyway - it fixes the build and stops the
macros from silently mis-evaluating a future composite argument.

Fixes: 9ccbacf5a012 ("ASoC: ux500: Validate MSP DAI configuration")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609051547.G9SJp8UQ-lkp@intel.com/
Assisted-by: LLM
Signed-off-by: Sasha Levin <sashal@kernel.org>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260913173132.1172003-1-sashal@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ux500/ux500_msp_i2s.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/ux500/ux500_msp_i2s.h b/sound/soc/ux500/ux500_msp_i2s.h
index 28a90207a4cb5..4e4f140912f9b 100644
--- a/sound/soc/ux500/ux500_msp_i2s.h
+++ b/sound/soc/ux500/ux500_msp_i2s.h
@@ -149,8 +149,8 @@ enum msp_direction {
 #define RCKPOL_MASK		BIT(0)
 #define TCKPOL_MASK		BIT(0)
 #define SPICKM_MASK		(BIT(1) | BIT(0))
-#define MSP_RX_CLKPOL_BIT(n)     ((n & RCKPOL_MASK) << RCKPOL_SHIFT)
-#define MSP_TX_CLKPOL_BIT(n)     ((n & TCKPOL_MASK) << TCKPOL_SHIFT)
+#define MSP_RX_CLKPOL_BIT(n)     (((n) & RCKPOL_MASK) << RCKPOL_SHIFT)
+#define MSP_TX_CLKPOL_BIT(n)     (((n) & TCKPOL_MASK) << TCKPOL_SHIFT)
 
 #define P1ELEN_SHIFT		0
 #define P1FLEN_SHIFT		3
-- 
2.53.0



