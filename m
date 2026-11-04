Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827206;
	b=YtOajYSilTyAsZv0jfzLfm/lAfkbag10U8EQsSQM5CmYL1Q+4Rw2gQqoaff8xth/pFwn
	 p5sLo4Hd6T6jAr9MCgBTlbCZT+40SG6lC0ZyiSzxgI4tehvvzPPzIafJE3kBFESZingnq
	 HHaf05Gbi9axGLmZ1Xl8kEci+Fivx9DENrWJG4lN5Dtn5N5AtZtlCtouXEGopylFLSV/M
	 pKUMPm21GkUwV6Hp3ZGZtGBYBuvdGcptv/X30JUopw0r26NFW/tNuM9gAf4SGtrIQ3exN
	 BWrrxZccuMCVIK3j44VwDUWhlnVA4I8uZ4dREqwa7KajM0BosZNGmX+ip5zd8hi/XGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827206;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uTv9/XB3FTmtWrCFkGH5LTU97kVthR48kXx+Kn+PAfY=;
	b=LM4v1uovl4ZmNOq8p23J0Dn2/hOudyUr19LGatMUAN7UFwW4Q5DQEyj1+nDD3R9pFClJ
	 SKvTyBcLB/83141eg6d2tDbjRUI56nd+NScl48oGc2MxL0WswUAvOGG34MgQBV6Qymcg7
	 Gb4l/3itPAgultxYRzee7udg8yKYOoP7NTTEd8bCg6KL6o7e1i6lOy7LXoBc2qzxQ8Eae
	 ybsSMtFb+m32R/1Kzpnflb2Y1QXZz4H1BSb23AvHgtblCS9UOU7Wy78x5Q3pzywWL8C1k
	 +bdsaYAqDT2wnpZuECOZta4oNUF62KmGlUv/5XZHVuJ7KB/g51VfcYIzyGyqckegmJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XxLGGgCV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48ECB606B2E1;
	Wed,  4 Nov 2026 21:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XxLGGgCV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21A31F00A02;
	Wed,  4 Nov 2026 21:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827206;
	bh=uTv9/XB3FTmtWrCFkGH5LTU97kVthR48kXx+Kn+PAfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XxLGGgCVwKv7il0A8UJQ8WV7NWyJrnP4Z5C7s12j/wJvOSZSWB6VaF/zLfUwhmj8B
	 JNWsBaHO9a7rhx3eyDhrvR7KW3PTi1gqgMfU+AsXSyQrWzZUlQqy569ZBQuRmEA90T
	 nS7xwsv7qj0YxbV2jjogZqhiYioYj2r9ubCn1CkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 7.3 257/547] power: supply: pf1550: drain IRQ work before unregistering supplies
Date: Wed,  4 Nov 2026 16:07:21 -0500
Message-ID: <20261104211045.483195148@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit 4856b49317ccd4ce96a0e8970df7d13ce8975a02 upstream.

The VBUS work calls power_supply_changed(), but its managed
cancellation is registered before the supplies. Cleanup can therefore
unregister a supply while IRQ-triggered work is still pending.

Commit 838767f50747 ("power: supply: pf1550: Fix use-after-free in
power_supply_changed()") moved IRQ requests after supply registration,
but left work cancellation before the supplies. That change protects
the direct IRQ callbacks, while this fix drains the work they queue.

Register the three work items after both supplies and before the IRQs.
Cleanup then frees the IRQ producers, drains the work, and unregisters
the supplies.

The teardown ordering issue was found by static analysis.

Fixes: 4b6b6433a97d ("power: supply: pf1550: add battery charger support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20261004043728.1140015-1-mhun512@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/pf1550-charger.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/drivers/power/supply/pf1550-charger.c
+++ b/drivers/power/supply/pf1550-charger.c
@@ -566,6 +566,22 @@ static int pf1550_charger_probe(struct p
 
 	platform_set_drvdata(pdev, chg);
 
+	psy_cfg.drv_data = chg;
+
+	chg->charger = devm_power_supply_register(&pdev->dev,
+						  &pf1550_charger_desc,
+						  &psy_cfg);
+	if (IS_ERR(chg->charger))
+		return dev_err_probe(&pdev->dev, PTR_ERR(chg->charger),
+				     "failed: power supply register\n");
+
+	chg->battery = devm_power_supply_register(&pdev->dev,
+						  &pf1550_battery_desc,
+						  &psy_cfg);
+	if (IS_ERR(chg->battery))
+		return dev_err_probe(&pdev->dev, PTR_ERR(chg->battery),
+				     "failed: power supply register\n");
+
 	ret = devm_delayed_work_autocancel(chg->dev, &chg->vbus_sense_work,
 					   pf1550_chg_vbus_work);
 	if (ret)
@@ -584,22 +600,6 @@ static int pf1550_charger_probe(struct p
 		return dev_err_probe(chg->dev, ret,
 				     "failed to add battery sense work\n");
 
-	psy_cfg.drv_data = chg;
-
-	chg->charger = devm_power_supply_register(&pdev->dev,
-						  &pf1550_charger_desc,
-						  &psy_cfg);
-	if (IS_ERR(chg->charger))
-		return dev_err_probe(&pdev->dev, PTR_ERR(chg->charger),
-				     "failed: power supply register\n");
-
-	chg->battery = devm_power_supply_register(&pdev->dev,
-						  &pf1550_battery_desc,
-						  &psy_cfg);
-	if (IS_ERR(chg->battery))
-		return dev_err_probe(&pdev->dev, PTR_ERR(chg->battery),
-				     "failed: power supply register\n");
-
 	for (i = 0; i < PF1550_CHARGER_IRQ_NR; i++) {
 		irq = platform_get_irq(pdev, i);
 		if (irq < 0)


