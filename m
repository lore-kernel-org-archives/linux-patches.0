Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5791A6195;
	Tue, 30 Jul 2024 16:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356878; cv=none; b=bWmVki/jhOfZHm4ghRSjU6K7VSE4HDChFjZqsg6v63rngs4vEHQewPvVmzNuV0uhUznWx1xFPc1Eb3t1wucyJ6n7ImtDEvbIJGFBw8g2L0Xvz+r/1qDmvi1bAYg507WRvG7oHzcPA8uOaRVGyS7S15xMG369Q7niEO6iRJ2Auco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356878; c=relaxed/simple;
	bh=DrGOWUMnIKFUHo4gqJr0Fl032NrfkQZLgMWx9xiLqas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFMLnfI0rLcUX+DU2T06gC5eKpMtrzU2MdxPW2VLSy53B9smxeb5+apVugafSjcG/rUGVeTzO8C6Ow8EoHPfiiKr7zxpiK6zH0u12A/LotJFCHU5lvzbD6eJVqjXwKy4R+w0A8jzt7ew4Gx1RhucusFV9dSyJOCsaTOXgYaBEhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VP2N4vS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VP2N4vS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A509CC32782;
	Tue, 30 Jul 2024 16:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356878;
	bh=DrGOWUMnIKFUHo4gqJr0Fl032NrfkQZLgMWx9xiLqas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VP2N4vS8ecyL1/tCE2/eKIwjnsR24omhABtFn0mIYJqfSZqm6jcbQWs9WuiNRj4Kz
	 b+9o3H1dN1b638RsBJxG4G8PUN9jCicDBpx4oQfPI+fHsKWATV6hgnv3nihexRx+qn
	 mAeyt4L+cPuY1IxHbXTXnWx3pOAl5BhdMG+K/Xr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 178/568] drm/mipi-dsi: Fix theoretical int overflow in mipi_dsi_dcs_write_seq()
Date: Tue, 30 Jul 2024 17:44:45 +0200
Message-ID: <20240730151646.836869234@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index 3011d33eccbd2..e0e2c17832e89 100644
--- a/include/drm/drm_mipi_dsi.h
+++ b/include/drm/drm_mipi_dsi.h
@@ -324,18 +324,18 @@ int mipi_dsi_dcs_get_display_brightness_large(struct mipi_dsi_device *dsi,
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



