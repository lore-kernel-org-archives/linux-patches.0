Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BF9402BBA;
	Wed, 20 May 2026 18:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302534; cv=none; b=J844lsjf6ALSgPvJ99DIrR86UADEWm0P5dhEYdwst+dlVI0slRELElMiVDrR+pkc1R2elogSEy8v58O00bLcS4nvKxfdSqhvwHKkRPmt9DBxudysog81JKYgYM1W9sHEe4IzjjXH6tJPpC7TTTwSXLFwBPpzWZg5V1pX+QwxiBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302534; c=relaxed/simple;
	bh=01JqyYmv8UtXKRp9x4sYgi4uxaxvPnqiCrsSHN+5zo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atCgOM/mqMSV4WclcN6+FWUDZU8YirWVCvPSgzGwct+7h0wN1wpa5t05bHQXMtss4U+vBhZ03MTHuHGakVFFA/syqtGSESMRki4jhyFiq/idSP9ynmUjhgAWAHGbgu8uPhMqbZrAt0ntGefoFbF+6Q8CigeeqUaHYkyfdSnYffI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sPeULikn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sPeULikn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9021F000E9;
	Wed, 20 May 2026 18:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302532;
	bh=EqHDXbfoFZ1q3v1wXvyujRxhlysJktB968RMYrzSZ4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sPeULiknhuqQdmLr0dXl4/LBz+UBfNgVAT7Kunwhrz4iNACW9sCOEyp75+CELbUpu
	 uHZ7GA3pOIzuWiW5V+QzGdbRrLY6l4weBFlytHJnvMRpBZMmDFSRk68nCft7l1RUTT
	 jZqk31peYcx0uWb8trImZgRQbREaAcQxX1ogBppM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 261/508] backlight: sky81452-backlight: Check return value of devm_gpiod_get_optional() in sky81452_bl_parse_dt()
Date: Wed, 20 May 2026 18:21:24 +0200
Message-ID: <20260520162104.300763415@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 797cc011ae02bda26f93d25a4442d7a1a77d84df ]

The devm_gpiod_get_optional() function may return an ERR_PTR in case of
genuine GPIO acquisition errors, not just NULL which indicates the
legitimate absence of an optional GPIO.

Add an IS_ERR() check after the call in sky81452_bl_parse_dt(). On
error, return the error code to ensure proper failure handling rather
than proceeding with invalid pointers.

Fixes: e1915eec54a6 ("backlight: sky81452: Convert to GPIO descriptors")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Link: https://patch.msgid.link/20260203021625.578678-1-nichen@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/sky81452-backlight.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/backlight/sky81452-backlight.c b/drivers/video/backlight/sky81452-backlight.c
index eb18c6eb0ff0d..6ce1c3c5f5676 100644
--- a/drivers/video/backlight/sky81452-backlight.c
+++ b/drivers/video/backlight/sky81452-backlight.c
@@ -204,6 +204,9 @@ static struct sky81452_bl_platform_data *sky81452_bl_parse_dt(
 	pdata->dpwm_mode = of_property_read_bool(np, "skyworks,dpwm-mode");
 	pdata->phase_shift = of_property_read_bool(np, "skyworks,phase-shift");
 	pdata->gpiod_enable = devm_gpiod_get_optional(dev, NULL, GPIOD_OUT_HIGH);
+	if (IS_ERR(pdata->gpiod_enable))
+		return dev_err_cast_probe(dev, pdata->gpiod_enable,
+					  "failed to get gpio\n");
 
 	ret = of_property_count_u32_elems(np, "led-sources");
 	if (ret < 0) {
-- 
2.53.0



