Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8793122540A;
	Thu, 12 Dec 2024 16:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021684; cv=none; b=sxo11kFANv45izNh8R+qATCXjjQHNi3MxODS/yodcP4if42rEOGINSa+Qjub0F3s5LHqACM0twEtrg5pOYcmcOnk1DMM0O18XCRXLon5WRuPZYRCH9YQaImSo3G2MDF1Z4HEjKW3cPvwph7rNJp5/a7md3PLzQKfCwSsGNAgWFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021684; c=relaxed/simple;
	bh=Njue87T6jO81O9j/9DM5r59/0HJmwVS0aZmXpSeHU6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qA5pV/IGhNO6FzBn3K8dcp8i1tdgqT6wCtq1ZdmwcnFBuw3GD9c8qk4GCmB5mzUVykgWfBpkuoNazjdZOwi8weG2QqhlCMBqKfs6SSNokZNErfD3B4kBGEk80DjBKZuzuUNjAeIAfEtlwK/dyG+YHy7328mDyHjb4i32gHjZpJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6heTiYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6heTiYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FC7C4CECE;
	Thu, 12 Dec 2024 16:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021684;
	bh=Njue87T6jO81O9j/9DM5r59/0HJmwVS0aZmXpSeHU6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L6heTiYkFCbfzAcgnJjKPeQ6Ce/ZYkS5TcYr/iSzqAZuGHPmAdFfyT5LN9MdVdZwE
	 Rzh52BIpVjn8v35L8cuUljDoaGw72yOtKJhpChiLbSDWSHCHf+teeQZSJ4KlbnwGjy
	 u7wSJObUWDFWYDqvYZsTaG7VqJbx3MRN4/ouwY10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 5.15 034/565] drm/bridge: tc358768: Fix DSI command tx
Date: Thu, 12 Dec 2024 15:53:49 +0100
Message-ID: <20241212144312.803960017@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -124,6 +124,9 @@
 #define TC358768_DSI_CONFW_MODE_CLR	(6 << 29)
 #define TC358768_DSI_CONFW_ADDR_DSI_CONTROL	(0x3 << 24)
 
+/* TC358768_DSICMD_TX (0x0600) register */
+#define TC358768_DSI_CMDTX_DC_START	BIT(0)
+
 static const char * const tc358768_supplies[] = {
 	"vddc", "vddmipi", "vddio"
 };
@@ -227,6 +230,21 @@ static void tc358768_update_bits(struct
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
@@ -507,8 +525,7 @@ static ssize_t tc358768_dsi_host_transfe
 		}
 	}
 
-	/* start transfer */
-	tc358768_write(priv, TC358768_DSICMD_TX, 1);
+	tc358768_dsicmd_tx(priv);
 
 	ret = tc358768_clear_error(priv);
 	if (ret)


