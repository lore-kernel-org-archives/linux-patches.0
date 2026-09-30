Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4775C51A73A;
	Wed, 30 Sep 2026 17:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788502; cv=none; b=PfLegg+neDNF02UYPJZo7B6eMZ501R6SOeS3g+l+S+GbQ9Qm55i7MUAgnT/kp4SQ1NJdOyNLyVuTnVsBwwUdgNBsAJP0+Fmr8MELXTgKHLjFHbmTupbmB+ldMjzo5F+SeTSU6wCGw8NSwzkkbjMlZJgBw5nEGiQ/Y4UYXCY1EKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788502; c=relaxed/simple;
	bh=ph1HNox1FPh7IcjrMKujtiuUz0PAF16ZczJLzB5Tk/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWzxw7hWGnZnpQrUNncy4X2jx9SJwNIlHMQMJOFxfrwZwvTftL616XHbBzpqUtNShQAWzyySSTkB2ry8/iBS53HRLzVcZv6tzLEYe1fZRZC6qPY5PYd87cu508LBhTtQA1tZrwuSy+g06ix7HwKqeguEPZp7X3c1NKS92clNNwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1cuQ5a4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1cuQ5a4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7421F000FF;
	Wed, 30 Sep 2026 17:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788501;
	bh=4qCWZSClnl5tDNhvgkyRVcT4pwiCNj+Ae8iVxvuBs2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i1cuQ5a4YmCenPw8AxQGSZNtK9VJUy/MJEX+WYYFKKXxidzCbFn5F2R3guwWwX4rA
	 fjXdz4NzAUKirjcy5D/BlS8/cXZhQ8Uyu+pPvdj7ECEevKriMPCBMVD6y3aUKM7/77
	 BDbC3ZRrB43rtxX0SiN6/osvXPxjorkaiRlfgCUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 146/877] ASoC: ux500: Parenthesize MSP_{RX,TX}_CLKPOL_BIT() arguments
Date: Wed, 30 Sep 2026 17:17:37 +0200
Message-ID: <20260930152417.875245109@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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



