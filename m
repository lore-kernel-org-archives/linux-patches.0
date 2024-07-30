Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FCA1898FF;
	Tue, 30 Jul 2024 16:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357590; cv=none; b=dLyzkxrkjbdUX6muL/r+a1UhkUp1AGj4sy/y/5oj74dlPMSE2ljWwgvplGAKLq7L72aj3HrSHsQZlzx7dRr1RhjLcYKYzz/FlRVz6YB7u/0hWVBJ5K14+qwi3ic7S59Hui3+mdN7wqQcZXIqC0HB0mA5EsnOtXTB6IsbZSUwAkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357590; c=relaxed/simple;
	bh=Q2vQ6m0fCWgC23nz+HO3dM5gax88mM214JP0akfmSCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzeOEWA1ZtJgNIPbGDNIlMR08dXk2cq5l7thFMmMrWs8v0xy3dOdxBt8zNmA3ASm2gOtg6Sd74eaZRcswyH8imSXpZCrZC44WMk5mbiZdAVeO6yDmGKU/yVNfU0GUo2AT0Av2Y0Fw2EtTjRT/G0aHMAJ5PfBsonf5RqSZsshue0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8XmW2Q/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8XmW2Q/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1E8C32782;
	Tue, 30 Jul 2024 16:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357590;
	bh=Q2vQ6m0fCWgC23nz+HO3dM5gax88mM214JP0akfmSCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8XmW2Q/s1U5KY5rMKLxs7UDpMQPIneAfwu4uIwIr1xie4j2bzx5mXVVePfdYKsuG
	 Wgs5V8has76E1/t3LUdUzfMvz2bk4Aoga74ZH+7UbSZlRSE5gklAywqFupfMdwE2n4
	 hgIdkUqPI068Z0tDPttSm9hrwjrIhZkvxf5qFslA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 270/809] drm/mipi-dsi: Fix theoretical int overflow in mipi_dsi_dcs_write_seq()
Date: Tue, 30 Jul 2024 17:42:26 +0200
Message-ID: <20240730151735.259513384@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 0b03829fdece47beba9ecb7dbcbde4585ee3663e ]

The mipi_dsi_dcs_write_seq() macro makes a call to
mipi_dsi_dcs_write_buffer() which returns a type ssize_t. The macro
then stores it in an int and checks to see if it's negative. This
could theoretically be a problem if "ssize_t" is larger than "int".

To see the issue, imagine that "ssize_t" is 32-bits and "int" is
16-bits, you could see a problem if there was some code out there that
looked like:

  mipi_dsi_dcs_write_seq(dsi, cmd, <32767 bytes as arguments>);

...since we'd get back that 32768 bytes were transferred and 32768
stored in a 16-bit int would look negative.

Though there are no callsites where we'd actually hit this (even if
"int" was only 16-bit), it's cleaner to make the types match so let's
fix it.

Fixes: 2a9e9daf7523 ("drm/mipi-dsi: Introduce mipi_dsi_dcs_write_seq macro")
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20240514102056.v5.1.I30fa4c8348ea316c886ef8a522a52fed617f930d@changeid
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240514102056.v5.1.I30fa4c8348ea316c886ef8a522a52fed617f930d@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/drm_mipi_dsi.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/drm/drm_mipi_dsi.h b/include/drm/drm_mipi_dsi.h
index 82b1cc434ea3f..70ce0b8cbc68e 100644
--- a/include/drm/drm_mipi_dsi.h
+++ b/include/drm/drm_mipi_dsi.h
@@ -333,18 +333,18 @@ int mipi_dsi_dcs_get_display_brightness_large(struct mipi_dsi_device *dsi,
  * @cmd: Command
  * @seq: buffer containing data to be transmitted
  */
-#define mipi_dsi_dcs_write_seq(dsi, cmd, seq...)                           \
-	do {                                                               \
-		static const u8 d[] = { cmd, seq };                        \
-		struct device *dev = &dsi->dev;                            \
-		int ret;                                                   \
-		ret = mipi_dsi_dcs_write_buffer(dsi, d, ARRAY_SIZE(d));    \
-		if (ret < 0) {                                             \
-			dev_err_ratelimited(                               \
-				dev, "sending command %#02x failed: %d\n", \
-				cmd, ret);                                 \
-			return ret;                                        \
-		}                                                          \
+#define mipi_dsi_dcs_write_seq(dsi, cmd, seq...)                            \
+	do {                                                                \
+		static const u8 d[] = { cmd, seq };                         \
+		struct device *dev = &dsi->dev;                             \
+		ssize_t ret;                                                \
+		ret = mipi_dsi_dcs_write_buffer(dsi, d, ARRAY_SIZE(d));     \
+		if (ret < 0) {                                              \
+			dev_err_ratelimited(                                \
+				dev, "sending command %#02x failed: %zd\n", \
+				cmd, ret);                                  \
+			return ret;                                         \
+		}                                                           \
 	} while (0)
 
 /**
-- 
2.43.0



