Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8F71DFD84;
	Tue,  8 Oct 2024 13:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394054; cv=none; b=FADZN03A3sdCGdZfSjDfE5nXgoj7x6/GHDuBgm9xXJTcbY5T+25MlqQDpi+sC86eeIvu8QHBm7Jl7FBowh6yCxaJGBvd5RT85MLqgNgPBDkvWL9BIbewC4n9nAloIdEMVu4AXVJsRggzv7yLQDJ7JYgs9E4mvba13dvaIm5wh4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394054; c=relaxed/simple;
	bh=kNnBU6swNo9xg7NUDjhI3S4gADrmytmSz3Y4S/v/Ms8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ej1qZT+rQ3j6GIHXn3BVG+XovsW1Lk0WBq5VcIjcqyQj7xIRwux4wCtD1Bq1xuvHpQ69LSEcJ4o3bMs0+GGP4RlVybpurna+fMXDjdMMqotyhiDd+7330hCNOASZmw7zuk1OyRJofYDCAxkpvpQfIQf9avFKY+RutBoWI9asG2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qq6JRUNA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qq6JRUNA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609FDC4CEC7;
	Tue,  8 Oct 2024 13:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394053;
	bh=kNnBU6swNo9xg7NUDjhI3S4gADrmytmSz3Y4S/v/Ms8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qq6JRUNAnG/IWO6l6qnrrXtTAhYHyhIdqo4Gwyj5mwIsXV6IfL4/ILAA242TnrhNj
	 WzQ/pqtikDmnxUh3+PIRzV801XvBCdIhE8XSHMLcQjUubN0v8Wx5L1J9RR9jRA/ZHn
	 gWoV8ros4E6HZf2hPh5UABa9H7CCtjkOoODIW5Sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@kernel.org>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 334/386] i2c: synquacer: Deal with optional PCLK correctly
Date: Tue,  8 Oct 2024 14:09:39 +0200
Message-ID: <20241008115642.526768552@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit f2990f8630531a99cad4dc5c44cb2a11ded42492 ]

ACPI boot does not provide clocks and regulators, but instead, provides
the PCLK rate directly, and enables the clock in firmware. So deal
gracefully with this.

Fixes: 55750148e559 ("i2c: synquacer: Fix an error handling path in synquacer_i2c_probe()")
Cc: stable@vger.kernel.org # v6.10+
Cc: Andi Shyti <andi.shyti@kernel.org>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-synquacer.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-synquacer.c b/drivers/i2c/busses/i2c-synquacer.c
index e774b9f499b63..9bb69a8ab6582 100644
--- a/drivers/i2c/busses/i2c-synquacer.c
+++ b/drivers/i2c/busses/i2c-synquacer.c
@@ -550,12 +550,13 @@ static int synquacer_i2c_probe(struct platform_device *pdev)
 	device_property_read_u32(&pdev->dev, "socionext,pclk-rate",
 				 &i2c->pclkrate);
 
-	pclk = devm_clk_get_enabled(&pdev->dev, "pclk");
+	pclk = devm_clk_get_optional_enabled(&pdev->dev, "pclk");
 	if (IS_ERR(pclk))
 		return dev_err_probe(&pdev->dev, PTR_ERR(pclk),
 				     "failed to get and enable clock\n");
 
-	i2c->pclkrate = clk_get_rate(pclk);
+	if (pclk)
+		i2c->pclkrate = clk_get_rate(pclk);
 
 	if (i2c->pclkrate < SYNQUACER_I2C_MIN_CLK_RATE ||
 	    i2c->pclkrate > SYNQUACER_I2C_MAX_CLK_RATE)
-- 
2.43.0



