Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F6B1A6192;
	Tue, 30 Jul 2024 17:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358987; cv=none; b=NyNKVGjle8YyWaZT8u+yauAWwOUgUSKK17Gk6nF77fgeSM19xDXAjuM6/mEtKzOpIu8A9aLo2NR9sSje2uGyWkhN5aBVQdBCFXAfWnB6ew7gW5vdfdLpCm4YTginBZU2jSgJiuBN9nPDIvLe3JKE+bfyRisWd6PFDNtWV2SENbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358987; c=relaxed/simple;
	bh=hYeKyI7U6wboGgU4c+9/H5T1beKJuAt4AHZr1oQjTXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQvDwIat2tNdgKRZmR9Ky/qj7pw2DOc0IO0I+ezNnERGpD+SjL7LWMJ1pEuVe0jJao8hOFwrdV8L2hxmzcdDelO4OIky3g1INNRnrWxDEAqyIgBRby3+c9fvcTFbMl2WF6LLJwYR4LatssY2YGgEDv45Z7Hn5UKij2NOrNA1ar4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tmgxUdof; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmgxUdof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D87AC32782;
	Tue, 30 Jul 2024 17:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358987;
	bh=hYeKyI7U6wboGgU4c+9/H5T1beKJuAt4AHZr1oQjTXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tmgxUdof+kSdCnEwctHtB/K5A0gaEqYyfAo/4D7K7ojm/IpwZnw6i4QcGwrfSPfWE
	 xuaxbl6o6pVmjuJMDy4xVyF1C6tPVoYyQm7wyfDMzkacJ3yKI71BA/KNp5mp2uAMJ/
	 0ClSK9UpdQjJOM0qId1vXYT5JEsA80AY4LJOni5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Lalaev <andrei.lalaev@anton-paar.com>,
	Marco Felsch <m.felsch@pengutronix.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 418/809] Input: qt1050 - handle CHIP_ID reading error
Date: Tue, 30 Jul 2024 17:44:54 +0200
Message-ID: <20240730151741.206699587@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Lalaev <andrei.lalaev@anton-paar.com>

[ Upstream commit 866a5c7e2781cf1b019072288f1f5c64186dcb63 ]

If the device is missing, we get the following error:

  qt1050 3-0041: ID -1340767592 not supported

Let's handle this situation and print more informative error
when reading of CHIP_ID fails:

  qt1050 3-0041: Failed to read chip ID: -6

Fixes: cbebf5addec1 ("Input: qt1050 - add Microchip AT42QT1050 support")
Signed-off-by: Andrei Lalaev <andrei.lalaev@anton-paar.com>
Reviewed-by: Marco Felsch <m.felsch@pengutronix.de>
Link: https://lore.kernel.org/r/20240617183018.916234-1-andrey.lalaev@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/qt1050.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/input/keyboard/qt1050.c b/drivers/input/keyboard/qt1050.c
index b51dfcd760386..056e9bc260262 100644
--- a/drivers/input/keyboard/qt1050.c
+++ b/drivers/input/keyboard/qt1050.c
@@ -226,7 +226,12 @@ static bool qt1050_identify(struct qt1050_priv *ts)
 	int err;
 
 	/* Read Chip ID */
-	regmap_read(ts->regmap, QT1050_CHIP_ID, &val);
+	err = regmap_read(ts->regmap, QT1050_CHIP_ID, &val);
+	if (err) {
+		dev_err(&ts->client->dev, "Failed to read chip ID: %d\n", err);
+		return false;
+	}
+
 	if (val != QT1050_CHIP_ID_VER) {
 		dev_err(&ts->client->dev, "ID %d not supported\n", val);
 		return false;
-- 
2.43.0



