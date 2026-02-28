Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3AF32ED2A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301916; cv=none; b=c7qFqGuxDwkVSIvHL33f491OqcGqZKmQcNzqXohCr2+DxVwV8M6qM77mGJ0UsoqC+Ul/A+GkGNBRofzYqOSUNGevVtnCT+sexklCg3ejWjj/u86ZSM2q0bfp7OYChm+nCoxX+GQDbNxRHI8iO8fQkLETDPBk4sB61kdhFA2vPAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301916; c=relaxed/simple;
	bh=3mwP6kznYyfkESHOLI2pSkeQTHVZmh6DBvlZpT+RJ44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBe0kM4zV6YOToYdk8G0kk7vKDaFe9WR0MMcKCnMx0e8IPTmk24zK8XZ89zhstyyncc1VD448Cj8JldWbyXlxirqRvHYBQfkp3P3rzA64CYzmZzdwOCxYJM2PgCY+TIVyvlSCLXGLSEDGkQo0Qk0tyDs1srGKhOlsGAtC6Z0yWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E2cC7Mkr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E2cC7Mkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD52C116D0;
	Sat, 28 Feb 2026 18:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301916;
	bh=3mwP6kznYyfkESHOLI2pSkeQTHVZmh6DBvlZpT+RJ44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E2cC7Mkr2K168rrm2h7c2JTkZ2JszhdNyYXkGNpZh5NZ77VMAE+Wm5YelsQkkAolz
	 /FiTzqjuqZXv70gPt2WfTQnX3amxsSZWCBW+1fEOF8vCIzJvwkuK3mlBwKcyJQbKbV
	 7CRh4QumAGo0l8v5ixjm0FBkQxp5k7azt7gQhNGcsDNnr6YJEUtat4bFmx/W0xyvty
	 hVVzkIGLQZPmHWVWM5iFxKb9q2TKwHDIVljTN8I/E2hS36/mubr+SEz2Msjl2ICSPH
	 UPlTQa/CWu0o8KYgvpgJ0GA2ZOwNVE22srmVUvDUgGGWvxloPftyeuNvgUtZYkjyrV
	 mmoaML+y91rRw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 349/385] leds: qcom-lpg: Check the return value of regmap_bulk_write()
Date: Sat, 28 Feb 2026 12:59:31 -0500
Message-ID: <20260228180011.1568201-349-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 84e02867f3b43..98c60e971b48f 100644
--- a/drivers/leds/rgb/leds-qcom-lpg.c
+++ b/drivers/leds/rgb/leds-qcom-lpg.c
@@ -368,7 +368,7 @@ static int lpg_lut_store(struct lpg *lpg, struct led_pattern *pattern,
 {
 	unsigned int idx;
 	u16 val;
-	int i;
+	int i, ret;
 
 	idx = bitmap_find_next_zero_area(lpg->lut_bitmap, lpg->lut_size,
 					 0, len, 0);
@@ -378,8 +378,10 @@ static int lpg_lut_store(struct lpg *lpg, struct led_pattern *pattern,
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

