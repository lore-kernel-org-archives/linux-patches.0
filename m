Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F07214813;
	Wed,  7 May 2025 18:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644097; cv=none; b=XGx5K7JB4jVtBuBPfqDFyGezzWUw0XfmRtLPj4DdpmMuq9lbwYVvnorlRbjhwRcjJ9BaUtjCTv4Czqy707UhtK20vruo08NYfFh8cEAvi+fywMXYKqfjI6AwAnlTjBNbjNa138swOBLdcVOqklf0IXQVj4Ekq1V0wo77KZJFbjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644097; c=relaxed/simple;
	bh=SLke+ncZVxsSuDFPR10UgiyY+4fxBx6pjaXVQ2UIJWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YDncuTIPkytbanqDdarDoYqirMUyxcBLQswJ0hp8aVzQasYbIBzT21qLsBuUU8KD7B1ehyny2iQI0//VshPq+ny3iQGqULxKIQzG5MeaN15aDfBJ9bHMLpTEaT2OKp+2rYJyw7bQmPuS0gnwd8HzqPkkfuATmKjrAyOz0B7C6bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IWQqjZYq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IWQqjZYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D568C4CEE2;
	Wed,  7 May 2025 18:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644097;
	bh=SLke+ncZVxsSuDFPR10UgiyY+4fxBx6pjaXVQ2UIJWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IWQqjZYqcsLin7UcO84P8g79uWkcPwCgyNXjyudBXSNA/IiFU5AVBknxub5hDVa5p
	 lh9NmqBILwsMcoDsv3MYQ3Mf08Uo2lkM1hIev3JQOwwVwOZuVTP4GGLTbILxqCDhUE
	 aWpTfNT6RVFPhrY8pgvcqq5exq42/nT8gyHFwMp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Russell Cloran <rcloran@gmail.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 111/183] drm/mipi-dbi: Fix blanking for non-16 bit formats
Date: Wed,  7 May 2025 20:39:16 +0200
Message-ID: <20250507183829.323375155@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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



