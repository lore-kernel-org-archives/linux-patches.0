Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD3F263F5E;
	Tue, 27 May 2025 16:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364705; cv=none; b=HGJH3+nkRS+alEwZfVPRYT+jFqzkOAtIpsQ0fa8gBfnmDTg2fkt9zd+m4Ic5yVoE8LhiCrZUbuBfNTmSWb5S5Nt1TMl1hNDXGLorUpgV80BmJFZce6ce3VghPLMGBRK8lPpmeBQvHtKbymEzQVsc82NI/HCWrC6CE0jH6dE4IlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364705; c=relaxed/simple;
	bh=8FYICPDfTnMvMeYHjWW8bE0ZiorfsFo+2Z26xsvhsLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9y0QCcC5P3FEb21sf9l7nA5z8LrWxi/kAbskYQwRrJUU+q1PrLI65FHhy9IFJdXniA+XvaIVcSOrKeHAt6abVSj0O4hdF82xsg9/JtjXswoRiujJprWyG3Ivq8v9OZL1wh7SRZ1jK88OGS7zhLif2BnOnaEy5ywYmWKJ46LRfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VozRy2Iv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VozRy2Iv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572C7C4CEE9;
	Tue, 27 May 2025 16:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364705;
	bh=8FYICPDfTnMvMeYHjWW8bE0ZiorfsFo+2Z26xsvhsLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VozRy2Iv79jzDHbIvU5snL0IpH8FfuV3DDm2XoRtyjyOZZKAbbHWBObD/KZPdPDYO
	 PFzAFA5Qgo/yCf9NSMpeYuRkYV0+PaXzBHLMib1M5ZPb/sC1mK5sPRT6oRUUR7eZ3o
	 6rgVmNUh6HmDyY/CF+gS7mcwjVlBV9QzFo48N5UM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Mordan <mordan@ispras.ru>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 113/626] i2c: pxa: fix call balance of i2c->clk handling routines
Date: Tue, 27 May 2025 18:20:06 +0200
Message-ID: <20250527162449.625395382@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Vitalii Mordan <mordan@ispras.ru>

[ Upstream commit be7113d2e2a6f20cbee99c98d261a1fd6fd7b549 ]

If the clock i2c->clk was not enabled in i2c_pxa_probe(), it should not be
disabled in any path.

Found by Linux Verification Center (linuxtesting.org) with Klever.

Signed-off-by: Vitalii Mordan <mordan@ispras.ru>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250212172803.1422136-1-mordan@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-pxa.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index 4d76e71cdd4be..afc1a8171f59e 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -1503,7 +1503,10 @@ static int i2c_pxa_probe(struct platform_device *dev)
 				i2c->adap.name);
 	}
 
-	clk_prepare_enable(i2c->clk);
+	ret = clk_prepare_enable(i2c->clk);
+	if (ret)
+		return dev_err_probe(&dev->dev, ret,
+				     "failed to enable clock\n");
 
 	if (i2c->use_pio) {
 		i2c->adap.algo = &i2c_pxa_pio_algorithm;
-- 
2.39.5



