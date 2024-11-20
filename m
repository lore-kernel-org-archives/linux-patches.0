Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967FB1ABEA3;
	Wed, 20 Nov 2024 13:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107675; cv=none; b=gIQSC7vw1K9JBK9k9aRbw7I7UHyT/AAm2SnTNlX8Zjecy9hrgiYeoR4r/D9hSZNDF9OhstPLiIbshw/KoyPItNZsQ1mWS24W4S7SbIUhmxQkbTuMjX0Vyop57JEud6Io9iFsLruGM/6BGG0WTIcgjz2P7T8aNA13oclmjYlYn7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107675; c=relaxed/simple;
	bh=4Ru3zBZvULVWIchRU1KrTugEkIfk2g86NOkk6K9yIc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWa+ZUZ4rAYssFmeOaJhYp5yy9ObJUQtQISZldeMfT86iWu6Czti4qgAaN0qtR2j5s1PaeGBWXoyt1H6KDQo0sm+OFm4Lgfgah7hyR2suWKtn4P87ANUdvRnEN7JfeCWUMC/YTjQ26uJU4mX2XGNtznLPmgOB7feQXIO8Z23sGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tz8CV7aI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tz8CV7aI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6454FC4CECD;
	Wed, 20 Nov 2024 13:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107675;
	bh=4Ru3zBZvULVWIchRU1KrTugEkIfk2g86NOkk6K9yIc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tz8CV7aI19Yj6Bu1E0CHXSlRzugW/JhgRKWHEXTrTEX7HRTVE5nUbAz5IK5Lyvixm
	 eWVKFt6CpPT67xXleXmu4G3bborZSLbGXqlVZZzEN4R/zMdh+ml7dOyiGOTesA+RtU
	 pSPMOMB0XUrqEWqEnZAUlRSyORJTHv4y6LX/Fnlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.1 32/73] drm/bridge: tc358768: Fix DSI command tx
Date: Wed, 20 Nov 2024 13:58:18 +0100
Message-ID: <20241120125810.381626418@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

commit 32c4514455b2b8fde506f8c0962f15c7e4c26f1d upstream.

Wait for the command transmission to be completed in the DSI transfer
function polling for the dc_start bit to go back to idle state after the
transmission is started.

This is documented in the datasheet and failures to do so lead to
commands corruption.

Fixes: ff1ca6397b1d ("drm/bridge: Add tc358768 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240926141246.48282-1-francesco@dolcini.it
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240926141246.48282-1-francesco@dolcini.it
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/tc358768.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/bridge/tc358768.c
+++ b/drivers/gpu/drm/bridge/tc358768.c
@@ -126,6 +126,9 @@
 #define TC358768_DSI_CONFW_MODE_CLR	(6 << 29)
 #define TC358768_DSI_CONFW_ADDR_DSI_CONTROL	(0x3 << 24)
 
+/* TC358768_DSICMD_TX (0x0600) register */
+#define TC358768_DSI_CMDTX_DC_START	BIT(0)
+
 static const char * const tc358768_supplies[] = {
 	"vddc", "vddmipi", "vddio"
 };
@@ -230,6 +233,21 @@ static void tc358768_update_bits(struct
 		tc358768_write(priv, reg, tmp);
 }
 
+static void tc358768_dsicmd_tx(struct tc358768_priv *priv)
+{
+	u32 val;
+
+	/* start transfer */
+	tc358768_write(priv, TC358768_DSICMD_TX, TC358768_DSI_CMDTX_DC_START);
+	if (priv->error)
+		return;
+
+	/* wait transfer completion */
+	priv->error = regmap_read_poll_timeout(priv->regmap, TC358768_DSICMD_TX, val,
+					       (val & TC358768_DSI_CMDTX_DC_START) == 0,
+					       100, 100000);
+}
+
 static int tc358768_sw_reset(struct tc358768_priv *priv)
 {
 	/* Assert Reset */
@@ -517,8 +535,7 @@ static ssize_t tc358768_dsi_host_transfe
 		}
 	}
 
-	/* start transfer */
-	tc358768_write(priv, TC358768_DSICMD_TX, 1);
+	tc358768_dsicmd_tx(priv);
 
 	ret = tc358768_clear_error(priv);
 	if (ret)


