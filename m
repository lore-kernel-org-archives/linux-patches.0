Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CC82144C0;
	Thu, 12 Dec 2024 16:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022656; cv=none; b=Kk/U1cATw6ycSufecS3n8JNvXey4YYp8zuudrty+icco9rjSSwTDFXBjRU9+DVeNpRmlwnB/WcQ32G+8b05A2oqEqya/9Do9tHoXmvuGu1d64tYPEteNLnmKGB6qAsP2otGsAbJW70DAEui7vuXusxF2M/QPV/I3G1xJlji0RZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022656; c=relaxed/simple;
	bh=C7/Wv+YAdr8+JXUcUk0L1FIb9+vMnA+2ccs/w7VIQ6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8qIgfv2zecb/qAL5CX+mtaC2xVBCXQp/jcOo2XABI4bCOthPnGvkT4MpjV4R/JHwDO1p6Fw0JezGZX2bNZ9WefQfzxl5Oi5nVy2OwKfZ/2LGccRymiEiUnTkO0+BUH0XXOpBlCyV4WNU6oFRJOvoatb3wvtkjCHTl9W6+YedjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9764gVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9764gVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3EBC4CED0;
	Thu, 12 Dec 2024 16:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022655;
	bh=C7/Wv+YAdr8+JXUcUk0L1FIb9+vMnA+2ccs/w7VIQ6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9764gVCzsatZATbgJISxS9WPQPZlYXLYN6X3XpcrsljtZZXY2JbTszgHDED6s6ib
	 F+IjwT5d0vHxqAJzTbi8u0NJUfiefhKEC+4k0zff13t22hQIVk5uW6m2DsaXdV56YA
	 XC2umFtI1fZosYVZTxlA3iytCKUWits49rcqBsoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Guittet <jguittet.opensource@witekio.com>
Subject: [PATCH 5.15 300/565] Revert "drivers: clk: zynqmp: update divider round rate logic"
Date: Thu, 12 Dec 2024 15:58:15 +0100
Message-ID: <20241212144323.324639672@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joel Guittet <jguittet@witekio.com>

This reverts commit 9117fc44fd3a9538261e530ba5a022dfc9519620 which is
commit 1fe15be1fb613534ecbac5f8c3f8744f757d237d upstream.

It is reported to cause regressions in the 5.15.y tree, so revert it for
now.

Link: https://www.spinics.net/lists/kernel/msg5397998.html
Signed-off-by: Joel Guittet <jguittet.opensource@witekio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/zynqmp/divider.c |   66 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 61 insertions(+), 5 deletions(-)

--- a/drivers/clk/zynqmp/divider.c
+++ b/drivers/clk/zynqmp/divider.c
@@ -110,6 +110,52 @@ static unsigned long zynqmp_clk_divider_
 	return DIV_ROUND_UP_ULL(parent_rate, value);
 }
 
+static void zynqmp_get_divider2_val(struct clk_hw *hw,
+				    unsigned long rate,
+				    struct zynqmp_clk_divider *divider,
+				    u32 *bestdiv)
+{
+	int div1;
+	int div2;
+	long error = LONG_MAX;
+	unsigned long div1_prate;
+	struct clk_hw *div1_parent_hw;
+	struct zynqmp_clk_divider *pdivider;
+	struct clk_hw *div2_parent_hw = clk_hw_get_parent(hw);
+
+	if (!div2_parent_hw)
+		return;
+
+	pdivider = to_zynqmp_clk_divider(div2_parent_hw);
+	if (!pdivider)
+		return;
+
+	div1_parent_hw = clk_hw_get_parent(div2_parent_hw);
+	if (!div1_parent_hw)
+		return;
+
+	div1_prate = clk_hw_get_rate(div1_parent_hw);
+	*bestdiv = 1;
+	for (div1 = 1; div1 <= pdivider->max_div;) {
+		for (div2 = 1; div2 <= divider->max_div;) {
+			long new_error = ((div1_prate / div1) / div2) - rate;
+
+			if (abs(new_error) < abs(error)) {
+				*bestdiv = div2;
+				error = new_error;
+			}
+			if (divider->flags & CLK_DIVIDER_POWER_OF_TWO)
+				div2 = div2 << 1;
+			else
+				div2++;
+		}
+		if (pdivider->flags & CLK_DIVIDER_POWER_OF_TWO)
+			div1 = div1 << 1;
+		else
+			div1++;
+	}
+}
+
 /**
  * zynqmp_clk_divider_round_rate() - Round rate of divider clock
  * @hw:			handle between common and hardware-specific interfaces
@@ -128,7 +174,6 @@ static long zynqmp_clk_divider_round_rat
 	u32 div_type = divider->div_type;
 	u32 bestdiv;
 	int ret;
-	u8 width;
 
 	/* if read only, just return current value */
 	if (divider->flags & CLK_DIVIDER_READ_ONLY) {
@@ -148,12 +193,23 @@ static long zynqmp_clk_divider_round_rat
 		return DIV_ROUND_UP_ULL((u64)*prate, bestdiv);
 	}
 
-	width = fls(divider->max_div);
+	bestdiv = zynqmp_divider_get_val(*prate, rate, divider->flags);
+
+	/*
+	 * In case of two divisors, compute best divider values and return
+	 * divider2 value based on compute value. div1 will  be automatically
+	 * set to optimum based on required total divider value.
+	 */
+	if (div_type == TYPE_DIV2 &&
+	    (clk_hw_get_flags(hw) & CLK_SET_RATE_PARENT)) {
+		zynqmp_get_divider2_val(hw, rate, divider, &bestdiv);
+	}
 
-	rate = divider_round_rate(hw, rate, prate, NULL, width, divider->flags);
+	if ((clk_hw_get_flags(hw) & CLK_SET_RATE_PARENT) && divider->is_frac)
+		bestdiv = rate % *prate ? 1 : bestdiv;
 
-	if (divider->is_frac && (clk_hw_get_flags(hw) & CLK_SET_RATE_PARENT) && (rate % *prate))
-		*prate = rate;
+	bestdiv = min_t(u32, bestdiv, divider->max_div);
+	*prate = rate * bestdiv;
 
 	return rate;
 }


