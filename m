Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A313D3CF7;
	Tue, 10 Mar 2026 11:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142136; cv=none; b=gr8ySGhutOIlg3SNxgVIaDQJSuRFZcpgEpHM4jns1PjdlcTQzIgTmbH4Vp4yHxnsiRW8syGXCPScu9lUJmTsce0R3PJXw1EN7jbNzmqB41RNs62X9H8OQcIWuEthoPco+Ciy5BNbMNCJCHSAIEf2VW4m2enWlusKWvm//k4o5f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142136; c=relaxed/simple;
	bh=LyVeIwi9BqGq6gRzBoe3vA8OSSSZfITg/KUa/0IA36w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+q8eBBpuyGyKI76pCBQd4HOB06b7MjzSg69aTqHftcBmXE2vWQx70h9JKNLzdcuKi4OyuQv7NneGCOsbw0rV5yDOxFHKIKIsMsCQpJn+J/mdFuZz2bOOtcWlhyqtoFJhYA7XTCN6jCswQygLHDBdus5Ak1KqiGWXV0ANUnuXDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nmrBdRqk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nmrBdRqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8615C2BCAF;
	Tue, 10 Mar 2026 11:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142136;
	bh=LyVeIwi9BqGq6gRzBoe3vA8OSSSZfITg/KUa/0IA36w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nmrBdRqkCpKJN9o4545JXSEGFHoKzQH/dx5IXsso79pJ9RIGiPJYArw9cE0SGduzE
	 EmQ/jU8MyPhERTx3DSYKw29gaCfB7d6hlJwJqSks8U1b9QhGAmh8yKWXT21csfctrv
	 hd0z8YrGfgvFlQKT/4KaRSNk0J2RexaR5ivSmUT01uI9JSIEFCS0tVwBUq/b+JAsGB
	 8EoYwUPPZ+cBsxd+VN67ItAAC4nZ8s8OUtaJIzuS4GHsqeCGHnX+LkJiRnPgjcPs+P
	 Jgbe2l+MepueLO96EzocjmoyatHW6lV2pE6kWj9ygKA3ux2eCtiXwYGb6a3sxOIJ55
	 72SzSn3JrZFiQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Francesco Lavra <flavra@baylibre.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 224/314] drm/solomon: Fix page start when updating rectangle in page addressing mode
Date: Tue, 10 Mar 2026 07:18:03 -0400
Message-ID: <a2922a688c87a6724f7e3e66ad8e5421ae58ba2b.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Francesco Lavra <flavra@baylibre.com>

[ Upstream commit 36d9579fed6c9429aa172f77bd28c58696ce8e2b ]

In page addressing mode, the pixel values of a dirty rectangle must be sent
to the display controller one page at a time. The range of pages
corresponding to a given rectangle is being incorrectly calculated as if
the Y value of the top left coordinate of the rectangle was 0. This can
result in rectangle updates being displayed on wrong parts of the screen.

Fix the above issue by consolidating the start page calculation in a single
place at the beginning of the update_rect function, and using the
calculated value for all addressing modes.

Fixes: b0daaa5cfaa5 ("drm/ssd130x: Support page addressing mode")
Signed-off-by: Francesco Lavra <flavra@baylibre.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patch.msgid.link/20260210180932.736502-1-flavra@baylibre.com
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/solomon/ssd130x.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/solomon/ssd130x.c b/drivers/gpu/drm/solomon/ssd130x.c
index eec43d1a55951..18d2294c526de 100644
--- a/drivers/gpu/drm/solomon/ssd130x.c
+++ b/drivers/gpu/drm/solomon/ssd130x.c
@@ -736,6 +736,7 @@ static int ssd130x_update_rect(struct ssd130x_device *ssd130x,
 	unsigned int height = drm_rect_height(rect);
 	unsigned int line_length = DIV_ROUND_UP(width, 8);
 	unsigned int page_height = SSD130X_PAGE_HEIGHT;
+	u8 page_start = ssd130x->page_offset + y / page_height;
 	unsigned int pages = DIV_ROUND_UP(height, page_height);
 	struct drm_device *drm = &ssd130x->drm;
 	u32 array_idx = 0;
@@ -773,14 +774,11 @@ static int ssd130x_update_rect(struct ssd130x_device *ssd130x,
 	 */
 
 	if (!ssd130x->page_address_mode) {
-		u8 page_start;
-
 		/* Set address range for horizontal addressing mode */
 		ret = ssd130x_set_col_range(ssd130x, ssd130x->col_offset + x, width);
 		if (ret < 0)
 			return ret;
 
-		page_start = ssd130x->page_offset + y / page_height;
 		ret = ssd130x_set_page_range(ssd130x, page_start, pages);
 		if (ret < 0)
 			return ret;
@@ -812,7 +810,7 @@ static int ssd130x_update_rect(struct ssd130x_device *ssd130x,
 		 */
 		if (ssd130x->page_address_mode) {
 			ret = ssd130x_set_page_pos(ssd130x,
-						   ssd130x->page_offset + i,
+						   page_start + i,
 						   ssd130x->col_offset + x);
 			if (ret < 0)
 				return ret;
-- 
2.51.0

