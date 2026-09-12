Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7856E3BE175;
	Sat, 12 Sep 2026 07:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196998; cv=none; b=oQyXPpO/k2YEGf+SatKRpD+ImFwm3vOxhD/qqejml3kgT+7nMgaLJB07i+vB+y25xuO8tx/4/3dUWcS/83hsm/LXpaTaPC71d86SIp/OHtxb1/BTvwSs7ck79MT10Qk3Xh5ILWIBaPd+NnPiCRp39duDgWZaqnFOrQbKcApYGwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196998; c=relaxed/simple;
	bh=NdfkfEjcn921V4phPNGNTkvUl1iJ42rtBZIOLVuUrsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDyfxv78Q2qtSjxmGQKPqBKEZ/4Rkff27I21sJZZ7Mj2hZs3gXOpyIYSNGt7B5mvYuZ6jecdMDkSZNw/q7xEh+pGrBw6T4OPmNAqnrrfXXxeqcrft7vt0sqlP4jn9EDBFE/kYk1hy+CKDS1bDuSwfLsGM1JgmxMLqvAg6H3cjfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mcjx6Khe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mcjx6Khe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746551F000FF;
	Sat, 12 Sep 2026 07:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196997;
	bh=s6SWAFzq1H4mznNragGE84z95Y2T8cR44YRgh8lk9ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mcjx6KheX2B+oi00IhWIjDvOoiRnASisD6YdOVUFmmpkY8zeQOroTLnAFwbn4/c/I
	 9GnLfloGL6ahe69ldi104k5uEfqtolI3U6WIocmWckEOp7sPDlP5sbnQl0EQDxWhtL
	 RyvXTyRARSZdXUaBCni4phzwx64iviseYuuls4I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Xukai Wang <kingxukai@zohomail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0079/1815] clk: canaan: Clear rate fields before reprogramming dividers
Date: Sat, 12 Sep 2026 08:30:29 +0200
Message-ID: <20260912065650.865823934@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 804bac4a2654ac69e328d68e1961eb984fb18a01 ]

The rate set_rate helpers perform a read-modify-write on the divider
and multiplier registers but only ever OR the new value in, without
first masking off the existing field. The first write after reset lands
on a zeroed field and looks correct, but any later reprogramming leaves
the old bits set: the field becomes the bitwise OR of the previous and
new encodings, corrupting the divider or multiplier.

Mask off each field before writing the new value so reprogramming a
clock to a different rate produces the intended register contents.

Fixes: a7b7c7c6c016 ("clk: canaan: Add clock driver for Canaan K230")
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Acked-by: Xukai Wang <kingxukai@zohomail.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-k230.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/clk/clk-k230.c b/drivers/clk/clk-k230.c
index cfc437038e4ed..f34a3e6d3bca0 100644
--- a/drivers/clk/clk-k230.c
+++ b/drivers/clk/clk-k230.c
@@ -2227,6 +2227,7 @@ static int k230_clk_set_rate_mul(struct clk_hw *hw, unsigned long rate,
 	guard(spinlock)(rate_self->lock);
 
 	mul_reg = readl(rate_self->reg + clk->mul_reg_off);
+	mul_reg &= ~(rate_self->mul_mask << rate_self->mul_shift);
 	mul_reg |= ((mul - 1) & rate_self->mul_mask) << (rate_self->mul_shift);
 	mul_reg |= BIT(rate_self->write_enable_bit);
 	writel(mul_reg, rate_self->reg + clk->mul_reg_off);
@@ -2257,6 +2258,7 @@ static int k230_clk_set_rate_div(struct clk_hw *hw, unsigned long rate,
 	guard(spinlock)(rate_self->lock);
 
 	div_reg = readl(rate_self->reg + clk->div_reg_off);
+	div_reg &= ~(rate_self->div_mask << rate_self->div_shift);
 	div_reg |= ((div - 1) & rate_self->div_mask) << (rate_self->div_shift);
 	div_reg |= BIT(rate_self->write_enable_bit);
 	writel(div_reg, rate_self->reg + clk->div_reg_off);
@@ -2287,11 +2289,13 @@ static int k230_clk_set_rate_mul_div(struct clk_hw *hw, unsigned long rate,
 	guard(spinlock)(rate_self->lock);
 
 	div_reg = readl(rate_self->reg + clk->div_reg_off);
+	div_reg &= ~(rate_self->div_mask << rate_self->div_shift);
 	div_reg |= ((div - 1) & rate_self->div_mask) << (rate_self->div_shift);
 	div_reg |= BIT(rate_self->write_enable_bit);
 	writel(div_reg, rate_self->reg + clk->div_reg_off);
 
 	mul_reg = readl(rate_self->reg + clk->mul_reg_off);
+	mul_reg &= ~(rate_self->mul_mask << rate_self->mul_shift);
 	mul_reg |= ((mul - 1) & rate_self->mul_mask) << (rate_self->mul_shift);
 	mul_reg |= BIT(rate_self->write_enable_bit);
 	writel(mul_reg, rate_self->reg + clk->mul_reg_off);
-- 
2.53.0



