Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC4048CDD;
	Tue, 23 Jan 2024 00:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969853; cv=none; b=Ds421/NgsUaxGTWoR7dh0cGDz4bDXWufrnuu1Tztd7LrLIElYS3pJZGZ/bhJSSqUx5x+18BHDVNxCa+NZIySlePU3wopWchqRidiXiKTYMBjcVcagILZQWCIMedezkMUeLcd6gNXla5fuy2pBoSUEOPMhU+pmlcTZeGKJCzssqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969853; c=relaxed/simple;
	bh=Yjx6dfb4oW3axsOCN5iwNE/fLNeTsC+6bAXpVFKk92Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDHjTFzZc0CJvsM8TZrynZvX4BjORmu5gdO3RFdlYcruZZ/oK8IfwFCdONMxsOyOsZ7XGSC+zdBYBOBzUy3wyzqvOMJBG2UlztlsEyethmmRA78db1RrGJj5m62kQvA3+BLZGzDU4huguLQFIm7xaIxMdULSpXUvRhATPcwYj64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HA45cvq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HA45cvq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C546DC433C7;
	Tue, 23 Jan 2024 00:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969853;
	bh=Yjx6dfb4oW3axsOCN5iwNE/fLNeTsC+6bAXpVFKk92Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HA45cvq12VQAIiaCUPEUVUYISeKTUhHBSVRZsdAfx4ejFd1GPx7diaEiFQaO1jARE
	 9OD81RiTuL+s8N5aMBlZRyiWGBZqVZxFH6GK0l6j8wBtrZedBDvumHrKPaIoC0dNWJ
	 pwaH7hDvPVyQBJaKdINnMBomrrelIKOd8e/tJLUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kurbanov <mmkurbanov@salutedevices.com>,
	Dmitry Rokosov <ddrokosov@salutedevices.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 487/641] leds: aw200xx: Fix write to DIM parameter
Date: Mon, 22 Jan 2024 15:56:31 -0800
Message-ID: <20240122235833.325168548@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Kurbanov <mmkurbanov@salutedevices.com>

[ Upstream commit adfd4621b78d0c02da91335da2b9ad847cb7b39e ]

If write only DIM value to the page 4, LED brightness will not be
updated, as both DIM and FADE need to be written to the page 4.
Therefore, write DIM to the page 1.

Fixes: 36a87f371b7a ("leds: Add AW20xx driver")
Signed-off-by: Martin Kurbanov <mmkurbanov@salutedevices.com>
Signed-off-by: Dmitry Rokosov <ddrokosov@salutedevices.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20231125200519.1750-2-ddrokosov@salutedevices.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-aw200xx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-aw200xx.c b/drivers/leds/leds-aw200xx.c
index 14ca236ce29e..f3bed4f05b34 100644
--- a/drivers/leds/leds-aw200xx.c
+++ b/drivers/leds/leds-aw200xx.c
@@ -74,6 +74,10 @@
 #define AW200XX_LED2REG(x, columns) \
 	((x) + (((x) / (columns)) * (AW200XX_DSIZE_COLUMNS_MAX - (columns))))
 
+/* DIM current configuration register on page 1 */
+#define AW200XX_REG_DIM_PAGE1(x, columns) \
+	AW200XX_REG(AW200XX_PAGE1, AW200XX_LED2REG(x, columns))
+
 /*
  * DIM current configuration register (page 4).
  * The even address for current DIM configuration.
@@ -153,7 +157,8 @@ static ssize_t dim_store(struct device *dev, struct device_attribute *devattr,
 
 	if (dim >= 0) {
 		ret = regmap_write(chip->regmap,
-				   AW200XX_REG_DIM(led->num, columns), dim);
+				   AW200XX_REG_DIM_PAGE1(led->num, columns),
+				   dim);
 		if (ret)
 			goto out_unlock;
 	}
-- 
2.43.0



