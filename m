Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7B12FDC5E;
	Sat, 30 May 2026 18:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165981; cv=none; b=vGFEXhDJbS3s24OJkok1NB23n1PN6pH/vh+GscJUw2xmJ7eScy5QztgvFuhb2oNF1Xxi6D4zvirK7C2oeXnyEtdLT8I+YiyBjzlXgKMBz32NoIczvAayN5RC2gUHRWotn1a+RH/sTyTJPTdcE3nXm/O8G/AUB72WkyD+mp9BZNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165981; c=relaxed/simple;
	bh=rkjo4mnr0zVeA5WfY3RIterRSVH3F/WIxwVOgJ62ILs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEjm2/UjrIDPbIWAXxIdUu7FtDKmuFeyBWrkQ6E1L1ttAj7jjY2dUzhRpP4MWTyqbAeHUWHGdy1zMR+X5Lbyzfg3s46TtRq7n+aig8vW3WVYcqQDwqfBpFEnrUl2jGSlTjK6D5m0EpidGLsqGdXvwFBuWf4RTLk9K5T+Iz/j9h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dg2X/tyT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dg2X/tyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08A91F00893;
	Sat, 30 May 2026 18:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165980;
	bh=QRrPfySsjqSMa03rka/IH1Ov38B2PYWQrTJfUAcacxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dg2X/tyTgoj1omgPWno42sjEJWD4AHjccdxAauy79e1OYvoJRGo0BO5Bhyss8mX84
	 FCFTfW6qCvJLLA3kIKSDmXyTRUb41puIOgkf/MhMKiu2H3cbAjT5Mwv2DFiCdVhqR+
	 oEZadkI9DH4Ej951pxZ14IC3zss5JtgBLH8OYCq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 238/589] parisc: Fix IRQ leak in LASI driver
Date: Sat, 30 May 2026 18:01:59 +0200
Message-ID: <20260530160231.253040174@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

commit 37b0dc5e279f35036fb638d1e187197b6c05a76d upstream.

When request_irq() succeeds but gsc_common_setup() fails later,
the IRQ is never released. Fix this by adding proper error handling
with goto labels to ensure resources are released in LIFO order.

Detected by Smatch:
  drivers/parisc/lasi.c:216 lasi_init_chip() warn: 'lasi->gsc_irq.irq'
from request_irq() not released on lines: 207.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202604180957.4QdAIxP6-lkp@intel.com/
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parisc/lasi.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/parisc/lasi.c
+++ b/drivers/parisc/lasi.c
@@ -196,8 +196,7 @@ static int __init lasi_init_chip(struct
 
 	ret = request_irq(lasi->gsc_irq.irq, gsc_asic_intr, 0, "lasi", lasi);
 	if (ret < 0) {
-		kfree(lasi);
-		return ret;
+		goto err_free;
 	}
 
 	/* enable IRQ's for devices below LASI */
@@ -206,8 +205,7 @@ static int __init lasi_init_chip(struct
 	/* Done init'ing, register this driver */
 	ret = gsc_common_setup(dev, lasi);
 	if (ret) {
-		kfree(lasi);
-		return ret;
+		goto err_irq;
 	}    
 
 	gsc_fixup_irqs(dev, lasi, lasi_choose_irq);
@@ -220,6 +218,12 @@ static int __init lasi_init_chip(struct
 	chassis_power_off = lasi_power_off;
 	
 	return ret;
+
+err_irq:
+	free_irq(lasi->gsc_irq.irq, lasi);
+err_free:
+	kfree(lasi);
+	return ret;
 }
 
 static struct parisc_device_id lasi_tbl[] __initdata = {


