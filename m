Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC86D1ADC83;
	Mon,  4 May 2026 14:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903814; cv=none; b=EoutLx+VWcNXYQvcOgW6hav5qgjLJbetwKOuvzIbmOczPzGUtiASf6ocaz2oSCVDjZcUV6I5hN0bFalShj/SUmRu2FWb2SZU+DfUEYd4xt11sUssdpQGrBBUUphJlugk4W3nKtYebg2h9h7capZyuBB5JssWmgU2IWH15xUU8ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903814; c=relaxed/simple;
	bh=8FBMiUQEseB67fLW/RSIIEnVEMCiGFw97yY7oxBGpKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVJ7ONywoN1EUNBT6QP66PmzgeMn3+z01Na/mAgHp7q0W1DogeutdLA3YSYD061UXJFfJgcOGggBWG9lBNk0CaWblEOsK5jzQWVYeoQ7XVfmUSGMDXvSAmfv318Y4ztl2WvGcDipJRVsCXpWEgpewFqsub7kbeHH1IROxMvcXs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WHl9E2px; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHl9E2px"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E16C2BCB8;
	Mon,  4 May 2026 14:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903814;
	bh=8FBMiUQEseB67fLW/RSIIEnVEMCiGFw97yY7oxBGpKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WHl9E2pxqJDfMZqd3o1/3bkV8VAmwz5o+43tscU11fLOIBbYhxHSqFzMXQi2229iV
	 F00j7hNhwL3IjHbLM0JnIY6gnAO6lmWJtGJsb2QLIXF9mtu4RgGlv8naVvR2V5FbFM
	 667tCCnOO2pnjzCQ6aevsfDhFTEK4tkY3RYwjGtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.18 072/275] mfd: stpmic1: Attempt system shutdown twice in case PMIC is confused
Date: Mon,  4 May 2026 15:50:12 +0200
Message-ID: <20260504135145.602692000@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Marek Vasut <marex@nabladev.com>

commit ffdc5c51f8bcd0e5e8255ca275a0a3b958475d99 upstream.

Attempt to shut down again, in case the first attempt failed.
The STPMIC1 might get confused and the first regmap_update_bits()
returns with -ETIMEDOUT / -110 . If that or similar transient
failure occurs, try to shut down again. If the second attempt
fails, there is some bigger problem, report it to user.

Cc: stable@vger.kernel.org
Fixes: 6e9df38f359a ("mfd: stpmic1: Add PMIC poweroff via sys-off handler")
Signed-off-by: Marek Vasut <marex@nabladev.com>
Link: https://patch.msgid.link/20260122111423.62591-1-marex@nabladev.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/stpmic1.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/mfd/stpmic1.c
+++ b/drivers/mfd/stpmic1.c
@@ -16,6 +16,8 @@
 
 #include <dt-bindings/mfd/st,stpmic1.h>
 
+#define STPMIC1_MAX_RETRIES 2
+
 #define STPMIC1_MAIN_IRQ 0
 
 static const struct regmap_range stpmic1_readable_ranges[] = {
@@ -121,9 +123,23 @@ static const struct regmap_irq_chip stpm
 static int stpmic1_power_off(struct sys_off_data *data)
 {
 	struct stpmic1 *ddata = data->cb_data;
+	int ret;
+
+	/*
+	 * Attempt to shut down again, in case the first attempt failed.
+	 * The STPMIC1 might get confused and the first regmap_update_bits()
+	 * returns with -ETIMEDOUT / -110 . If that or similar transient
+	 * failure occurs, try to shut down again. If the second attempt
+	 * fails, there is some bigger problem, report it to user.
+	 */
+	for (int retries = 0; retries < STPMIC1_MAX_RETRIES; retries++) {
+		ret = regmap_update_bits(ddata->regmap, MAIN_CR, SOFTWARE_SWITCH_OFF,
+					 SOFTWARE_SWITCH_OFF);
+		if (!ret)
+			return NOTIFY_DONE;
+	}
 
-	regmap_update_bits(ddata->regmap, MAIN_CR,
-			   SOFTWARE_SWITCH_OFF, SOFTWARE_SWITCH_OFF);
+	dev_err(ddata->dev, "Failed to access PMIC I2C bus (%d)\n", ret);
 
 	return NOTIFY_DONE;
 }


