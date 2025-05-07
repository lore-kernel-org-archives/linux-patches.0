Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D9C29A0;
	Wed,  7 May 2025 19:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644614; cv=none; b=szZzHWAsOluSLhAjNtMdFt5BmhDfcSoMH4GLwofPjvmnW38kAKo6NH+6IVihXRC3P6NS4/nt8tfpeEr2eBFB4+u4d0KHfjjer46GRSdq+playzd9ytoZ4NFXCGn9nADW435roazwrwJnvyAVbH9eU6k9KG/MUeO/H6Q7sy/4XGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644614; c=relaxed/simple;
	bh=26eTC2p2ZrAJtfWHA1+yE61usq+5vaabwMxfMAzUyes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ab3OwNb9utL0IB6eRvkuOlPHxWlTNE3f2ykkUfGIP/jhX8bscRQd3rCU0OFol3Anq44wqt+4iovaDk0iqMgjnwKX+dDKliUhYoXLL3lRUj4IaJSg3h40CxzgCvpQTeB5X0s0vsQaJrjfGTAOe0kwFdQ/APEo/heUVkn2nI1satA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHGfK43+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHGfK43+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390FAC4CEE2;
	Wed,  7 May 2025 19:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644614;
	bh=26eTC2p2ZrAJtfWHA1+yE61usq+5vaabwMxfMAzUyes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kHGfK43+yP1fdnScbBfQHdOGXFqeJuG0vDUW1tJJpzfg+WcTUqdtBDOh7ZEHdkzwz
	 nFMVqO1yy0VF2m77a1MaAo3mHWOFx8A3yecFg7QpHuwZp/q9mxS1VSScYdKe6eQnPx
	 gEY/qQptMMibb8cZnuMWRO4TzPn4bPavpEsN46gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Russell Cloran <rcloran@gmail.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 101/164] drm/mipi-dbi: Fix blanking for non-16 bit formats
Date: Wed,  7 May 2025 20:39:46 +0200
Message-ID: <20250507183825.064618278@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell Cloran <rcloran@gmail.com>

[ Upstream commit 1a8bc0fe8039e1e57f68c4a588f0403d98bfeb1f ]

On r6x2b6x2g6x2 displays not enough blank data is sent to blank the
entire screen. When support for these displays was added, the dirty
function was updated to handle the different amount of data, but
blanking was not, and remained hardcoded as 2 bytes per pixel.

This change applies almost the same algorithm used in the dirty function
to the blank function, but there is no fb available at that point, and
no concern about having to transform any data, so the dbidev pixel
format is always used for calculating the length.

Fixes: 4aebb79021f3 ("drm/mipi-dbi: Add support for DRM_FORMAT_RGB888")
Signed-off-by: Russell Cloran <rcloran@gmail.com>
Link: https://lore.kernel.org/r/20250415053259.79572-1-rcloran@gmail.com
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_mipi_dbi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_mipi_dbi.c b/drivers/gpu/drm/drm_mipi_dbi.c
index 34bca75675766..3ea9f23b4f67a 100644
--- a/drivers/gpu/drm/drm_mipi_dbi.c
+++ b/drivers/gpu/drm/drm_mipi_dbi.c
@@ -404,12 +404,16 @@ static void mipi_dbi_blank(struct mipi_dbi_dev *dbidev)
 	u16 height = drm->mode_config.min_height;
 	u16 width = drm->mode_config.min_width;
 	struct mipi_dbi *dbi = &dbidev->dbi;
-	size_t len = width * height * 2;
+	const struct drm_format_info *dst_format;
+	size_t len;
 	int idx;
 
 	if (!drm_dev_enter(drm, &idx))
 		return;
 
+	dst_format = drm_format_info(dbidev->pixel_format);
+	len = drm_format_info_min_pitch(dst_format, 0, width) * height;
+
 	memset(dbidev->tx_buf, 0, len);
 
 	mipi_dbi_set_window_address(dbidev, 0, width - 1, 0, height - 1);
-- 
2.39.5



