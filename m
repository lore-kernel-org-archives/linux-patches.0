Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE796A03B;
	Tue, 23 Jan 2024 02:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975338; cv=none; b=qghvLBR0dHxA1fCWQkAe69FcuothPfXLmWAyjbqom4lfe4nkUSIBqEvPt78OXbdDANYmf+2Sypfy/gLfNKNnh/eytTn5jPtFNZ5EThZ7vAEVgiAAptnDa+bQeng2HFhZ2bC+oNnexUMlhp9PtwTIkjT8ASLijBJ3OvgWEKleguY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975338; c=relaxed/simple;
	bh=lwn6LdBRTKi8k+ei37LrVkzkXqKK17/La9l4R5NXrxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMERKXp/GOCWyZHx6dmZhDSZgSTKPvEUScbcmX2mlZp3xHKu4fJ+y4UAORRQkWMMBZ0s2LbwEK+qw+9IEfNjL0ozLr/nTKDmVi1lwEG5tPDbid5Z4gsjSZLp7jsPYCjyM1z1kyLUqNANI2KpkfYhNfRE4qKFx1GQCIIqpZOzVt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRAToSMG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRAToSMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12EF6C43390;
	Tue, 23 Jan 2024 02:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975338;
	bh=lwn6LdBRTKi8k+ei37LrVkzkXqKK17/La9l4R5NXrxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRAToSMGstVTydYem3gsmQpbO9eRnWh8CT9CMiBajK8LAQkLAo/6zzIn1hilUSlJ5
	 RgEEL0JzrsJdYKHDqhv53Nty53cMVPBx1/h5sYzhj7ePSejqNHZgbQeJdoxyX2yl8N
	 f1Wa9qP6/rhUBIOuwELJw/IOI63cSbz5gtBacGmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Buddhabhatti <jay.buddhabhatti@amd.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 299/583] drivers: clk: zynqmp: update divider round rate logic
Date: Mon, 22 Jan 2024 15:55:50 -0800
Message-ID: <20240122235821.166767595@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jay Buddhabhatti <jay.buddhabhatti@amd.com>

[ Upstream commit 1fe15be1fb613534ecbac5f8c3f8744f757d237d ]

Currently zynqmp divider round rate is considering single parent and
calculating rate and parent rate accordingly. But if divider clock flag
is set to SET_RATE_PARENT then its not trying to traverse through all
parent rate and not selecting best parent rate from that. So use common
divider_round_rate() which is traversing through all clock parents and
its rate and calculating proper parent rate.

Fixes: 3fde0e16d016 ("drivers: clk: Add ZynqMP clock driver")
Signed-off-by: Jay Buddhabhatti <jay.buddhabhatti@amd.com>
Link: https://lore.kernel.org/r/20231129112916.23125-3-jay.buddhabhatti@amd.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/zynqmp/divider.c | 66 +++---------------------------------
 1 file changed, 5 insertions(+), 61 deletions(-)

diff --git a/drivers/clk/zynqmp/divider.c b/drivers/clk/zynqmp/divider.c
index 33a3b2a22659..5a00487ae408 100644
--- a/drivers/clk/zynqmp/divider.c
+++ b/drivers/clk/zynqmp/divider.c
@@ -110,52 +110,6 @@ static unsigned long zynqmp_clk_divider_recalc_rate(struct clk_hw *hw,
 	return DIV_ROUND_UP_ULL(parent_rate, value);
 }
 
-static void zynqmp_get_divider2_val(struct clk_hw *hw,
-				    unsigned long rate,
-				    struct zynqmp_clk_divider *divider,
-				    u32 *bestdiv)
-{
-	int div1;
-	int div2;
-	long error = LONG_MAX;
-	unsigned long div1_prate;
-	struct clk_hw *div1_parent_hw;
-	struct zynqmp_clk_divider *pdivider;
-	struct clk_hw *div2_parent_hw = clk_hw_get_parent(hw);
-
-	if (!div2_parent_hw)
-		return;
-
-	pdivider = to_zynqmp_clk_divider(div2_parent_hw);
-	if (!pdivider)
-		return;
-
-	div1_parent_hw = clk_hw_get_parent(div2_parent_hw);
-	if (!div1_parent_hw)
-		return;
-
-	div1_prate = clk_hw_get_rate(div1_parent_hw);
-	*bestdiv = 1;
-	for (div1 = 1; div1 <= pdivider->max_div;) {
-		for (div2 = 1; div2 <= divider->max_div;) {
-			long new_error = ((div1_prate / div1) / div2) - rate;
-
-			if (abs(new_error) < abs(error)) {
-				*bestdiv = div2;
-				error = new_error;
-			}
-			if (divider->flags & CLK_DIVIDER_POWER_OF_TWO)
-				div2 = div2 << 1;
-			else
-				div2++;
-		}
-		if (pdivider->flags & CLK_DIVIDER_POWER_OF_TWO)
-			div1 = div1 << 1;
-		else
-			div1++;
-	}
-}
-
 /**
  * zynqmp_clk_divider_round_rate() - Round rate of divider clock
  * @hw:			handle between common and hardware-specific interfaces
@@ -174,6 +128,7 @@ static long zynqmp_clk_divider_round_rate(struct clk_hw *hw,
 	u32 div_type = divider->div_type;
 	u32 bestdiv;
 	int ret;
+	u8 width;
 
 	/* if read only, just return current value */
 	if (divider->flags & CLK_DIVIDER_READ_ONLY) {
@@ -193,23 +148,12 @@ static long zynqmp_clk_divider_round_rate(struct clk_hw *hw,
 		return DIV_ROUND_UP_ULL((u64)*prate, bestdiv);
 	}
 
-	bestdiv = zynqmp_divider_get_val(*prate, rate, divider->flags);
-
-	/*
-	 * In case of two divisors, compute best divider values and return
-	 * divider2 value based on compute value. div1 will  be automatically
-	 * set to optimum based on required total divider value.
-	 */
-	if (div_type == TYPE_DIV2 &&
-	    (clk_hw_get_flags(hw) & CLK_SET_RATE_PARENT)) {
-		zynqmp_get_divider2_val(hw, rate, divider, &bestdiv);
-	}
+	width = fls(divider->max_div);
 
-	if ((clk_hw_get_flags(hw) & CLK_SET_RATE_PARENT) && divider->is_frac)
-		bestdiv = rate % *prate ? 1 : bestdiv;
+	rate = divider_round_rate(hw, rate, prate, NULL, width, divider->flags);
 
-	bestdiv = min_t(u32, bestdiv, divider->max_div);
-	*prate = rate * bestdiv;
+	if (divider->is_frac && (clk_hw_get_flags(hw) & CLK_SET_RATE_PARENT) && (rate % *prate))
+		*prate = rate;
 
 	return rate;
 }
-- 
2.43.0



