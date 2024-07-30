Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFCD18990B;
	Tue, 30 Jul 2024 16:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357600; cv=none; b=oOUljXrsGjkPybpyokInXQejL7IRmp5YNI+m/TsFp8QgQa5LWwAyT7F8klQou6a5X6ftU5hRbmuCiW1nFBOYXKfk59HtN2glD1JkGN+hKMPSo6Px64rlbLWrHgbqFiX6SMh6fbLuGSqkrKMO1fCrkr9O6BYfjHvW/SiDbpogp7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357600; c=relaxed/simple;
	bh=5kJzp9dD0/Yy6tU9IunpKd9UHMpk3SAjqqfaswpGza0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bE6scmS3Xfq0/Ig6cgarm+3WC8/xXg/mscqMCncNgvFTtLz0QZUvfX0riw8oVYJ+Elyp6BGdm0PH3ysO4kiGoWenDe+MkhdjSWoQBeQbHTA6MATvfAhviEQlNvbhBPpHXwec9MXB9adXjU5elvml0OgiF1VND5jManAeEW6KO3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GLmU/3L2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLmU/3L2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EF2C4AF14;
	Tue, 30 Jul 2024 16:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357600;
	bh=5kJzp9dD0/Yy6tU9IunpKd9UHMpk3SAjqqfaswpGza0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLmU/3L2T3J5W6I1k0BpptZOwyAEAx9Gnj+HEqCY3X6gn6vHcC17/lA9j+wZYbHJP
	 TKruSh586l8+7cEjsYkRiD3D3358W7rIF6x0MC/U6+5yjm688ne3U23gN4d4YHRWiC
	 RidrwOsRQbzKTwu18eJOCeQDQ0C9MnY3+Up1syXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 271/809] drm/mipi-dsi: Fix theoretical int overflow in mipi_dsi_generic_write_seq()
Date: Tue, 30 Jul 2024 17:42:27 +0200
Message-ID: <20240730151735.298062674@linuxfoundation.org>
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

[ Upstream commit 24acbcce5cc673886c2f4f9b3f6f89a9c6a53b7e ]

The mipi_dsi_generic_write_seq() macro makes a call to
mipi_dsi_generic_write() which returns a type ssize_t. The macro then
stores it in an int and checks to see if it's negative. This could
theoretically be a problem if "ssize_t" is larger than "int".

To see the issue, imagine that "ssize_t" is 32-bits and "int" is
16-bits, you could see a problem if there was some code out there that
looked like:

  mipi_dsi_generic_write_seq(dsi, <32768 bytes as arguments>);

...since we'd get back that 32768 bytes were transferred and 32768
stored in a 16-bit int would look negative.

Though there are no callsites where we'd actually hit this (even if
"int" was only 16-bit), it's cleaner to make the types match so let's
fix it.

Fixes: a9015ce59320 ("drm/mipi-dsi: Add a mipi_dsi_dcs_write_seq() macro")
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20240514102056.v5.2.Iadb65b8add19ed3ae3ed6425011beb97e380a912@changeid
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240514102056.v5.2.Iadb65b8add19ed3ae3ed6425011beb97e380a912@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/drm_mipi_dsi.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/drm/drm_mipi_dsi.h b/include/drm/drm_mipi_dsi.h
index 70ce0b8cbc68e..e0f56564bf975 100644
--- a/include/drm/drm_mipi_dsi.h
+++ b/include/drm/drm_mipi_dsi.h
@@ -314,17 +314,17 @@ int mipi_dsi_dcs_get_display_brightness_large(struct mipi_dsi_device *dsi,
  * @dsi: DSI peripheral device
  * @seq: buffer containing the payload
  */
-#define mipi_dsi_generic_write_seq(dsi, seq...)                                \
-	do {                                                                   \
-		static const u8 d[] = { seq };                                 \
-		struct device *dev = &dsi->dev;                                \
-		int ret;                                                       \
-		ret = mipi_dsi_generic_write(dsi, d, ARRAY_SIZE(d));           \
-		if (ret < 0) {                                                 \
-			dev_err_ratelimited(dev, "transmit data failed: %d\n", \
-					    ret);                              \
-			return ret;                                            \
-		}                                                              \
+#define mipi_dsi_generic_write_seq(dsi, seq...)                                 \
+	do {                                                                    \
+		static const u8 d[] = { seq };                                  \
+		struct device *dev = &dsi->dev;                                 \
+		ssize_t ret;                                                    \
+		ret = mipi_dsi_generic_write(dsi, d, ARRAY_SIZE(d));            \
+		if (ret < 0) {                                                  \
+			dev_err_ratelimited(dev, "transmit data failed: %zd\n", \
+					    ret);                               \
+			return ret;                                             \
+		}                                                               \
 	} while (0)
 
 /**
-- 
2.43.0



