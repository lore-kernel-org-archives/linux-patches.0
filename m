Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D3B7E110;
	Tue, 29 Apr 2025 17:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946085; cv=none; b=kIg3MXmBBLbKQPu8PjUaEmxamtj5lM8y3i6eVa7aRUvjTLXljJzU5Ji/1l8j8eO80yLZld8/dYaZSFMiWNj5BnBAmCP57rScxEzE0h0cjQtFoAVeW8MsuTNqo1E8lidV3v9QY2qEGhHg/MFPBKcltI3N968wDr9ZqGT+FxcqxpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946085; c=relaxed/simple;
	bh=txD6A/0eVHSZBqD3X88bOQaLSohW/GerBKjOplxDPiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0fXSfqygBaJYud1lPYhZJgjxgE0wQAs1lhHEr8Tf2YCyOFklzo+EX7j4cdoNfvwq5rU+NaokNWC1CEPfgij7fPn7fbOxR+rJ4YPM7yVp85WtvpkIyErVuA3AlFNDygV8hn+UENH9ALXKPax9xcvDXaof53z7XrHuxJTSo2Rn8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1eCuDO3B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1eCuDO3B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C469EC4CEEA;
	Tue, 29 Apr 2025 17:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946085;
	bh=txD6A/0eVHSZBqD3X88bOQaLSohW/GerBKjOplxDPiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1eCuDO3BCi0uW7mPCwwk7kLFbUAalroUztM8ZsDmzM7fPbCXWdW1G4SSc+Q1tybUs
	 V4Mmwam0Ig6MKqMAS30Pnj0LjQHE9u01jkhv+xH7/b6aQeuSvYYM+i9quaUmoYrfCH
	 oRaM3SJ7tf4K9H5BmQJsh3HCkrhJuIu3UmnT5G7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.14 119/311] drm: panel: jd9365da: fix reset signal polarity in unprepare
Date: Tue, 29 Apr 2025 18:39:16 +0200
Message-ID: <20250429161125.914209111@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 095c8e61f4c71cd4630ee11a82e82cc341b38464 upstream.

commit a8972d5a49b4 ("drm: panel: jd9365da-h3: fix reset signal polarity")
fixed reset signal polarity in jadard_dsi_probe() and jadard_prepare().

It was not done in jadard_unprepare() because of an incorrect assumption
about reset line handling in power off mode. After looking into the
datasheet, it now appears that before disabling regulators, the reset line
is deasserted first, and if reset_before_power_off_vcioo is true, then the
reset line is asserted.

Fix reset polarity by inverting gpiod_set_value() second argument in
in jadard_unprepare().

Fixes: 6b818c533dd8 ("drm: panel: Add Jadard JD9365DA-H3 DSI panel")
Fixes: 2b976ad760dc ("drm/panel: jd9365da: Support for kd101ne3-40ti MIPI-DSI panel")
Fixes: a8972d5a49b4 ("drm: panel: jd9365da-h3: fix reset signal polarity")
Cc: stable@vger.kernel.org
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250417195507.778731-1-hugo@hugovil.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250417195507.778731-1-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c
+++ b/drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c
@@ -129,11 +129,11 @@ static int jadard_unprepare(struct drm_p
 {
 	struct jadard *jadard = panel_to_jadard(panel);
 
-	gpiod_set_value(jadard->reset, 1);
+	gpiod_set_value(jadard->reset, 0);
 	msleep(120);
 
 	if (jadard->desc->reset_before_power_off_vcioo) {
-		gpiod_set_value(jadard->reset, 0);
+		gpiod_set_value(jadard->reset, 1);
 
 		usleep_range(1000, 2000);
 	}


