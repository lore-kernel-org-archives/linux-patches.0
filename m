Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1617D183CA0;
	Tue, 30 Jul 2024 16:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355787; cv=none; b=sK5oC176M9BiKHqHrdtMyQ4EXr3+qAgIYHDVywbSL6Pv7bt3B45c4G5cD2j2blYfgJbuP3IP/wmCcnYttd2TxA/kJTIAxpVAkMVtX/CmeJOfW+24o2x0bjiaXmtpmsCgjuZirshVcSK8UNLDm+uFDPib+bF30WyTKK+SHdMYeAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355787; c=relaxed/simple;
	bh=woFqQ4Ox2WkAe1/g6uhlAvSNr3xWH0MKeC/C7XBdaUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSFVKEv6ErfsKX+fLCoBqqOD9fFXNPml0+iE9NHQmep8t7PVt1DBjPlHXvyhcdZ25rmtCJX5X8IoRZvSBDHUdNKfuB3ZvzfOK65td2M6xkMn6cH+qhkoDigChqzf68Ox0PYLWu53DjtMLk9aJtg8KpsYKZfjR1HOHDOZD5Sn26o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGjaNNL4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGjaNNL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C33C4AF0A;
	Tue, 30 Jul 2024 16:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355786;
	bh=woFqQ4Ox2WkAe1/g6uhlAvSNr3xWH0MKeC/C7XBdaUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NGjaNNL4apVG2XJtKSM4iF0Cj8GNxZqFYa5xNYBO9Hz8+3/Ej2Ol3EU2vMOUW04wE
	 qvnyr1V4k3zINptx0GwjzDp/siVnk79OuG25AQrBqPm/e9L5zlHWe4xeFtqV0XVki3
	 wTv8M6dvW6MjH8cSs1LOBA0xq+4NLCLGyLHVBjmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/440] drm/mipi-dsi: Fix theoretical int overflow in mipi_dsi_dcs_write_seq()
Date: Tue, 30 Jul 2024 17:46:03 +0200
Message-ID: <20240730151620.959807807@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
index 9dd1093b2dfa9..1a921e8943a03 100644
--- a/include/drm/drm_mipi_dsi.h
+++ b/include/drm/drm_mipi_dsi.h
@@ -309,18 +309,18 @@ int mipi_dsi_dcs_get_display_brightness_large(struct mipi_dsi_device *dsi,
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



