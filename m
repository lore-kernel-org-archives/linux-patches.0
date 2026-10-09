Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A223BED42;
	Fri,  9 Oct 2026 14:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557487; cv=none; b=dUmbVYdHXzPUHekZNNxRipuMfROK2NTey2zbRGHjVOmdAMxDa8uiufeWVK6EVSjzgxsdgiLjb+lbySy5WKQCMMSdSzNQmVisF/DJ8pg76ZZUueThzKf5spksDSK8yytOTowg2ba2YpIsmqLF7I79qc3tvFNgP2J9zAjXwDsXEGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557487; c=relaxed/simple;
	bh=WLYs2nbTBaDgqNekCpcus3RKOludtD9Yu2jNa/c4M5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugY4wJQBWHfDn4dRxw2BXWy1pobZvCTlsxyW1RXjPCt7grJr81OaMVO4PMicI0dRFTc+/KpDnaxL30K57z62bdZm7InPS6WXpzTWTnut9VcHfGclfv/KQKSuEnYZV636eihVHRPgXlQWGD4XGc4MGtA3keznD5g2P6md7edbehs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+ZZ+20E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+ZZ+20E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E891F000FF;
	Fri,  9 Oct 2026 14:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557486;
	bh=JWz+BG9+rceUF5uTS6OkdPQgQXye9poABte4aLO+bwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+ZZ+20E7k5DAUtjKTu2oUT346JUSsRvI1dWQjsS7//Kb6LEn1O3QmkK0VnspcBFr
	 3sADYKCfnrt6fjjaU6Nc/MckWMXmxQKWB1QHga3XUL2TsjhDJGl9VNan3BDcymM3+S
	 r2ylZJ6MWkeP5Fb/DK4m7NZIMg6Q5axcIADcwpzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 376/428] iio: adc: ade9000: fix NULL pointer dereference in clkout registration
Date: Fri,  9 Oct 2026 16:11:53 +0200
Message-ID: <20261009140954.447338728@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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
@@ -1647,8 +1647,9 @@ static int ade9000_setup_clkout(struct d
 		return 0;
 
 	/* CLKOUT passes through CLKIN with divider of 1 */
-	clkout_hw = devm_clk_hw_register_divider(dev, "clkout", __clk_get_name(st->clkin),
-						 CLK_SET_RATE_PARENT, NULL, 0, 1, 0, NULL);
+	clkout_hw = devm_clk_hw_register_fixed_factor(dev, "clkout",
+						      __clk_get_name(st->clkin),
+						      CLK_SET_RATE_PARENT, 1, 1);
 	if (IS_ERR(clkout_hw))
 		return dev_err_probe(dev, PTR_ERR(clkout_hw), "Failed to register clkout");
 


