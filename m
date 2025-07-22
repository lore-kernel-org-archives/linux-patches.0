Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359852877FA;
	Tue, 22 Jul 2025 13:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192591; cv=none; b=d266HggsAEn8q1//XzvGzwIpf9CjkbiA93F1oy8WUklvsdnrhVZ6KTLtHsW0yxy8A4Xvol5vdxucyQac2bK6gYVQOOfwV+qtWlVpGz5xDtGAcIbj9iYqOlZojiJsxPt1LdbJ8GbEv/d3yB+oc6l0zot07WIacdSVxiUa8+VvMN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192591; c=relaxed/simple;
	bh=Huj66fiXYAcLJSoHSBI++zrhKTPi1u9IK2MNUgarwwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYWuSAs59VAlZpFu+nlXGGz6owLWTFnaC8vH3RsltXTS26qm2EQjp31xELxVrXbn4p9Ojk8vh9GdOcA0hFx6neLgNK67TfNrgMd5TBthgWBHokYJq+1ccuBtkQ8JXILMy7qrJwHxapenlTBYUZTDLEBAMfgs7SOKPLrPVyKNmpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WTn7Smbp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WTn7Smbp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCF4C4CEEB;
	Tue, 22 Jul 2025 13:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192590;
	bh=Huj66fiXYAcLJSoHSBI++zrhKTPi1u9IK2MNUgarwwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WTn7SmbpApiifGlw3paVFl/4Qmw04Na2rxJmKeQ6tSadjTjNQlySP+APXwMfMkwvm
	 d0i2wMrZMjrx1dFXBQO5//h+mAT3EXRZd5fbtMH18k+ag3SB/u97P8x1ekUuGNV/dg
	 i++mxRbW5SHoEynm5FJ32DV0/nmpJ758CEnezLms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/111] i2c: omap: Handle omap_i2c_init() errors in omap_i2c_probe()
Date: Tue, 22 Jul 2025 15:45:19 +0200
Message-ID: <20250722134337.285996435@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1475,7 +1475,9 @@ omap_i2c_probe(struct platform_device *p
 	}
 
 	/* reset ASAP, clearing any IRQs */
-	omap_i2c_init(omap);
+	r = omap_i2c_init(omap);
+	if (r)
+		goto err_mux_state_deselect;
 
 	if (omap->rev < OMAP_I2C_OMAP1_REV_2)
 		r = devm_request_irq(&pdev->dev, omap->irq, omap_i2c_omap1_isr,
@@ -1518,6 +1520,7 @@ omap_i2c_probe(struct platform_device *p
 
 err_unuse_clocks:
 	omap_i2c_write_reg(omap, OMAP_I2C_CON_REG, 0);
+err_mux_state_deselect:
 	if (omap->mux_state)
 		mux_state_deselect(omap->mux_state);
 err_put_pm:


