Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38052D0606;
	Thu, 12 Mar 2026 20:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347029; cv=none; b=JoMis6OxtToIoVZ4Xh5tQVxk44Op6fsqXa5X5qcwaDCnyO/sQSTJ2rC0gRDEz9ggL53mQSDYkK10Xt08Hm9Z8CyJfk47BDUlM3VahwV0O5QyoGGhQgK29aZiBDM7IEZ2vQGH9GjFyGv0KLQ0Qzo8j/R1ztdH29rofIo/j8Av2FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347029; c=relaxed/simple;
	bh=GCnp4httLn6ilE1wPKXPDNM3WT7v7nKpVFXdao0YVq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3Y/GISkE2di9uowd1Iv8NaDTPabGTsTz99uDiXQg+4sBGipgmd4vdDbD35mRSS/RuF3vWZQ9QCDPIkhNhlHBjAhjo/r0tKbMVKBRQrNCxtXHMh4Q+/1TPSXMzSVEZG+Tjnc9TIzuCdAk9vUccg454GAKjXbc6uw0XuSots7FJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0k9z0Bg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0k9z0Bg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AAE0C4CEF7;
	Thu, 12 Mar 2026 20:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347029;
	bh=GCnp4httLn6ilE1wPKXPDNM3WT7v7nKpVFXdao0YVq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0k9z0Bg2jPNfbwPFeKSix9TcF+X7oEbuUFOGe1FtKRTvAPJ+OsKX+XCUR0OfMMvk
	 khqs/bx692LA3tID+R3T2utRy4Lh6Gp1xqmnyxLCoP08IOntugnLiTmsQkzNZsx96e
	 OCJoLfc0O3f37gfqBneaqCBl7P0Ha3XgN8xU/ztc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lavra <flavra@baylibre.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 183/265] drm/solomon: Fix page start when updating rectangle in page addressing mode
Date: Thu, 12 Mar 2026 21:09:30 +0100
Message-ID: <20260312201024.922658232@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
User-Agent: quilt/0.69
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
index e0fc12d514d76..cd8347396082a 100644
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



