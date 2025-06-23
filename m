Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6FC225A31;
	Mon, 23 Jun 2025 22:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716784; cv=none; b=hfhwR+rDu8xDPc9KfIa0liaZAYw+LUnfYpfcU/JMrRsLs9uvxEROIajnhEhmiJ3w4Aucvaq7bYLlC+ep0ynkffcLSO7bETgSwr6BTZRmQzUSO/yBrXmkjYiMGgy/LTAKdhSqbiJlwwA2n8ulFcs1CF0TJRk9P8D3DhRuCgGAXnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716784; c=relaxed/simple;
	bh=W8GC8xtHH5DDL+SpWSkyL1by4zYGfIsBZPY6eMop+e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0kS7JwPaGVWNs1ChphV5960ud2QcwLFscBJfM8SC0V0vscz+i/d6COHs/HJynObRK6wPpIg3SAVASHzPHk6aEEtl260veNOBAdlbJjRkUXtR4GdIDV3aaR0opnZo6feFyjpjaKQ2PDj0vdS5zH6u0B1G2KyQJ4vhO6WTz39o6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ln+gSbhD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ln+gSbhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DE9C4CEF1;
	Mon, 23 Jun 2025 22:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716783;
	bh=W8GC8xtHH5DDL+SpWSkyL1by4zYGfIsBZPY6eMop+e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ln+gSbhDMKbRPZAmHFIaknl4+UKsM8yIEfa9fANwYYWDUj0gZ0hfLAHXKYe9Zd/lp
	 q04jNZrRRNd01y8xqxr9lfRthcGRdJUMf1Dr3be4BVmr6aYlKrY2axTUEmLxtI2Y3N
	 3+V3xqfV3ZRz/vUqMLsYP5iz2381FeIIBmsggxOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Werling <brett.werling@garmin.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 328/508] can: tcan4x5x: fix power regulator retrieval during probe
Date: Mon, 23 Jun 2025 15:06:13 +0200
Message-ID: <20250623130653.393667466@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -310,10 +310,11 @@ static int tcan4x5x_can_probe(struct spi
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
 


