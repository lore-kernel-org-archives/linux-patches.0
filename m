Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A0E3DBD44;
	Wed, 30 Sep 2026 19:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796161; cv=none; b=BT87+5zguZMuK6B1YqYhRfYY4IF7tCAOmfCPgsv0m6t0XZDOQoFv71rsLKt5lYuM0RZdEwsjE/o6/dHEXF5WTBOmdaHgGOlc1PjsaYePegSXil+itaoyAfqaN3fNzCd2PQQdXamiWahe5ehuN4DpbZBTWyvgt1sPdoeI/prHyuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796161; c=relaxed/simple;
	bh=AerNgMihZWEonz8HUuvisorfS0sdsQYOgvhAXhmCVO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3p2tXrLbfo8+DvxxrIY42GobT7gohxtlnqoiPwQ3M8tnN1DexkDwpMMU6xTku1WLBLoX5wpo8Va64yEKPDxKEJN7i05TcvkGJC69hgXchs9ldDeOUdh/yiYEx/RN3tkI9O+MXp3xKadcRFN6MeXFWj/zhKsmFqKGuACUpTHst8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LtpNXAEF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LtpNXAEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD341F000FF;
	Wed, 30 Sep 2026 19:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796159;
	bh=72NGPCNkR+iqpcXTvpd1PLFPClIi3TECLY/Ia/8uIM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LtpNXAEFFGyQwiADFqPVcC/HBguDIev6hR8rndljM95h7q7Mv+7dRb8GmVKy4cD7Q
	 QszbjH+ipt1xuIl8vQBi8ec9uHgGJqhbVUY949XLMe7HkkHyC7+TAooi+4nsOWq9wy
	 CqdFPDkkc6igDg7p6Vs7EO5jA215sBUhwnLEcIoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 0816/1193] ASoC: ux500: Parenthesize MSP_{RX,TX}_CLKPOL_BIT() arguments
Date: Wed, 30 Sep 2026 17:25:00 +0200
Message-ID: <20260930152452.373881725@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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



