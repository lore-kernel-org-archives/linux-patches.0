Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3627233A713
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302238; cv=none; b=KjFfkCKEDpRXEfVP9/7BLXo1czRQpxOa0QErJn7ogb3OOhEXRAVM+4EAGRuhWoOYn0PrmF/CUKQwNp0NOylpQ3yYYSJck6UyTYjxXvQVLHzKsEu9tSl7CoJul2IPPdjbCbRobbX5S1DdK0v2Fkn0djRlIYthGChC4jSAT9v6lME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302238; c=relaxed/simple;
	bh=1bt3eJuOOHT3reUJo7ZW09FmjbBWuZfvPgWVJXZzoO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ox058wxi8PswOKzIctpFBRwfFeb+pM/+U8ojNFVk6K51HAxBlrfumXo4ylo1eLDXhiWr7GFcoDi24W9dRjvbV5mKQXuE0pbNtOgQQ6Gzoa/JeY1BOljpz2Jeq3I1COZYvDSXyaIODeH3D5VS6oRrH11Eyf7rmvKPXOzNRWOvbH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D8KfGAVF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D8KfGAVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BF5C116D0;
	Sat, 28 Feb 2026 18:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302238;
	bh=1bt3eJuOOHT3reUJo7ZW09FmjbBWuZfvPgWVJXZzoO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D8KfGAVF1MtXuwPprCUPO8KUC6Zp6o2BfS2ZTGwoedRIb3lwWODhtrcxDyNwDuP9l
	 9FW9WBekpebJ7tjQdyxKUreGpz8wzuA6Z5fZVbjMGzefVHFy+qwdleMrD10bSG53p+
	 Vb2efPNh73Et/HyynMyBV1bd/EtVs83Z503IxukmvZxxarPTnJCVn6xeTCBEpT5lH5
	 NYKzAnRbU4VFLogmcT5Lb7Ux7c2j6UqESQMv18tj6xUJuJbVEZD0wCVAxaDc2mb4iy
	 /bqF7SHKtJquIdwzjrhJILRiIBeeGO866mSdO91q7qEVzfYcImwJqUE7ShD6B3CLCp
	 d23Xi472zrrVw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 249/283] leds: qcom-lpg: Check the return value of regmap_bulk_write()
Date: Sat, 28 Feb 2026 13:06:31 -0500
Message-ID: <20260228180709.1583486-249-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index a41c2b13766dc..9843fe2e5f9eb 100644
--- a/drivers/leds/rgb/leds-qcom-lpg.c
+++ b/drivers/leds/rgb/leds-qcom-lpg.c
@@ -221,7 +221,7 @@ static int lpg_lut_store(struct lpg *lpg, struct led_pattern *pattern,
 {
 	unsigned int idx;
 	u16 val;
-	int i;
+	int i, ret;
 
 	idx = bitmap_find_next_zero_area(lpg->lut_bitmap, lpg->lut_size,
 					 0, len, 0);
@@ -231,8 +231,10 @@ static int lpg_lut_store(struct lpg *lpg, struct led_pattern *pattern,
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

