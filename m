Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A3676C65;
	Mon, 29 Jan 2024 17:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548649; cv=none; b=BIfzcJgJutq80hdhhGCZ3TjASMndd3LtR2HOtWwx1MgJiC59XwMmpzfgPJbeKIfrVoLp4yq7iN6jU/bYGcpjxX/fcEHkIdIqPkq4T7XLFKkc+A0uDNk0+M0gqFfaJ+5xHCVg/0HvK2yHKpr1gcHVaJXbKeWuLK/oxIJ1h0uBg30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548649; c=relaxed/simple;
	bh=CHVm6sDxE8ArOYqpKM0Rkpat3KB31Nq6i98+l7yCCxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1eAJNn8kRxNhuEDq+8TBejC/zHu1+RSpmkUnDOFYP3V3UrUw3l/A07NLF19JHeL/U8B1H5cwJE7M7I2i7sZcfIQnheJGrLCYPvIplZFYId+zICgijHmR7DxIGAzZGMYqZGu+RJnJBD7d5aVzaglnU1+OLgfmkoku7eFDFN7OvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NhVJexAi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NhVJexAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B38BC433F1;
	Mon, 29 Jan 2024 17:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548649;
	bh=CHVm6sDxE8ArOYqpKM0Rkpat3KB31Nq6i98+l7yCCxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NhVJexAiZ4Be0FWjGlVgNLRTVqx6uctXuZ5M9IWm8dcCMg3MLBCtYVJLHt41QocHw
	 tiSTDk3qSmX6VRFIDjf/mheZWPTQeYVHdnT6aiYQVBU6VwSZoIT3AA10RbjRqPOx+1
	 J5ELi0cbQcNAw3sK4kWIIwcUEiy7rIHpgKCNQ7u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Jyri Sarha <jsarha@ti.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 304/331] drm/bridge: sii902x: Fix audio codec unregistration
Date: Mon, 29 Jan 2024 09:06:08 -0800
Message-ID: <20240129170023.769397690@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 3fc6c76a8d208d3955c9e64b382d0ff370bc61fc ]

The driver never unregisters the audio codec platform device, which can
lead to a crash on module reloading, nor does it handle the return value
from sii902x_audio_codec_init().

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Fixes: ff5781634c41 ("drm/bridge: sii902x: Implement HDMI audio support")
Cc: Jyri Sarha <jsarha@ti.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20240103-si902x-fixes-v1-2-b9fd3e448411@ideasonboard.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240103-si902x-fixes-v1-2-b9fd3e448411@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/sii902x.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/sii902x.c b/drivers/gpu/drm/bridge/sii902x.c
index 69da73e414a9..4560ae9cbce1 100644
--- a/drivers/gpu/drm/bridge/sii902x.c
+++ b/drivers/gpu/drm/bridge/sii902x.c
@@ -1080,7 +1080,9 @@ static int sii902x_init(struct sii902x *sii902x)
 			return ret;
 	}
 
-	sii902x_audio_codec_init(sii902x, dev);
+	ret = sii902x_audio_codec_init(sii902x, dev);
+	if (ret)
+		return ret;
 
 	i2c_set_clientdata(sii902x->i2c, sii902x);
 
@@ -1088,13 +1090,15 @@ static int sii902x_init(struct sii902x *sii902x)
 					1, 0, I2C_MUX_GATE,
 					sii902x_i2c_bypass_select,
 					sii902x_i2c_bypass_deselect);
-	if (!sii902x->i2cmux)
-		return -ENOMEM;
+	if (!sii902x->i2cmux) {
+		ret = -ENOMEM;
+		goto err_unreg_audio;
+	}
 
 	sii902x->i2cmux->priv = sii902x;
 	ret = i2c_mux_add_adapter(sii902x->i2cmux, 0, 0, 0);
 	if (ret)
-		return ret;
+		goto err_unreg_audio;
 
 	sii902x->bridge.funcs = &sii902x_bridge_funcs;
 	sii902x->bridge.of_node = dev->of_node;
@@ -1107,6 +1111,12 @@ static int sii902x_init(struct sii902x *sii902x)
 	drm_bridge_add(&sii902x->bridge);
 
 	return 0;
+
+err_unreg_audio:
+	if (!PTR_ERR_OR_ZERO(sii902x->audio.pdev))
+		platform_device_unregister(sii902x->audio.pdev);
+
+	return ret;
 }
 
 static int sii902x_probe(struct i2c_client *client)
@@ -1179,6 +1189,9 @@ static void sii902x_remove(struct i2c_client *client)
 
 	drm_bridge_remove(&sii902x->bridge);
 	i2c_mux_del_adapters(sii902x->i2cmux);
+
+	if (!PTR_ERR_OR_ZERO(sii902x->audio.pdev))
+		platform_device_unregister(sii902x->audio.pdev);
 }
 
 static const struct of_device_id sii902x_dt_ids[] = {
-- 
2.43.0



