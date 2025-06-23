Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E6113A265;
	Mon, 23 Jun 2025 13:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684532; cv=none; b=nSHQCtXcxF6xM/mLxS1oKj5FIqhQuNa4DYpHry63swcjttXvC+wDXE4vXIzEJqF2tpf8Ik3Hk7BK3SHqnzLIJZJerh7lNgRiLSrAPzxmBV5zp6EepbtInsDiuyVsIcMyEnNr/nKHC+ygmqa8Y/A/fZodS5hlaiMeYUDIEmWJ9xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684532; c=relaxed/simple;
	bh=jwE4BWeTnR62p3K1QIQH034oyNExj2u23wNS72lAIDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDi6DHpR39/OBe3k1qZgz8i5Mvqh7WbeOMov1G3u+yEMwCgiINIKB55mzSuMDiRTAc3M2BkEnuUyIixEXON2xrkrsSxbb8bKYmF/h9uadxMApPv6wGLkgz+wrnhZzqJB/MrXZFIL+FPjyZzoWRx8BC729fy22Gtlzner4fj1lM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9qknuDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9qknuDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E04DC4CEEA;
	Mon, 23 Jun 2025 13:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684532;
	bh=jwE4BWeTnR62p3K1QIQH034oyNExj2u23wNS72lAIDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l9qknuDhaFVGZvq5CM0t9iKNHpnwqJCv+i+AFfXMRFo5lXgxvXiiGJodQ0q3819iT
	 OY/SH4/23oUKaFWyiYKxA0vQpl934NIrjdddPy5Q86QRynjYKUQIJ/PN7f6ElWRYeV
	 7wk6fdN2/Qhcb9Vg5ZsXQFl8Fm7QWSTCAU4dz2i0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Werling <brett.werling@garmin.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.15 102/592] can: tcan4x5x: fix power regulator retrieval during probe
Date: Mon, 23 Jun 2025 15:01:00 +0200
Message-ID: <20250623130702.702632376@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Brett Werling <brett.werling@garmin.com>

commit db22720545207f734aaa9d9f71637bfc8b0155e0 upstream.

Fixes the power regulator retrieval in tcan4x5x_can_probe() by ensuring
the regulator pointer is not set to NULL in the successful return from
devm_regulator_get_optional().

Fixes: 3814ca3a10be ("can: tcan4x5x: tcan4x5x_can_probe(): turn on the power before parsing the config")
Signed-off-by: Brett Werling <brett.werling@garmin.com>
Link: https://patch.msgid.link/20250612191825.3646364-1-brett.werling@garmin.com
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/m_can/tcan4x5x-core.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/net/can/m_can/tcan4x5x-core.c
+++ b/drivers/net/can/m_can/tcan4x5x-core.c
@@ -411,10 +411,11 @@ static int tcan4x5x_can_probe(struct spi
 	priv = cdev_to_priv(mcan_class);
 
 	priv->power = devm_regulator_get_optional(&spi->dev, "vsup");
-	if (PTR_ERR(priv->power) == -EPROBE_DEFER) {
-		ret = -EPROBE_DEFER;
-		goto out_m_can_class_free_dev;
-	} else {
+	if (IS_ERR(priv->power)) {
+		if (PTR_ERR(priv->power) == -EPROBE_DEFER) {
+			ret = -EPROBE_DEFER;
+			goto out_m_can_class_free_dev;
+		}
 		priv->power = NULL;
 	}
 


