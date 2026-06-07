Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A71D2D3A69;
	Sun,  7 Jun 2026 10:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828684; cv=none; b=o19mdtGca4R32JdYMmAf+Tf0zxwbS+pO0M2wDRWKscy7mGIMrw43q8sU0nDKiSOOhyRoi+G/Iv+Und+xHq0yhntm4xlSxftss5OSYDKIO6eCcDlNfRG8Vfcpsh6LZjVcy/FbA75UAOaZbYqCUQPTmiDnru4uIDpNiO26AejSfQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828684; c=relaxed/simple;
	bh=1TPdF/rgRar5azxM06sSMBWRGIb3mCpQx0LNHdmVgKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jch8YIxKcUAY+vOLkvMx/KTnfw/9rIBoCu43+X0adR2/X5V797J/uqnfxvpA/PCa/73ESSD+tEP6VzUkM93yfe4o4IzOLhvaDcca8X4VrTgzEq8jAHB4Ja3GdsWiJZOmdBh2QCJlerMqde5iX/dwoAd6WuMtOamoj6c723sjX1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UAbmeAxB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UAbmeAxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799451F00893;
	Sun,  7 Jun 2026 10:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828683;
	bh=4JEcr28DtA5g8Tzy/QIoWZ1N5OB7q7fmfkBYDvQvD2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UAbmeAxB3xRc4KyX86KUiF3AcqzPDfx2egS/G7cfEACOdFR2UQCtcZta9p8RB1yLt
	 /Okn+53HajK8KRMx2Nt/WkNEbs/eqM+n1eUe5PgUx1csv7WJpHYjYYHh365Kst9Ekj
	 wd26Tp6AUUsJcoSX1VlSk48BpuSyxa6gOQYgCEV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Chaitanya Sabnis <chaitanya.msabnis@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 182/315] i2c: davinci: fix division by zero on missing clock-frequency
Date: Sun,  7 Jun 2026 11:59:29 +0200
Message-ID: <20260607095734.268111488@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Chaitanya Sabnis <chaitanya.msabnis@gmail.com>

commit 030675aa54cf757769b3db65642433d626b3ed7c upstream.

When the 'clock-frequency' property is missing from the device tree,
the driver falls back to DAVINCI_I2C_DEFAULT_BUS_FREQ. However, this
macro was defined in kHz (100), whereas the device tree property is
expected in Hz.

The probe function divided the fallback value by 1000, causing
integer truncation that resulted in dev->bus_freq = 0. This triggered
a deterministic division-by-zero kernel panic when calculating clock
dividers later in the probe sequence.

Fix this by redefining DAVINCI_I2C_DEFAULT_BUS_FREQ in Hz (100000)
to match the expected device tree property unit, allowing the existing
division logic to work correctly for both cases.

Fixes: b04ce6385979 ("i2c: davinci: kill platform data")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260514044726.57297C2BCB7@smtp.kernel.org/
Signed-off-by: Chaitanya Sabnis <chaitanya.msabnis@gmail.com>
Cc: <stable@vger.kernel.org> # v6.14+
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260526102240.4949-1-chaitanya.msabnis@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-davinci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -117,7 +117,7 @@
 /* timeout for pm runtime autosuspend */
 #define DAVINCI_I2C_PM_TIMEOUT	1000	/* ms */
 
-#define DAVINCI_I2C_DEFAULT_BUS_FREQ	100
+#define DAVINCI_I2C_DEFAULT_BUS_FREQ	100000
 
 struct davinci_i2c_dev {
 	struct device           *dev;


