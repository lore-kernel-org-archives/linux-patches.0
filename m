Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C743115B8;
	Wed, 25 Feb 2026 06:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002696; cv=none; b=P7qrsiTCidubgqeWSejkzZHI/btoZw37tEH8aPxAFlfUVXQG1UNLZGSwqaNZt2dSzycyf4tgXSq9X5BvsBakOArKmucjDVS9X+xYxkCbglwODc2jr2BIcM/Oy6BXX9B65vuX0oxQvpb6UMlp9LiY1Mv9Flk1+PQo0k2oFr+GNVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002696; c=relaxed/simple;
	bh=dIfRM7ntspt5ciRIoc0OYHkJI9pw6UcZKPs/1y7pCK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlEE1CdIUVvLwpW9KXbWzdbXq82L/sd9W4leGt4G0/FGchF+hoFXCNHxmzXwwypkCM3QKJKWt15N3I8OTxB4lAqNGG//MNlgdl0jqaKih9etGdcCUpFd8pL8eBnOiui4L89YFdUdL2hq6zh2qwcUteqN9pBiIMWJHgyRnbuM2OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9z+yJ3d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9z+yJ3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BB3C2BC86;
	Wed, 25 Feb 2026 06:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002696;
	bh=dIfRM7ntspt5ciRIoc0OYHkJI9pw6UcZKPs/1y7pCK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v9z+yJ3d1OyssxGfY6vJ14uMj1w0v0FVFz2sSzr5jw3N/zNBguw6ArqVgkrDPyOWI
	 CrP0VJ+K3ediQp+w3BBAeNTzwIwSlvXJG4rt8losnz0Ae7vaug0PLf8jYk0m8qbK11
	 9AzC+ya4SsR/942t8gymwuD4hZM42oUfazD9levE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 493/641] leds: qcom-lpg: Check the return value of regmap_bulk_write()
Date: Tue, 24 Feb 2026 17:23:39 -0800
Message-ID: <20260225012400.463705832@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit f42033b5ce8c79c5db645916c9a72ee3e10cecfa ]

The lpg_lut_store() function currently ignores the return value of
regmap_bulk_write() and always returns 0. This can cause hardware write
failures to go undetected, leading the caller to believe LUT programming
succeeded when it may have failed.

Check the return value of regmap_bulk_write() in lpg_lut_store and return
the error to the caller on failure.

Fixes: 24e2d05d1b68 ("leds: Add driver for Qualcomm LPG")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260108175133.638-1-vulab@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/rgb/leds-qcom-lpg.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/rgb/leds-qcom-lpg.c b/drivers/leds/rgb/leds-qcom-lpg.c
index e197f548cddb0..a460782dadca4 100644
--- a/drivers/leds/rgb/leds-qcom-lpg.c
+++ b/drivers/leds/rgb/leds-qcom-lpg.c
@@ -369,7 +369,7 @@ static int lpg_lut_store(struct lpg *lpg, struct led_pattern *pattern,
 {
 	unsigned int idx;
 	u16 val;
-	int i;
+	int i, ret;
 
 	idx = bitmap_find_next_zero_area(lpg->lut_bitmap, lpg->lut_size,
 					 0, len, 0);
@@ -379,8 +379,10 @@ static int lpg_lut_store(struct lpg *lpg, struct led_pattern *pattern,
 	for (i = 0; i < len; i++) {
 		val = pattern[i].brightness;
 
-		regmap_bulk_write(lpg->map, lpg->lut_base + LPG_LUT_REG(idx + i),
-				  &val, sizeof(val));
+		ret = regmap_bulk_write(lpg->map, lpg->lut_base + LPG_LUT_REG(idx + i),
+					&val, sizeof(val));
+		if (ret)
+			return ret;
 	}
 
 	bitmap_set(lpg->lut_bitmap, idx, len);
-- 
2.51.0



