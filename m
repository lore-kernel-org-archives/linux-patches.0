Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731E0470450;
	Fri,  9 Oct 2026 14:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556853; cv=none; b=AGSHm1c1OZ/BuGrqQfiaYf/v9UsUAKUJcK0Qndt6ywaH8uYNLuUXhDnXYZgGl/aSk+qlCRT4s4QtKbQ8EeZYP0cQnI1PA8fH1qQGgqzwF+/CH9O1GK5Fp2fMxVQL2vZrRTCp5MuJJDpRw0pZ9WEdL1y6437xOmV6tabA+v4MmQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556853; c=relaxed/simple;
	bh=7G74qGV04+Fzz675bV8zAMwdM19Qou/t1vgl2WPECek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEKupUmfRT3BfIsn7cDAEw15rGTmD47nwE5CVoudnRKXP/cvu9SxY0K6xOu2Ra5V/f1RetzWBxitLp2wVPsRWok/HPNdPsyT16sPglXUXmc1/mR3pNNYL4w0cnGK4ynIZo2IfAvTsndSAj2cxfD3JEKZn4HsbSO+7e7M6xFGoI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gXoljk6U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gXoljk6U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69C21F000FF;
	Fri,  9 Oct 2026 14:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556852;
	bh=Du0usr3M7LfRj8VOssb+k5gZR7AAuTG61HCCl7e97pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gXoljk6UuvFNt6hWjGz0F1z1h5A2YhB6x1NBFr3g9WYTR2ckCdpTd9Y97NL6oDcRh
	 aZqVbiMCLCdr3oRYqpc8Y5BrBvN+wNZTdvAhXy/ITIsofAJ4gZMO4SpsZQOovrripi
	 uwO+xEtckbUJz8wVVzd72efb6orowzlAibUIbct8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 303/403] iio: adc: ade9000: fix NULL pointer dereference in clkout registration
Date: Fri,  9 Oct 2026 16:11:04 +0200
Message-ID: <20261009140959.301278075@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

commit 49ee1c6a3ebda6b7de06b2961b0e09c1c3fe536a upstream.

ade9000_setup_clkout() passes NULL as the register address when
registering a divider clock. During clock registration, the common
clock framework calls clk_divider_recalc_rate(), which dereferences
the address through readl(). As a result, probing an ADE9000 configured
as a clock provider with an external input clock crashes.

CLKOUT passes CLKIN through without changing its rate. Register it as
a 1:1 fixed-factor clock, which does not require register access.

This change does not affect the configuration using the internal clock,
for which the driver does not register a clock provider.

Fixes: 81de7b4619fc ("iio: adc: add ade9000 support")
Cc: stable@vger.kernel.org
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ade9000.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/ade9000.c
+++ b/drivers/iio/adc/ade9000.c
@@ -1652,8 +1652,9 @@ static int ade9000_setup_clkout(struct d
 		return 0;
 
 	/* CLKOUT passes through CLKIN with divider of 1 */
-	clkout_hw = devm_clk_hw_register_divider(dev, "clkout", __clk_get_name(st->clkin),
-						 CLK_SET_RATE_PARENT, NULL, 0, 1, 0, NULL);
+	clkout_hw = devm_clk_hw_register_fixed_factor(dev, "clkout",
+						      __clk_get_name(st->clkin),
+						      CLK_SET_RATE_PARENT, 1, 1);
 	if (IS_ERR(clkout_hw))
 		return dev_err_probe(dev, PTR_ERR(clkout_hw), "Failed to register clkout");
 


