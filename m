Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62C9334C3B;
	Wed, 23 Sep 2026 14:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173276; cv=none; b=NV4Qm27YxFqCXL9oJvnztLRVI/WYKtNYFEjwnIysWro+ZFYzk8QtvM1CflvELJ1YjC2HPqwnfVU9rBvjMr1LS/sJTKy0zOGYxsbqX7aMIUfjuCSWWKeLzQYo5Z9p1L6yDppeDIqj390TTaqziLYe3s5RoonKrmHGMIPORxAI0MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173276; c=relaxed/simple;
	bh=ynq5CWLisF17ORhiia5Kl+RwkJ6eDpPUyUfJy3nEvH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJxK11B/0RAT6CE1XHPs6r3AbBP+yWiT0mv7o98p+GOK089H6umrTWEDaJc4Z0J4XVdyWBrWO7D9jSOw4GQIxpXnXbYRzP9eC4mwhZG9huKBqZlP/DmNKVyF0UocyqhyTyv5Ybo5XsYgynYJRBx4kWOC4CNzJ5SP7af/VMF7X2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0cSR0io9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0cSR0io9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26321F000FF;
	Wed, 23 Sep 2026 14:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173275;
	bh=qXVCEHhiHG0tbdxHFOpxAqcCOzLd+ZJ4HQU/RmF3vi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0cSR0io9llfgV5KzT217wXodZbe14ZJTJ3e1mX+zI1TrV/DZ0fjVDS4IoaPlLB89c
	 XvlHibWE4CTJ7gmym/95MtzfTEd1cz+uY2ENZT+6paAFhbo7OPGJIIZVJOBXeZSi/5
	 XSWNe40ZF419996VjLPLxjbAXSsOEPY8rkn5Xem8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 197/438] ASoC: ux500: Parenthesize MSP_{RX,TX}_CLKPOL_BIT() arguments
Date: Wed, 23 Sep 2026 16:03:38 +0200
Message-ID: <20260923140649.864065637@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 2bf2699bdc49f..c66ef455e1380 100644
--- a/sound/soc/ux500/ux500_msp_i2s.h
+++ b/sound/soc/ux500/ux500_msp_i2s.h
@@ -147,8 +147,8 @@ enum msp_direction {
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



