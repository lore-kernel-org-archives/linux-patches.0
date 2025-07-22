Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398426D17;
	Tue, 22 Jul 2025 14:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193169; cv=none; b=GI7LLUxQKARTWVblgt9Um4U6AZbglMEf740u3s3RNbXoivrj5w6lgXvcmuzwTaDywXxl19kcgg6/k1e0x0g9OxTC2VdZXIkUB86Qi3rPnipynUvovsydVI0Fq1d7vipVGEryuqV23XmePia+ELgEMSXZajQ5T/8YGBkCxrsBpfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193169; c=relaxed/simple;
	bh=BdBG2HNX+c2pF9a3Mk+5A73Ie5poSCaFPYAJ8lbCfMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5KgwnPTWFbzADFBX/XrVttDvGj8WEXS0OxaoOvnElOV10L+nSCJ4ZovMtaFTF2o0rpYLOWv3kqoUCcAR7iMKEl1JUNRNwG9udW0mK3dxLweUDMKQOI7xK6jBPoK4gCXX9YSRI761cA0ZGB6UYS4G/670VaPEGgtdBB48W6muco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CFhVZD2O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CFhVZD2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FA4C4CEEB;
	Tue, 22 Jul 2025 14:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193169;
	bh=BdBG2HNX+c2pF9a3Mk+5A73Ie5poSCaFPYAJ8lbCfMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CFhVZD2OhxaJlU5thgziqePkryCMDs4lmHBd5YeDYVV7PU6y18YFuZI7AF2OaPLLK
	 WAxCdHuJoWvUu7598zLqleTCsyiyGJenhbhQm0fsq98s+SuTDiziKyMbX0dqEV49Cw
	 R0w42xN2q6ozGzgW7bM5WKMU15QCUlLVqcx3BHcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.15 012/187] i2c: omap: Handle omap_i2c_init() errors in omap_i2c_probe()
Date: Tue, 22 Jul 2025 15:43:02 +0200
Message-ID: <20250722134346.216036010@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit a9503a2ecd95e23d7243bcde7138192de8c1c281 upstream.

omap_i2c_init() can fail. Handle this error in omap_i2c_probe().

Fixes: 010d442c4a29 ("i2c: New bus driver for TI OMAP boards")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: <stable@vger.kernel.org> # v2.6.19+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/565311abf9bafd7291ca82bcecb48c1fac1e727b.1751701715.git.christophe.jaillet@wanadoo.fr
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


