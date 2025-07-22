Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31461D6193;
	Tue, 22 Jul 2025 14:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193108; cv=none; b=YbwG1urgC33lJQiuiVc2DWB+BfU/baBFK95oBbBeKxNPwgDU/YrVXA+YhRq+NE1BZdWcWYk1eMqG87ZOYXi218WvfgY80s9cktmyJvY2wB0cHLjoofrUmyymw/t3+YuISZJ3cLdktvGRNGFUa65/NBqgmZKobHwrKm9EBPvdRao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193108; c=relaxed/simple;
	bh=MxfeZUtOggGDa7EHpZcMMiuYn+r1eyxzJn327PwoCZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJsZDkacRvXUgil07AzpIr6qLvznQZbe6+18jY53v8cTyEQwjDW7mKviM3vKviLQsj/Hzb63hm7H5D1FEXpIIbVsutK+RL6QBnCO9P84GgNLbKqDNboeb2FmtCDdtGGuViBKQmd919rkHU3F51ghEBfYCHirfqwYJHRp0ocmQPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2thji4Rb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2thji4Rb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B23EC4CEEB;
	Tue, 22 Jul 2025 14:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193108;
	bh=MxfeZUtOggGDa7EHpZcMMiuYn+r1eyxzJn327PwoCZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2thji4Rb6cx1sPniSzKt8xQE2bACFGQnv+zFAoUP5ij7Ltzepx4R1luZDyKKxi8aM
	 O0JkkTymXV5Ea3EY+VqPP2mpLscZkPm3+2LRsGqtQzME9qrwgoVoPUUoCFjy4t22L0
	 73JthCCX9SiuIGihTAttgw8GVeIxeiBiRCsm5qDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 153/158] i2c: omap: Handle omap_i2c_init() errors in omap_i2c_probe()
Date: Tue, 22 Jul 2025 15:45:37 +0200
Message-ID: <20250722134346.424543731@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit a9503a2ecd95e23d7243bcde7138192de8c1c281 upstream.

omap_i2c_init() can fail. Handle this error in omap_i2c_probe().

Fixes: 010d442c4a29 ("i2c: New bus driver for TI OMAP boards")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: <stable@vger.kernel.org> # v2.6.19+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/565311abf9bafd7291ca82bcecb48c1fac1e727b.1751701715.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-omap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -1472,7 +1472,9 @@ omap_i2c_probe(struct platform_device *p
 	}
 
 	/* reset ASAP, clearing any IRQs */
-	omap_i2c_init(omap);
+	r = omap_i2c_init(omap);
+	if (r)
+		goto err_mux_state_deselect;
 
 	if (omap->rev < OMAP_I2C_OMAP1_REV_2)
 		r = devm_request_irq(&pdev->dev, omap->irq, omap_i2c_omap1_isr,
@@ -1515,6 +1517,7 @@ omap_i2c_probe(struct platform_device *p
 
 err_unuse_clocks:
 	omap_i2c_write_reg(omap, OMAP_I2C_CON_REG, 0);
+err_mux_state_deselect:
 	if (omap->mux_state)
 		mux_state_deselect(omap->mux_state);
 err_put_pm:


