Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C894132AAB5;
	Fri,  9 Jan 2026 12:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961380; cv=none; b=oL0hL8bgfPpV3TxXZwbp/hYAzp9qUFnhV9iJ0vLa778lCIHEO8EYQrMh5wveK0Ktu3tlhRRfvAhkFJbj3VebwmSlpyUGkPHcIiYjtQe4sUpK4qzY2ie/6WpArbhXI8luL2dQ7QP11qevYCme8okpDAoGOsvKSzpXnXUCpzqIiBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961380; c=relaxed/simple;
	bh=OLrg/FKMPQz9ztDIPzlikAjYuPl2OdbETQ4XLG18gM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=leRwXHhqR2PiJSQ4HCBDXuF+ripu0PQOFTMyd8yjlJJz22pfjWy8+YPDHfr74Fn0m0cCGHwVU4H+YRTFGZcei0bRVO9UzhTT7X26lUJVmNs4PgMAhFpSDC7U55tgdFyzkaqtwkpdIm2yNrv2dAg/Dn2+S3BPOo91wEAks9uW+8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aGd+I1kC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aGd+I1kC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03778C16AAE;
	Fri,  9 Jan 2026 12:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961380;
	bh=OLrg/FKMPQz9ztDIPzlikAjYuPl2OdbETQ4XLG18gM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aGd+I1kC4yLpV3t+L60E6Gyn58G0g3XsSll11UKwONf7CzUWJex4Xg3OpmZpyrMdd
	 mpkrl+lKhgiUasYx55QwCh80xxyGu33sQ81poQsgORNTXEPZ/TvNVruIXvvqqstqXn
	 aid+k93laAFKBzo6Cjt9Q+mye8l62WC6XNGV2AQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Rahul Sharma <black.hawk@163.com>
Subject: [PATCH 6.6 732/737] net: stmmac: make sure that ptp_rate is not 0 before configuring EST
Date: Fri,  9 Jan 2026 12:44:31 +0100
Message-ID: <20260109112201.642932858@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexis Lothoré <alexis.lothore@bootlin.com>

commit cbefe2ffa7784525ec5d008ba87c7add19ec631a upstream.

If the ptp_rate recorded earlier in the driver happens to be 0, this
bogus value will propagate up to EST configuration, where it will
trigger a division by 0.

Prevent this division by 0 by adding the corresponding check and error
code.

Suggested-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
Fixes: 8572aec3d0dc ("net: stmmac: Add basic EST support for XGMAC")
Link: https://patch.msgid.link/20250529-stmmac_tstamp_div-v4-2-d73340a794d5@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ The context change is due to the commit c3f3b97238f6
  ("net: stmmac: Refactor EST implementation")
  which is irrelevant to the logic of this patch. ]
Signed-off-by: Rahul Sharma <black.hawk@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c        |    5 +++++
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c |    5 +++++
 2 files changed, 10 insertions(+)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
@@ -597,6 +597,11 @@ int dwmac5_est_configure(void __iomem *i
 	int i, ret = 0x0;
 	u32 ctrl;
 
+	if (!ptp_rate) {
+		pr_warn("Dwmac5: Invalid PTP rate");
+		return -EINVAL;
+	}
+
 	ret |= dwmac5_est_write(ioaddr, BTR_LOW, cfg->btr[0], false);
 	ret |= dwmac5_est_write(ioaddr, BTR_HIGH, cfg->btr[1], false);
 	ret |= dwmac5_est_write(ioaddr, TER, cfg->ter, false);
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -1537,6 +1537,11 @@ static int dwxgmac3_est_configure(void _
 	int i, ret = 0x0;
 	u32 ctrl;
 
+        if (!ptp_rate) {
+                pr_warn("Dwxgmac2: Invalid PTP rate");
+                return -EINVAL;
+        }
+
 	ret |= dwxgmac3_est_write(ioaddr, XGMAC_BTR_LOW, cfg->btr[0], false);
 	ret |= dwxgmac3_est_write(ioaddr, XGMAC_BTR_HIGH, cfg->btr[1], false);
 	ret |= dwxgmac3_est_write(ioaddr, XGMAC_TER, cfg->ter, false);


