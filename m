Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717A21E8324;
	Mon, 23 Jun 2025 21:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713214; cv=none; b=twji9tq3LivPlDaUTXCU3RkyQ1noAN2NGK47hPjU4WTHiWkFB/8lmCjeBokWptRImkUpQQeJrst/nGh5RIc8Dd7r7GydsA11s+rnoiyD6eKhmyvx58J2YS/QS33sWn5tSLtF9sGFcss3EqFcStjqDnNlxg9u09wBvZibzfQe+zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713214; c=relaxed/simple;
	bh=a3BIQAfHd2Z5JT7EXrFeRsARMfpb8fGQVH9G47SxzxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCgX25it6x/Xo/LEmfClLpRH9YNQydWAZkZ56Svi0R0MvTkB/mZeuUWEJwn0hkbTQP/UtbOkNPrExrwrSWOtZpzvKJHR30/Jo3xLYImeZcO1egAY+mStEzUWIbWbRflxoRk/kO4sw5kM3QKpHR+dYfqwKYwn9UqkLrObPkdCkMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jzXk9PcA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jzXk9PcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ABC0C4CEED;
	Mon, 23 Jun 2025 21:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713214;
	bh=a3BIQAfHd2Z5JT7EXrFeRsARMfpb8fGQVH9G47SxzxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jzXk9PcAPDo5MGGCkAjlXhLOreK6svb7Mr7s8lhTYYmLhz2E2e/eZf+aOe4jDDyqY
	 4H92cXlKyAjVOGUr9+gw/6BIfUZ2N8s/PYcjb8nT2NJAg/Mk/jFGWwKa67l5a2oEGu
	 j5qOzt1+z0jzGgu9XEk69FC7xA3BPvKhkbwWWh+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Werling <brett.werling@garmin.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 054/290] can: tcan4x5x: fix power regulator retrieval during probe
Date: Mon, 23 Jun 2025 15:05:15 +0200
Message-ID: <20250623130628.629077596@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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
@@ -385,10 +385,11 @@ static int tcan4x5x_can_probe(struct spi
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
 


