Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3715A2F7F17;
	Sat, 12 Sep 2026 16:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229435; cv=none; b=PL1HMoaUqrTDo3NFxRm2gLygLROHyrjt6dmwPj23XahheugSWmxPnFUB2thr9nufOwYWK8radic0Qbp1zIbaHcEBd3zZsfK9qXa//zz4MX8w3w2QU8miD4HNcQ5qy7E/VR9knWHU+ySJx1EScJC05XlKr4ZlbT4sXx/uW+eHDHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229435; c=relaxed/simple;
	bh=2B0hUVu+RODH918AQ1LNKh0bBCczGqkIAg1R4dTPGno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZoOzb/OHP6dBgHu3m3L4AcYoLnO5mLIO4JorkximtKc7pBnqo2CwH0hR8cVd3wOragc6mYRGjo7Xcmf0OF+HS6dOK/gsuv1ebs1L2b1nQ16zl24fRq5RCGFMwI5uhXi+n6yQqQ0bdR4Q/6Y1DJkGAVJZlvu8VT+6bhQeMRleN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rDM4GEuE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rDM4GEuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734571F000FF;
	Sat, 12 Sep 2026 16:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229433;
	bh=yJltfFek75ovhK4mR8R4455v0Qn+g3Y31z/V0alGGdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rDM4GEuEosKAuPsa9p5j+x0+EdRLOSOf+jLz41aTjbxbuMJ2kojqlWZYz4/NM79xE
	 LTDCweaP6B+B1QTjmqoCk7RvWguW+r7YWrPrHTKNbjTJEKtxM6UEmjb7cMGxI0LObg
	 tRGGKahr0u2hkm6g0YPaMfbzVmE8jKS7+5cEWJzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0588/1191] drm/panel: samsung-s6d16d0: Power off on prepare failure
Date: Sat, 12 Sep 2026 08:55:16 +0200
Message-ID: <20260912065601.454939850@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>

[ Upstream commit a9f950adfe2147318d75e7a6eab5e814851802ac ]

If enabling tearing mode or exiting sleep mode fails after the
regulator is enabled, s6d16d0_prepare() returns without asserting
reset or disabling the supply. Since the DRM panel core leaves the
panel unprepared, a later unprepare call skips the driver callback
and the supply remains enabled.

Assert reset and disable the supply before returning the DSI command error.

Fixes: ac1d6d74884e ("drm/panel: Add driver for Samsung S6D16D0 panel")
Assisted-by: Codex:gpt-5
Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260704070648.35249-1-acharyalaxman8848@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-samsung-s6d16d0.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-samsung-s6d16d0.c b/drivers/gpu/drm/panel/panel-samsung-s6d16d0.c
index 008e2b0d6652b..ae8bb9d90d2a8 100644
--- a/drivers/gpu/drm/panel/panel-samsung-s6d16d0.c
+++ b/drivers/gpu/drm/panel/panel-samsung-s6d16d0.c
@@ -89,16 +89,22 @@ static int s6d16d0_prepare(struct drm_panel *panel)
 				       MIPI_DSI_DCS_TEAR_MODE_VBLANK);
 	if (ret) {
 		dev_err(s6->dev, "failed to enable vblank TE (%d)\n", ret);
-		return ret;
+		goto err_power_off;
 	}
 	/* Exit sleep mode and power on */
 	ret = mipi_dsi_dcs_exit_sleep_mode(dsi);
 	if (ret) {
 		dev_err(s6->dev, "failed to exit sleep mode (%d)\n", ret);
-		return ret;
+		goto err_power_off;
 	}
 
 	return 0;
+
+err_power_off:
+	gpiod_set_value_cansleep(s6->reset_gpio, 1);
+	regulator_disable(s6->supply);
+
+	return ret;
 }
 
 static int s6d16d0_enable(struct drm_panel *panel)
-- 
2.53.0



